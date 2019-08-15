package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
)

func (f *FuncDecl) doAssignStmt(assignStmt *ast.AssignStmt) value.Value {
	//c:=a+b
	//a+b
	var r []value.Value
	var l []value.Value
	//0
	for _, value := range assignStmt.Rhs {
		switch value.(type) {
		case *ast.BinaryExpr:
			r = append(r, f.doBinary(value.(*ast.BinaryExpr)))
		case *ast.Ident: //
			variable := f.GetVariable(value.(*ast.Ident).Name)
			if variable == nil {
				r = append(r, ir.NewParam(value.(*ast.Ident).Name, nil))
			} else {
				r = append(r, f.GetVariable(value.(*ast.Ident).Name))
			}
		case *ast.BasicLit:
			r = append(r, f.BasicLitToValue(value.(*ast.BasicLit)))
		case *ast.CallExpr:
			r = append(r, f.doCallExpr(value.(*ast.CallExpr)))
		case *ast.IndexExpr:
			r = append(r, f.doIndexExpr(value.(*ast.IndexExpr)))
		case *ast.CompositeLit:
			r = append(r, f.doCompositeLit(value.(*ast.CompositeLit)))
		default:
			fmt.Println("not impl assignStmt.Rhs")
		}
	}
	//V
	for _, value := range assignStmt.Lhs {
		switch value.(type) {
		case *ast.Ident:
			variable := f.GetVariable(value.(*ast.Ident).Name)
			if variable == nil {
				l = append(l, ir.NewParam(value.(*ast.Ident).Name, nil))
			} else {
				l = append(l, f.GetVariable(value.(*ast.Ident).Name))
			}
		case *ast.BinaryExpr:
			l = append(l, f.doBinary(value.(*ast.BinaryExpr)))
		case *ast.BasicLit:
			l = append(l, f.BasicLitToValue(value.(*ast.BasicLit)))
		case *ast.IndexExpr:
			l = append(l, f.doIndexExpr(value.(*ast.IndexExpr)))
		case *ast.CompositeLit:
			l = append(l, f.doCompositeLit(value.(*ast.CompositeLit)))
		case *ast.SelectorExpr: //TODO struts
			selectorExpr := value.(*ast.SelectorExpr)
			l = append(l, f.doSelectorExpr(selectorExpr))
		default:
			fmt.Println("no impl assignStmt.Lhs")
		}
	}

	//check
	r[0] = f.doCorrect(r[0], l[0].Type())
	l[0] = f.doCorrect(l[0], r[0].Type())

	fmt.Println(l[0], r[0])

	//ops
	switch assignStmt.Tok {
	case token.DEFINE: // :=
		f.GetCurrentBlock().NewStore(r[0], l[0])
	case token.ASSIGN: // =
		//TODO
		if len(r) == 1 {
			f.GetCurrentBlock().NewStore(r[0], l[0])
		}
	default:
		fmt.Println("doAssignStmt no impl")
	}
	return l[0]
}

func (f *FuncDecl) doSelectorExpr(selectorExpr *ast.SelectorExpr) value.Value {
	varName := GetIdentName(selectorExpr.X.(*ast.Ident))
	variable := f.GetVariable(varName)
	structDefs := f.StructDefs[doSymbol(variable.Type().String())]
	def := structDefs[GetIdentName(selectorExpr.Sel)]
	load := f.GetCurrentBlock().NewLoad(variable)
	return f.GetCurrentBlock().NewGetElementPtr(load, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, int64(def.Order)))
}

//fix param
func (f *FuncDecl) doCorrect(v value.Value, tyt types.Type) value.Value {
	if v.Type() == nil {
		vName := v.(*ir.Param).Name()
		//FIXME ERROR TYPE
		nv := f.GetCurrentBlock().NewAlloca(tyt)
		f.PutVariable(vName, nv)
		return nv
	} else {
		//if v.Type()== {
		//
		//}
		return v
	}
}

//index array
func (f *FuncDecl) doIndexExpr(index *ast.IndexExpr) value.Value {
	var kv value.Value
	switch index.Index.(type) {
	case *ast.BasicLit:
		kv = f.BasicLitToValue(index.Index.(*ast.BasicLit))
	case *ast.CallExpr:
		kv = f.doCallExpr(index.Index.(*ast.CallExpr))
	case *ast.Ident:
		kv = f.IdentToValue(index.Index.(*ast.Ident))
	case *ast.BinaryExpr:
		kv = f.doBinary(index.Index.(*ast.BinaryExpr))
	default:
		fmt.Println("doIndex not impl")
	}
	if _, ok := kv.Type().(*types.PointerType); ok {
		kv = f.GetCurrentBlock().NewLoad(kv)
	}

	switch index.X.(type) {
	case *ast.Ident:
		ident := index.X.(*ast.Ident)
		ptr := f.GetCurrentBlock().NewGetElementPtr(f.GetVariable(ident.Name), constant.NewInt(types.I32, 0), kv)
		return ptr
	default:
		fmt.Println("no impl index.X")
	}
	return nil
}

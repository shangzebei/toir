package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
	"strconv"
	"strings"
	"toir/utils"
)

func (f *FuncDecl) doAssignStmt(assignStmt *ast.AssignStmt) []value.Value {
	//ast.Print(f.fset, assignStmt)
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
			//f.IdentToValue(value.(*ast.Ident))
			variable := f.GetVariable(value.(*ast.Ident).Name)
			if variable == nil {
				r = append(r, ir.NewParam(value.(*ast.Ident).Name, nil))
			} else {
				r = append(r, variable)
			}
		case *ast.BasicLit:
			toConstant := f.BasicLitToConstant(value.(*ast.BasicLit))
			r = append(r, toConstant)
		case *ast.CallExpr:
			r = append(r, f.doCallExpr(value.(*ast.CallExpr)))
		case *ast.IndexExpr:
			r = append(r, f.doIndexExpr(value.(*ast.IndexExpr)))
		case *ast.CompositeLit:
			r = append(r, f.doCompositeLit(value.(*ast.CompositeLit)))
		case *ast.SelectorExpr:
			r = append(r, f.doSelectorExpr(value.(*ast.SelectorExpr)))
		case *ast.UnaryExpr:
			r = append(r, f.doUnaryExpr(value.(*ast.UnaryExpr)))
		case *ast.StarExpr:
			r = append(r, f.doStartExpr(value.(*ast.StarExpr)))
		case *ast.SliceExpr:
			r = append(r, f.doSliceExpr(value.(*ast.SliceExpr)))
		default:
			logrus.Error("not impl assignStmt.Rhs")
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
			l = append(l, f.BasicLitToConstant(value.(*ast.BasicLit)))
		case *ast.IndexExpr:
			l = append(l, f.doIndexExpr(value.(*ast.IndexExpr)))
		case *ast.CompositeLit:
			l = append(l, f.doCompositeLit(value.(*ast.CompositeLit)))
		case *ast.SelectorExpr: //TODO struts
			selectorExpr := value.(*ast.SelectorExpr)
			l = append(l, f.doSelectorExpr(selectorExpr))
		case *ast.StarExpr:
			l = append(l, f.doStartExpr(value.(*ast.StarExpr)))
		default:
			fmt.Println("no impl assignStmt.Lhs")
		}
	}

	//check return
	if len(r) != len(l) {
		if len(r) == 1 && len(l) != 1 {
			if re, ok := r[0].Type().(*types.StructType); ok && strings.HasPrefix(re.Name(), "return.") { //return
				for index := range re.Fields {
					r = append(r, f.GetCurrentBlock().NewExtractValue(r[0], uint64(index)))
				}
			}
		} else {
			logrus.Error("not common return")
		}
	}
	//check
	for index := range l {
		if len(l) > index && len(r) > index {
			r[index] = f.doBoolean(r[index], l[index].Type())
		}
	}

	//ops
	switch assignStmt.Tok {
	case token.DEFINE: // :=
		var rep []value.Value
		for lindex, lvalue := range l {
			vName := lvalue.(*ir.Param).Name()
			if _, ok := r[lindex].(constant.Constant); ok {
				switch GetBaseType(r[lindex].Type()).(type) {
				//case *types.StructType, *types.ArrayType:
				//	f.PutVariable(vName, f.InitValue(realType, r[lindex]))
				case *types.IntType:
					newAlloc := f.NewType(GetRealType(r[lindex].Type()))
					f.GetCurrentBlock().NewStore(r[lindex], newAlloc)
					f.PutVariable(vName, newAlloc)
				default:
					newAlloc := f.NewType(GetRealType(r[lindex].Type()))
					f.GetCurrentBlock().NewStore(r[lindex], newAlloc)
					f.PutVariable(vName, newAlloc)
				}
				rep = append(rep, f.GetVariable(vName))
			} else if f.IsSlice(r[lindex]) {
				//newAllocSlice := f.NewAllocSlice(types.NewArray(0, array.emt))
				//f.CopySlice(newAllocSlice, array)
				//f.PutVariable(vName, newAllocSlice)
				//rep = append(rep, newAllocSlice)
				//return rep

				i := r[lindex]
				//newType := f.NewType(i.Type())
				//f.GetCurrentBlock().NewStore(i, newType)
				f.PutVariable(vName, i)
				rep = append(rep, i)
			} else {
				newAlloc := f.NewType(r[lindex].Type())
				f.GetCurrentBlock().NewStore(r[lindex], newAlloc)
				f.PutVariable(vName, newAlloc)
				rep = append(rep, f.GetVariable(vName))
			}

		}
		return rep
	case token.ASSIGN: // =
		var rep []value.Value
		for lIndex, lvalue := range l {
			switch r[lIndex].(type) {
			case *ir.InstAlloca:
				//ri := r[lIndex].(*ir.InstAlloca)
				//r[lIndex] = f.GetCurrentBlock().NewLoad(ri)
				f.GetCurrentBlock().NewStore(r[lIndex], utils.GetSrcPtr(lvalue))
			case *SliceArray:
				f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewLoad(r[lIndex]), lvalue)
			default:
				f.GetCurrentBlock().NewStore(r[lIndex], lvalue)
				fmt.Println("token.ASSIGN unknown type")
			}
			rep = append(rep, lvalue)
		}
		return rep
	default:
		fmt.Println("doAssignStmt no impl")
	}
	return nil
}

//struts.v
func (f *FuncDecl) doSelectorExpr(selectorExpr *ast.SelectorExpr) value.Value {
	varName := GetIdentName(selectorExpr.X.(*ast.Ident))
	variable := f.GetVariable(varName)
	structDefs := f.StructDefs[doSymbol(variable.Type().String())]
	def := structDefs[GetIdentName(selectorExpr.Sel)]
	if _, ok := GetRealType(variable.Type()).(*types.PointerType); ok { //support pointer a.b
		variable = f.GetCurrentBlock().NewLoad(variable)
	}
	indexStruct := utils.IndexStruct(f.GetCurrentBlock(), variable, def.Order)
	return utils.LoadValue(f.GetCurrentBlock(), indexStruct)
}

//do Boolean
func (f *FuncDecl) doBoolean(v value.Value, tyt types.Type) value.Value {
	if p, ok := v.(*ir.Param); ok && IsKeyWord(p.Name()) {
		parseBool, e := strconv.ParseBool(p.Name())
		if e != nil {
			return v
		}
		if parseBool {
			return constant.NewInt(types.I8, 1)
		} else {
			return constant.NewInt(types.I8, 0)
		}
	}
	return v
}

//index array return i8*
func (f *FuncDecl) doIndexExpr(index *ast.IndexExpr) value.Value {
	var kv value.Value
	switch index.Index.(type) {
	case *ast.BasicLit:
		kv = f.BasicLitToConstant(index.Index.(*ast.BasicLit))
	case *ast.CallExpr:
		kv = f.doCallExpr(index.Index.(*ast.CallExpr))
	case *ast.Ident:
		//index is one
		kv = f.IdentToValue(index.Index.(*ast.Ident))[0]
	case *ast.BinaryExpr:
		kv = f.doBinary(index.Index.(*ast.BinaryExpr))
	case *ast.IndexExpr:
		kv = f.doIndexExpr(index.Index.(*ast.IndexExpr))
	case *ast.SelectorExpr:
		kv = f.doSelectorExpr(index.Index.(*ast.SelectorExpr))
	default:
		fmt.Println("doIndex not impl")
	}

	if _, ok := kv.Type().(*types.PointerType); ok {
		kv = f.GetCurrentBlock().NewLoad(kv)
	}

	switch index.X.(type) {
	case *ast.Ident:
		ident := index.X.(*ast.Ident)
		variable := f.GetVariable(ident.Name)
		instBitCast := f.GetCurrentBlock().NewBitCast(f.GetSliceIndex(variable, kv), types.NewPointer(f.FindSliceEmType(ident.Obj)))
		return utils.LoadValue(f.GetCurrentBlock(), instBitCast)
	case *ast.CallExpr:
		return f.doCallExpr(index.X.(*ast.CallExpr))
	default:
		fmt.Println("no impl index.X")
	}
	return nil
}

func (f *FuncDecl) FindSliceEmType(id *ast.Object) types.Type {
	switch id.Decl.(type) {
	case *ast.AssignStmt:
		exprs := id.Decl.(*ast.AssignStmt).Rhs
		expr := (exprs[0].(*ast.CompositeLit).Type).(*ast.ArrayType).Elt
		return f.GetTypeFromName(GetIdentName(expr.(*ast.Ident)))
	case *ast.ValueSpec:
		expr := id.Decl.(*ast.ValueSpec).Type.(*ast.ArrayType).Elt
		return f.GetTypeFromName(GetIdentName(expr.(*ast.Ident)))
	default:
		logrus.Error("not find Slice em type")
	}
	return nil
}

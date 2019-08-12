package convert

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
	"strings"
)

func (f *FuncDecl) doAssignStmt(assignStmt *ast.AssignStmt) {
	//c:=a+b
	//a+b
	var r []value.Value
	var l []value.Value
	//right
	for _, value := range assignStmt.Rhs {
		switch value.(type) {
		case *ast.BinaryExpr:
			r = append(r, f.doBinary("", value.(*ast.BinaryExpr)))
		case *ast.Ident: //
			variable := f.GetVariable(value.(*ast.Ident).Name)
			if variable == nil {
				r = append(r, ir.NewParam(value.(*ast.Ident).Name, nil))
			} else {
				r = append(r, f.GetVariable(value.(*ast.Ident).Name))
			}
		case *ast.BasicLit:
			r = append(r, BasicLitToConstant(value.(*ast.BasicLit)))
		default:
			fmt.Println("not impl assignStmt.Rhs")
		}
	}
	//c
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
			l = append(l, f.doBinary("", value.(*ast.BinaryExpr)))
		case *ast.BasicLit:
			l = append(l, BasicLitToConstant(value.(*ast.BasicLit)))
		default:
			fmt.Println("no impl assignStmt.Lhs")
		}
	}

	//check

	//ops
	switch assignStmt.Tok {
	case token.DEFINE: // :=
		f.GetCurrentBlock().NewStore(r[0], f.doParam(l[0], r[0].Type()))
	case token.ASSIGN: // =
		//TODO
		if len(r) == 1 {
			//a=b+c
			//a=b
			if strings.HasSuffix(r[0].Type().String(), "*") {
				f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewLoad(r[0]), l[0])
			} else {
				//
				f.GetCurrentBlock().NewStore(r[0], l[0])
			}
		}
	case token.EQL: // ==

	default:
		fmt.Println("doAssignStmt no impl")
	}

}

func (f *FuncDecl) doParam(v value.Value, tyt types.Type) value.Value {
	if v.Type() == nil {
		vName := v.(*ir.Param).Name()
		nv := f.GetCurrentBlock().NewAlloca(tyt)
		f.PutVariable(vName, nv)
		return nv
	} else {
		return v
	}
}

func (f *FuncDecl) doStore(src value.Value, des value.Value) {

}

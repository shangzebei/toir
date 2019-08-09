package convert

import (
	"fmt"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
)

func (f *FuncDecl) doAssignStmt(assignStmt *ast.AssignStmt) {
	//c:=a+b
	//a+b
	var r []value.Value
	var l []value.Value
	for _, value := range assignStmt.Rhs {
		switch value.(type) {
		case *ast.BinaryExpr:
			r = append(r, f.doBinary("", value.(*ast.BinaryExpr)))
		case *ast.Ident:
			r = append(r, f.GetVariable(value.(*ast.Ident).Name))
		default:
			fmt.Println("not impl assignStmt.Rhs")
		}
	}
	//c
	for _, value := range assignStmt.Lhs {
		switch value.(type) {
		case *ast.Ident:
			l = append(l, f.GetVariable(value.(*ast.Ident).Name))
		case *ast.BinaryExpr:
			l = append(l, f.doBinary("", value.(*ast.BinaryExpr)))
		default:
			fmt.Println("no impl assignStmt.Lhs")
		}
	}

	//check
	if len(r) != len(l) {
		panic("Assign count mismatch")
	}

	//ops
	switch assignStmt.Tok {
	case token.DEFINE:
		fmt.Println("doAssignStmt no impl :=")
	case token.ASSIGN:
		if len(r) == 1 {
			//a=b+c
			//a=b
			load := f.GetCurrentBlock().NewLoad(r[0])
			f.GetCurrentBlock().NewStore(load, l[0])
		}
	case token.EQL:

	default:
		fmt.Println("doAssignStmt no impl")
	}

}

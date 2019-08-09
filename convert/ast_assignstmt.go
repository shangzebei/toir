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
		}
	}
	//c
	for _, value := range assignStmt.Lhs {
		switch value.(type) {
		case *ast.Ident:
			//FIXME
			l = append(l, IdentToValue(value.(*ast.Ident)))
		default:
			fmt.Println("no impl c")
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
		if len(r) == 1 { //a=b+c
			f.GetCurrentBlock().NewStore(r[0], l[0])
		}
	case token.EQL:

	default:
		fmt.Println("doAssignStmt no impl")
	}

}

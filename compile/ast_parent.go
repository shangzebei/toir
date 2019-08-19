package compile

import (
	"fmt"
	"github.com/llir/llvm/ir/value"
	"go/ast"
)

func (f *FuncDecl) doParenExpr(expr *ast.ParenExpr) value.Value {
	switch expr.X.(type) {
	case *ast.BinaryExpr:
		return f.doBinary(expr.X.(*ast.BinaryExpr))
	default:
		fmt.Println("doParenExpr")
	}
	return nil
}

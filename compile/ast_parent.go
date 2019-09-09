package compile

import (
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"toir/utils"
)

func (f *FuncDecl) ParenExpr(expr *ast.ParenExpr) value.Value {
	return utils.CCall(f, expr.X)[0].(value.Value)
}

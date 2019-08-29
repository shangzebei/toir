package compile

import (
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"learn/stdlib"
	"learn/utils"
)

func (f *FuncDecl) doSelector(params []value.Value, fexpr *ast.SelectorExpr) value.Value {
	varName := GetIdentName(fexpr.X.(*ast.Ident))
	variable := f.GetVariable(varName)
	if variable != nil {
		if t, ok := GetRealType(variable.Type()).(*types.StructType); ok {
			var kk = []value.Value{variable}
			if len(params) > 0 {
				kk = append(kk, params...)
			}
			fun := f.StructDefs[t.Name()][GetIdentName(fexpr.Sel)].Fun
			return f.GetCurrentBlock().NewCall(fun, kk...)
		}
	}
	switch GetCallFuncName(fexpr) {
	case "fmt.Printf", "external.Printf":
		return f.StdCall(stdlib.Printf, params...)
	case "test":
		decl := f.DoFunDecl("runtime", utils.CompileRuntime("runtime/std.go", "checkAppend"))
		f.StdCall(decl)
	default:
		logrus.Debug("not impl doSelector")
	}
	return nil
}

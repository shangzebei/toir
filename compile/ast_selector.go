package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"strings"
	"toir/runtime/call"
	"toir/stdlib"
	"toir/utils"
)

func (f *FuncDecl) doSelector(params []value.Value, fexpr *ast.SelectorExpr, flag string) value.Value {
	ident := fexpr.X.(*ast.Ident)
	varName := GetIdentName(ident)
	if ident.Obj != nil {
		switch ident.Obj.Kind {
		case ast.Var:
			//struct func call
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
		default:
			logrus.Error("not doSelector")
		}

	}
	switch flag {
	case "type":
		return f.typeSelector(fexpr)
	case "call":
		return f.callSelector(params, fexpr)
	}
	////////////
	return nil
}

func (f *FuncDecl) typeSelector(fexpr *ast.SelectorExpr) value.Value {
	name := GetCallFuncName(fexpr)
	if strings.HasPrefix(name, "def.") {
		lastIndex := strings.LastIndex(name, ".")
		return ir.NewParam("", f.GetTypeFromName(name[lastIndex+1:]))
	} else {
		return ir.NewParam("", f.GetTypeFromName(name))
	}
}

func (f *FuncDecl) callSelector(params []value.Value, fexpr *ast.SelectorExpr) value.Value {
	name := GetCallFuncName(fexpr)
	if strings.HasPrefix(name, "def.") {
		lastIndex := strings.LastIndex(name, ".")
		return utils.Call(&call.Call{Block: f.GetCurrentBlock()}, name[lastIndex+1:], params)
	}
	switch name {
	case "fmt.Printf", "external.Printf":
		return f.StdCall(stdlib.Printf, params...)
	case "test.test":
		decl := f.DoFunDecl("runtime", utils.CompileRuntime("runtime/std.go", "copySlice"))
		return f.StdCall(decl)
	default:
		logrus.Debug("not impl doSelector")
	}
	return nil
}
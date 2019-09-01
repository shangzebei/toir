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

//which struct return value not pointer
func (f *FuncDecl) doSelector(params []value.Value, fexpr *ast.SelectorExpr, flag string) value.Value {
	ident := fexpr.X.(*ast.Ident)
	varName := GetIdentName(ident)
	if ident.Obj != nil {
		switch ident.Obj.Kind {
		case ast.Var:
			//struct func call
			variable := f.GetVariable(varName)
			if variable != nil {
				if t, ok := GetBaseType(variable.Type()).(*types.StructType); ok {
					def, ok := f.StructDefs[t.Name()][GetIdentName(fexpr.Sel)]
					if ok {
						var kk = []value.Value{variable}
						if len(params) > 0 {
							kk = append(kk, params...)
						}
						if def.Fun == nil {
							index := utils.IndexStruct(f.GetCurrentBlock(), variable, def.Order)
							return index
						} else {
							return f.GetCurrentBlock().NewCall(def.Fun, kk...)
						}
					}
				}
			}
		default:
			logrus.Error("not doSelector")
		}

	}

	switch flag {
	case "type":
		return f.typeSelector(fexpr)
	//case "value":
	//return f.valueSelector(fexpr)
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
		return utils.Call(&call.Call{Block: f.GetCurrentBlock(), M: f.m}, name[lastIndex+1:], params)
	}
	switch name {
	case "fmt.Printf", "external.Printf":
		return f.StdCall(stdlib.Printf, params...)
	case "test.test":
		decl := f.DoFunDecl("runtime", f.r.GetFunc("checkAppend"))
		return f.StdCall(decl)
	default:
		logrus.Debugf("not impl doSelector %s", name)
	}
	return nil
}

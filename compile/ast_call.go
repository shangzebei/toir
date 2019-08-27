package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"learn/stdlib"
	"reflect"
	"strings"
)

func (f *FuncDecl) doCallExpr(call *ast.CallExpr) value.Value {
	//get call param
	var params []value.Value
	for _, value := range call.Args {
		switch value.(type) {
		case *ast.Ident:
			ident := value.(*ast.Ident)
			if ident.Obj.Kind == ast.Var { //constant,Glob,alloa,param
				variable := f.GetVariable(ident.Name)
				if f.IsSlice(variable) {
					params = append(params, variable)
				} else {
					if _, ok := variable.Type().(*types.PointerType); ok {
						params = append(params, f.GetCurrentBlock().NewLoad(variable)) //f.GetCurrentBlock().NewLoad(
					} else {
						params = append(params, variable) //f.GetCurrentBlock().NewLoad(
					}
				}
			}
		case *ast.BasicLit: //param
			basicLit := value.(*ast.BasicLit)
			constant := f.BasicLitToConstant(basicLit)
			params = append(params, constant)
		case *ast.CallExpr:
			params = append(params, f.doCallExpr(value.(*ast.CallExpr)))
		case *ast.BinaryExpr:
			params = append(params, f.doBinary(value.(*ast.BinaryExpr)))
		case *ast.IndexExpr:
			params = append(params, f.GetCurrentBlock().NewLoad(f.doIndexExpr(value.(*ast.IndexExpr))))
		case *ast.SelectorExpr:
			params = append(params, f.GetCurrentBlock().NewLoad(f.doSelectorExpr(value.(*ast.SelectorExpr))))
		case *ast.UnaryExpr: //get addr
			unaryExpr := value.(*ast.UnaryExpr)
			params = append(params, f.doUnaryExpr(unaryExpr))
		case *ast.CompositeLit:
			//TODO
			params = append(params, f.doCompositeLit(value.(*ast.CompositeLit)))
		case *ast.StarExpr:
			params = append(params, f.GetCurrentBlock().NewLoad(f.doStartExpr(value.(*ast.StarExpr))))
		default:
			fmt.Println("doCallExpr args not impl")
		}
	}
	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		fexpr := call.Fun.(*ast.SelectorExpr)
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
		default:
			fmt.Println("doCallExpr SelectorExpr no impl")
		}
	case *ast.Ident:
		return f.doCallFunc(params, call.Fun.(*ast.Ident))
	default:
		fmt.Println("doCallExpr call.Fun")
	}
	return nil
}

//convert param type to target
func (f *FuncDecl) checkAndConvert(funPars []*ir.Param, params []value.Value) []value.Value {
	var re []value.Value
	for index, value := range funPars { //func type
		if value.Typ != params[index].Type() {
			re = append(re, f.convertTypeTo(params[index], value.Typ))
		} else {
			re = append(re, params[index])
		}
	}
	return re
}

func (f *FuncDecl) doCallFunc(values []value.Value, id *ast.Ident) value.Value {
	block := f.GetCurrentBlock()
	if id.Obj != nil {
		if f.GetCurrent().Name() == GetIdentName(id) { //recursion
			return block.NewCall(f.GetCurrent(), values...)
		} else {
			funDecl := f.DoFunDecl("", id.Obj.Decl.(*ast.FuncDecl))
			return block.NewCall(funDecl, values...)
		}
	} else { //Custom func
		valueOf := reflect.ValueOf(f)
		name := valueOf.MethodByName(FastCharToLower(id.Name))
		if name.IsNil() || name.IsZero() {
			fmt.Println("not buildin", id.Name)
		}
		var params []reflect.Value
		for _, value := range values {
			params = append(params, reflect.ValueOf(value))
		}
		call := name.Call(params)
		return call[0].Interface().(value.Value)
	}

}

func FastCharToLower(name string) string {
	return strings.ToUpper(string(name[0])) + name[1:]
}

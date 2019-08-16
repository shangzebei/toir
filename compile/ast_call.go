package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"learn/stdlib"
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
				switch variable.(type) {
				case *ir.InstAlloca:
					params = append(params, f.GetCurrentBlock().NewLoad(variable))
				default:
					params = append(params, variable)

				}
			}
		case *ast.BasicLit: //param
			basicLit := value.(*ast.BasicLit)
			constant := f.BasicLitToConstant(basicLit)
			if _, ok := constant.(*ir.Global); ok {
				params = append(params, f.Toi8Ptr(constant))
			} else {
				params = append(params, constant)
			}
		case *ast.CallExpr:
			params = append(params, f.doCallExpr(value.(*ast.CallExpr)))
		case *ast.BinaryExpr:
			params = append(params, f.doBinary(value.(*ast.BinaryExpr)))
		case *ast.IndexExpr:
			params = append(params, f.GetCurrentBlock().NewLoad(f.doIndexExpr(value.(*ast.IndexExpr))))
		case *ast.SelectorExpr:
			params = append(params, f.GetCurrentBlock().NewLoad(f.doSelectorExpr(value.(*ast.SelectorExpr))))
		default:
			fmt.Println("doCallExpr args not impl")
		}
	}
	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		switch GetCallFuncName(call.Fun.(*ast.SelectorExpr)) {
		case "fmt.Printf":
			f.StdCall(stdlib.Printf, params...)
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
		funDecl := f.DoFunDecl("", id.Obj.Decl.(*ast.FuncDecl))
		return block.NewCall(funDecl, values...)
	} else { //Custom func
		logrus.Panicln("not find fun", id.Name)
		return nil
	}

}

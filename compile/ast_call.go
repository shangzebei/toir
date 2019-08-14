package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
)

func (f *FuncDecl) doCallExpr(call *ast.CallExpr) value.Value {
	//get call param
	var params []value.Value
	for _, value := range call.Args {
		switch value.(type) {
		case *ast.Ident:
			ident := value.(*ast.Ident)
			if ident.Obj.Kind == ast.Var {
				params = append(params, f.GetCurrentBlock().NewLoad(f.GetVariable(ident.Name)))
			}
		case *ast.BasicLit: //param
			basicLit := value.(*ast.BasicLit)
			params = append(params, f.BasicLitToConstant(basicLit))
		case *ast.CallExpr:
			params = append(params, f.doCallExpr(value.(*ast.CallExpr)))
		case *ast.BinaryExpr:
			params = append(params, f.doBinary(value.(*ast.BinaryExpr)))
		case *ast.IndexExpr:
			params = append(params, f.doIndexExpr(value.(*ast.IndexExpr)))
		case *ast.SelectorExpr:
			params = append(params, f.doSelectorExpr(value.(*ast.SelectorExpr)))
		default:
			fmt.Println("doCallExpr args not impl")
		}
	}
	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		fmt.Println("doCallExpr SelectorExpr no impl")
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
		return block.NewCall(funDecl, f.checkAndConvert(funDecl.Params, values)...)
	} else { //Custom func
		logrus.Panicln("not find fun", id.Name)
		return nil
	}

}

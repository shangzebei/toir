package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"toir/utils"
)

func (f *FuncDecl) doCallExpr(call *ast.CallExpr) value.Value {
	//get call param
	var params []value.Value
	for _, value := range call.Args {
		switch value.(type) {
		case *ast.Ident:
			doIdent := f.doIdent(value.(*ast.Ident))
			if a, ok := doIdent.(*ir.InstAlloca); ok {
				params = append(params, f.GetCurrentBlock().NewLoad(a))
			} else {
				params = append(params, doIdent)
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
			params = append(params, f.doIndexExpr(value.(*ast.IndexExpr)))
		case *ast.SelectorExpr:
			params = append(params, f.doSelectorExpr(value.(*ast.SelectorExpr)))
		case *ast.UnaryExpr: //get addr
			unaryExpr := value.(*ast.UnaryExpr)
			params = append(params, f.doUnaryExpr(unaryExpr))
		case *ast.CompositeLit:
			//TODO
			params = append(params, f.doCompositeLit(value.(*ast.CompositeLit)))
		case *ast.StarExpr:
			params = append(params, f.doStartExpr(value.(*ast.StarExpr)))
		case *ast.SliceExpr:
			params = append(params, f.doSliceExpr(value.(*ast.SliceExpr)))
		case *ast.ArrayType:
			params = append(params, f.NewAllocSlice(f.doArrayType(value.(*ast.ArrayType)).Type()))
		case *ast.FuncLit:
			params = append(params, f.doFuncLit(value.(*ast.FuncLit)))
		default:
			fmt.Println("doCallExpr args not impl")
		}
	}
	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		fexpr := call.Fun.(*ast.SelectorExpr)
		return f.doSelector(params, fexpr, "call")
	case *ast.Ident:
		return f.doCallFunc(params, call.Fun.(*ast.Ident))
	default:
		fmt.Println("doCallExpr call.Fun")
	}
	return nil
}

func (f *FuncDecl) doCallFunc(values []value.Value, id *ast.Ident) value.Value {
	block := f.GetCurrentBlock()
	////recursion
	if f.GetCurrent().Name() == GetIdentName(id) {
		return block.NewCall(f.GetCurrent(), values...)
	}
	if id.Obj != nil {
		switch id.Obj.Decl.(type) {
		case *ast.FuncDecl:
			funDecl := f.DoFunDecl("", id.Obj.Decl.(*ast.FuncDecl))
			//auto convert param type
			var cor []value.Value
			for index, value := range values {
				cor = append(cor, f.ConvertType(funDecl.Sig.Params[index], value))
			}
			return block.NewCall(funDecl, cor...)
		case *ast.Field:
			return block.NewCall(f.GetVariable(GetIdentName(id)), values...)
		default:
			logrus.Debug("not find type doCallFunc")
		}
	} else { //Custom func
		return utils.Call(f, utils.FastCharToLower(id.Name), values)
	}
	return nil

}

package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"toir/utils"
)

func (f *FuncDecl) CallExpr(call *ast.CallExpr) value.Value {
	//get call param
	var params []value.Value
	for _, value := range call.Args {
		switch value.(type) {
		case *ast.Ident:
			params = append(params, FixAlloc(f.GetCurrentBlock(), f.Ident(value.(*ast.Ident))))
		case *ast.BasicLit: //param
			params = append(params, f.BasicLit(value.(*ast.BasicLit)))
		case *ast.CallExpr:
			params = append(params, f.CallExpr(value.(*ast.CallExpr)))
		case *ast.BinaryExpr:
			params = append(params, f.BinaryExpr(value.(*ast.BinaryExpr)))
		case *ast.IndexExpr:
			params = append(params, f.IndexExpr(value.(*ast.IndexExpr)))
		case *ast.SelectorExpr:
			params = append(params, f.SelectorExpr(value.(*ast.SelectorExpr)))
		case *ast.UnaryExpr: //get addr
			unaryExpr := value.(*ast.UnaryExpr)
			params = append(params, f.UnaryExpr(unaryExpr))
		case *ast.CompositeLit:
			params = append(params, f.CompositeLit(value.(*ast.CompositeLit)))
		case *ast.StarExpr:
			params = append(params, f.StartExpr(value.(*ast.StarExpr), "value"))
		case *ast.SliceExpr:
			params = append(params, f.SliceExpr(value.(*ast.SliceExpr)))
		case *ast.ArrayType:
			arrayType := value.(*ast.ArrayType)
			typeFromName := f.GetTypeFromName(GetIdentName(arrayType.Elt.(*ast.Ident)))
			params = append(params, ir.NewParam("", typeFromName)) //slice type
		case *ast.FuncLit:
			params = append(params, f.FuncLit(value.(*ast.FuncLit)))
		default:
			fmt.Println("CallExpr args not impl")
		}
	}
	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		fexpr := call.Fun.(*ast.SelectorExpr)
		return f.doSelector(params, fexpr, "call")
	case *ast.Ident:
		return f.doCallFunc(params, call.Fun.(*ast.Ident))
	//case *ast.ArrayType:
	//arrayType := call.Fun.(*ast.ArrayType)
	//ki := f.GetTypeFromName(GetIdentName(arrayType.Elt.(*ast.Ident)))
	//if s, ok := params[0].(*constant.ExprGetElementPtr); ok {
	//	i := s.ElemType.(*types.ArrayType)
	//	types.NewArray(i.Len,ki)
	//	slice := f.NewSlice(ki, constant.NewInt(types.I32, 4))
	//	f.InitArrayValue(si)
	//}
	//
	//return slice
	default:
		fmt.Println("CallExpr call.Fun")
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
		return utils.Call(f, utils.FastCharToLower(id.Name), values...)
	}
	return nil

}

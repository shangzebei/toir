package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
)

func (f *FuncDecl) doReturnStmt(returnStmt *ast.ReturnStmt) {
	mul := false
	if len(returnStmt.Results) > 1 {
		mul = true
	}
	var values []value.Value
	for _, val := range returnStmt.Results {
		var rev value.Value
		switch val.(type) {
		case *ast.BasicLit:
			rev = f.BasicLitToConstant(val.(*ast.BasicLit))
		case *ast.BinaryExpr:
			rev = f.doBinary(val.(*ast.BinaryExpr))
		case *ast.CallExpr:
			rev = f.doCallExpr(val.(*ast.CallExpr))
		case *ast.Ident:
			//TODO return
			identToValue := f.IdentToValue(val.(*ast.Ident))[0]
			if _, ok := identToValue.(*ir.InstAlloca); ok {
				rev = f.GetCurrentBlock().NewLoad(identToValue)
			} else {
				rev = identToValue
			}
		default:
			logrus.Debug("doBlockStmt return not impl!")
		}
		values = append(values, rev)
	}
	if !mul {
		f.GetCurrent().Sig.RetType = values[0].Type()
		f.GetCurrentBlock().NewRet(values[0])
	} else {
		newTypeDef := f.m.NewTypeDef(f.GetCurrent().Name()+".return", types.NewStruct(GetStrutsTypes(values)...))
		f.GetCurrent().Sig.RetType = newTypeDef
		alloca := f.GetCurrentBlock().NewAlloca(newTypeDef)
		for index, value := range values {
			getElementPtr := f.GetCurrentBlock().NewGetElementPtr(alloca, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, int64(index)))
			f.GetCurrentBlock().NewStore(value, getElementPtr)
		}
		f.GetCurrentBlock().NewRet(f.GetCurrentBlock().NewLoad(alloca))
	}
}

func GetStrutsTypes(values []value.Value) []types.Type {
	var pp []types.Type
	for _, value := range values {
		pp = append(pp, value.Type())
	}
	return pp
}
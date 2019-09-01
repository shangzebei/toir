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
		case *ast.SelectorExpr:
			rev = f.doSelector(nil, val.(*ast.SelectorExpr), "call")
		default:
			logrus.Debug("doBlockStmt return not impl!")
		}
		values = append(values, rev)
	}
	if !mul {
		f.GetCurrentBlock().NewRet(f.ConvertType(f.GetCurrent().Sig.RetType, values[0]))
	} else {
		alloca := f.GetCurrentBlock().NewAlloca(f.GetCurrent().Sig.RetType)
		for index, value := range values {
			getElementPtr := f.GetCurrentBlock().NewGetElementPtr(alloca, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, int64(index)))
			f.GetCurrentBlock().NewStore(value, getElementPtr)
		}
		f.GetCurrentBlock().NewRet(f.GetCurrentBlock().NewLoad(alloca))
	}
}

func (f *FuncDecl) ConvertType(exportType types.Type, current value.Value) value.Value {
	if types.IsPointer(exportType) {
		if types.IsPointer(exportType) == types.IsPointer(current.Type()) {
			return current
		} else {
			logrus.Warn("conver pointer to")
			load := f.GetCurrentBlock().NewLoad(current)
			return f.ConvertType(exportType, load)
		}
	} else if types.IsInt(exportType) {
		if types.IsInt(exportType) == types.IsInt(current.Type()) {
			return current
		} else {
			logrus.Warn("conver int to")
			load := f.GetCurrentBlock().NewLoad(current)
			return f.ConvertType(exportType, load)
		}
	} else {
		logrus.Error("unkonw")
	}
	return nil

}

func StrutsToTypes(values []value.Value) []types.Type {
	var pp []types.Type
	for _, value := range values {
		pp = append(pp, value.Type())
	}
	return pp
}

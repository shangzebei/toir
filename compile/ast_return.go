package compile

import (
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"toir/utils"
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
			rev = f.doIdent(val.(*ast.Ident))
		case *ast.SelectorExpr:
			rev = f.doSelector(nil, val.(*ast.SelectorExpr), "call")
		default:
			logrus.Debug("doBlockStmt return not impl!")
		}
		values = append(values, FixAlloc(f.GetCurrentBlock(), rev))
	}

	if len(returnStmt.Results) == 0 {
		f.GetCurrentBlock().NewRet(nil)
		return
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
			return f.GetSrcPtr(current)
		}
	} else if types.IsInt(exportType) {
		if types.IsInt(exportType) == types.IsInt(current.Type()) {
			return current
		} else {
			return utils.LoadValue(f.GetCurrentBlock(), current)
		}
	} else {
		logrus.Warn("unkonw ConvertType type")
		return current
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

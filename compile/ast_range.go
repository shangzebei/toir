package compile

import (
	"github.com/jinzhu/copier"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"toir/utils"
)

/**
 *  for(int i=0;i<10,i++)
 *  {
 *     k=i,
 *     v=d[i]
 *  }
 */
func (f *FuncDecl) doRangeStmt(stmt *ast.RangeStmt) {
	utils.NewComment(f.GetCurrentBlock(), "[range start]")
	var va value.Value
	var name string
	switch stmt.X.(type) {
	case *ast.Ident:
		i := stmt.X.(*ast.Ident)
		name = GetIdentName(i)
		va = f.doIdent(i)
	case *ast.CallExpr:
		va = f.doCallExpr(stmt.X.(*ast.CallExpr))
		f.tempVariables["rangeV"] = va
		name = "rangeV"
	default:
		logrus.Error("not doRangeStmt")
	}

	emType := GetSliceEmType(GetBaseType(va.Type())) //I32*
	//init len
	getLen := f.GetLen(f.GetSrcPtr(va))
	f.tempVariables["zrangzwrLen"] = getLen

	getFunc := f.r.GetFunc("rangeTemp")
	//ast.Print(f.fSet, getFunc)
	blockStmt := getFunc.Body
	var assgn []*ast.AssignStmt
	var forStmt ast.ForStmt
	for _, value := range blockStmt.List {
		if f, ok := value.(*ast.ForStmt); ok {
			_ = copier.Copy(&forStmt, f)
		}
	}
	for _, value := range forStmt.Body.List {
		if i, ok := value.(*ast.AssignStmt); ok {
			assgn = append(assgn, i)
		}
	}
	var st []ast.Stmt
	//init key
	if stmt.Key != nil && !IsIgnore(stmt.Key.(*ast.Ident)) {
		keyName := GetIdentName(stmt.Key.(*ast.Ident))
		keyAlloca := f.GetCurrentBlock().NewAlloca(types.I32)
		f.tempVariables[keyName] = keyAlloca
		assgn[0].Lhs[0].(*ast.Ident).Name = keyName
		st = append(st, assgn[0])
	}
	//init value
	if stmt.Value != nil && !IsIgnore(stmt.Value.(*ast.Ident)) {
		valueName := GetIdentName(stmt.Value.(*ast.Ident))
		valueAlloca := f.GetCurrentBlock().NewAlloca(GetRealType(emType))
		f.tempVariables[valueName] = valueAlloca
		assgn[1].Lhs[0].(*ast.Ident).Name = valueName
		indexExpr := assgn[1].Rhs[0].(*ast.IndexExpr)
		indexExpr.X = &ast.Ident{
			NamePos: 0,
			Name:    name,
			Obj:     nil,
		}
		st = append(st, assgn[1])
	}

	forStmt.Body.List = append(st, stmt.Body.List...)

	//ast.Print(f.fSet, forStmt)
	f.doForStmt(&forStmt)
	utils.NewComment(f.GetCurrentBlock(), "[range end]")
}

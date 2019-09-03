package compile

import (
	"github.com/jinzhu/copier"
	"github.com/llir/llvm/ir/types"
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
	i := stmt.X.(*ast.Ident)
	value := f.doIdent(i)
	emType := GetSliceEmType(GetBaseType(value.Type())) //I32*

	//init len
	getLen := f.GetLen(utils.LoadValue(f.GetCurrentBlock(), value))
	f.tempVariables["zrangzwrLen"] = getLen
	//f.PutVariable("zrangzwrLen", getLen)

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
		indexExpr.X = i
		st = append(st, assgn[1])
	}

	forStmt.Body.List = append(st, stmt.Body.List...)

	//ast.Print(f.fSet, forStmt)
	f.doForStmt(&forStmt)
	utils.NewComment(f.GetCurrentBlock(), "[range end]")
}

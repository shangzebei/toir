package compile

import (
	"fmt"
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
	fmt.Println(emType)
	//init key
	keyName := GetIdentName(stmt.Key.(*ast.Ident))
	keyAlloca := f.GetCurrentBlock().NewAlloca(types.I32)
	f.PutVariable(keyName, keyAlloca)
	//init value
	valueName := GetIdentName(stmt.Value.(*ast.Ident))
	valueAlloca := f.GetCurrentBlock().NewAlloca(GetRealType(emType))
	f.PutVariable(valueName, valueAlloca)
	//init len
	getLen := f.GetLen(utils.LoadValue(f.GetCurrentBlock(), value))
	f.PutVariable("zrangzwrLen", getLen)

	getFunc := f.r.GetFunc("rangeTemp")
	blockStmt := getFunc.Body
	var assgn []*ast.AssignStmt
	var forStmt *ast.ForStmt
	for _, value := range blockStmt.List {
		if f, ok := value.(*ast.ForStmt); ok {
			forStmt = f
		}
	}

	for _, value := range forStmt.Body.List {
		if i, ok := value.(*ast.AssignStmt); ok {
			assgn = append(assgn, i)
		}
	}
	assgn[0].Lhs[0].(*ast.Ident).Name = keyName
	assgn[1].Lhs[0].(*ast.Ident).Name = valueName
	indexExpr := assgn[1].Rhs[0].(*ast.IndexExpr)
	indexExpr.X = i
	var st []ast.Stmt
	forStmt.Body.List = append(st, assgn[0], assgn[1])
	forStmt.Body.List = append(forStmt.Body.List, stmt.Body.List...)

	f.doForStmt(forStmt)
	//ast.Print(f.fSet, forStmt)

	utils.NewComment(f.GetCurrentBlock(), "[range end]")
}

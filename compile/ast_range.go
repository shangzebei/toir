package compile

import (
	"fmt"
	"github.com/llir/llvm/ir/types"
	"go/ast"
)

/**
 *  for(int i=0;i<10,i++)
 *  {
 *     k=i,
 *     v=d[i]
 *  }
 */
func (f *FuncDecl) doRangeStmt(stmt *ast.RangeStmt) {
	fmt.Println("not impl doRangeStmt")
	ast.Print(f.fset, stmt)
	fmt.Println(stmt.Key.(*ast.Ident).Obj.Decl == stmt.Value.(*ast.Ident).Obj.Decl)
	fmt.Println(stmt.Key)
	fmt.Println(stmt.Value)
	//init
	keyName := GetIdentName(stmt.Key.(*ast.Ident))
	f.PutVariable(keyName, f.GetCurrentBlock().NewAlloca(types.I32))
	//
	value := f.doIdent(stmt.X.(*ast.Ident))
	if v, ok := value.(*SliceArray); ok {
		valueName := GetIdentName(stmt.Value.(*ast.Ident))
		f.PutVariable(valueName, f.GetCurrentBlock().NewAlloca(v.emt))
	}
	fmt.Println(value)
	f.doBlockStmt(stmt.Body)

}

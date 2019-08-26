package compile

import (
	"fmt"
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
	//ast.Print(f.fset,stmt)
	f.doBlockStmt(stmt.Body)
	fmt.Println(stmt.Key)
	fmt.Println(stmt.Value)

}

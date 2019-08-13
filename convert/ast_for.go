package convert

import (
	"go/ast"
)

func (f *FuncDecl) doForStmt(st *ast.ForStmt) {

	// INIT
	f.doAssignStmt(st.Init.(*ast.AssignStmt))

	// ADD
	postBlock := f.newBlock()
	switch st.Post.(type) {
	case *ast.IncDecStmt:
		f.doIncDecStmt(st.Post.(*ast.IncDecStmt))
	}
	f.popBlock()

	//
	body := f.doBlockStmt(postBlock, st.Body)

	// COND
	newBlock := f.newBlock()
	doBinary := f.doBinary(st.Cond.(*ast.BinaryExpr))
	f.GetCurrentBlock().NewCondBr(doBinary, body, postBlock)
	f.popBlock()
	//

	f.GetCurrentBlock().NewBr(newBlock)

}

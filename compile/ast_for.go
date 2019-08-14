package compile

import (
	"fmt"
	"go/ast"
)

func (f *FuncDecl) doForStmt(st *ast.ForStmt) {

	// INIT
	dd := f.doAssignStmt(st.Init.(*ast.AssignStmt))

	// ADD
	addBlock := f.newBlock()
	switch st.Post.(type) {
	case *ast.IncDecStmt:
		doIncDecStmt := f.doIncDecStmt(st.Post.(*ast.IncDecStmt))
		addBlock.NewStore(doIncDecStmt, dd)
	default:
		fmt.Println("doForStmt not impl")
	}
	f.popBlock()

	//body
	body := f.doBlockStmt(addBlock, st.Body)

	// COND
	condBlock := f.newBlock() //---begin
	doBinary := f.doBinary(st.Cond.(*ast.BinaryExpr))

	empty := f.newBlock()
	f.popBlock()

	f.GetCurrentBlock().NewCondBr(doBinary, body, empty)
	f.popBlock() //---end
	//
	addBlock.NewBr(condBlock)

	f.GetCurrentBlock().NewBr(condBlock)

}

package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"go/ast"
)

func (f *FuncDecl) doForStmt(st *ast.ForStmt) *ir.Block {

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
	f.popBlock() //end ADD

	//body
	body := f.doBlockStmt(st.Body)
	body.NewBr(addBlock)

	// COND
	condBlock := f.newBlock() //---begin
	doBinary := f.doBinary(st.Cond.(*ast.BinaryExpr))
	f.popBlock() //END COND
	//

	f.GetCurrentBlock().NewBr(condBlock)
	f.popBlock() //Close MAIN

	// EMPTY
	empty := f.newBlock()
	condBlock.NewCondBr(doBinary, body, empty)
	//
	addBlock.NewBr(condBlock)
	return empty

}

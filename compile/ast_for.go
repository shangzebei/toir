package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
	"go/ast"
)

func (f *FuncDecl) doForStmt(st *ast.ForStmt) (start *ir.Block, end *ir.Block) {

	temp := f.GetCurrentBlock()
	// INIT
	dd := f.doAssignStmt(st.Init.(*ast.AssignStmt))

	// ADD
	addBlock := f.newBlock()
	switch st.Post.(type) {
	case *ast.IncDecStmt:
		doIncDecStmt := f.doIncDecStmt(st.Post.(*ast.IncDecStmt))
		addBlock.NewStore(doIncDecStmt, dd)
	case *ast.AssignStmt:
		f.doAssignStmt(st.Post.(*ast.AssignStmt))
	default:
		logrus.Error("doForStmt not impl")
	}
	f.popBlock() //end ADD

	//body
	sBody, endBody := f.doBlockStmt(st.Body)
	endBody.NewBr(addBlock) //end to add

	// COND
	condBlock := f.newBlock() //---begin
	doBinary := f.doBinary(st.Cond.(*ast.BinaryExpr))
	f.popBlock() //END COND
	//

	f.GetCurrentBlock().NewBr(addBlock)
	f.popBlock() //Close MAIN

	// EMPTY
	empty := f.newBlock()
	condBlock.NewCondBr(doBinary, sBody, empty)
	//
	addBlock.NewBr(condBlock)
	return temp, empty

}

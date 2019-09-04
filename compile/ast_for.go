package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
	"go/ast"
	"toir/utils"
)

func (f *FuncDecl) doForStmt(st *ast.ForStmt) (start *ir.Block, end *ir.Block) {

	temp := f.GetCurrentBlock()

	f.OpenTempVariable()

	// INIT
	utils.NewComment(f.GetCurrentBlock(), "init block")
	dd := f.doAssignStmt(st.Init.(*ast.AssignStmt))

	// ADD
	addBlock := f.newBlock()
	utils.NewComment(f.GetCurrentBlock(), "add block")
	switch st.Post.(type) {
	case *ast.IncDecStmt:
		doIncDecStmt := f.doIncDecStmt(st.Post.(*ast.IncDecStmt))
		addBlock.NewStore(doIncDecStmt, dd[0])
	case *ast.AssignStmt:
		f.doAssignStmt(st.Post.(*ast.AssignStmt))
	default:
		logrus.Error("doForStmt not impl")
	}
	f.popBlock() //end ADD

	// COND
	condBlock := f.newBlock() //---begin
	utils.NewComment(f.GetCurrentBlock(), "cond Block begin")
	doBinary := f.doBinary(st.Cond.(*ast.BinaryExpr))
	utils.NewComment(f.GetCurrentBlock(), "cond Block end")
	f.popBlock() //END COND
	//

	//body
	sBody, endBody := f.doBlockStmt(st.Body)

	endBody.NewBr(addBlock) //end to add //!

	temp.NewBr(sBody) //!
	f.popBlock()      //Close MAIN

	// EMPTY
	empty := f.newBlock()
	utils.NewComment(f.GetCurrentBlock(), "empty block")
	condBlock.NewCondBr(doBinary, sBody, empty) //!
	//

	//check break
	if f.forBreak != nil {
		f.forBreak.NewBr(empty)
		f.forBreak = nil
	}
	//check continue
	if f.forContinue != nil {
		f.forContinue.NewBr(addBlock)
		f.forContinue = nil
	}
	f.CloseTempVariable()
	//
	addBlock.NewBr(condBlock)
	return temp, empty

}

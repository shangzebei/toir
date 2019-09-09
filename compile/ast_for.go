package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"toir/utils"
)

func (f *FuncDecl) ForStmt(st *ast.ForStmt) (start *ir.Block, end *ir.Block) {

	temp := f.GetCurrentBlock()

	f.OpenTempVariable()

	// INIT
	utils.NewComment(f.GetCurrentBlock(), "init block")
	if st.Init != nil {
		utils.CCall(f, st.Init)
	}

	// ADD
	addBlock := f.newBlock()
	utils.NewComment(f.GetCurrentBlock(), "add block")
	if st.Post != nil {
		utils.CCall(f, st.Post)
	}
	f.popBlock() //end ADD

	var doBinary value.Value
	// COND
	condBlock := f.newBlock() //---begin
	utils.NewComment(f.GetCurrentBlock(), "cond Block begin")
	if st.Cond != nil {
		doBinary = utils.CCall(f, st.Cond)[0].(value.Value)
	}
	utils.NewComment(f.GetCurrentBlock(), "cond Block end")
	f.popBlock() //END COND
	//

	//body
	sBody, endBody := f.BlockStmt(st.Body)

	endBody.NewBr(addBlock) //end to add //!

	temp.NewBr(condBlock) //!
	f.popBlock()          //Close MAIN

	// EMPTY
	empty := f.newBlock()
	utils.NewComment(f.GetCurrentBlock(), "empty block")
	if doBinary != nil {
		condBlock.NewCondBr(doBinary, sBody, empty) //!
	} else {
		condBlock.NewBr(sBody)
	}
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

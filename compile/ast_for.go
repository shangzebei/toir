package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"toir/utils"
)

func (f *FuncDecl) doForStmt(st *ast.ForStmt) (start *ir.Block, end *ir.Block) {

	temp := f.GetCurrentBlock()

	f.OpenTempVariable()

	// INIT
	utils.NewComment(f.GetCurrentBlock(), "init block")
	if st.Init != nil {
		f.doAssignStmt(st.Init.(*ast.AssignStmt))
	}

	// ADD
	addBlock := f.newBlock()
	utils.NewComment(f.GetCurrentBlock(), "add block")
	if st.Post != nil {
		switch st.Post.(type) {
		case *ast.IncDecStmt:
			f.doIncDecStmt(st.Post.(*ast.IncDecStmt))
		case *ast.AssignStmt:
			f.doAssignStmt(st.Post.(*ast.AssignStmt))
		case *ast.ExprStmt:
			f.doExprStmt(st.Post.(*ast.ExprStmt))
		default:
			logrus.Error("doForStmt not impl")
		}
	}
	f.popBlock() //end ADD

	var doBinary value.Value
	// COND
	condBlock := f.newBlock() //---begin
	utils.NewComment(f.GetCurrentBlock(), "cond Block begin")
	if st.Cond != nil {
		switch st.Cond.(type) {
		case *ast.BinaryExpr:
			doBinary = f.doBinary(st.Cond.(*ast.BinaryExpr))
		case *ast.CallExpr:
			doBinary = f.doCallExpr(st.Cond.(*ast.CallExpr))
		}
	}
	utils.NewComment(f.GetCurrentBlock(), "cond Block end")
	f.popBlock() //END COND
	//

	//body
	sBody, endBody := f.doBlockStmt(st.Body)

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

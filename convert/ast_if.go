package convert

import (
	"fmt"
	"go/ast"
	"strconv"
)

func (f *FuncDecl) doIfStmt(expr *ast.IfStmt) {
	switch expr.Cond.(type) {
	case *ast.BinaryExpr:
		binaryExpr := expr.Cond.(*ast.BinaryExpr)
		doBinary := f.doBinary(binaryExpr)
		//if body
		trueBlock := f.doBlockStmt(expr.Body)
		//else body
		if expr.Else == nil {
			block := f.newBlock()
			f.popBlock()
			f.GetCurrentBlock().NewCondBr(doBinary, trueBlock, block)
		} else {
			falseBlock := f.doBlockStmt(expr.Else.(*ast.BlockStmt))
			f.GetCurrentBlock().NewCondBr(doBinary, trueBlock, falseBlock)
		}
	case *ast.Ident:
		identName := GetIdentName(expr.Cond.(*ast.Ident))
		parseBool, _ := strconv.ParseBool(identName)
		if parseBool {
			f.GetCurrentBlock().NewBr(f.doBlockStmt(expr.Body))
		}
	default:
		fmt.Println("not impl doIfStmt")
	}
}

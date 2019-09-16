package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
	"strconv"
	"toir/utils"
)

type IFValue struct {
	X     value.Value //mul cond
	Y     value.Value //end one
	Br    *ir.Block
	Token token.Token
}

func NewIFValue(condX value.Value, condY value.Value, br *ir.Block, token token.Token) *IFValue {
	return &IFValue{X: condX, Y: condY, Br: br, Token: token}
}

func (i *IFValue) Type() types.Type {
	return i.X.Type()
}

func (i *IFValue) String() string {
	return i.X.String()
}

func (i *IFValue) Ident() string {
	return i.X.Ident()
}

func (f *FuncDecl) setOpts(cru *ir.Block, opts *IFValue, ifBodyBlock *ir.Block, elseBlock *ir.Block) {
	switch opts.Token {
	case token.LOR:
		cru.NewCondBr(opts, ifBodyBlock, opts.Br)
	case token.LAND:
		cru.NewCondBr(opts, opts.Br, elseBlock)
	}
}

func (f *FuncDecl) mulCond(iv *IFValue, ifBodyBlock *ir.Block, elseBlock *ir.Block) *ir.Block {
	if y, ok := iv.X.(*IFValue); ok {
		f.setOpts(y.Br, iv, ifBodyBlock, elseBlock)
		return f.mulCond(y, ifBodyBlock, elseBlock)
	} else {
		//set start
		f.setOpts(f.GetCurrentBlock(), iv, ifBodyBlock, elseBlock)
		return iv.Br
	}

}

func (f *FuncDecl) IfStmt(expr *ast.IfStmt) (start *ir.Block, end *ir.Block) {
	temp := f.GetCurrentBlock()
	block := f.newBlock()
	temp.NewBr(block)
	//init
	if expr.Init != nil {
		utils.GCCall(f, expr.Init)
	}
	//Cond
	switch expr.Cond.(type) {
	case *ast.BinaryExpr:
		var elseBlock *ir.Block
		//var endElseBlock *ir.Block
		//cond
		doCond := f.BinaryExpr(expr.Cond.(*ast.BinaryExpr))
		//if body
		ifBodyBlock, _ := f.BlockStmt(expr.Body)
		//else block
		if expr.Else != nil {
			call := utils.GCCall(f, expr.Else)
			elseBlock = call[0].(*ir.Block)
		}
		//empty block
		if elseBlock == nil {
			elseBlock = f.newBlock()
			f.popBlock()
		}
		if c, ok := doCond.(*IFValue); ok {
			c.Br.NewCondBr(doCond, ifBodyBlock, elseBlock) //end
			f.mulCond(c, ifBodyBlock, elseBlock)
		} else {
			block.NewCondBr(doCond, ifBodyBlock, elseBlock)
		}
		f.popBlock()
		if ifBodyBlock.Term == nil || elseBlock.Term == nil {
			f.popBlock() //Close main
			newBlock := f.newBlock()
			if ifBodyBlock.Term == nil {
				ifBodyBlock.NewBr(newBlock)
			}
			if elseBlock.Term == nil {
				elseBlock.NewBr(newBlock)
			}
		}
	case *ast.Ident:
		identName := GetIdentName(expr.Cond.(*ast.Ident))
		parseBool, _ := strconv.ParseBool(identName)
		if parseBool {
			_, stmt := f.BlockStmt(expr.Body)
			f.GetCurrentBlock().NewBr(stmt)
			f.popBlock() //close main
			empty := f.newBlock()
			stmt.NewBr(empty)
		}
	default:
		fmt.Println("not impl IfStmt")
	}
	return block, f.GetCurrentBlock()
}

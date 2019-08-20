package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
	"strconv"
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
	//iv.Br.NewCondBr(iv.Y, ifBodyBlock, elseBlock)
	//ifBodyBlock.NewBr(elseBlock)

}

func (f *FuncDecl) doIfStmt(expr *ast.IfStmt) {
	//init
	switch expr.Init.(type) {
	case *ast.AssignStmt:
		f.doAssignStmt(expr.Init.(*ast.AssignStmt))
	default:
		fmt.Println("expr.Init doIfStmt")
	}

	//Cond
	switch expr.Cond.(type) {
	case *ast.BinaryExpr:
		var elseBlock *ir.Block
		//if body
		ifBodyBlock := f.doBlockStmt(nil, expr.Body)
		//else block
		if expr.Else != nil {
			elseBlock = f.doBlockStmt(nil, expr.Else.(*ast.BlockStmt))
		}
		//empty block
		if elseBlock == nil {
			elseBlock = f.newBlock()
			f.popBlock()
		}
		//cond
		doCond := f.doBinary(expr.Cond.(*ast.BinaryExpr))
		if c, ok := doCond.(*IFValue); ok {
			c.Br.NewCondBr(doCond, ifBodyBlock, elseBlock) //end
			f.mulCond(c, ifBodyBlock, elseBlock)
		} else {
			f.GetCurrentBlock().NewCondBr(doCond, ifBodyBlock, elseBlock)
		}
	case *ast.Ident:
		identName := GetIdentName(expr.Cond.(*ast.Ident))
		parseBool, _ := strconv.ParseBool(identName)
		if parseBool {
			f.GetCurrentBlock().NewBr(f.doBlockStmt(nil, expr.Body))
		}
	default:
		fmt.Println("not impl doIfStmt")
	}
}

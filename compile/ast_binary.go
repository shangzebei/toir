package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/enum"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
)

func (f *FuncDecl) doBinary(expr *ast.BinaryExpr) value.Value {
	block := f.GetCurrentBlock()

	ifS := false
	var ifBr *ir.Block
	if expr.Op == token.LAND || expr.Op == token.LOR {
		ifS = true
	}
	//get x
	var x value.Value
	var y value.Value
	switch expr.X.(type) {
	case *ast.Ident:
		ident := expr.X.(*ast.Ident)
		x = f.doIdent(ident)
	case *ast.BasicLit:
		basicLit := expr.X.(*ast.BasicLit)
		x = f.BasicLitToConstant(basicLit)
	case *ast.BinaryExpr:
		x = f.doBinary(expr.X.(*ast.BinaryExpr))
	case *ast.CallExpr:
		x = f.doCallExpr(expr.X.(*ast.CallExpr))
	case *ast.IndexExpr:
		x = f.doIndexExpr(expr.X.(*ast.IndexExpr))
	case *ast.ParenExpr:
		x = f.doParenExpr(expr.X.(*ast.ParenExpr))
	case *ast.SelectorExpr:
		x = f.doSelector(nil, expr.X.(*ast.SelectorExpr), "type")
	default:
		fmt.Println("not impl doBinary")
	}

	if ifS {
		ifBr = f.newBlock()
	}
	//get y
	switch expr.Y.(type) {
	case *ast.Ident:
		ident := expr.Y.(*ast.Ident)
		y = f.doIdent(ident)
	case *ast.BasicLit:
		basicLit := expr.Y.(*ast.BasicLit)
		y = f.BasicLitToConstant(basicLit)
	case *ast.BinaryExpr:
		y = f.doBinary(expr.Y.(*ast.BinaryExpr))
	case *ast.CallExpr:
		y = f.doCallExpr(expr.Y.(*ast.CallExpr))
	case *ast.IndexExpr:
		y = f.doIndexExpr(expr.Y.(*ast.IndexExpr))
	case *ast.SelectorExpr:
		y = f.doSelector(nil, expr.Y.(*ast.SelectorExpr), "call")
	case *ast.ParenExpr:
		y = f.doParenExpr(expr.Y.(*ast.ParenExpr))
	default:
		fmt.Println("not impl doBinary")
	}

	if ifS {
		f.popBlock()
	}

	x = FixAlloc(f.GetCurrentBlock(), x)
	y = FixAlloc(f.GetCurrentBlock(), y)

	x = FixNil(x, y.Type())
	y = FixNil(y, x.Type())

	//get ops
	switch expr.Op {
	case token.ADD: // +
		return block.NewAdd(x, y)
	case token.SUB: // -
		return block.NewSub(x, y)
	case token.MUL: // x
		return block.NewMul(x, y)
	case token.QUO: // /
		return block.NewUDiv(x, y)
	case token.REM: // %
		return block.NewSRem(x, y)
	case token.AND: // &
		return block.NewAnd(x, y)
	case token.OR: // |
		return block.NewOr(x, y)
	case token.XOR: // !
		return block.NewXor(x, y)
	case token.SHL: // <<
		return block.NewShl(x, y)
	case token.SHR: // >>
		return block.NewLShr(x, y)
	case token.GTR: // >
		return block.NewICmp(enum.IPredSGT, x, y)
	case token.LSS: // <
		return block.NewICmp(enum.IPredSLT, x, y)
	case token.EQL: // ==
		return block.NewICmp(enum.IPredEQ, x, y)
	case token.LEQ: // <=
		return block.NewICmp(enum.IPredSLE, x, y)
	case token.GEQ: // >=
		return block.NewICmp(enum.IPredSGE, x, y)
	case token.LAND:
		return NewIFValue(x, y, ifBr, token.LAND)
	case token.LOR:
		return NewIFValue(x, y, ifBr, token.LOR)
	case token.NEQ:
		return block.NewICmp(enum.IPredNE, x, y)
	default:
		logrus.Error("not impl doBinary ops")
	}
	return nil
}

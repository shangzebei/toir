package convert

import (
	"fmt"
	"github.com/llir/llvm/ir/enum"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
	"strings"
)

func (f *FuncDecl) doBinary(expr *ast.BinaryExpr) value.Value {
	block := f.GetCurrentBlock()
	//get x
	var x value.Value
	var y value.Value
	switch expr.X.(type) {
	case *ast.Ident:
		ident := expr.X.(*ast.Ident)
		x = f.IdentToValue(ident)
	case *ast.BasicLit:
		basicLit := expr.X.(*ast.BasicLit)
		x = BasicLitToConstant(basicLit)
	case *ast.BinaryExpr:
		x = f.doBinary(expr.X.(*ast.BinaryExpr))
	case *ast.CallExpr:
		x = f.doCallExpr(expr.X.(*ast.CallExpr))
	case *ast.IndexExpr:
		x = f.doIndexExpr(expr.X.(*ast.IndexExpr))
	default:
		fmt.Println("not impl doBinary")
	}
	//get y
	switch expr.Y.(type) {
	case *ast.Ident:
		ident := expr.Y.(*ast.Ident)
		y = f.IdentToValue(ident)
	case *ast.BasicLit:
		basicLit := expr.Y.(*ast.BasicLit)
		y = BasicLitToConstant(basicLit)
	case *ast.BinaryExpr:
		y = f.doBinary(expr.Y.(*ast.BinaryExpr))
	case *ast.CallExpr:
		y = f.doCallExpr(expr.Y.(*ast.CallExpr))
	case *ast.IndexExpr:
		y = f.doIndexExpr(expr.Y.(*ast.IndexExpr))
	default:
		fmt.Println("not impl doBinary")
	}

	if x.Type() != y.Type() { //TODO mismatch
		fmt.Println("warm type mismatch")
		if strings.HasSuffix(x.Type().String(), "*") {
			x = f.GetCurrentBlock().NewLoad(x)
		}
	}

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
	case token.EQL: //==
		return block.NewICmp(enum.IPredEQ, x, y)
	default:
		fmt.Println("not impl doBinary ops")
	}
	return nil
}

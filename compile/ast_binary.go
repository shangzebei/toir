package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/enum"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
	"toir/utils"
)

func (f *FuncDecl) BinaryExpr(expr *ast.BinaryExpr) value.Value {
	block := f.GetCurrentBlock()

	ifS := false
	var ifBr *ir.Block
	if expr.Op == token.LAND || expr.Op == token.LOR {
		ifS = true
	}
	//get x
	var x = utils.GCCall(f, expr.X)[0].(value.Value)

	if ifS {
		ifBr = f.newBlock()
	}
	//get y
	var y = utils.GCCall(f, expr.Y)[0].(value.Value)

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
		if f.IsString(x.Type()) && f.IsString(y.Type()) {
			return f.GetCurrentBlock().NewLoad(f.CallRuntime("stringJoin", f.GetSrcPtr(x), f.GetSrcPtr(y)))
		} else {
			return block.NewAdd(x, y)
		}
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
		logrus.Error("not impl BinaryExpr ops")
	}
	return nil
}

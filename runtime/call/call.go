package call

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
)

type Call struct {
	Block *ir.Block
}

//
func (c *Call) SliceIntToI8(v value.Value) value.Value {
	return c.SliceToI8(v)

}

//
func (c *Call) SliceToI8(v value.Value) value.Value {
	return c.Block.NewBitCast(v, types.I8Ptr)
}

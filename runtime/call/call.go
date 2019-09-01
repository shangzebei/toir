package call

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"toir/llvm"
	"toir/stdlib"
	"toir/utils"
)

type Call struct {
	Block *ir.Block
	M     *ir.Module
}

//
func (c *Call) SliceIntToI8(v value.Value) value.Value {
	return c.SliceToI8(v)

}

//
func (c *Call) SliceToI8(v value.Value) value.Value {
	return c.Block.NewBitCast(v, types.I8Ptr)
}

//
func (c *Call) Unreachable() {
	c.Block.NewUnreachable()
	utils.StdCall(c.M, c.Block, stdlib.Exit, constant.NewInt(types.I32, 0))
}

func (c *Call) MemCopy(dst value.Value, src value.Value, len value.Value) {
	utils.StdCall(c.M, c.Block, llvm.Mencpy,
		dst,
		src,
		len,
		constant.NewBool(false))

}

func (c *Call) Malloc(size value.Value) value.Value {
	return utils.StdCall(c.M, c.Block, stdlib.Malloc, size)
}

//
func (c *Call) ArrayPtr(src value.Value, bytes value.Value, index value.Value) value.Value {
	fmt.Println(src)
	ptr := c.Block.NewGetElementPtr(src, c.Block.NewMul(bytes, index))
	return ptr
}

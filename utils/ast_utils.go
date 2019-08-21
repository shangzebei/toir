package utils

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
)

func Index(block *ir.Block, src value.Value, index int) *ir.InstGetElementPtr {
	return block.NewGetElementPtr(src, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, int64(index)))
}

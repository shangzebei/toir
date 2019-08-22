package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"learn/utils"
)

type SliceValue struct {
	SPtr       value.Value
	SInfoValue value.Value
	SLen       int64
	SCap       int64
	SOffset    int64
	ID         int
}

func (i *SliceValue) Type() types.Type {
	return i.SPtr.Type()
}

func (i *SliceValue) String() string {
	return i.SPtr.String()
}

func (i *SliceValue) Ident() string {
	return i.SPtr.Ident()
}

func NewAllocSlice(block *ir.Block, elemType types.Type) *SliceValue {
	if a, ok := elemType.(*types.ArrayType); ok {
		sliceValue := &SliceValue{SLen: int64(a.Len), SCap: int64(a.Len)}
		t := elemType.(*types.ArrayType)
		sliceValue.SPtr = block.NewAlloca(types.NewPointer(t.ElemType))
		ptr := block.NewGetElementPtr(block.NewAlloca(elemType), constant.NewInt(types.I64, 0), constant.NewInt(types.I64, 0))
		block.NewStore(ptr, sliceValue.SPtr)
		sliceValue.initSlice(block, a)
		return sliceValue
	}
	return nil
}

func (f *SliceValue) initSlice(block *ir.Block, bytes *types.ArrayType) {
	f.SInfoValue = block.NewAlloca(types.NewArray(uint64(3), types.I32))
	index0 := utils.Index(block, f.SInfoValue, 0) //len
	index1 := utils.Index(block, f.SInfoValue, 1) //cap
	index2 := utils.Index(block, f.SInfoValue, 2) //bytes
	block.NewStore(constant.NewInt(types.I32, f.SLen), index0)
	block.NewStore(constant.NewInt(types.I32, f.SCap), index1)
	block.NewStore(constant.NewInt(types.I32, GetSliceBytes(bytes)), index2)
}

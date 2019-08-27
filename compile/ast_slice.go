package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"learn/utils"
	"strconv"
	"strings"
)

type SliceArray struct {
	p value.Value
}

func (i *SliceArray) Type() types.Type {
	return i.p.Type()
}

func (i *SliceArray) String() string {
	return i.p.String()
}

func (i *SliceArray) Ident() string {
	return i.p.Ident()
}

func (f *FuncDecl) NewAllocSlice(block *ir.Block, elemType types.Type) value.Value {
	if t, ok := elemType.(*types.ArrayType); ok {
		//len,cap,elem bytes,ptr//TODO
		newTypeDef := f.m.NewTypeDef(f.GetCurrent().Name()+".slice", types.NewStruct(types.I32, types.I32, types.I32, types.NewPointer(t.ElemType)))
		alloca := f.GetCurrentBlock().NewAlloca(newTypeDef)
		alloca.SetName("array." + strconv.Itoa(len(f.GetCurrentBlock().Insts)))
		array := f.ToPtr(f.GetCurrentBlock().NewAlloca(t))
		f.GetCurrentBlock().NewStore(array, f.GetPSlice(alloca))
		f.GetCurrentBlock().NewStore(constant.NewInt(types.I32, GetSliceBytes(t)), f.GetPBytes(alloca))
		f.SetLen(alloca, constant.NewInt(types.I32, int64(t.Len)))
		f.SetCap(alloca, constant.NewInt(types.I32, int64(t.Len)))
		return &SliceArray{p: alloca}
	}
	return nil
}

func (f *FuncDecl) IsSlice(v value.Value) bool {
	if bit, ok := v.(*ir.InstBitCast); ok && strings.HasPrefix(bit.Name(), "array.") {
		return true
	}
	if _, ok := v.(*SliceArray); ok {
		return true
	}
	return false
}

func (f *FuncDecl) GetSliceIndex(v value.Value, index int) value.Value {
	load := f.GetCurrentBlock().NewLoad(f.GetPSlice(v))
	return f.GetCurrentBlock().NewExtractValue(load, uint64(index))
}

func (f *FuncDecl) GetPSlice(v value.Value) value.Value {
	return utils.Index(f.GetCurrentBlock(), v, 3)
}

func (f *FuncDecl) GetPLen(v value.Value) value.Value {
	return utils.Index(f.GetCurrentBlock(), v, 0)
}

func (f *FuncDecl) GetPCap(v value.Value) value.Value {
	return utils.Index(f.GetCurrentBlock(), v, 1)
}

func (f *FuncDecl) SetLen(slice value.Value, v value.Value) {
	f.GetCurrentBlock().NewStore(v, f.GetPLen(slice))
}

func (f *FuncDecl) SetCap(slice value.Value, v value.Value) {
	f.GetCurrentBlock().NewStore(v, f.GetPCap(slice))
}

func (f *FuncDecl) GetBytes(v value.Value) value.Value {
	return f.GetCurrentBlock().NewLoad(f.GetPBytes(v))
}
func (f *FuncDecl) GetPBytes(v value.Value) value.Value {
	return utils.Index(f.GetCurrentBlock(), v, 2)
}

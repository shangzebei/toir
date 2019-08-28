package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"learn/llvm"
	"learn/utils"
	"strconv"
	"strings"
)

type SliceArray struct {
	p   value.Value
	emt types.Type
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

var stTypeDef types.Type

func (f *FuncDecl) NewAllocSlice(block *ir.Block, elemType types.Type) value.Value {
	if t, ok := elemType.(*types.ArrayType); ok {
		//len,cap,elem bytes,ptr//TODO
		if stTypeDef == nil {
			stTypeDef = f.m.NewTypeDef("slice", types.NewStruct(types.I32, types.I32, types.I32, types.I8Ptr))
		}
		alloca := f.GetCurrentBlock().NewAlloca(stTypeDef)
		alloca.SetName("array." + strconv.Itoa(len(f.GetCurrentBlock().Insts)))
		array := f.ToPtr(f.GetCurrentBlock().NewAlloca(t))
		f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewBitCast(array, types.I8Ptr), f.GetPSlice(alloca))
		f.GetCurrentBlock().NewStore(constant.NewInt(types.I32, int64(GetBytes(t.ElemType))), f.GetPBytes(alloca))
		f.SetLen(alloca, constant.NewInt(types.I32, int64(t.Len)))
		f.SetCap(alloca, constant.NewInt(types.I32, int64(t.Len)))
		return &SliceArray{p: alloca, emt: t.ElemType}
	}
	return nil
}

func (f *FuncDecl) GetSliceDef() types.Type {
	return stTypeDef
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

func (f *FuncDecl) GetSliceIndex(v value.Value, index value.Value) value.Value {
	t, _ := v.(*SliceArray)
	load := f.GetCurrentBlock().NewLoad(f.GetPSlice(v))
	cast := f.GetCurrentBlock().NewBitCast(load, types.NewPointer(t.emt))
	return f.GetCurrentBlock().NewGetElementPtr(cast, index)
}

//i8**
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

func (f *FuncDecl) GetLen(slice value.Value) value.Value {
	return f.GetCurrentBlock().NewExtractValue(slice, 0)
}

func (f *FuncDecl) GetCap(slice value.Value) value.Value {
	return f.GetCurrentBlock().NewExtractValue(slice, 1)
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

func (f *FuncDecl) CopySlice(old value.Value, new value.Value) {
	getLen := f.GetLen(f.GetCurrentBlock().NewLoad(old))
	f.CopyStruct(old, new)
	f.StdCall(llvm.Mencpy,
		f.GetCurrentBlock().NewLoad(f.GetPSlice(new)),
		f.GetCurrentBlock().NewLoad(f.GetPSlice(old)),
		getLen,
		constant.NewBool(false))
}

func (f *FuncDecl) CopyStruct(old value.Value, new value.Value) {
	f.StdCall(llvm.Mencpy,
		f.GetCurrentBlock().NewBitCast(new, types.I8Ptr),
		f.GetCurrentBlock().NewBitCast(old, types.I8Ptr),
		constant.NewInt(types.I32, int64(GetStructBytes(old))),
		constant.NewBool(false))
}

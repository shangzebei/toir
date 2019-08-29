package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"toir/llvm"
	"toir/utils"

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

func (f *FuncDecl) NewAllocSlice(array types.Type) value.Value {
	alloca := f.GetCurrentBlock().NewAlloca(f.GetSliceType())
	alloca.SetName("array." + strconv.Itoa(len(f.GetCurrentBlock().Insts)))
	if t, ok := array.(*types.ArrayType); ok {
		//set types
		f.GetCurrentBlock().NewStore(constant.NewInt(types.I32, int64(GetBytes(t.ElemType))), f.GetPBytes(alloca))
		//len,cap,elem bytes,ptr//TODO
		if t.Len != 0 {
			array := f.GetCurrentBlock().NewAlloca(t)
			cast := f.GetCurrentBlock().NewBitCast(array, types.NewPointer(types.I8Ptr))
			f.GetCurrentBlock().NewStore(cast, f.GetPSlice(alloca))
			f.SetLen(alloca, constant.NewInt(types.I32, int64(t.Len)))
			f.SetCap(alloca, constant.NewInt(types.I32, int64(t.Len)))
		}
		return &SliceArray{p: alloca, emt: t.ElemType}
	}
	return &SliceArray{p: alloca}
}

func (f *FuncDecl) GetSliceType() types.Type {
	if stTypeDef == nil {
		stTypeDef = f.m.NewTypeDef("slice", types.NewStruct(types.I32, types.I32, types.I32, types.NewPointer(types.I8Ptr)))
	}
	return stTypeDef
}

func (f *FuncDecl) IsSlice(v value.Value) bool {
	if bit, ok := v.(*ir.InstBitCast); ok && strings.HasPrefix(bit.Name(), "array.") {
		return true
	}
	if _, ok := v.(*SliceArray); ok {
		return true
	}
	if v.Type() == f.GetSliceType() && v.Type().Name() == "slice" {
		return true
	}
	return false
}

func (f *FuncDecl) GetSliceIndex(v value.Value, index value.Value) value.Value {
	t, _ := v.(*SliceArray)
	cast := f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(f.GetPSlice(v)), types.NewPointer(t.emt))
	return f.GetCurrentBlock().NewGetElementPtr(cast, index)
}

//slice*** [char **]
func (f *FuncDecl) GetPSlice(v value.Value) value.Value {
	return utils.Index(f.GetCurrentBlock(), v, 3)
}

//addr char *
func (f *FuncDecl) GetVSlice(v value.Value) value.Value {
	return f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(f.GetPSlice(v)), types.I8Ptr)
}

func (f *FuncDecl) GetPLen(v value.Value) value.Value {
	return utils.Index(f.GetCurrentBlock(), v, 0)
}

func (f *FuncDecl) GetPBytes(v value.Value) value.Value {
	return utils.Index(f.GetCurrentBlock(), v, 2)
}

func (f *FuncDecl) GetPCap(v value.Value) value.Value {
	return utils.Index(f.GetCurrentBlock(), v, 1)
}

////////////////////////v////////////////////////////////////////////
func (f *FuncDecl) SetLen(slice value.Value, v value.Value) {
	f.GetCurrentBlock().NewStore(v, f.GetPLen(slice))
}

//func (f *FuncDecl) GetSlice(slice value.Value) value.Value {
//	extractValue := f.GetCurrentBlock().NewExtractValue(f.GetCurrentBlock().NewLoad(slice), 3)
//	return f.GetCurrentBlock().NewLoad(extractValue)
//}

func (f *FuncDecl) GetLen(slice value.Value) value.Value {
	return f.GetCurrentBlock().NewExtractValue(f.GetCurrentBlock().NewLoad(slice), 0)
}

func (f *FuncDecl) GetBytes(slice value.Value) value.Value {
	return f.GetCurrentBlock().NewExtractValue(f.GetCurrentBlock().NewLoad(slice), 2)
}

func (f *FuncDecl) GetCap(slice value.Value) value.Value {
	return f.GetCurrentBlock().NewExtractValue(f.GetCurrentBlock().NewLoad(slice), 1)
}
func (f *FuncDecl) SetCap(slice value.Value, v value.Value) {
	f.GetCurrentBlock().NewStore(v, f.GetPCap(slice))
}

func (f *FuncDecl) CopySlice(dst value.Value, src value.Value) {
	if f.IsSlice(src) && f.IsSlice(src) {
		f.CopyStruct(dst, src)
		f.Copy(dst, src)
	} else {
		logrus.Error("copy dst or src is not sliceArray")
	}
}

func (f *FuncDecl) CopyStruct(dst value.Value, src value.Value) {
	f.StdCall(llvm.Mencpy,
		f.GetCurrentBlock().NewBitCast(dst, types.I8Ptr),
		f.GetCurrentBlock().NewBitCast(src, types.I8Ptr),
		constant.NewInt(types.I32, int64(GetStructBytes(src))),
		constant.NewBool(false))
}

func (f *FuncDecl) toSlice(value2 value.Value) *SliceArray {
	if t, ok := value2.(*SliceArray); ok {
		return t
	}
	return nil
}

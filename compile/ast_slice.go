package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"strconv"
	"strings"
	"toir/llvm"
	"toir/stdlib"
	"toir/utils"
)

type SliceValue struct {
	p   value.Value
	emt types.Type
}

func (i *SliceValue) Type() types.Type {
	return i.p.Type()
}

func (i *SliceValue) String() string {
	return i.p.String()
}

func (i *SliceValue) Ident() string {
	return i.p.Ident()
}

var sliceTypes []types.Type

func (f *FuncDecl) NewAllocSlice(em types.Type, arrayLen value.Value) value.Value {
	if em == nil {
		panic("error type in NewAllocSlice")
	}
	utils.NewComment(f.GetCurrentBlock(), "init slice...............")
	newStruct := types.NewStruct(types.I32, types.I32, types.I32, types.NewPointer(em))
	sliceTypes = append(sliceTypes, newStruct)
	alloc := f.GetCurrentBlock().NewAlloca(newStruct)
	i := int64(GetBytes(em))
	f.SetBytes(alloc, constant.NewInt(types.I32, i))
	alloc.SetName("array." + strconv.Itoa(len(f.GetCurrentBlock().Insts)))
	call := f.StdCall(stdlib.Malloc, f.GetCurrentBlock().NewMul(arrayLen, constant.NewInt(types.I32, i)))
	slice := f.GetPSlice(alloc)
	f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewBitCast(call, types.NewPointer(em)), slice)
	f.SetCap(alloc, arrayLen)
	utils.NewComment(f.GetCurrentBlock(), "end init slice.................")
	return &SliceValue{p: alloc, emt: em}
}

func (f *FuncDecl) GetSliceType() types.Type {
	return f.GlobDef["slice"]
}

func (f *FuncDecl) IsSlice(v value.Value) bool {
	if bit, ok := v.(*ir.InstBitCast); ok && strings.HasPrefix(bit.Name(), "array.") {
		return true
	}
	if _, ok := v.(*SliceValue); ok {
		return true
	}
	baseType := GetBaseType(v.Type())
	for _, value := range sliceTypes {
		if baseType == value {
			return true
		}
	}
	return false
}

func (f *FuncDecl) GetSliceIndex(v value.Value, index value.Value) value.Value {

	utils.NewComment(f.GetCurrentBlock(), "get slice index")
	//decl := f.DoFunDecl("runtime", f.r.GetFunc("indexSlice"))
	//return f.GetCurrentBlock().NewLoad(f.GetCurrentBlock().NewBitCast(f.StdCall(decl, v, index), p))
	slice := f.GetPSlice(f.GetSrcPtr(v))

	return f.GetCurrentBlock().NewLoad(f.GetCurrentBlock().NewGetElementPtr(f.GetCurrentBlock().NewLoad(slice), index))
}

//slice*** [char **]
func (f *FuncDecl) GetPSlice(v value.Value) value.Value {
	return utils.IndexStruct(f.GetCurrentBlock(), v, 3)
}

//addr char *
func (f *FuncDecl) GetVSlice(v value.Value) value.Value {
	return f.GetCurrentBlock().NewLoad(f.GetPSlice(v))
}

func (f *FuncDecl) GetPLen(v value.Value) value.Value {
	return utils.IndexStruct(f.GetCurrentBlock(), v, 0)
}

func (f *FuncDecl) GetPBytes(v value.Value) value.Value {
	return utils.IndexStruct(f.GetCurrentBlock(), v, 2)
}

func (f *FuncDecl) GetPCap(v value.Value) value.Value {
	return utils.IndexStruct(f.GetCurrentBlock(), v, 1)
}

////////////////////////v////////////////////////////////////////////
func (f *FuncDecl) SetLen(slice value.Value, v value.Value) {
	f.GetCurrentBlock().NewStore(v, f.GetPLen(slice))
}
func (f *FuncDecl) SetBytes(slice value.Value, v value.Value) {
	f.GetCurrentBlock().NewStore(v, f.GetPBytes(slice))
}

//func (f *FuncDecl) GetSlice(slice value.Value) value.Value {
//	extractValue := f.GetCurrentBlock().NewExtractValue(f.GetCurrentBlock().NewLoad(slice), 3)
//	return f.GetCurrentBlock().NewLoad(extractValue)
//}

func (f *FuncDecl) GetLen(slice value.Value) value.Value {
	return f.GetCurrentBlock().NewExtractValue(slice, 0)
}

func (f *FuncDecl) GetBytes(slice value.Value) value.Value {
	return f.GetCurrentBlock().NewExtractValue(slice, 2)
}

func (f *FuncDecl) GetCap(slice value.Value) value.Value {
	return f.GetCurrentBlock().NewExtractValue(slice, 1)
}
func (f *FuncDecl) SetCap(slice value.Value, v value.Value) {
	f.GetCurrentBlock().NewStore(v, f.GetPCap(slice))
}

func (f *FuncDecl) CopyNewSlice(src value.Value) value.Value {
	if f.IsSlice(src) {
		utils.NewComment(f.GetCurrentBlock(), "copy and new slice")
		baseType := GetBaseType(src.Type())
		structType := baseType.(*types.StructType)
		i := structType.Fields[3]
		getLen := f.GetLen(utils.LoadValue(f.GetCurrentBlock(), utils.LoadValue(f.GetCurrentBlock(), src)))
		dstSlice := f.NewAllocSlice(GetBaseType(i), getLen)
		f.CopyStruct(dstSlice, f.GetSrcPtr(src))
		utils.NewComment(f.GetCurrentBlock(), "copy and end slice")
		return dstSlice
	} else {
		logrus.Error("copy dst or src is not sliceArray")
	}
	return nil
}

func (f *FuncDecl) CopyStruct(dst value.Value, src value.Value) {
	f.StdCall(llvm.Mencpy,
		f.GetCurrentBlock().NewBitCast(f.GetSrcPtr(dst), types.I8Ptr),
		f.GetCurrentBlock().NewBitCast(f.GetSrcPtr(src), types.I8Ptr),
		constant.NewInt(types.I32, int64(GetStructBytes(src))),
		constant.NewBool(false))
}

func (f *FuncDecl) toSlice(value2 value.Value) *SliceValue {
	if t, ok := value2.(*SliceValue); ok {
		return t
	}
	return nil
}

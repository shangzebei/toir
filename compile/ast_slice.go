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

// --- [ Structure types ] -----------------------------------------------------

// StructType is an LLVM IR structure type. Identified (named) struct types are
// uniqued by type names, not by structural identity.
type SliceType struct {
	types.StructType
	// Type name; or empty if not present.
	TypeName string
	// Packed memory layout.
	Packed bool
	// Struct fields.
	Fields []types.Type
	// Opaque struct type.
	Opaque bool

	EmType types.Type
}

func NewCopySlice(s *SliceType, em types.Type) *SliceType {
	return &SliceType{
		TypeName: s.TypeName,
		Packed:   s.Packed,
		Fields:   s.Fields,
		Opaque:   s.Opaque,
		EmType:   em,
	}
}

// NewStruct returns a new struct type based on the given field types.
func NewSlice(em types.Type, fields ...types.Type) *SliceType {
	return &SliceType{
		Fields: fields,
		EmType: em,
	}
}

// Equal reports whether t and u are of equal type.
func (t *SliceType) Equal(u types.Type) bool {
	if u, ok := u.(*SliceType); ok {
		if len(t.TypeName) > 0 || len(u.TypeName) > 0 {
			// Identified struct types are uniqued by type names, not by structural
			// identity.
			//
			// t or u is an identified struct type.
			return t.TypeName == u.TypeName
		}
		// Literal struct types are uniqued by structural identity.
		if t.Packed != u.Packed {
			return false
		}
		if len(t.Fields) != len(u.Fields) {
			return false
		}
		for i := range t.Fields {
			if !t.Fields[i].Equal(u.Fields[i]) {
				return false
			}
		}
		return true
	}
	return false
}

// String returns the string representation of the structure type.
func (t *SliceType) String() string {
	if len(t.TypeName) > 0 {
		return utils.Local(t.TypeName)
	}
	return t.LLString()
}

// LLString returns the LLVM syntax representation of the definition of the
// type.
func (t *SliceType) LLString() string {
	// Opaque struct type.
	//
	//    'opaque'
	//
	// Struct type.
	//
	//    '{' Fields=(Type separator ',')+? '}'
	//
	// Packed struct type.
	//
	//    '<' '{' Fields=(Type separator ',')+? '}' '>'   -> PackedStructType
	if t.Opaque {
		return "opaque"
	}
	if len(t.Fields) == 0 {
		if t.Packed {
			return "<{}>"
		}
		return "{}"
	}
	buf := &strings.Builder{}
	if t.Packed {
		buf.WriteString("<")
	}
	buf.WriteString("{ ")
	for i, field := range t.Fields {
		if i != 0 {
			buf.WriteString(", ")
		}
		buf.WriteString(field.String())
	}
	buf.WriteString(" }")
	if t.Packed {
		buf.WriteString(">")
	}
	return buf.String()
}

// Name returns the type name of the type.
func (t *SliceType) Name() string {
	return t.TypeName
}

// SetName sets the type name of the type.
func (t *SliceType) SetName(name string) {
	t.TypeName = name
}

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
			cast := f.GetCurrentBlock().NewBitCast(array, types.I8Ptr)
			f.GetCurrentBlock().NewStore(cast, f.GetPSlice(alloca))
			f.SetLen(alloca, constant.NewInt(types.I32, int64(t.Len)))
			f.SetCap(alloca, constant.NewInt(types.I32, int64(t.Len)))
		}
		return &SliceValue{p: alloca, emt: t.ElemType}
	} else {
		logrus.Debugf("not init slice type %s", array)
	}
	return &SliceValue{p: alloca}
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
	if GetBaseType(v.Type()) == f.GetSliceType() {
		return true
	}
	return false
}

var cast value.Value

func (f *FuncDecl) GetSliceIndex(v value.Value, index value.Value, p types.Type) value.Value {
	if l, ok := v.(*ir.InstLoad); ok {
		v = l.Src
	}
	//decl := f.DoFunDecl("runtime", f.r.GetFunc("indexSlice"))
	//return f.GetCurrentBlock().NewLoad(f.GetCurrentBlock().NewBitCast(f.StdCall(decl, v, index), p))
	slice := f.GetPSlice(v)
	if cast == nil {
		cast = f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(slice), p)
	}
	return f.GetCurrentBlock().NewLoad(f.GetCurrentBlock().NewGetElementPtr(cast, index))
}

//slice*** [char **]
func (f *FuncDecl) GetPSlice(v value.Value) value.Value {
	return utils.IndexStruct(f.GetCurrentBlock(), v, 3)
}

//addr char *
func (f *FuncDecl) GetVSlice(v value.Value) value.Value {
	return f.GetPSlice(v)
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
		decl := f.DoFunDecl("runtime", f.r.GetFunc("copyNewSlice"))
		call := f.StdCall(decl, src)
		alloca := f.GetCurrentBlock().NewAlloca(call.Type())
		f.GetCurrentBlock().NewStore(call, alloca)
		return f.GetCurrentBlock().NewLoad(alloca)
	} else {
		logrus.Error("copy dst or src is not sliceArray")
	}
	return nil
}

func (f *FuncDecl) CopyStruct(dst value.Value, src value.Value) {
	f.StdCall(llvm.Mencpy,
		f.GetCurrentBlock().NewBitCast(dst, types.I8Ptr),
		f.GetCurrentBlock().NewBitCast(src, types.I8Ptr),
		constant.NewInt(types.I32, int64(GetStructBytes(src))),
		constant.NewBool(false))
}

func (f *FuncDecl) toSlice(value2 value.Value) *SliceValue {
	if t, ok := value2.(*SliceValue); ok {
		return t
	}
	return nil
}

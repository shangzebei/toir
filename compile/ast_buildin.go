package compile

import (
	"fmt"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"toir/llvm"
	"toir/stdlib"
	"toir/utils"
)

func (f *FuncDecl) IntType(value2 value.Value, typ types.Type) value.Value {
	switch value2.Type() {
	case types.Float:
		return f.GetCurrentBlock().NewFPToSI(value2, types.I32)
	case types.I8, types.I16, types.I32, types.I64:
		intType := value2.Type().(*types.IntType)
		intType1 := typ.(*types.IntType)
		if intType.BitSize == intType1.BitSize {
			return value2
		}
		if intType.BitSize < intType1.BitSize {
			return f.GetCurrentBlock().NewSExt(value2, typ)
		} else {
			return f.GetCurrentBlock().NewTrunc(value2, typ)
		}
	default:
		fmt.Println("not impl ")
	}
	return nil
}

//to int32
func (f *FuncDecl) Int32(value2 value.Value) value.Value {
	return f.IntType(value2, types.I32)
}

func (f *FuncDecl) Int16(value2 value.Value) value.Value {
	return f.IntType(value2, types.I16)
}

//to int64
func (f *FuncDecl) Int64(value2 value.Value) value.Value {
	return f.IntType(value2, types.I64)
}

func (f *FuncDecl) Int8(value2 value.Value) value.Value {
	return f.IntType(value2, types.I8)
}

func (f *FuncDecl) Float32(value2 value.Value) value.Value {
	if _, ok := value2.(constant.Constant); ok {
		return value2
	}
	return f.GetCurrentBlock().NewSIToFP(value2, types.Float)
}

func (f *FuncDecl) Float64(value2 value.Value) value.Value {
	return f.Float32(value2)
}

//////////////////slice////////////////////
func (f *FuncDecl) Len(value2 value.Value) value.Value {
	return f.GetLen(value2)
}

func (f *FuncDecl) Cap(value2 value.Value) value.Value {
	return f.GetCap(value2)
}

//func copy(dst, src []Type) int
func (f *FuncDecl) Copy(dst value.Value, src value.Value) value.Value {
	if f.IsSlice(dst) && f.IsSlice(src) {
		len := f.Len(src)
		return f.StdCall(llvm.Mencpy,
			f.GetVSlice(dst),
			f.GetVSlice(src),
			f.GetCurrentBlock().NewMul(len, f.GetBytes(src)),
			constant.NewBool(false))
		return len
	} else {
		logrus.Error("copy dst or src is not sliceArray")
		return nil
	}
}

func (f *FuncDecl) NewType(tp types.Type) value.Value {
	switch tp.(type) {
	case *types.ArrayType:
		return f.NewAllocSlice(tp)
	case *types.StructType:
		if tp == f.GetSliceType() && tp.Name() == "slice" {
			return f.NewAllocSlice(tp)
		} else {
			return f.GetCurrentBlock().NewAlloca(tp)
		}
	default:
		logrus.Warnf("default NewAlloca %s", tp.String())
		alloca := f.GetCurrentBlock().NewAlloca(tp)
		return alloca
	}
	return nil
}

func (f *FuncDecl) Append(value2 value.Value, elems ...value.Value) value.Value {
	if f.IsSlice(value2) {
		decl := f.DoFunDecl("runtime", f.r.GetFunc("checkGrow"))
		srcPtr := f.GetSrcPtr(value2)
		utils.NewComment(f.GetCurrentBlock(), "append start---------------------")
		//malloc
		call := f.StdCall(
			decl,
			srcPtr,
		)

		lenPtr := f.GetPLen(srcPtr)
		len := f.GetCurrentBlock().NewLoad(lenPtr)

		slice := f.CopyNewSlice(f.GetSrcPtr(value2))

		slicePtr := f.GetPSlice(slice)
		newPtr := f.GetPLen(slice)

		//store call
		f.GetCurrentBlock().NewStore(call, slicePtr)

		//append
		utils.NewComment(f.GetCurrentBlock(), "append value")
		i := elems[0]
		bitCast := f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(slicePtr), types.NewPointer(i.Type()))
		ptr := f.GetCurrentBlock().NewGetElementPtr(bitCast, len)
		f.GetCurrentBlock().NewStore(i, ptr)

		utils.NewComment(f.GetCurrentBlock(), "store len value")
		newAdd := f.GetCurrentBlock().NewAdd(len, constant.NewInt(types.I32, 1))
		f.GetCurrentBlock().NewStore(newAdd, newPtr)
		utils.NewComment(f.GetCurrentBlock(), "append end-------------------------")

		return utils.LoadValue(f.GetCurrentBlock(), slice)
	}
	return nil
}

//TODO
func (f *FuncDecl) Make(v value.Value, size ...value.Value) value.Value {
	if t, ok := v.(*SliceValue); ok {
		allocSlice := f.NewAllocSlice(types.NewArray(0, t.emt))
		call := f.StdCall(stdlib.Malloc, f.GetCurrentBlock().NewMul(size[0], f.GetBytes(v)))
		f.GetCurrentBlock().NewStore(call, f.GetPSlice(allocSlice))
		f.SetCap(allocSlice, size[0])
		f.SetLen(allocSlice, size[0])
		return allocSlice
	}
	return nil

}

func (f *FuncDecl) New(v value.Value) value.Value {
	alloca := f.NewType(v.Type())
	return alloca
}

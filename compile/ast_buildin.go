package compile

import (
	"fmt"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"toir/llvm"
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
	utils.NewComment(f.GetCurrentBlock(), "copy ptr..........start")
	if f.IsSlice(dst) && f.IsSlice(src) {
		loadValue := utils.LoadValue(f.GetCurrentBlock(), src)
		len := f.Len(loadValue)
		f.StdCall(llvm.Mencpy,
			f.GetCurrentBlock().NewBitCast(f.GetVSlice(f.GetSrcPtr(dst)), types.I8Ptr),
			f.GetCurrentBlock().NewBitCast(f.GetVSlice(f.GetSrcPtr(src)), types.I8Ptr),
			f.GetCurrentBlock().NewMul(len, f.GetBytes(loadValue)),
			constant.NewBool(false))
		utils.NewComment(f.GetCurrentBlock(), "copy ptr..........end")
		return len
	} else {
		logrus.Error("copy dst or src is not sliceArray")
		return nil
	}
}

func (f *FuncDecl) NewType(tp types.Type) value.Value {
	switch tp.(type) {
	case *types.ArrayType:
		arrayType := tp.(*types.ArrayType)
		return f.NewAllocSlice(arrayType.ElemType, constant.NewInt(types.I32, int64(arrayType.Len)))
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
		//i8 * checkGrow(i8 *,len i32,cap i32,bytes i32)
		call := f.StdCall(
			decl,
			f.GetCurrentBlock().NewBitCast(f.GetVSlice(srcPtr), types.I8Ptr),
			f.GetLen(value2),
			f.GetCap(value2),
			f.GetBytes(value2),
		)
		lenPtr := f.GetPLen(srcPtr)
		len := f.GetCurrentBlock().NewLoad(lenPtr)

		slice := f.CopyNewSlice(srcPtr)

		slicePtr := f.GetPSlice(slice)
		newPtr := f.GetPLen(slice)

		//store call
		indexStruct := utils.IndexStructValue(f.GetCurrentBlock(), call, 0) //ptr
		indexCap := utils.IndexStructValue(f.GetCurrentBlock(), call, 1)    //cap
		f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewBitCast(indexStruct, types.NewPointer(GetBaseType(slicePtr.Type()))), slicePtr)

		//append
		utils.NewComment(f.GetCurrentBlock(), "store value")
		i := elems[0]
		bitCast := f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(slicePtr), types.NewPointer(i.Type()))
		ptr := f.GetCurrentBlock().NewGetElementPtr(bitCast, len)
		f.GetCurrentBlock().NewStore(i, ptr)

		utils.NewComment(f.GetCurrentBlock(), "add 1 len")
		newAdd := f.GetCurrentBlock().NewAdd(len, constant.NewInt(types.I32, 1))
		f.GetCurrentBlock().NewStore(newAdd, newPtr)

		//set cap
		f.SetCap(slice, indexCap)

		utils.NewComment(f.GetCurrentBlock(), "append end-------------------------")

		return utils.LoadValue(f.GetCurrentBlock(), slice)
	}
	return nil
}

func (f *FuncDecl) Make(v value.Value, size ...value.Value) value.Value {
	return f.GetCurrentBlock().NewLoad(f.NewAllocSlice(v.Type(), size[0]))
}

func (f *FuncDecl) New(v value.Value) value.Value {
	alloca := f.NewType(v.Type())
	return alloca
}

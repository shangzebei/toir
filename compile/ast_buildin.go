package compile

import (
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
	case types.I1, types.I8, types.I16, types.I32, types.I64:
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
		logrus.Warnf("not impl src %s ept %s", value2.Type().String(), typ.String())
		return value2
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

func (f *FuncDecl) Uint(value2 value.Value) value.Value {
	return f.IntType(value2, types.I32)
}

//to int64
func (f *FuncDecl) Int64(value2 value.Value) value.Value {
	return f.IntType(value2, types.I64)
}

func (f *FuncDecl) Int8(value2 value.Value) value.Value {
	return f.IntType(value2, types.I8)
}

func (f *FuncDecl) Float32(value2 value.Value) value.Value {
	if types.IsFloat(value2.Type()) {
		return value2
	}
	return f.GetCurrentBlock().NewSIToFP(value2, types.Float)
}

func (f *FuncDecl) Float64(value2 value.Value) value.Value {
	return f.Float32(value2)
}

//////////////////slice or string////////////////////
func (f *FuncDecl) Len(value2 value.Value) value.Value {
	switch {
	case f.IsSlice(value2):
		return f.GetLen(f.GetSrcPtr(value2))
	case f.IsString(value2.Type()):
		return f.CallRuntime("getStringLen", f.GetSrcPtr(value2))
	default:
		return nil
	}
}

func (f *FuncDecl) Cap(value2 value.Value) value.Value {
	return f.GetCap(f.GetSrcPtr(value2))
}

//func copy(dst, src []Type) int
func (f *FuncDecl) Copy(dst value.Value, src value.Value) value.Value {
	utils.NewComment(f.GetCurrentBlock(), "copy ptr..........start")
	if f.IsSlice(dst) && f.IsSlice(src) {
		srcPtr := f.GetSrcPtr(src)
		len := f.GetLen(srcPtr)
		f.StdCall(llvm.Mencpy,
			f.GetCurrentBlock().NewBitCast(f.GetVSlice(f.GetSrcPtr(dst)), types.I8Ptr),
			f.GetCurrentBlock().NewBitCast(f.GetVSlice(f.GetSrcPtr(src)), types.I8Ptr),
			f.GetCurrentBlock().NewMul(len, f.GetBytes(srcPtr)),
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
		return f.NewSlice(arrayType.ElemType, constant.NewInt(types.I32, int64(arrayType.Len)))
	case *types.StructType:
		structType := tp.(*types.StructType)
		if f.rf == true {
			logrus.Warnf("default Malloc with runtime %s", tp.String())
			call := f.StdCall(stdlib.Malloc, constant.NewInt(types.I32, int64(GetStructBytes(structType))))
			return f.GetCurrentBlock().NewBitCast(call, types.NewPointer(tp))
		}
		if f.StringType() == tp {
			return f.NewString(constant.NewInt(types.I32, 0))
		} else {
			logrus.Warnf("default Malloc new %s", tp.String())
			call := f.StdCall(stdlib.Malloc, constant.NewInt(types.I32, int64(GetStructBytes(structType))))
			return f.GetCurrentBlock().NewBitCast(call, types.NewPointer(tp))
		}
	default:
		logrus.Warnf("default NewAlloca %s", tp.String())
		return f.GetCurrentBlock().NewAlloca(tp)
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
			f.GetLen(srcPtr),
			f.GetCap(srcPtr),
			f.GetBytes(srcPtr),
			constant.NewInt(types.I32, int64(len(elems))),
		)
		lenPtr := f.GetPLen(srcPtr)
		length := f.GetCurrentBlock().NewLoad(lenPtr)

		newSlice := f.CopyNewSlice(srcPtr)

		slicePtr := f.GetPSlice(newSlice)
		newLenPtr := f.GetPLen(newSlice)

		//store call
		indexStruct := utils.IndexStructValue(f.GetCurrentBlock(), call, 0) //ptr
		indexCap := utils.IndexStructValue(f.GetCurrentBlock(), call, 1)    //cap

		f.NewStore(f.GetCurrentBlock().NewBitCast(indexStruct, types.NewPointer(utils.GetBaseType(slicePtr.Type()))), slicePtr)

		//append
		utils.NewComment(f.GetCurrentBlock(), "store value")

		for index, value := range elems {
			bitCast := f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(slicePtr), types.NewPointer(value.Type()))
			ptr := f.GetCurrentBlock().NewGetElementPtr(bitCast, f.GetCurrentBlock().NewAdd(length, constant.NewInt(types.I32, int64(index))))
			f.NewStore(value, ptr)
		}

		utils.NewComment(f.GetCurrentBlock(), "add len")
		newAdd := f.GetCurrentBlock().NewAdd(length, constant.NewInt(types.I32, int64(len(elems))))
		f.NewStore(newAdd, newLenPtr)

		//set cap
		f.SetCap(newSlice, indexCap)

		utils.NewComment(f.GetCurrentBlock(), "append end-------------------------")

		return utils.LoadValue(f.GetCurrentBlock(), newSlice)
	}
	logrus.Error("Append return nil")
	return nil
}

func (f *FuncDecl) Make(v value.Value, size ...value.Value) value.Value {
	return f.GetCurrentBlock().NewLoad(f.NewSlice(v.Type(), size[0]))
}

func (f *FuncDecl) New(v value.Value) value.Value {
	alloca := f.NewType(v.Type())
	return alloca
}

func (f *FuncDecl) Print(v ...value.Value) value.Value {
	for i := 0; i < len(v); i++ {
		if f.IsSlice(v[i]) {
			v[i] = f.GetVSlice(f.GetSrcPtr(v[i]))
		}
		if f.IsString(v[i].Type()) {
			v[i] = f.GetCurrentBlock().NewLoad(f.GetPString(f.GetSrcPtr(v[i])))
		}
	}
	return f.StdCall(stdlib.Printf, v...)
}

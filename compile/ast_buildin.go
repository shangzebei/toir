package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/enum"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"toir/llvm"
	"toir/stdlib"
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
			f.GetCurrentBlock().NewAlloca(tp)
		}
	default:
		logrus.Warnf("default NewAlloca %s", tp.String())
		return f.GetCurrentBlock().NewAlloca(tp)
	}
	return nil
}

func (f *FuncDecl) Append(value2 value.Value, elems ...value.Value) value.Value {
	if f.IsSlice(value2) {
		//malloc
		call := f.StdCall(
			f.checkAppend(value2, types.I32),
			value2,
		)
		slice := f.GetVSlice(value2)
		f.GetCurrentBlock().NewStore(call, slice)

		//append
		lenPtr := f.GetPLen(value2)
		len := f.GetCurrentBlock().NewLoad(lenPtr)
		i := elems[0]
		bitCast := f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(slice), types.NewPointer(i.Type()))
		ptr := f.GetCurrentBlock().NewGetElementPtr(bitCast, len)
		f.GetCurrentBlock().NewStore(i, ptr)
		//store len+1
		f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewAdd(len, constant.NewInt(types.I32, 1)), lenPtr)
		//

		return value2
	}
	return nil
}

func (f *FuncDecl) newSlice(b *ir.Func) *ir.Block {
	block := b.NewBlock("")
	slice := ir.NewParam("ptr", types.NewPointer(f.GetSliceType())) //slice ptr
	len := block.NewGetElementPtr(slice, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 0))
	cap := block.NewGetElementPtr(slice, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 1))
	src := block.NewGetElementPtr(slice, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 3))

	//cap
	vlen := block.NewLoad(len)
	vcap := block.NewLoad(cap)
	vbytes := block.NewExtractValue(block.NewLoad(slice), 2)
	vcapAddLen := block.NewAdd(vcap, constant.NewInt(types.I32, 4))
	dst := f.Call(block, stdlib.Malloc, block.NewMul(vcapAddLen, vbytes)) //i8* ptr

	f.Call(block,
		llvm.Mencpy,
		dst, //block.NewLoad(malloc),
		block.NewLoad(src),
		block.NewMul(vlen, vbytes),
		constant.NewBool(false),
	)
	block.NewStore(vcapAddLen, cap) //store cap
	block.NewRet(dst)
	return block
}

func (f *FuncDecl) appendSlice(b *ir.Func) *ir.Block {
	block := b.NewBlock("")
	slice := ir.NewParam("ptr", types.NewPointer(f.GetSliceType())) //slice ptr
	src := block.NewGetElementPtr(slice, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, 3))
	block.NewRet(block.NewLoad(src))
	return block
}

func (f *FuncDecl) checkAppend(src value.Value, p types.Type) *ir.Func {
	//i8 * checkAppend(slice *)
	newFunc := ir.NewFunc("checkAppend",
		types.I8Ptr,
		ir.NewParam("ptr", types.NewPointer(f.GetSliceType())),
	)

	newBlock := newFunc.NewBlock("")
	param := newBlock.NewLoad(ir.NewParam("ptr", types.NewPointer(f.GetSliceType())))
	cmp := newBlock.NewICmp(enum.IPredSGE,
		newBlock.NewExtractValue(param, 0),
		newBlock.NewExtractValue(param, 1),
	)

	newBlock.NewCondBr(cmp,
		f.newSlice(newFunc),
		f.appendSlice(newFunc),
	)
	return newFunc
}

//TODO
func (f *FuncDecl) Make(v value.Value, size ...value.Value) value.Value {
	if t, ok := v.(*SliceArray); ok {
		allocSlice := f.NewAllocSlice(types.NewArray(0, t.emt))
		call := f.StdCall(stdlib.Malloc, f.GetCurrentBlock().NewMul(size[0], f.GetBytes(v)))
		f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewBitCast(call, types.NewPointer(types.I8Ptr)), f.GetPSlice(allocSlice))
		f.SetCap(allocSlice, size[0])
		f.SetLen(allocSlice, size[0])
		return allocSlice
	}
	return nil

}

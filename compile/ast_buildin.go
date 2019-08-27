package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/enum"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"learn/llvm"
	"learn/stdlib"
	"strconv"
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
	return f.GetCurrentBlock().NewLoad(f.GetPLen(value2))
}

func (f *FuncDecl) Cap(value2 value.Value) value.Value {
	return f.GetCurrentBlock().NewLoad(f.GetPCap(value2))
}

//func copy(dst, src []Type) int
func (f *FuncDecl) Copy(dst value.Value, src value.Value) value.Value {
	return f.StdCall(llvm.Mencpy,
		f.GetCurrentBlock().NewBitCast(dst, types.I8Ptr),
		f.GetCurrentBlock().NewBitCast(src, types.I8Ptr),
		f.Len(src),
		constant.NewBool(false))
}

func (f *FuncDecl) NewType(tp types.Type) value.Value {
	switch tp.(type) {
	case *types.ArrayType:
		return f.NewAllocSlice(f.GetCurrentBlock(), tp)
	default:
		return f.GetCurrentBlock().NewAlloca(tp)
	}
}

func (f *FuncDecl) Append(value2 value.Value, elems ...value.Value) value.Value {
	if f.IsSlice(value2) {
		//malloc
		src := f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(value2), types.I8Ptr)
		call := f.StdCall(
			f.checkAppend(value2, types.I32),
			src,
		)
		realType := GetRealType(value2.Type())
		instBitCast := f.GetCurrentBlock().NewBitCast(call, realType)

		instBitCast.SetName("array." + strconv.Itoa(len(f.GetCurrentBlock().Insts)) + "." + doSymbol(realType.String()))
		//append
		lenPtr := f.GetPLen(value2)
		len := f.GetCurrentBlock().NewLoad(lenPtr)
		ptr := f.GetCurrentBlock().NewGetElementPtr(instBitCast, len)
		f.GetCurrentBlock().NewStore(elems[0], ptr)
		//store len
		f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewAdd(len, constant.NewInt(types.I32, 1)), lenPtr)
		return instBitCast
	}
	return nil
}

func (f *FuncDecl) newSlice(b *ir.Func) *ir.Block {
	block := b.NewBlock("")
	slice := ir.NewParam("slice", types.I8Ptr) //slice ptr
	len := f.GetPLen(slice)                    //len
	cap := f.GetPCap(slice)                    //cap
	vlen := block.NewLoad(len)
	vcap := block.NewLoad(cap)
	vbytes := f.GetBytes(slice) //bytes
	vcapAddLen := block.NewAdd(vcap, constant.NewInt(types.I32, 4))
	dst := f.Call(block, stdlib.Malloc, block.NewMul(vcapAddLen, vbytes)) //i8* ptr

	f.Call(block,
		llvm.Mencpy,
		dst, //block.NewLoad(malloc),
		f.GetPSlice(ir.NewParam("slice", types.I8Ptr)),
		block.NewMul(vlen, vbytes),
		constant.NewBool(false),
	)
	block.NewStore(vcapAddLen, cap) //store cap
	block.NewRet(dst)
	return block
}

func (f *FuncDecl) appendSlice(b *ir.Func) *ir.Block {
	block := b.NewBlock("")
	slice := ir.NewParam("slice", types.I8Ptr) //slice ptr
	block.NewRet(slice)
	return block
}

func (f *FuncDecl) checkAppend(src value.Value, p types.Type) *ir.Func {
	//int * append_slice(int len,int cap,int * v,int )
	newFunc := ir.NewFunc("checkAppend",
		types.I8Ptr,
		ir.NewParam("slice", types.I8Ptr),
	)
	newBlock := newFunc.NewBlock("")
	sPInfo := ir.NewParam("sInfo", types.NewPointer(types.NewArray(uint64(3), types.I32)))
	sInfo := newBlock.NewLoad(sPInfo)
	cmp := newBlock.NewICmp(enum.IPredSGE,
		newBlock.NewExtractValue(sInfo, 0),
		newBlock.NewExtractValue(sInfo, 1),
	)
	newBlock.NewCondBr(cmp,
		f.newSlice(newFunc),
		f.appendSlice(newFunc),
	)
	return newFunc
}

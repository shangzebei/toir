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
	"learn/utils"
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
	if s, ok := value2.(*SliceValue); ok {
		extractValue := f.GetCurrentBlock().NewExtractValue(f.GetCurrentBlock().NewLoad(s.SInfoValue), 0)
		return extractValue
	}
	return nil
}

func (f *FuncDecl) Cap(value2 value.Value) value.Value {
	if s, ok := value2.(*SliceValue); ok {
		extractValue := f.GetCurrentBlock().NewExtractValue(f.GetCurrentBlock().NewLoad(s.SInfoValue), 1)
		return extractValue
	}
	return nil
}

//func copy(dst, src []Type) int
func (f *FuncDecl) Copy(dst value.Value, src value.Value) value.Value {
	return f.StdCall(llvm.Mencpy,
		f.GetCurrentBlock().NewBitCast(dst, types.I8Ptr),
		f.GetCurrentBlock().NewBitCast(src, types.I8Ptr),
		f.Len(src),
		constant.NewBool(false))
}

func (f *FuncDecl) Append(value2 value.Value, elems ...value.Value) value.Value {
	if s, ok := value2.(*SliceValue); ok {
		//malloc
		src := f.GetCurrentBlock().NewBitCast(f.GetCurrentBlock().NewLoad(value2), types.I8Ptr)
		call := f.StdCall(
			f.checkAppend(value2, types.I32),
			src,
			s.SInfoValue,
		)
		instBitCast := f.GetCurrentBlock().NewBitCast(call, GetRealType(value2.Type()))
		//append
		len := f.Len(value2)
		ptr := f.GetCurrentBlock().NewGetElementPtr(instBitCast, len)
		f.GetCurrentBlock().NewStore(elems[0], ptr)
		//store len
		lenPtr := utils.Index(f.GetCurrentBlock(), s.SInfoValue, 0) //len
		f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewAdd(len, constant.NewInt(types.I32, 1)), lenPtr)
		return instBitCast
	}
	return nil
}

func (f *FuncDecl) newSlice(b *ir.Func) *ir.Block {
	block := b.NewBlock("")
	sPInfo := ir.NewParam("sInfo", types.NewPointer(types.NewArray(uint64(3), types.I32)))
	len := utils.Index(block, sPInfo, 0)   //len
	cap := utils.Index(block, sPInfo, 1)   //cap
	bytes := utils.Index(block, sPInfo, 2) //bytes
	vlen := block.NewLoad(len)
	vcap := block.NewLoad(cap)
	vbytes := block.NewLoad(bytes)
	vcapAddLen := block.NewAdd(vcap, constant.NewInt(types.I32, 4))

	dst := f.Call(block, stdlib.Malloc, block.NewMul(vcapAddLen, vbytes)) //i8* ptr

	f.Call(block,
		llvm.Mencpy,
		dst,                               //block.NewLoad(malloc),
		ir.NewParam("slice", types.I8Ptr), //block.NewLoad(alloca),
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
	newFunc := ir.NewFunc("checkAppend"+p.String(),
		types.I8Ptr,
		ir.NewParam("slice", types.I8Ptr),
		ir.NewParam("sInfo", types.NewPointer(types.NewArray(uint64(3), types.I32))),
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

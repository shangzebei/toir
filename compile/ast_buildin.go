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
	//return f.StdCall(llvm.Mencpy,
	//	f.GetCurrentBlock().NewBitCast(dst, types.I8Ptr),
	//	f.GetCurrentBlock().NewBitCast(src, types.I8Ptr),
	//	constant.NewInt(types.I32, l),
	//	constant.NewBool(false))
	return nil
}

func (f *FuncDecl) Append(value2 value.Value, elems ...value.Value) value.Value {
	if _, ok := value2.(*SliceValue); ok {
		slen := f.Len(value2)
		scap := f.Cap(value2)
		cast := f.GetCurrentBlock().NewBitCast(value2, types.I8Ptr)
		f.GetCurrentBlock().NewCall(f.append(), slen, scap, cast, elems[0])
		return constant.NewInt(types.I32, 1)
	}
	return nil
}

func (f *FuncDecl) newSlice(b *ir.Func, len value.Value, src value.Value) *ir.Block {
	block := b.NewBlock("")
	dst := f.Call(block, stdlib.Malloc, len)
	block.NewCall(llvm.Mencpy,
		dst,
		block.NewBitCast(src, types.I8Ptr),
		len,
		constant.NewBool(false))
	block.NewRet(dst)
	return block
}

func (f *FuncDecl) appendSlice(b *ir.Func) *ir.Block {
	block := b.NewBlock("")
	block.NewRet(constant.NewInt(types.I32, 12))
	return block
}

func (f *FuncDecl) append() *ir.Func {
	//int * append_slice(int len,int cap,int * v,int )
	newFunc := f.m.NewFunc("append",
		types.I8Ptr,
		ir.NewParam("len", types.I32),
		ir.NewParam("cap", types.I32),
		ir.NewParam("slice", types.I8Ptr),
		ir.NewParam("value", types.I32),
	)
	newBlock := newFunc.NewBlock("entry")
	cmp := newBlock.NewICmp(enum.IPredSGE, ir.NewParam("len", types.I32), ir.NewParam("cap", types.I32))
	newBlock.NewCondBr(cmp,
		f.newSlice(newFunc, ir.NewParam("cap", types.I32), ir.NewParam("slice", types.I8Ptr)),
		f.appendSlice(newFunc))
	return newFunc
}

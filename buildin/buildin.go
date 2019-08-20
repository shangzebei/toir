package buildin

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
)

type BuildIn struct {
	Block *ir.Block
}

func (f *BuildIn) IntType(value2 value.Value, typ types.Type) value.Value {
	switch value2.Type() {
	case types.Float:
		return f.Block.NewFPToSI(value2, types.I32)
	case types.I8, types.I16, types.I32, types.I64:
		intType := value2.Type().(*types.IntType)
		intType1 := typ.(*types.IntType)
		if intType.BitSize == intType1.BitSize {
			return value2
		}
		if intType.BitSize < intType1.BitSize {
			return f.Block.NewSExt(value2, typ)
		} else {
			return f.Block.NewTrunc(value2, typ)
		}
	default:
		fmt.Println("not impl ")
	}
	return nil
}

//to int32
func (f *BuildIn) Int32(value2 value.Value) value.Value {
	return f.IntType(value2, types.I32)
}

func (f *BuildIn) Int16(value2 value.Value) value.Value {
	return f.IntType(value2, types.I16)
}

//to int64
func (f *BuildIn) Int64(value2 value.Value) value.Value {
	return f.IntType(value2, types.I64)
}

func (f *BuildIn) Int8(value2 value.Value) value.Value {
	return f.IntType(value2, types.I8)
}

func (f *BuildIn) Float32(value2 value.Value) value.Value {
	if _, ok := value2.(constant.Constant); ok {
		return value2
	}
	return f.Block.NewSIToFP(value2, types.Float)
}

func (f *BuildIn) Float64(value2 value.Value) value.Value {
	return f.Float32(value2)
}

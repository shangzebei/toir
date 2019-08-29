package llvm

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"toir/stdlib"
)

type std func() *ir.Func

var (
	//declare void @llvm.memcpy.p0i8.p0i8.i32(i8* <dest>, i8* <src>, i32 <len>, i1 <isvolatile>)
	Mencpy = stdlib.V("llvm.memcpy.p0i8.p0i8.i32", types.Void, types.I8Ptr, types.I8Ptr, types.I32, types.I1)
)

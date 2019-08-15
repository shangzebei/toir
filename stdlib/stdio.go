package stdlib

import "github.com/llir/llvm/ir/types"

//declare i32 @printf(i8*, ...)
var (
	Printf = VE("printf", types.I32, true, types.I8Ptr)
)

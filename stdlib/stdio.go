package stdlib

import "github.com/llir/llvm/ir/types"

var (
	//i32 @printf(i8*, ...)
	Printf = VE("printf", types.I32, true, types.I8Ptr)
	//i8* @malloc(i64 24)
	Malloc = VE("malloc", types.I8Ptr, false, types.I32)
	Free   = VE("free", types.Void, false, types.I8Ptr)
	//void exit(int status)
	Exit = VE("exit", types.Void, false, types.I32)
)

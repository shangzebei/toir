package def

import "toir/runtime"

func SliceIntToI8([]int) I8p { return I8p(0) }

func Unreachable() {}

func Malloc(size int) I8p { return I8p(0) }

func SliceToI8(slice *runtime.slice) I8p { return I8p(0) }

func MemCopy(dst I8p, src I8p, len int) {}

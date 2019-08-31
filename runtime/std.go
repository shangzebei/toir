package runtime

import (
	"fmt"
	"toir/runtime/def"
)

type slice struct {
	Len   int
	Cap   int
	bytes int
	ptr   def.I8p
}

//return Slice ptr
func indexSlice(s *slice, index int) def.I8p {
	if index >= s.Len {
		fmt.Printf("out of range\n")
		def.Unreachable()
	}
	return s.ptr
}

//i8 * checkGrow(slice *)
func checkGrow(s *slice) def.I8p {
	if s.Len >= s.Cap {
		len := s.Len + 4
		a := def.Malloc(len * s.bytes)
		def.MemCopy(a, s.ptr, s.Len)
		s.Cap = len
		return a
	} else {
		return s.ptr
	}
}

//int copy(char *dst,char *src)
func copySlice(dst *slice, src *slice) int {
	if dst.Cap > src.Len {
		def.MemCopy(dst.ptr, src.ptr, src.Len)
		dst.Len = src.Len
		return src.Len
	} else {
		fmt.Printf("copy error !\n")
		def.Unreachable()
	}
	return 0
}

//new slice
func makeSlice() *slice {
	return new(slice)
}

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

func rangeSlice(s *slice, low int, high int) *slice {
	l := high - low
	i := new(slice)
	malloc := def.Malloc(l * s.bytes)
	i.Cap = l
	i.Len = l
	def.MemCopy(malloc, def.ArrayPtr(s.ptr, s.bytes, l), l)
	i.ptr = malloc
	return i
}

//new slice
func makeSlice() *slice {
	return new(slice)
}

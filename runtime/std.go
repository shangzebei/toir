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
		fmt.Printf("out of range [%d]\n", index)
		def.Unreachable()
	}
	fmt.Printf("bytes=%d index=%d\n", s.bytes, index)
	return def.ArrayPtr(s.ptr, s.bytes, index)
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
	fmt.Printf("rangeSlice bytes=%d\n", s.bytes)
	l := high - low
	i := makeSlice(s.bytes)
	malloc := def.Malloc(l * s.bytes)
	i.Cap = l
	i.Len = l
	def.MemCopy(malloc, def.ArrayPtr(s.ptr, s.bytes, l), l)
	i.ptr = malloc
	return i
}

//new slice
func makeSlice(types int) *slice {
	i := new(slice)
	i.bytes = types
	return i
}

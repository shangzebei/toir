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
		fmt.Printf("out of range [%d] len =%d \n", index, s.Len)
		def.Unreachable()
	}
	fmt.Printf("indexSlice bytes=%d index=%d\n", s.bytes, index)
	return def.ArrayPtr(s.ptr, s.bytes, index)
}

//i8 * checkGrow(slice *)
func checkGrow(s *slice) def.I8p {
	if s.Len >= s.Cap {
		fmt.Printf("checkGrow bytes %d\n", s.bytes)
		len := s.Len + 4
		a := def.Malloc(len * s.bytes)
		def.MemCopy(a, s.ptr, s.Len*s.bytes)
		s.Cap = len
		return a
	} else {
		return s.ptr
	}
}

//int copy(char *dst,char *src)
func copyNewSlice(src *slice) *slice {
	i := new(slice)
	mem := src.Len * src.bytes
	malloc := def.Malloc(mem)
	def.MemCopy(malloc, src.ptr, mem)
	i.bytes = src.bytes
	i.Len = src.Len
	i.Cap = src.Cap
	i.ptr = malloc
	return i
}

func rangeSlice(s *slice, low int, high int) *slice {
	fmt.Printf("rangeSlice bytes=%d\n", s.bytes)
	l := high - low
	//i := makeSlice(s.bytes)
	i := new(slice)
	i.bytes = s.bytes
	i2 := l * s.bytes
	malloc := def.Malloc(i2)
	def.MemCopy(malloc, def.ArrayPtr(s.ptr, s.bytes, low), i2)
	i.Cap = l
	i.Len = l
	i.ptr = malloc
	fmt.Printf("rangeSlice %d-%d-%d\n", i.Len, i.Cap, i.bytes)
	return i
}

//new slice
func makeSlice(types int) *slice {
	i := new(slice)
	i.bytes = types
	return i
}

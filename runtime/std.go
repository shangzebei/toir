package runtime

import (
	"fmt"
	"toir/runtime/def"
)

type Slice struct {
	Len   int
	Cap   int
	bytes int
	ptr   def.I8p
}

//i8 * checkAppend(slice *)
func checkAppend(s *Slice) def.I8p {
	if s.Len >= s.Cap {
		//return def.SliceIntToI8(make([]int, s.Len+4))
	} else {
		//return def.SliceToI8(s)
	}
}

//int copy(char *dst,char *src)
func copySlice(dst []int, src []int) int {
	if cap(dst) > len(src) {
		return copy(dst, src)
	} else {
		fmt.Printf("copy error !\n")
	}
	return 0
}

//new slice
func makeSlice() *Slice {
	return new(Slice)
}

package runtime

import (
	"fmt"
	"toir/runtime/def"
)

//i8 * checkAppend(slice *)
func checkAppend(s []int) def.I8p {
	if len(s) >= cap(s) {
		return def.SliceToI8(make([]int, len(s)+4))
	} else {
		return def.SliceToI8(s)
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

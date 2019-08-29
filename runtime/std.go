package runtime

import "toir/runtime/def"

//i8 * checkAppend(slice *)
func checkAppend(s []int) def.I8p {
	if len(s) >= cap(s) {
		return def.StructToI8(make([]int, 4))
	} else {
		return def.StructToI8(s)
	}
}

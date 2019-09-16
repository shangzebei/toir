package runtime

import "toir/runtime/def"

type string struct {
	Len int
	ptr def.I8p
}

func newString(size int) *string {
	temp := new(string)
	if size == 0 {
		return temp
	}
	temp.Len = size - 1
	temp.ptr = def.Malloc(size)
	return temp
}

func newEmptyString() *string {
	return newString(0)
}

func getStringLen(s *string) int {
	return s.Len
}

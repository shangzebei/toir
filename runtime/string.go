package runtime

import "toir/runtime/def"

//var eof = ""

type string struct {
	Len int
	ptr def.I8p
}

//reality size
func newString(size int) *string {
	temp := new(string)
	if size == 0 {
		return temp
	}
	temp.Len = size
	temp.ptr = def.Malloc(size + 1)
	return temp
}

func newEmptyString() *string {
	return newString(0)
}

func getStringLen(s *string) int {
	return s.Len
}

func stringJoin(a *string, b *string) *string {
	i := newString(a.Len + b.Len + 1)
	//copy a
	def.MemCopy(i.ptr, a.ptr, a.Len)
	//copy b
	def.MemCopy(def.ArrayPtr(i.ptr, 1, a.Len), b.ptr, b.Len+1)
	return i
}

func stringEqu(a *string, b *string) bool {
	if a.Len != b.Len {
		return false
	}
	return true
}

func stringToBytes(a *string) []byte {
	var temp = make([]byte, a.Len)
	def.MemCopy(def.SlicePtr(temp), a.ptr, a.Len)
	return temp
}

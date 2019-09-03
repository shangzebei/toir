package runtime

import (
	"fmt"
	"toir/runtime/def"
)

//i8 * checkGrow(i8 *,len i32,cap i32,bytes i32)
func checkGrow(ptr def.I8p, len int, cap int, bytes int) (def.I8p, int) {
	if len >= cap {
		fmt.Printf("checkGrow bytes %d\n", bytes)
		lenA := len + 4
		a := def.Malloc(lenA * bytes)
		def.MemCopy(a, ptr, len*bytes)
		cap = len
		return a, lenA
	} else {
		return ptr, len
	}
}

//i8* rangeSlice(i8* ptr,int low ,int high,int bytes)
func rangeSlice(ptr def.I8p, low int, high int, bytes int) def.I8p {
	fmt.Printf("rangeSlice bytes=%d\n", bytes)
	l := high - low
	i2 := l * bytes
	malloc := def.Malloc(i2)
	def.MemCopy(malloc, def.ArrayPtr(ptr, bytes, low), i2)
	return malloc
}

//use for range
func rangeTemp() {
	var key int
	var value int
	var zrangzwrLen int
	var f []int
	for zrangzwr := 0; zrangzwr < zrangzwrLen; zrangzwr++ {
		key = zrangzwr
		value = f[zrangzwr]
	}
}

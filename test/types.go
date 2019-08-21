package test

import "fmt"

func main() {
	//
	d1 := int8(23)
	d2 := int16(234)
	d3 := int32(235)
	d4 := int64(2356)
	//
	f := float32(12.336)
	f1 := float64(12.336)
	b := 1236
	var a = int8(b)
	t(int32(a))
	tt(int64(b))
	ff(float32(b))
	t(int32(f))
}

func t(a int32) {
	fmt.Printf("%d\n", a)
}

func tt(a int64) {
	fmt.Printf("%d\n", a)
}

func ff(float322 float32) {
	fmt.Printf("%f\n", float322)
}

func b() {
	a := true
}

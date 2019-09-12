package test

import "fmt"

var tt = 90

func add(a int, b int) int {
	return a + b
}

func main() {
	b := 4
	var d = 3
	print("%d-%d=%d\n", b, d, tt)
}

//func varBool() bool {
//	a := 90
//	b := 78
//	c := 12
//	d := a > 1 && b > 50 && c < 50 //ERROR
//	return d
//}

func varBool1() {
	var name bool
	name = true
}

func varBool2() {
	b := true
}

package test

import "fmt"

func mul2(a int) (int, int) {
	return k(), 5
}

func k() int {
	return 85
}

func main() {
	i, i2 := mul2(1)
	print("%d--%d\n", i, i2)
}

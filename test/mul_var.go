package test

import "fmt"

func main() {
	i, i2 := mulFunc(1)
	fmt.Printf("%d--%d\n", i, i2)
	mulVar()
}

func mulVar() {
	// 10 20
	a1, b1 := 10, 20
	fmt.Printf("%d %d\n", a1, b1)
	// 10 20 30
	a2, b2, c2 := 10, 20, 30
	fmt.Printf("%d %d %d\n", a2, b2, c2)
}

func mulFunc(a int) (int, int) {
	return 1, 5
}

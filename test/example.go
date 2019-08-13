package test

import "fmt"

func main(c int) {
	var a [2]int
	a[0] = 23
	a[1] = 32
	if a[0] < 100 {
		b := 45
		b = b * 67
		if b > 100 {
			b = b * 23
			a[0] = sub(90, 4)
		} else {
			b = add(4, 7)
		}
	} else {
		e := 67
		e = e + 45
		if e == 9 {
			e = sub(90, 6)
		}
	}
}

func add(a int, b int) int {
	fmt.Println("hello")
	return a + b
}

func sub(a int, b int) int {
	return a - b
}

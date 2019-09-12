package test

import "fmt"

//import "fmt"

func main() {
	a := []int{1, 2, 3}
	a = append(a, 8)
	b := len(a)
	print("%d\n", b)
}

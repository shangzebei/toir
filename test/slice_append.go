package test

import "fmt"

func main() {
	a := []int{3, 2, 4}
	//append(a, 8)
	a[2] = 89
	fmt.Printf("%d-%d\n", a[2], len(a))

}

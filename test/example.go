package test

import "fmt"

//import "fmt"

func main() {
	var kk [1][]int
	kk[0] = []int{1, 2, 3, 4, 5}
	for _, value := range kk[0] {
		fmt.Printf("%d\n", value)
	}
}

func kkp(kk [][]int) [][]int {
	return kk
}

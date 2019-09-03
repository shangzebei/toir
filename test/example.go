package test

import "fmt"

//import "fmt"

func main() {

	//test.test()
	a := []int{21, 22, 33, 44, 55}
	ints := a[1:3]
	for key, value := range ints {
		fmt.Printf("%d-%d\n", key, value)
	}
}

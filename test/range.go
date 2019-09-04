package test

import "fmt"

func main() {
	range1asdfasdfs()
	range2()
	range3()
	range4()
}

func range1asdfasdfs() {
	a := []int{1, 2, 3, 4, 5}
	for index := range a {
		fmt.Printf("asdfasdfasdfsdfsdf%d\n", index)
	}
}

//
func range2() {
	a := []int{1, 2, 3, 4, 5}
	for index, value := range a {
		fmt.Printf("%d-%d\n", index, value)
	}
}

func range3() {
	a := []int{1, 2, 3, 4, 5}
	for _, value := range a {
		fmt.Printf("%d\n", value)
	}
}

func range4() {
	a := []int{1, 2, 3, 4, 5}
	for key, _ := range a {
		fmt.Printf("%d\n", key)
	}
}

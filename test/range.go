package test

import "fmt"

func main() {
	range1asdfasdfs()
	range2()
	range3()
	range4()
	range5()
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

func range5() {
	a := []int{1, 2, 3, 4, 5}
	b := []int{11, 22, 33, 44, 55}
	for key1, _ := range a {
		fmt.Printf("=====[row %d]==== \n", key1)
		for _, value := range b {
			fmt.Printf("%d ", value)
		}
		fmt.Printf("end\n")
	}
}

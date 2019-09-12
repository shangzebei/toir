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
		print("asdfasdfasdfsdfsdf%d\n", index)
	}
}

//
func range2() {
	a := []int{1, 2, 3, 4, 5}
	for index, value := range a {
		print("%d-%d\n", index, value)
	}
}

func range3() {
	a := []int{1, 2, 3, 4, 5}
	for _, value := range a {
		print("%d\n", value)
	}
}

func range4() {
	a := []int{1, 2, 3, 4, 5}
	for key, _ := range a {
		print("%d\n", key)
	}
}

func range5() {
	a := []int{1, 2, 3, 4, 5}
	b := []int{11, 22, 33, 44, 55}
	for key1, _ := range a {
		print("=====[row %d]==== \n", key1)
		for _, value := range b {
			print("%d ", value)
		}
		print("end\n")
	}
}

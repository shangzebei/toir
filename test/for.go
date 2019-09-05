package test

import "fmt"

//import "fmt"

func main() {
	for2()
	for23()
	for1()
}

func show(a int) {
	fmt.Printf("%d\n", a)
}

func max() int {
	return 10
}

func for1() {
	for i := 0; i <= 3; i++ {
		fmt.Printf("aaaaaaaaaaa\n")
	}
	fmt.Printf("bbbbbbbbbbbb\n")
	for j := 0; j <= 2; j++ {
		fmt.Printf("%d\n", j)
	}
	fmt.Printf("ggggggggggggggg")
}

func for2() {
	for i := 0; i < 10; i++ {
		fmt.Printf("%d\n", i)
	}
}

func for23() int {
	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			fmt.Printf("asdfasdfasd%d-%d\n", i, j)
		}
	}
	return 0
}

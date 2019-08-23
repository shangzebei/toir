package test

import "fmt"

//import "fmt"

func main() {
	show(5)
	for1()
}

func show(a int) {
	fmt.Printf("%d\n", a)
}

func max() int {
	return 10
}

func for1() {
	for i := 0; i <= 11; i++ {
		fmt.Printf("aaaaaaaaaaa\n")
	}
	fmt.Printf("bbbbbbbbbbbb\n")
	for j := 0; j <= 10; j++ {
		fmt.Printf("%d\n", j)
	}
	fmt.Printf("ggggggggggggggg")

}

func for2() {
	for i := 0; i <= 10; i++ {
		fmt.Printf("%d\n", i)
	}
}

package test

import "fmt"

func main() {
	fmt.Printf("%d\n", forr())
	ifrr()
}

func forr() int {
	fmt.Printf("begin\n")
	for i := 0; i <= 11; i++ {
		fmt.Printf("asdfasdfsdf--%d\n", i)
		if i > 5 {
			fmt.Printf("aaaaaaaaaaa\n")
			return i
		}
	}
	return 0
}

func ifrr() int {
	i := 9
	if i > 5 {
		fmt.Printf("aaaaaaaaaaa\n")
		return 1
	}
	return 0
}

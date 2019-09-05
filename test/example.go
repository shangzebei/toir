package test

import "fmt"

//import "fmt"

func main() {
	i := 90
	for i := 0; i < 3; i++ {
		fmt.Printf("bbbbbbbbbbbb\n")
		for i := 0; i < 2; i++ {
			fmt.Printf("aaaaaaaaaaa\n")
		}
	}
	fmt.Printf("cccccccccccc %d\n", i)
}

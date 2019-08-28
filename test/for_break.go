package test

import "fmt"

func main() {
	for2break()
}

func for2break() {
	for j := 0; j < 10; j++ {
		for i := 0; i < 10; i++ {
			if i > 5 {
				fmt.Printf("break\n")
				break
			} else {
				fmt.Printf("no\n")
			}
		}
		fmt.Printf("bbbbbbbbbbbbbbbb\n")
	}
}

func for1break() {
	for i := 0; i < 10; i++ {
		if i > 5 {
			fmt.Printf("break\n")
			break
		} else {
			fmt.Printf("no\n")
		}
	}
	fmt.Printf("bbbbbbbbbbbbbbbbb\n")
}

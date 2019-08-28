package test

import "fmt"

func main() {
	for1con()
}

func for1con() {
	for i := 0; i < 10; i++ {
		if i > 5 {
			continue
		}
		fmt.Printf("okkkkkkkkkkkk\n")
	}
	fmt.Printf("bbbbbbbbbbbbbbbbb\n")
}

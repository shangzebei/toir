package test

import "fmt"

//import "fmt"

func main() {
	forr()
}

func forr() int {
	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			fmt.Printf("asdfasdfasd%d-%d\n", i, j)
		}
	}
	return 0
}

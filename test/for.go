package test

import "fmt"

func main() {
	for i := 0; i <= max()+1; i++ {
		show(i)
	}
}

func show(a int) {
	fmt.Printf("%d\n", a)
}

func max() int {
	return 10
}

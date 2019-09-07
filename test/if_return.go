package test

import "fmt"

func main() {
	ifr1()
	ifr2()
	ifr3()
}

func ifr2() int {
	a := 90
	if a > 50 {
		fmt.Printf("aaaaaaaaaaaaaa")
		return 0
	} else {
		fmt.Printf("bbbbbbbbbbbbbbb")
		return 1
	}
}

func ifr1() int {
	a := 90
	if a > 50 {
		fmt.Printf("aaaaaaaaaaaaaa")
	} else {
		fmt.Printf("bbbbbbbbbbbbbbb")
		return 1
	}
	return 0
}

func ifr3() {
	a := 90
	if a > 50 {
		return
	}
	fmt.Printf("asdfasfdsaf")
}

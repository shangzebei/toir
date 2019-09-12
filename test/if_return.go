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
		print("aaaaaaaaaaaaaa\n")
		return 0
	} else {
		print("bbbbbbbbbbbbbbb\n")
		return 1
	}
}

func ifr1() int {
	a := 90
	if a > 50 {
		print("aaaaaaaaaaaaaa\n")
	} else {
		print("bbbbbbbbbbbbbbb\n")
		return 1
	}
	return 0
}

func ifr3() {
	a := 90
	if a > 50 {
		return
	}
	print("asdfasfdsaf\n")
}

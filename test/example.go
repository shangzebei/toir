package test

import "fmt"

type Hlo struct {
	Len int
	Cap int
}

func main() {
	//test.test()
	sh(&Hlo{Cap: 3, Len: 2})
}

func sh(hlo *Hlo) {
	fmt.Printf("%d-%d\n", hlo.Len, hlo.Cap)
}

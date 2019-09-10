package main

import "fmt"

type BB struct {
	A int
}

func main() {
	var ad = BB{A: 90}
	ad.KK()
}

func (b *BB) KK() {
	fmt.Printf("%d\n", b.A)
}

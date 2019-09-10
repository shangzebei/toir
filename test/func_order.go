package test

import "fmt"

type One struct {
}

//
func a1() {
	a2()
	fmt.Printf("aaaaaaaa\n")
}
func a2() {
	a1()
}

//
func (t *One) Kkkk() {

}

//
type Two struct {
}

func (t *Two) two() {
	t.two1()
}

func (t *Two) two1() {
	t.two()
}

func main() {

}

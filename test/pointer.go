package test

import "fmt"

type A struct {
	Name string
}

func main() {
	a := 90
	b := 80
	swap(&a, &b)
	fmt.Printf("%d-%d\n", a, b)
	i := A{Name: "ttttt"}
	do(i)
}

func swap(a *int, b *int) {
	*a = 44
	*b = 23
}

func swapFloat(a *int64, b *int64) {

}

func do(a A) {
	fmt.Printf("%s\n", a.Name)
}

package test

import "fmt"

type Person struct {
	Name string
	Sex  string
	Age  int
}

func main() {
	ad := Person{}
	ad.Name = "wang"
	ad.Sex = "man"
	ad.Age = 12
	d := ad.Age
	show(ad.Age)
}

func show(a int) {
	fmt.Printf("%d\n", a)
}

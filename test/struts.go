package test

import "fmt"

type Person struct {
	Name string
	Sex  string
	Age  int
}

func main() {
	//var pp Person
	var ad = Person{Name: "wang", Sex: "man", Age: 12}
	//ad := Person{}
	//ad.Name = "asdf"
	//ad.Age = 45
	fmt.Printf("%s\n", ad.Name)

	//pp = ad

	show(ad.Age)
}

func show(a int) {
	fmt.Printf("%d\n", a)
}

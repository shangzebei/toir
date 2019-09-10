package test

import "fmt"

type Person struct {
	Name string
	Sex  string
	Age  int
}

type ListN struct {
	Val  int
	Next *ListN
}

func main() {
	initS()
	sFunc()
}

//null-man-12
func initS() {
	var ad = Person{Sex: "man", Age: 12}
	ad.Age = 45
	fmt.Printf("%s-%s-%d\n", ad.Name, ad.Sex, ad.Age)
}

//null
//12
//asdfasdfasdfsdfsd
func sFunc() {
	var ad = Person{Sex: "man", Age: 12}
	//ad := Person{}
	//ad.Name = "asdf"
	//ad.Age = 45
	fmt.Printf("%s\n", ad.Name)

	//pp = ad

	show(ad.Age)
	ad.Show()
}

func show(a int) {
	fmt.Printf("%d\n", a)
}

func (p *Person) Show() {
	fmt.Printf("asdfasdfasdfsdfsd\n")
}

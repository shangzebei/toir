package test

type Person struct {
	Name string
	Sex  string
	Age  int
}

func main() {
	initS()
	sFunc()
}

//null-man-12
func initS() {
	var ad = Person{Sex: "man", Age: 12}
	ad.Age = 45
	print("%s-%s-%d\n", ad.Name, ad.Sex, ad.Age)
}

//null
//12
//asdfasdfasdfsdfsd
func sFunc() {
	var ad = Person{Sex: "man", Age: 12}
	print("%s\n", ad.Name)
	show(ad.Age)
	ad.Show()
}

func show(a int) {
	print("%d\n", a)
}

func (p *Person) Show() {
	print("tttttttttttttttt\n")
}

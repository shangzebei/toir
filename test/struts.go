package test

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
}

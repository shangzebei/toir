package test

type Person struct {
	Name string
	Sex  string
	Age  int
}

type KK struct {
	N string
}

func main() {
	ad := Person{}
	ad.Name = "wang"
	ad.Sex = "man"
	ad.Age = 12
	show(ad.Age)
	//kk := KK{N: "shang"}//ERROR

}

func show(a int) {

}

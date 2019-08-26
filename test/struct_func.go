package test

import "fmt"

type Hello struct {
	Name string
	Age  int
}

func (h Hello) Show() {
	fmt.Printf("%d\n", h.Age)
}

func main() {
	hello := Hello{Name: "shang", Age: 12}
	hello.Show()
	fmt.Printf("%s\n", hello.Name)
}

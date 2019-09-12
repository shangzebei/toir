package test

import "fmt"

type Hello struct {
	Name string
	Age  int
}

func (h Hello) Show() {
	print("%d\n", h.Age)
}

func main() {
	hello := Hello{Name: "shang", Age: 12}
	hello.Show()
	print("%s\n", hello.Name)
}

package test

import "fmt"

type AA struct {
	Name string
}

//asdfsdfs-bbbbbbbb-asdfsdfs
func main() {
	var kk AA
	aa := AA{Name: "asdfsdfs"}
	kk = aa
	kk.Name = "bbbbbbbb"
	fmt.Printf("%s-%s-%s\n", aa.Name, kk.Name, aa.Name)
}

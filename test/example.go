package test

import "fmt"

type AA struct {
	Name string
}

func main() {
	aa := AA{Name: "asdfsdfs"}
	bb := AA{Name: "eeeeeeee"}
	aa = bb
	bb.Name = "gggggggg"
	fmt.Printf("%s-%s-%s\n", aa.Name, bb.Name, aa.Name)
}

////asdfsdfs-bbbbbbbb-asdfsdfs
//func v() {
//	var kk AA
//	aa := AA{Name: "asdfsdfs"}
//	kk = aa
//	kk.Name = "bbbbbbbb"
//	fmt.Printf("%s-%s-%s\n", aa.Name, kk.Name, aa.Name)
//}
////eeeeeeee-bbbbbbbb-eeeeeeee
//func p() {
//	var kk AA
//	aa := AA{Name: "asdfsdfs"}
//	bb := AA{Name: "eeeeeeee"}
//	aa = bb
//	kk = aa
//	kk.Name = "bbbbbbbb"
//	fmt.Printf("%s-%s-%s\n", aa.Name, kk.Name, aa.Name)
//}

package test

import "fmt"

type UU struct {
	Len int
}

func main() {
	//uu := new(UU)
	//uu.Len=90
	//test.test()
	a := []int{1, 2, 3, 4, 5}
	fmt.Printf("%d", a[1:4][0])
	//b := a[2]
	//jj(&b)
	//nn(b)
}

//func sh(uu UU)  {
//
//}
//
//func pp(uu *UU)  {
//	jj(&uu.Len)
//	nn(uu.Len)
//}
//
//func jj(int2 *int) {
//
//}
//
////
//func nn(int2 int) {
//	fmt.Printf("%d\n", int2)
//}

package test

import "fmt"

func main() {

	//test.test()
	a := []int{1, 22, 33, 44, 5}
	//fmt.Printf("%d\n", len(a))
	f := append(a, 89)
	for i := 0; i < len(f); i++ {
		fmt.Printf("%d\n", f[i])
	}
}

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

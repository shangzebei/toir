package test

import "fmt"

//type UU struct {
//	Len int
//}

func main() {
	//test.test()
	//uu := UU{Len: 23}
	//sh(uu)
	//pp(&uu)
	//jj(&uu.Len)
	//nn(uu.Len)
	b := []int{1, 2, 3, 4}
	//b = append(b, 11)
	nn(b[2])

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
//func jj(int2 *int)  {
//
//}
//
func nn(int2 int) {
	fmt.Printf("%d\n", int2)
}

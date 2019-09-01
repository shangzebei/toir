package test

import "fmt"

type UU struct {
	Len int
}

func main() {
	a := []int{1, 2, 3, 4, 5}
	b := a[2]

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

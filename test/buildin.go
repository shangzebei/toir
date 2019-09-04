package test

import "fmt"

type Per struct {
	Name string
}

func main() {
	//newF()
}

////1-2-3-7-8-9
func copyt() {
	s := []int{1, 2, 3}
	ii := []int{4, 5, 6, 7, 8, 9}
	copy(ii, s)
	fmt.Printf("%d-%d-%d-%d-%d-%d\n", ii[0], ii[1], ii[2], ii[3], ii[4], ii[5])
}

//ERROR
//func maket() {
//	a := make([]int, 3)
//	printSlice("see@ ", a)
//	a[0] = 90
//	a[1] = 50
//	a[2] = 70
//	for i := 0; i < 3; i++ {
//		fmt.Printf("%d\n", a[i])
//	}
//
//}

//func printSlice(s string, x []int) {
//	fmt.Printf("%s len=%d cap=%d \n", s, len(x), cap(x))
//}

//func newF() {
//	per := new(Per)
//	per.Name = "asdfasdfasd"
//	fmt.Printf("%s\n", per.Name)
//}

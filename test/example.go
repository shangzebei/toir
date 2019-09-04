package test

import "fmt"

//import "fmt"

func main() {
	var name = []int{1, 2, 3}
	//name = append(name, 1)
	//fmt.Printf("len=%d,cap=%d\n", len(name), cap(name))
	//fmt.Printf("%d\n", name[3])
	//fmt.Printf("%d\n", name[4])
	for i := 0; i < 30; i++ {
		name = append(name, i)
		fmt.Printf("len-%d cap-%d %d\n", len(name), cap(name), name[i])
	}
	//for j := 0; j < 33; j++ {
	//	fmt.Printf("%d\n", name[j])
	//}
}

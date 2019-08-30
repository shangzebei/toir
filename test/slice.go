package test

import "fmt"

// %len|%cap|%offset|%backing
func main() {
	sliceRange()
}

//len=2 cap=9 5-5
func sliceRange() {
	a := []int{9, 7, 3, 5, 5, 2, 3, 4, 5, 6, 7, 8}
	//fmt.Printf("%d\n",a[2])
	b := a[3:5]
	fmt.Printf("len=%d cap=%d %d-%d\n", len(b), cap(b), b[0], b[1])
	//fmt.Printf("len=%d cap=%d %d\n",len(b),cap(b),b[0])
}

//3-3
func slicecp() {
	a := []int{9, 7, 3, 5, 5}
	b := []int{9, 7, 3, 9}
	a = b
	fmt.Printf("%d-%d\n", len(a), cap(a))
}

func slicet() {
	//d := 1
	var b int
	var a [4]int
	a[0] = 52
	a[1] = 0
	b = a[0]
	//ff(a[0])
	fmt.Printf("%d\n", a[0])
	//ff(a[0])
	//a[i()] = 90
	//a[d] = 80
	//a[2] = 81
	//a[3] = d + 777
	//b = a[2+1]
	//ff(a[2])
	var aa = []string{"asaaa\n", "bbbbb\n"}

	//	//var b int = a[0]
	fmt.Printf("%s\n", aa[a[0]])
	//show(a[1])
}

package test

import "fmt"

func main() {
	sli3()
}

func sli1() {
	a := []int{100}
	fmt.Printf("len-%d\n", len(a))
	a = append(a, 11)
	fmt.Printf("len-%d\n", len(a))
	a = append(a, 12)
	fmt.Printf("len-%d\n", len(a))
	fmt.Printf("%d\n", a[0])
	fmt.Printf("%d\n", a[1])
	fmt.Printf("%d\n", a[2])
}

func sli2() {
	a := []int{100}
	for i := 0; i < 30; i++ {
		a = append(a, i)
		fmt.Printf("len-%d cap-%d\n", len(a), cap(a))
	}
}

func sli3() {
	var name = []int{1, 2, 3}
	for i := 0; i < 30; i++ {
		name = append(name, i)
		fmt.Printf("len-%d cap-%d\n", len(name), cap(name))
	}

}

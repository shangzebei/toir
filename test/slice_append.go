package test

import "fmt"

func main() {
	sli1()
	sli2()
	sli3()
	othSli()
	//stringSli()
}

func sli1() {
	a := []int{100}
	print("len-%d\n", len(a))
	a = append(a, 11)
	print("len-%d\n", len(a))
	a = append(a, 12)
	print("len-%d\n", len(a))
	print("%d\n", a[0])
	print("%d\n", a[1])
	print("%d\n", a[2])
}

func sli2() {
	a := []int{100}
	for i := 0; i < 30; i++ {
		a = append(a, i)
		print("len-%d cap-%d\n", len(a), cap(a))
	}
}

func sli3() {
	var name = []int{1, 2, 3}
	for i := 0; i < 30; i++ {
		name = append(name, i)
		print("len-%d cap-%d\n", len(name), cap(name))
	}
	for j := 0; j < 33; j++ {
		print("%d\n", name[j])
	}

}

func othSli() {
	var f = []float32{1.0, 2.0, 3.0}
	f = append(f, 5.355234234)
	print("%.2g\n", f[3])
}

//func stringSli() {
//	var s = []string{"aaaaa", "bbbbb", "ccccc"}
//	s = append(s, "eeeeee")
//	print("%s\n", s[3])
//
//}

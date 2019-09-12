package test


type Per struct {
	Name string
}

func main() {
	copyt()
	newF()
	make1()
}

func copyt() {
	s := []int{1, 2, 3}
	ii := []int{4, 5, 6, 7, 8, 9}
	copy(ii, s)
	print("%d-%d-%d-%d-%d-%d\n", ii[0], ii[1], ii[2], ii[3], ii[4], ii[5])
}

func make1() {
	a := make([]int, 3)
	printSlice("see@ ", a)
	a[0] = 90
	a[1] = 50
	a[2] = 70
	for i := 0; i < 3; i++ {
		print("%d\n", a[i])
	}
}

func printSlice(s string, x []int) {
	print("%s len=%d cap=%d \n", s, len(x), cap(x))
}

func newF() {
	per := new(Per)
	per.Name = "asdfasdfasd"
	print("%s\n", per.Name)
}

package test

// %len|%cap|%offset|%backing
func main() {
	sliceRange()
	sliceslice()
}

//len=2 cap=9 5-5
func sliceRange() {
	a := []int{9, 7, 3, 5, 5, 2, 3, 4, 5, 6, 7, 8}
	//print("%d\n",a[2])
	b := a[3:5]
	print("len=%d cap=%d %d-%d\n", len(b), cap(b), b[0], b[1])
	//print("len=%d cap=%d %d\n",len(b),cap(b),b[0])
}

//3-3
func slicecp() {
	a := []int{9, 7, 3, 5, 5}
	b := []int{9, 7, 3, 9}
	a = b
	print("%d-%d\n", len(a), cap(a))
}

func slicet() {
	//d := 1
	var b int
	var a [4]int
	a[0] = 52
	a[1] = 0
	b = a[0]
	//ff(a[0])
	print("%d\n", a[0])
	//ff(a[0])
	//a[i()] = 90
	//a[d] = 80
	//a[2] = 81
	//a[3] = d + 777
	//b = a[2+1]
	//ff(a[2])

	//	//var b int = a[0]
	print("%s\n", a[0])
	//show(a[1])
}

func sliceslice() {
	var kk [1][]int
	kk[0] = []int{1, 2, 3, 4, 5}
	for _, value := range kk[0] {
		print("%d\n", value)
	}
}

func kkp(kk [][]int) [][]int {
	return kk
}

type PP struct {
	Age int
}

func BaseSlice() {
	var aa1 []string
	var aa2 []int
	var aa3 []byte
	var aa4 []float32
	var aa5 []float64
	var aa6 []PP
}

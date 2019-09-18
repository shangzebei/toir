package test

func main() {
	ini2()
}

func ini1() {
	a := []int{1, 2, 3, 4}
	a2 := []bool{true, false, false, true}
	a3 := []float32{1, 2, 3, 4}
	a4 := []string{"aaaa", "bbbbb", "ccccc", "ddddd"}
}

func ini2() {
	a1 := "asdfasdf"
	a2 := "bbbbbbbbb"
	a3 := "cccccccccc"
	aa1 := []string{a1, a2, a3, "endendend"}
	for index, value := range aa1 {
		print("index%d --[%s]--len %d\n", index, value, len(value))
	}
}

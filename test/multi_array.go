package test

func main() {
	arr1()
	arr2()
	arr3()
	arr4()
}

func arr1() {
	grid := [][]int{
		{3, 0, 8, 4},
		{2, 4, 5, 7},
	}
	for _, value := range grid {
		for _, v := range value {
			print("%d ", v)
		}
		print("\n")
	}
}

func arr2() {
	grid := [][]int{
		{3, 0, 8, 4},
		{2, 4, 5, 7},
		{9, 2, 6, 3},
		{0, 3, 1, 0},
	}
	print("%d\n", grid[2][2])
}

func arr3() {
	var a = [][][]int{
		{
			{1, 2, 3, 4}, {5, 6, 7, 8},
		},
		{
			{9, 10, 11, 12}, {13, 14, 15, 16},
		},
		{
			{17, 18, 19, 20}, {21, 22, 23, 24},
		},
	}
	print("%d\n", a[1][1][1])
}

func arr4() {
	a := [][]string{
		{"aaaaa", "bbbbbb", "vvvvv"},
		{"fffff", "rrrrrr", "ggggg"},
	}
	for _, value := range a {
		for _, v := range value {
			print("%s ", v)
		}
		print("\n")
	}
}

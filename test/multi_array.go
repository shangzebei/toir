package test

func main() {
	arr1()
	arr2()
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

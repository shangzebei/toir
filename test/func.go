package test

func main() {
	b := add(1+1-1, sul(call(), 1))
}

func add(a int, b int) int {
	return a + b
}

func sul(a int, b int) int {
	return a - b
}
func call() int {
	return add(5, 6)
}

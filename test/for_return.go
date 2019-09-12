package test

func main() {
	print("%d\n", forr())
	ifrr()
	forr()
}

func forr() int {
	print("begin\n")
	for i := 0; i <= 11; i++ {
		print("asdfasdfsdf--%d\n", i)
		if i > 5 {
			print(">5 \n")
		}
	}
	return 0
}

func ifrr() int {
	i := 9
	if i > 5 {
		print("aaaaaaaaaaa\n")
		return 1
	}
	return 0
}

package test

//import "fmt"

func main() {
	for2()
	for23()
	for1()
	for4()
}

func max() int {
	return 3
}

func for1() {
	for i := 0; i <= max(); i++ {
		print("aaaaaaaaaaa\n")
	}
	print("bbbbbbbbbbbb\n")
	for j := 0; j <= 2; j++ {
		print("%d\n", j)
	}
	print("ggggggggggggggg")
}

func for2() {
	for i := 0; i < 10; i++ {
		print("%d\n", i)
	}
}

func for23() int {
	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			print("asdfasdfasd%d-%d\n", i, j)
		}
	}
	return 0
}

/**
  bbbbbbbbbbbb
  aaaaaaaaaaa
  aaaaaaaaaaa
  bbbbbbbbbbbb
  aaaaaaaaaaa
  aaaaaaaaaaa
  bbbbbbbbbbbb
  aaaaaaaaaaa
  aaaaaaaaaaa
  cccccccccccc 90
*/
func for4() {
	i := 90
	for i := 0; i < 3; i++ {
		print("bbbbbbbbbbbb\n")
		for i := 0; i < 2; i++ {
			print("aaaaaaaaaaa\n")
		}
	}
	print("cccccccccccc %d\n", i)
}

func for5() {
	for i := 0; ; {
		i++
		if i > 5 {
			break
		}
	}
}

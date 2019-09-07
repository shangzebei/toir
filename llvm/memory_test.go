package llvm

import (
	"fmt"
	"testing"
)

type TT struct {
}

var a = 0

func TestName(t *testing.T) {
	//for kk(){
	//	a++
	//	fmt.Printf("aaaaaaaaaa\n")
	//}

	for i := 0; jj(i); i++ {
		fmt.Println(i)
	}
}

func jj(i int) bool {
	fmt.Println("GGGGGGGGGG")
	return i < 6
}

func kk() bool {
	fmt.Println("bbbbbb")
	return a < 5
}

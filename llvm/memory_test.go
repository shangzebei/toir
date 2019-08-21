package llvm

import (
	"fmt"
	"testing"
)

func dd(a int32) {
	fmt.Println("cccc")
	a++
	if a < 5 {
		fmt.Println("aaaa")
		dd(a)
		fmt.Println("bbbb")
	}
	fmt.Println("ddddddd")
}

func TestName(t *testing.T) {
	a := [3]int{1, 2, 3}
	var b [3]int

}

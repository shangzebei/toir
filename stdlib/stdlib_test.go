package stdlib

import (
	"fmt"
	"testing"
)

func TestName(t *testing.T) {
	i := 78
	b := []int{121, 122, 133, 144, 155}
	for i := 0; i < len(b); i++ {
		fmt.Printf("%d\n", b[i])
	}
	for i := 0; i < len(b); i++ {
		fmt.Printf("%d\n", b[i])
	}
	fmt.Println(i)
}

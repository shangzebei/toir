package llvm

import (
	"fmt"
	"testing"
)

type AA struct {
	Name string
}

func TestName(t *testing.T) {
	a := make([]int, 3)
	fmt.Printf("cap=%d - len=%d\n", cap(a), len(a))
}

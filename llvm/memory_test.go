package llvm

import (
	"fmt"
	"testing"
)

type AA struct {
	Name string
}

func TestName(t *testing.T) {
	for i := 0; i < 10; i++ {
		fmt.Printf("%d\n", i)
	}
}

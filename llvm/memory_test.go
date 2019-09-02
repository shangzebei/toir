package llvm

import (
	"fmt"
	"testing"
)

type TT struct {
}

func TestName(t *testing.T) {
	aa := aaa(TT{})
	fmt.Printf("%p\n", &aa)
}

func aaa(t TT) TT {
	fmt.Printf("%p\n", &t)
	return t
}

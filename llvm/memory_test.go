package llvm

import (
	"fmt"
	"testing"
)

type AA struct {
	Name string
}

func TestName(t *testing.T) {
	var kk AA
	aa := AA{Name: "asdfsdfs"}
	kk = aa
	kk.Name = "bbbbbbbb"
	fmt.Printf("%s-%s-%s\n", aa.Name, kk.Name, aa.Name)
}

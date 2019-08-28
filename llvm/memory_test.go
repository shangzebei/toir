package llvm

import (
	"fmt"
	"testing"
)

type AA struct {
	Name string
}

func TestName(t *testing.T) {
	aa := AA{Name: "asdfsdfs"}
	bb := AA{Name: "eeeeeeee"}
	aa = bb
	bb.Name = "gggggggg"
	fmt.Printf("%s-%s-%s\n", aa.Name, bb.Name, aa.Name)
}

package llvm

import (
	"fmt"
	"testing"
)

func dd(a int32) {

}

func TestName(t *testing.T) {
	b := int32(1236)
	var a = int8(b)
	dd(int32(a))
	fmt.Printf("%d\n", a)

}

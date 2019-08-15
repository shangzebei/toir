package llvm

import (
	"fmt"
	"testing"
)

func TestName(t *testing.T) {
	a := 89
	var b int = a
	fmt.Printf("%p===%p", &a, &b)
	//fmt.Printf(a,b)
}

package convert

import (
	"fmt"
	"github.com/llir/llvm/ir"
)

func Push(context *[]*ir.Func, x *ir.Func) bool {
	for _, value := range *context {
		fmt.Println("cmp", x.Name(), value.Name())
		if x.Name() == value.Name() {
			return false
		}
	}
	*context = append(*context, x)
	fmt.Println("push Func =================")
	return true
}

func Pop(context *[]*ir.Func) *ir.Func {
	old := *context
	n := len(old)
	x := old[n-1]
	*context = old[0 : n-1]
	fmt.Println("pop Func =================")
	return x
}

package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
)

func Push(context *[]*ir.Func, x *ir.Func) bool {
	for _, value := range *context {
		fmt.Println("cmp", x.Name(), value.Name())
		if x.Name() == value.Name() {
			return false
		}
	}
	*context = append(*context, x)
	logrus.Debugf("push Func ======%s=========", x.Name())
	return true
}

func Pop(context *[]*ir.Func) *ir.Func {
	old := *context
	n := len(old)
	x := old[n-1]
	*context = old[0 : n-1]
	logrus.Debugf("pop Func ========%s=======", x.Name())
	return x
}

package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
)

func PushFunc(context *[]*ir.Func, x *ir.Func) bool {
	*context = append(*context, x)
	logrus.Debugf("push Func ======%s=========", x.Name())
	return true
}

func PopFunc(context *[]*ir.Func) *ir.Func {
	old := *context
	n := len(old)
	x := old[n-1]
	*context = old[0 : n-1]
	logrus.Debugf("popFunc Func ========%s=======", x.Name())
	return x
}

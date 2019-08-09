package stdlib

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"

	"testing"
)

func TestName(t *testing.T) {
	//declare i32 @printf(i8*, ...)
	m := ir.NewModule()
	newFunc := m.NewFunc("printf", types.I32, ir.NewParam("", types.I8Ptr))
	newFunc.Sig.Variadic = true
	block := newFunc.NewBlock("")
	block.NewRet(constant.NewInt(types.I32, int64(123)))
	fmt.Println(m)
}

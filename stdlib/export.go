package stdlib

import (
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
)

//{i32,"printf",[{""}]}
func VE(name string, ret types.Type, va bool, p ...types.Type) *ir.Func {
	var prs []*ir.Param
	for _, value := range p {
		prs = append(prs, ir.NewParam("", value))
	}
	newFunc := ir.NewFunc(name, ret, prs...)
	newFunc.Sig.Variadic = va
	return newFunc
}

func V(name string, ret types.Type, p ...types.Type) *ir.Func {
	return VE(name, ret, false, p...)
}

func DV(m *ir.Module, name string, ret types.Type, va bool, p ...types.Type) *ir.Func {
	ve := VE(name, ret, va, p...)
	m.Funcs = append(m.Funcs, ve)
	return ve
}

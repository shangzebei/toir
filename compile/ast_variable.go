package compile

import (
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
)

//only use flag
type Scope struct {
	V    value.Value
	Flag int
}

func (i *Scope) Type() types.Type {
	return i.V.Type()
}

func (i *Scope) String() string {
	return i.V.String()
}

func (i *Scope) Ident() string {
	return i.V.Ident()
}

func (f *FuncDecl) clsScopeVar(value2 value.Value, flag int, cls func()) value.Value {
	if s, ok := value2.(*Scope); ok && s.Flag == flag {
		cls()
		return value2
	}
	return value2
}

func (f *FuncDecl) GetVariable(name string) value.Value {
	if f.tempV > 0 {
		for i := f.tempV; i > 0; i-- {
			p, ok := f.tempVariables[i][name]
			if ok {
				logrus.Debugf("get temp[%d] name %s", f.tempV, name)
				return p
			}
		}
	}
	//find which glob
	for _, value := range f.m.Globals {
		if value.Name() == name {
			return value
		}
	}
	//find with block
	for _, block := range f.GetCurrent().Blocks {
		values, ok := f.Variables[block]
		if !ok {
			continue
		}
		i, ok := values[name]
		if ok {
			return i
		}
	}
	//
	logrus.Warnf("not find Variable %s", name)
	return nil
}

//this use for for or range and if
func (f *FuncDecl) OpenTempVariable() {
	f.tempV++
	logrus.Debugf("open temp variable %d", f.tempV)
	if len(f.tempVariables[0]) != 0 {
		f.tempVariables[f.tempV] = f.tempVariables[0]
	} else {
		f.tempVariables[f.tempV] = make(map[string]value.Value)
	}

}

func (f *FuncDecl) CloseTempVariable() {
	f.tempVariables[0] = make(map[string]value.Value)
	f.tempVariables[f.tempV] = make(map[string]value.Value)
	logrus.Debugf("close temp variable %d", f.tempV)
	f.tempV--
}

//clear all current block variable
func (f *FuncDecl) ClearVariable(flag int) {
	for _, value := range f.GetCurrent().Blocks {
		for key, v := range f.Variables[value] {
			f.clsScopeVar(v, flag, func() {
				delete(f.Variables[value], key)
			})
		}
	}
	if f.tempV > 0 {
		for i := f.tempV; i > 0; i-- {
			for key, value := range f.tempVariables[i] {
				f.clsScopeVar(value, flag, func() {
					delete(f.tempVariables[i], key)
				})
			}
		}
	}
}

func (f *FuncDecl) PutVariable(name string, value2 value.Value) {
	if IsKeyWord(name) {
		logrus.Errorf("%d is keyword", name)
		return
	}
	if f.tempV > 0 {
		f.tempVariables[f.tempV][name] = value2
		logrus.Debugf("Put temp[%d] name %s", f.tempV, name)
	} else {
		_, ok := f.Variables[f.GetCurrentBlock()]
		if !ok {
			f.Variables[f.GetCurrentBlock()] = make(map[string]value.Value)
		}
		logrus.Debugf("PutVariable name %s", name)
		f.Variables[f.GetCurrentBlock()][name] = value2
	}

}

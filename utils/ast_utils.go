package utils

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/parser"
	"go/token"
	"io/ioutil"
	"math/rand"
	"reflect"
	"strconv"
	"strings"
	"time"
)

//src must x* type
func IndexStruct(block *ir.Block, src value.Value, index int) *ir.InstGetElementPtr {
	return IndexStructPtr(block, src, constant.NewInt(types.I32, int64(index)))
}

func IndexStructPtr(block *ir.Block, src value.Value, index value.Value) *ir.InstGetElementPtr {
	return block.NewGetElementPtr(src, constant.NewInt(types.I32, 0), index)
}

func IndexStructValue(block *ir.Block, src value.Value, index int) value.Value {
	return block.NewExtractValue(src, uint64(index))
}

func CompileRuntime(fileName string, funName string) *ast.FuncDecl {
	fSet := token.NewFileSet()
	bytes, _ := ioutil.ReadFile(fileName)
	f, err := parser.ParseFile(fSet, "hello.go", bytes, parser.ParseComments)
	if err != nil {
		fmt.Print(err) // parse error
		return nil
	}
	ast.Print(fSet, f)
	for _, value := range f.Decls {
		switch value.(type) {
		case *ast.GenDecl:
		case *ast.FuncDecl:
			if value.(*ast.FuncDecl).Name.Name == funName {
				return value.(*ast.FuncDecl)
			}
		}
	}
	return nil
}

func GCCall(owner interface{}, inf interface{}) []interface{} {
	valueOf := reflect.ValueOf(owner)
	of := reflect.ValueOf(inf)
	s := of.Type().String()
	index := strings.LastIndex(s, ".")
	fName := s[index+1:]
	fun := valueOf.MethodByName(fName)
	if fun.IsValid() {
		logrus.Debugf("call func %s", fName)
		values := fun.Call([]reflect.Value{of})
		var res []interface{}
		for _, v := range values {
			res = append(res, v.Interface())
		}
		return res
	}
	logrus.Errorf("not find method %s", fName)
	return nil
}

func Call(i interface{}, funName string, params ...value.Value) value.Value {
	valueOf := reflect.ValueOf(i)
	fun := valueOf.MethodByName(funName)
	if fun.IsValid() {
		var vs []reflect.Value
		for _, value := range params {
			vs = append(vs, reflect.ValueOf(value))
		}
		call := fun.Call(vs)
		if len(call) > 0 {
			return call[0].Interface().(value.Value)
		}

	} else {
		fmt.Println("not buildin", funName)
	}
	return nil
}

func FastCharToLower(name string) string {
	return strings.ToUpper(string(name[0])) + name[1:]
}

func Toi8Ptr(b *ir.Block, src value.Value) *ir.InstGetElementPtr {
	return b.NewGetElementPtr(src, constant.NewInt(types.I64, 0), constant.NewInt(types.I64, 0))
}

func StdCall(m *ir.Module, b *ir.Block, v value.Value, args ...value.Value) value.Value {
	typ := v.Type()
	if p, ok := v.Type().(*types.PointerType); ok {
		typ = p.ElemType
	}
	if _, ok := typ.(*types.FuncType); ok {
		ex := false
		i := v.(*ir.Func)
		for _, value := range m.Funcs {
			if i.GlobalName == value.GlobalName {
				ex = true
				break
			}
		}
		if !ex {
			m.Funcs = append(m.Funcs, v.(*ir.Func))
		}
		return b.NewCall(v, args...)
	} else {
		fmt.Println("type error")
	}
	return nil
}

func LoadValue(block *ir.Block, v value.Value) value.Value {
	if !types.IsPointer(v.Type()) {
		return v
	}
	if v, ok := v.(*ir.InstLoad); ok {
		return v
	}
	return block.NewLoad(v)
}

func GetRandNum(size int) string {
	a := ""
	for i := 0; i < size; i++ {
		a += strconv.Itoa(rand.Intn(10))
	}
	return a + strconv.Itoa(int(time.Now().Unix()))
}

func GetBaseType(v types.Type) types.Type {
	if p, ok := v.(*types.PointerType); ok {
		return GetBaseType(p.ElemType)
	} else {
		return v
	}
}

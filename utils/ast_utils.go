package utils

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/parser"
	"go/token"
	"io/ioutil"
	"reflect"
	"strings"
)

//src must x* type
func IndexStruct(block *ir.Block, src value.Value, index int) *ir.InstGetElementPtr {
	return block.NewGetElementPtr(src, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, int64(index)))
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

func Call(i interface{}, funName string, params []value.Value) value.Value {
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
	if v, ok := v.(*ir.InstLoad); ok {
		return v
	}
	return block.NewLoad(v)
}

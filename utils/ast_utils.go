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

func Index(block *ir.Block, src value.Value, index int) *ir.InstGetElementPtr {
	return block.NewGetElementPtr(src, constant.NewInt(types.I32, 0), constant.NewInt(types.I32, int64(index)))
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
	name := valueOf.MethodByName(funName)
	if name.IsNil() || name.IsZero() {
		fmt.Println("not buildin", funName)
	}
	var vs []reflect.Value
	for _, value := range params {
		vs = append(vs, reflect.ValueOf(value))
	}
	call := name.Call(vs)
	return call[0].Interface().(value.Value)
}

func FastCharToLower(name string) string {
	return strings.ToUpper(string(name[0])) + name[1:]
}

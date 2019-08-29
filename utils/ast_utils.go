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

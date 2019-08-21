package main

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/parser"
	"go/token"
	"io/ioutil"
	"learn/compile"
)

func init() {
	//logrus.SetOutput(os.Stdout)
	logrus.SetLevel(logrus.DebugLevel)
}

func main() {
	fset := token.NewFileSet()
	bytes, _ := ioutil.ReadFile("test/slice_append.go")
	f, err := parser.ParseFile(fset, "hello.go", bytes, parser.ParseComments)
	if err != nil {
		fmt.Print(err) // parse error
		return
	}
	ast.Print(fset, f)
	m := ir.NewModule()
	doFunc := compile.DoFunc(m, fset)
	for _, value := range f.Decls {
		switch value.(type) {
		case *ast.GenDecl:
			doFunc.DoGenDecl(value.(*ast.GenDecl))
		case *ast.FuncDecl:
			doFunc.DoFunDecl(f.Name.Name, value.(*ast.FuncDecl))
		}
	}
	ioutil.WriteFile("bc.llr", []byte(m.String()), 0644)
}

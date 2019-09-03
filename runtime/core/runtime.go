package core

import (
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"io/ioutil"
)

type Runtime struct {
	f *ast.File
}

func Init(fileName string) *Runtime {
	fSet := token.NewFileSet()
	bytes, _ := ioutil.ReadFile(fileName)
	f, err := parser.ParseFile(fSet, "hello.go", bytes, parser.ParseComments)
	if err != nil {
		fmt.Print(err) // parse error
		return nil
	}
	//ast.Print(fSet, f)
	return &Runtime{f: f}

}

func (r *Runtime) GetFunc(name string) *ast.FuncDecl {
	for _, value := range r.f.Decls {
		switch value.(type) {
		case *ast.FuncDecl:
			if value.(*ast.FuncDecl).Name.Name == name {
				return value.(*ast.FuncDecl)
			}
		}
	}
	return nil
}

func (r *Runtime) GenAll() []*ast.GenDecl {
	var temp []*ast.GenDecl
	for _, value := range r.f.Decls {
		switch value.(type) {
		case *ast.GenDecl:
			temp = append(temp, value.(*ast.GenDecl))
		}
	}
	return temp
}

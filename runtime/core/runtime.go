package core

import (
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"strings"
)

type Runtime struct {
	f map[string]*ast.Package
}

func Init(dir string) *Runtime {
	fSet := token.NewFileSet()
	pkgs, _ := parser.ParseDir(fSet, dir, func(info os.FileInfo) bool {
		return strings.HasSuffix(info.Name(), ".go")
	}, parser.ParseComments)
	return &Runtime{f: pkgs}

}

func (r *Runtime) GetFunc(name string) *ast.FuncDecl {
	for _, v := range r.f {
		for _, d := range v.Files {
			for _, value := range d.Decls {
				switch value.(type) {
				case *ast.FuncDecl:
					if value.(*ast.FuncDecl).Name.Name == name {
						return value.(*ast.FuncDecl)
					}
				}
			}

		}
	}
	return nil
}

func (r *Runtime) GenAll() []*ast.GenDecl {
	var temp []*ast.GenDecl
	for _, v := range r.f {
		for _, d := range v.Files {
			for _, value := range d.Decls {
				switch value.(type) {
				case *ast.GenDecl:
					temp = append(temp, value.(*ast.GenDecl))
				}
			}

		}
	}
	return temp
}

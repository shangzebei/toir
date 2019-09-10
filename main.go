package main

import (
	"flag"
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/parser"
	"go/token"
	"io/ioutil"
	"os"
	"os/exec"
	"toir/compile"
	"toir/runtime/core"
)

func init() {
	//logrus.SetOutput(os.Stdout)
	logrus.SetLevel(logrus.DebugLevel)
}

func Build(file string, outputPath string) {
	fset := token.NewFileSet()
	bytes, _ := ioutil.ReadFile(file)
	f, err := parser.ParseFile(fset, "hello.go", bytes, parser.ParseComments)
	if err != nil {
		fmt.Print(err) // parse error
		return
	}
	//ast.Print(fset, f)
	m := ir.NewModule()

	//init runtime
	runtime := core.Init("runtime/std.go")
	doFunc := compile.DoFunc(m, fset, "main", runtime)

	var mainF ast.Decl

	//copy runtime def to ...
	var globs []*ast.GenDecl
	globs = append(globs, runtime.GenAll()...)

	//
	var funs []*ast.FuncDecl
	for _, value := range f.Decls {
		switch value.(type) {
		case *ast.GenDecl:
			globs = append(globs, value.(*ast.GenDecl))
		case *ast.FuncDecl:
			if value.(*ast.FuncDecl).Name.Name != "main" {
				funs = append(funs, value.(*ast.FuncDecl))
			} else {
				mainF = value
			}
		}
	}
	//Glob
	for _, value := range globs {
		doFunc.GenDecl(value)
	}
	//define func
	for _, value := range funs {
		doFunc.DoFunDecl(f.Name.Name, value)
	}
	//main
	doFunc.DoFunDecl(f.Name.Name, mainF.(*ast.FuncDecl))

	ioutil.WriteFile(outputPath+".ll", []byte(m.String()), 0644)

}

func main() {
	i := flag.String("file", ".", "go files")
	flag.Parse()
	if len(os.Args) == 0 {
		flag.Usage()
		return
	}
	Build(*i, "binary")
	cmd := exec.Command("lli", "binary.ll")
	output, _ := cmd.CombinedOutput()
	fmt.Println(string(output))
}

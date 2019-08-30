package main

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/parser"
	"go/token"
	"io/ioutil"
	"toir/compile"
	"toir/runtime/core"

	"os/exec"
)

func init() {
	//logrus.SetOutput(os.Stdout)
	logrus.SetLevel(logrus.DebugLevel)
}

func main() {
	fset := token.NewFileSet()
	bytes, _ := ioutil.ReadFile("test/mul_var.go")
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
		doFunc.DoGenDecl(value)
	}
	//define func
	for _, value := range funs {
		doFunc.DoFunDecl(f.Name.Name, value)
	}
	//main
	doFunc.DoFunDecl(f.Name.Name, mainF.(*ast.FuncDecl))

	ioutil.WriteFile("bc.ll", []byte(m.String()), 0644)

	outputBinaryPath := "binary"

	clangArgs := []string{
		"-Wno-override-module", // Disable override target triple warnings
		"bc.ll",                // Path to LLVM IR
		"-o", outputBinaryPath, // Output path
	}

	// Invoke clang compiler to compile LLVM IR to a binary executable
	cmd := exec.Command("clang", clangArgs...)
	output, err := cmd.CombinedOutput()
	if err != nil {
		fmt.Println(string(output))
	}

	if len(output) > 0 {
		fmt.Println(string(output))
	}
}

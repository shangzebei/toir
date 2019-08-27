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
	"os/exec"
)

func init() {
	//logrus.SetOutput(os.Stdout)
	logrus.SetLevel(logrus.DebugLevel)
}

func main() {
	fset := token.NewFileSet()
	bytes, _ := ioutil.ReadFile("test/slice-append-assign.go")
	f, err := parser.ParseFile(fset, "hello.go", bytes, parser.ParseComments)
	if err != nil {
		fmt.Print(err) // parse error
		return
	}
	ast.Print(fset, f)
	m := ir.NewModule()
	doFunc := compile.DoFunc(m, fset, "main")
	var mainF ast.Decl
	for _, value := range f.Decls {
		switch value.(type) {
		case *ast.GenDecl:
			doFunc.DoGenDecl(value.(*ast.GenDecl))
		case *ast.FuncDecl:
			if value.(*ast.FuncDecl).Name.Name != "main" {
				doFunc.DoFunDecl(f.Name.Name, value.(*ast.FuncDecl))
			} else {
				mainF = value
			}
		}
	}

	doFunc.DoFunDecl(f.Name.Name, mainF.(*ast.FuncDecl)) //main

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

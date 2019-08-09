package convert

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
)

type FuncDecl struct {
	m         *ir.Module
	fset      *token.FileSet
	Funs      map[string]*ir.Func
	FuncHeap  *[]*ir.Func
	GlobDef   map[string]*ir.Func
	FuncDecls []*ast.FuncDecl
}

func DoFunc(m *ir.Module, fset *token.FileSet) *FuncDecl {

	return &FuncDecl{
		m:        m,
		fset:     fset,
		FuncHeap: new([]*ir.Func),
	}
}

func (f *FuncDecl) DoGenDecl(decl *ast.GenDecl) {
	if decl.Tok == token.VAR {
		for _, v := range decl.Specs {
			spec := v.(*ast.ValueSpec)
			for _, value := range spec.Values {
				basicLit := value.(*ast.BasicLit)
				globName := spec.Names[0].String()
				f.m.NewGlobalDef(globName, BasicLitToValue(basicLit))
			}

		}
	}
}

func (f *FuncDecl) doFunType(funName string, fields []*ast.Field) {
	if len(fields) > 0 {
		for index, value := range fields {
			paramName := value.Names[0].String()
			paramKind := (value.Type.(*ast.Ident)).Name
			f.GetCurrent().Params = append(f.GetCurrent().Params, ir.NewParam(paramName, GetTypeFromName(paramKind)))
			logrus.Debug(paramKind)
			//paramKinds = append(paramKinds, ir.NewParam(paramName, GetTypeFromName(paramKind)))
			logrus.Debug(index, paramName, paramKind)
		}
	}
	paramTypes := make([]types.Type, len(f.GetCurrent().Params))
	for i, param := range f.GetCurrent().Params {
		paramTypes[i] = param.Type()
	}
	f.GetCurrent().Sig.Params = paramTypes
}

func (f *FuncDecl) GetCurrent() *ir.Func {
	if len(*f.FuncHeap) == 0 {
		return nil
	}
	return (*f.FuncHeap)[len(*f.FuncHeap)-1]
}

func (f *FuncDecl) CreatTempFunc(name string) *ir.Func {
	i := new(ir.Func)
	i.Sig = new(types.FuncType)
	i.SetName(name)
	return i
}

func (f *FuncDecl) DoFunDecl(pkg string, funDecl *ast.FuncDecl) *ir.Func {
	for _, value := range f.FuncDecls {
		if value == funDecl {
			fmt.Println("has def func!!! ")
			return nil
		}
	}
	f.FuncDecls = append(f.FuncDecls, funDecl)
	////////////////////////////method begin//////////////////////////////

	//func name
	funName := funDecl.Name.Name
	Push(f.FuncHeap, f.CreatTempFunc(funName))
	//func type
	funcType := funDecl.Type.Params.List
	f.doFunType(funName, funcType)
	//func body
	blockStmt := funDecl.Body
	f.doBlockStmt(blockStmt)
	//body
	////////////////////////////method end/////////////////////////
	return f.pop()

}

func (f *FuncDecl) pop() *ir.Func {
	f.GetCurrent().Type()
	f.m.Funcs = append(f.m.Funcs, f.GetCurrent())
	for index, value := range f.GetCurrent().Blocks {
		if value.Term == nil {
			logrus.Errorf("index %d %s block ret is nil", index, value.Name())
			f.GetCurrent().Blocks[index].NewRet(nil)
		}
	}
	return Pop(f.FuncHeap)
}

func (f *FuncDecl) doBlockStmt(block *ast.BlockStmt) *ir.Block {
	newBlock := f.GetCurrent().NewBlock("")
	//ast.Print(f.fset, block.List)
	for _, value := range block.List {
		switch value.(type) {
		case *ast.ExprStmt:
			exprStmt := value.(*ast.ExprStmt)
			switch exprStmt.X.(type) {
			case *ast.CallExpr:
				callExpr := exprStmt.X.(*ast.CallExpr)
				f.doCallExpr(callExpr)
			}
		case *ast.IfStmt: //if
			expr := value.(*ast.IfStmt)
			switch expr.Cond.(type) {
			case *ast.BinaryExpr:
				binaryExpr := expr.Cond.(*ast.BinaryExpr)
				trueBlock := f.doBlockStmt(expr.Body)
				doBinary := f.doBinary("return", binaryExpr)
				if expr.Else == nil {
					newBlock.NewCondBr(doBinary, trueBlock, nil)
				} else {
					falseBlock := f.doBlockStmt(expr.Else.(*ast.BlockStmt))
					newBlock.NewCondBr(doBinary, trueBlock, falseBlock)
				}
			}
		case *ast.ReturnStmt:
			returnStmt := value.(*ast.ReturnStmt)
			//ast.Print(f.fset, returnStmt)
			//return 1 value
			for _, value := range returnStmt.Results {
				switch value.(type) {
				case *ast.BasicLit:
					basicLit := value.(*ast.BasicLit)
					f.GetCurrent().Sig.RetType = GetTypes(basicLit.Kind)
					newBlock.NewRet(BasicLitToValue(value.(*ast.BasicLit)))
				case *ast.BinaryExpr:
					binary := f.doBinary("return", value.(*ast.BinaryExpr))
					f.GetCurrent().Sig.RetType = binary.Type()
					newBlock.NewRet(binary)
				case *ast.CallExpr:
					callExpr := f.doCallExpr(value.(*ast.CallExpr))
					f.GetCurrent().Sig.RetType = callExpr.Type()
					newBlock.NewRet(callExpr)
				}

			}

		}
	}
	if f.GetCurrent() != nil && f.GetCurrent().Sig.RetType == nil {
		f.GetCurrent().Sig.RetType = types.Void
		newBlock.NewRet(nil)
	}
	return newBlock
}

func (f *FuncDecl) doCallExpr(call *ast.CallExpr) value.Value {
	//get call param
	var params []value.Value
	for _, value := range call.Args {
		switch value.(type) {
		case *ast.Ident:
			ident := value.(*ast.Ident)
			switch ident.Obj.Kind {
			case ast.Var:
				//ast.Print(f.fset, ident.Obj.Kind)
				fmt.Println("no impl in doCallExpr")
			}
		case *ast.BasicLit: //param
			basicLit := value.(*ast.BasicLit)
			params = append(params, BasicLitToValue(basicLit))
		}
	}
	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		fmt.Println("no impl")
	case *ast.Ident:
		return f.doCallFunc(params, call.Fun.(*ast.Ident))
	}
	return nil
}

func (f *FuncDecl) doCallFunc(values []value.Value, id *ast.Ident) value.Value {
	block := f.GetCurrentBlock()
	funDecl := f.DoFunDecl("", id.Obj.Decl.(*ast.FuncDecl))
	return block.NewCall(funDecl, values...)
}

func (f *FuncDecl) doBasicLit(flags string, base *ast.BasicLit) {
	switch flags {
	case "return":

	}
}

func (f *FuncDecl) GetCurrentBlock() *ir.Block {
	blocks := f.GetCurrent().Blocks
	return blocks[len(blocks)-1]
}

package convert

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
	"strconv"
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
	return f.pop()
}

func (f *FuncDecl) pop() *ir.Func {
	f.GetCurrent().Type()
	f.m.Funcs = append(f.m.Funcs, f.GetCurrent())
	for index, value := range f.GetCurrent().Blocks {
		if value.Term == nil {
			logrus.Errorf("index %d block ret is nil", index)
			f.GetCurrent().Blocks[index].NewRet(nil)
		}
	}
	fmt.Println(f.GetCurrent().Blocks)
	return Pop(f.FuncHeap)
}

func (f *FuncDecl) doBlockStmt(block *ast.BlockStmt) {
	f.GetCurrent().NewBlock("")
	for _, value := range block.List {
		switch value.(type) {
		case *ast.ExprStmt:
			exprStmt := value.(*ast.ExprStmt)
			switch exprStmt.X.(type) {
			case *ast.CallExpr:
				callExpr := exprStmt.X.(*ast.CallExpr)
				f.doCallExpr(callExpr)
			}
		case *ast.ReturnStmt:
			returnStmt := value.(*ast.ReturnStmt)
			ast.Print(f.fset, returnStmt)
			block := f.GetCurrent().Blocks[0]
			//return 1 value
			for _, value := range returnStmt.Results {
				switch value.(type) {
				case *ast.BasicLit:
					f.doBasicLit("return", value.(*ast.BasicLit))
				case *ast.BinaryExpr:
					binary := f.doBinary("return", value.(*ast.BinaryExpr))
					f.GetCurrent().Sig.RetType = binary.Type()
					block.NewRet(binary)
				}

			}

		}
	}
	if f.GetCurrent() != nil && f.GetCurrent().Sig.RetType == nil {
		f.GetCurrent().Sig.RetType = types.Void
	}

}

func (f *FuncDecl) doCallExpr(call *ast.CallExpr) {
	fmt.Println("call", GetCallFunc(call))
	//get call param
	var params []value.Value
	for _, value := range call.Args {
		switch value.(type) {
		case *ast.Ident:
			ident := value.(*ast.Ident)
			switch ident.Obj.Kind {
			case ast.Var:
				ast.Print(f.fset, ident.Obj.Kind)
			}
		case *ast.BasicLit: //param
			basicLit := value.(*ast.BasicLit)
			switch basicLit.Kind {
			case token.INT:
				atoi, _ := strconv.Atoi(basicLit.Value)
				params = append(params, constant.NewInt(types.I32, int64(atoi)))
			}
		}
	}

	//fmt.Println(len(f.GetCurrent().Blocks))
	block := f.GetCurrent().Blocks[0]
	//block.NewCall(stdlib.DV(f.m, "printf", types.I32, true, types.I8Ptr), Toi8Ptr(block, Get("shangzebe").(value.Value)))

	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		fmt.Println("fasdfasdfasdf")
	case *ast.Ident:
		f.doCallFunc(params, call.Fun.(*ast.Ident))
	}
	block.NewRet(nil)
}

func (f *FuncDecl) doCallFunc(values []value.Value, id *ast.Ident) {
	block := f.GetCurrent().Blocks[0]
	funDecl := f.DoFunDecl("", id.Obj.Decl.(*ast.FuncDecl))
	block.NewCall(funDecl, values...)
}

func (f *FuncDecl) doBinary(flags string, expr *ast.BinaryExpr) value.Value {
	switch flags {
	case "return":
		block := f.GetCurrent().Blocks[0]
		//get x
		var x value.Value
		var y value.Value
		switch expr.X.(type) {
		case *ast.Ident:
			ident := expr.X.(*ast.Ident)
			x = IdentToValue(ident)
		case *ast.BasicLit:
			basicLit := expr.X.(*ast.BasicLit)
			x = BasicLitToValue(basicLit)
		case *ast.BinaryExpr:
			x = f.doBinary(flags, expr.X.(*ast.BinaryExpr))
		}
		//get y
		switch expr.Y.(type) {
		case *ast.Ident:
			ident := expr.Y.(*ast.Ident)
			y = IdentToValue(ident)
		case *ast.BasicLit:
			basicLit := expr.Y.(*ast.BasicLit)
			y = BasicLitToValue(basicLit)
		case *ast.BinaryExpr:
			y = f.doBinary(flags, expr.Y.(*ast.BinaryExpr))
		}
		//get ops
		switch expr.Op {
		case token.ADD:
			return block.NewAdd(x, y)
		case token.SUB:
			return block.NewSub(x, y)
		case token.MUL:
			return block.NewMul(x, y)
		case token.QUO:
			return block.NewUDiv(x, y)

		}

	}
	return nil
}

func (f *FuncDecl) doBasicLit(flags string, base *ast.BasicLit) {
	switch flags {
	case "return":
		f.GetCurrent().Sig.RetType = GetTypes(base.Kind)
		f.GetCurrent().Blocks[0].NewRet(BasicLitToValue(base))
	}
}

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
	FuncDecls map[*ast.FuncDecl]*ir.Func
	blockHeap map[*ir.Func][]*ir.Block
	Variables map[*ir.Block]map[string]value.Value
}

func DoFunc(m *ir.Module, fset *token.FileSet) *FuncDecl {
	return &FuncDecl{
		m:         m,
		fset:      fset,
		FuncHeap:  new([]*ir.Func),
		Variables: make(map[*ir.Block]map[string]value.Value),
		blockHeap: make(map[*ir.Func][]*ir.Block),
		FuncDecls: make(map[*ast.FuncDecl]*ir.Func),
	}
}

func (f *FuncDecl) doFunType(funName string, fields []*ast.Field) {
	if len(fields) > 0 {
		for _, value := range fields {
			paramName := value.Names[0].String()
			paramKind := (value.Type.(*ast.Ident)).Name
			newParam := ir.NewParam(paramName, GetTypeFromName(paramKind))
			f.GetCurrent().Params = append(f.GetCurrent().Params, newParam)
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
	i, ok := f.FuncDecls[funDecl]
	if ok {
		return i
	}
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
	pop := f.pop()
	f.FuncDecls[funDecl] = pop
	return pop

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
	//ast.Print(f.fset, block)
	newBlock := f.newBlock()
	defer f.popBlock()
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
				doBinary := f.doBinary("return", binaryExpr)
				//if body
				trueBlock := f.doBlockStmt(expr.Body)

				//else body
				if expr.Else == nil {
					newBlock.NewCondBr(doBinary, trueBlock, ir.NewBlock(""))
				} else {
					falseBlock := f.doBlockStmt(expr.Else.(*ast.BlockStmt))
					newBlock.NewCondBr(doBinary, trueBlock, falseBlock)

				}
			}
		case *ast.ReturnStmt:
			returnStmt := value.(*ast.ReturnStmt)
			//ast.Print(f.fset, returnStmt)
			//TODO return 1 value
			for _, value := range returnStmt.Results {
				switch value.(type) {
				case *ast.BasicLit:
					basicLit := value.(*ast.BasicLit)
					f.GetCurrent().Sig.RetType = GetTypes(basicLit.Kind)
					newBlock.NewRet(BasicLitToConstant(value.(*ast.BasicLit)))
				case *ast.BinaryExpr:
					binary := f.doBinary("return", value.(*ast.BinaryExpr))
					f.GetCurrent().Sig.RetType = binary.Type()
					newBlock.NewRet(binary)
				case *ast.CallExpr:
					callExpr := f.doCallExpr(value.(*ast.CallExpr))
					f.GetCurrent().Sig.RetType = callExpr.Type()
					newBlock.NewRet(callExpr)
				case *ast.Ident:
					identToValue := f.IdentToValue(value.(*ast.Ident))
					f.GetCurrent().Sig.RetType = identToValue.Type()
					newBlock.NewRet(identToValue)
				default:
					fmt.Println("doBlockStmt return not impl!")
				}

			}
		case *ast.ForStmt:
			fmt.Println("ForStmt not impl")
		case *ast.IncDecStmt:
			//f.GetCurrentBlock().NewSelect()
			fmt.Println("IncDecStmt not impl")
		case *ast.AssignStmt:
			assignStmt := value.(*ast.AssignStmt)
			f.doAssignStmt(assignStmt)
		case *ast.DeclStmt:
			f.doDeclStmt(value.(*ast.DeclStmt))
		default:
			fmt.Println("doBlockStmt not impl")
		}
	}
	if f.GetCurrent() != nil && f.GetCurrent().Sig.RetType == nil {
		f.GetCurrent().Sig.RetType = types.Void
		newBlock.NewRet(nil)
	}

	return newBlock
}

func (f *FuncDecl) doDeclStmt(decl *ast.DeclStmt) {
	switch decl.Decl.(type) {
	case *ast.GenDecl:
		f.DoGenDecl(decl.Decl.(*ast.GenDecl))
	}
}

func (f *FuncDecl) doCallExpr(call *ast.CallExpr) value.Value {
	//get call param
	var params []value.Value
	for _, value := range call.Args {
		switch value.(type) {
		case *ast.Ident:
			ident := value.(*ast.Ident)
			if ident.Obj.Kind == ast.Var {
				params = append(params, f.IdentToValue(ident))
			}
		case *ast.BasicLit: //param
			basicLit := value.(*ast.BasicLit)
			params = append(params, BasicLitToConstant(basicLit))
		case *ast.CallExpr:
			params = append(params, f.doCallExpr(value.(*ast.CallExpr)))
		case *ast.BinaryExpr:
			params = append(params, f.doBinary("", value.(*ast.BinaryExpr)))
		default:
			fmt.Println("doCallExpr args not impl")
		}
	}

	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		fmt.Println("doCallExpr SelectorExpr no impl")
	case *ast.Ident:
		return f.doCallFunc(params, call.Fun.(*ast.Ident))
	default:
		fmt.Println("doCallExpr call.Fun")

	}
	return nil
}

func (f *FuncDecl) doCallFunc(values []value.Value, id *ast.Ident) value.Value {
	block := f.GetCurrentBlock()
	funDecl := f.DoFunDecl("", id.Obj.Decl.(*ast.FuncDecl))
	return block.NewCall(funDecl, values...)
}

func (f *FuncDecl) GetVariable(name string) value.Value {
	//find with param
	for _, value := range f.GetCurrent().Params {
		if value.Name() == name {
			return value
		}
	}
	//find which glob
	for _, value := range f.m.Globals {
		if value.Name() == name {
			return value
		}
	}
	//find with block
	for _, block := range f.GetCurrent().Blocks {
		values, ok := f.Variables[block]
		if !ok {
			fmt.Println("not find Variable", name)
			continue
		}
		i, ok := values[name]
		if ok {
			return i
		}
		if block == f.GetCurrentBlock() {
			break
		}
	}
	return nil
}

func (f *FuncDecl) PutVariable(name string, value2 value.Value) {
	_, ok := f.Variables[f.GetCurrentBlock()]
	if !ok {
		f.Variables[f.GetCurrentBlock()] = make(map[string]value.Value)
	}
	f.Variables[f.GetCurrentBlock()][name] = value2
}

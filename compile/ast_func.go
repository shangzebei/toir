package compile

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

type StructDef struct {
	Name  string
	Order int
	Typ   types.Type
}

type FuncDecl struct {
	m         *ir.Module
	fset      *token.FileSet
	Funs      map[string]*ir.Func
	FuncHeap  *[]*ir.Func
	FuncDecls map[*ast.FuncDecl]*ir.Func
	blockHeap map[*ir.Func][]*ir.Block
	//variables
	Variables map[*ir.Block]map[string]value.Value
	//struct---
	GlobDef    map[string]types.Type           //for type
	StructDefs map[string]map[string]StructDef //for type info
	//struct---
	Constants []constant.Constant //for constant
}

func DoFunc(m *ir.Module, fset *token.FileSet) *FuncDecl {
	return &FuncDecl{
		m:          m,
		fset:       fset,
		FuncHeap:   new([]*ir.Func),
		Variables:  make(map[*ir.Block]map[string]value.Value),
		blockHeap:  make(map[*ir.Func][]*ir.Block),
		FuncDecls:  make(map[*ast.FuncDecl]*ir.Func),
		GlobDef:    make(map[string]types.Type),
		StructDefs: make(map[string]map[string]StructDef),
	}
}

func (f *FuncDecl) doFunType(funName string, fields []*ast.Field) {
	if len(fields) > 0 {
		for _, value := range fields {
			paramName := value.Names[0].String()
			var paramKind types.Type
			switch value.Type.(type) {
			case *ast.Ident:
				param := (value.Type.(*ast.Ident)).Name
				paramKind = f.GetTypeFromName(param)
			case *ast.StarExpr:
				paramKind = f.doStartExpr(value.Type.(*ast.StarExpr)).Type()
			}
			newParam := ir.NewParam(paramName, paramKind)
			f.GetCurrent().Params = append(f.GetCurrent().Params, newParam)
			//
		}
	}
	paramTypes := make([]types.Type, len(f.GetCurrent().Params))
	for i, param := range f.GetCurrent().Params {
		paramTypes[i] = param.Type()
	}
	f.GetCurrent().Sig.Params = paramTypes
}

//&
func (f *FuncDecl) doUnaryExpr(unaryExpr *ast.UnaryExpr) value.Value {
	name := GetIdentName(unaryExpr.X.(*ast.Ident))
	variable := f.GetVariable(name)
	switch unaryExpr.Op {
	case token.AND:
		return variable
	default:
		fmt.Println("doUnaryExpr not impl")
	}
	return nil

}

//*
func (f *FuncDecl) doStartExpr(x *ast.StarExpr) value.Value {
	if x.X.(*ast.Ident).Obj == nil { //func param
		return ir.NewParam("", types.NewPointer(f.GetTypeFromName(GetIdentName(x.X.(*ast.Ident)))))
	} else {
		name := GetIdentName(x.X.(*ast.Ident))
		if p := f.GetVariable(name); p != nil {
			return f.GetCurrentBlock().NewLoad(p)
		} else {
			fmt.Println("not find in doStartExpr")
		}
	}
	fmt.Println("not impl doStartExpr")
	return nil
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

	if f.GetCurrent() != nil && f.GetCurrent().Sig.RetType == nil {
		f.GetCurrent().Sig.RetType = types.Void
	}
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
	//copy func param
	if len(f.GetCurrent().Blocks) == 1 {
		f.initFuncParam()
	}
	defer f.popBlock()
	for _, value := range block.List {
		switch value.(type) {
		case *ast.ExprStmt:
			exprStmt := value.(*ast.ExprStmt)
			switch exprStmt.X.(type) {
			case *ast.CallExpr:
				callExpr := exprStmt.X.(*ast.CallExpr)
				f.doCallExpr(callExpr)
			case *ast.IndexExpr:
				callExpr := exprStmt.X.(*ast.IndexExpr)
				f.doIndexExpr(callExpr)
			default:
				fmt.Println("aaaaaaaaaaa")
			}
		case *ast.IfStmt: //if
			f.doIfStmt(value.(*ast.IfStmt))
		case *ast.ReturnStmt:
			returnStmt := value.(*ast.ReturnStmt)
			//ast.Print(f.fset, returnStmt)
			//TODO return 1 value
			for _, value := range returnStmt.Results {
				switch value.(type) {
				case *ast.BasicLit:
					basicLit := value.(*ast.BasicLit)
					f.GetCurrent().Sig.RetType = f.GetTypes(basicLit.Kind)
					newBlock.NewRet(f.BasicLitToConstant(value.(*ast.BasicLit)))
				case *ast.BinaryExpr:
					binary := f.doBinary(value.(*ast.BinaryExpr))
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
			f.doForStmt(value.(*ast.ForStmt))
		case *ast.IncDecStmt:
			f.doIncDecStmt(value.(*ast.IncDecStmt))
		case *ast.AssignStmt:
			assignStmt := value.(*ast.AssignStmt)
			f.doAssignStmt(assignStmt)
		case *ast.DeclStmt:
			f.doDeclStmt(value.(*ast.DeclStmt))
		case *ast.RangeStmt:
			f.doRangeStmt(value.(*ast.RangeStmt))
		default:
			fmt.Println("doBlockStmt not impl")
		}
	}
	return f.GetCurrentBlock()
}

func (f *FuncDecl) initFuncParam() {
	for _, value := range f.GetCurrent().Params {
		newAlloca := f.GetCurrentBlock().NewAlloca(value.Typ)
		f.GetCurrentBlock().NewStore(value, newAlloca)
		f.PutVariable(value.Name(), newAlloca)
	}
}

func (f *FuncDecl) doIncDecStmt(decl *ast.IncDecStmt) value.Value {
	var x value.Value
	switch decl.X.(type) {
	case *ast.Ident:
		ident := decl.X.(*ast.Ident)
		x = f.GetVariable(GetIdentName(ident))
	default:
		fmt.Println("doIncDecStmt not impl")
	}
	x = f.checkType(x)
	switch decl.Tok {
	case token.INC: //++
		return f.GetCurrentBlock().NewAdd(x, constant.NewInt(types.I32, 1))
	case token.DEC: //--
		return f.GetCurrentBlock().NewSub(x, constant.NewInt(types.I32, 1))
	default:
		fmt.Println("decl.Tok not impl")
	}
	return nil
}

func (f *FuncDecl) doDeclStmt(decl *ast.DeclStmt) {
	switch decl.Decl.(type) {
	case *ast.GenDecl:
		f.DoGenDecl(decl.Decl.(*ast.GenDecl))
	}
}

func (f *FuncDecl) GetVariable(name string) value.Value {
	//find with param
	//for _, value := range f.GetCurrent().Params {
	//	if value.Name() == name {
	//		return value
	//	}
	//}

	//find which glob
	for _, value := range f.m.Globals {
		if value.Name() == name {
			return value
		}
	}

	//find with block
	for _, block := range f.blockHeap[f.GetCurrent()] {
		values, ok := f.Variables[block]
		if !ok {
			fmt.Println("not find Variable", name)
			continue
		}
		i, ok := values[name]
		if ok {
			return i
		}
	}
	return nil
}

func (f *FuncDecl) PutVariable(name string, value2 value.Value) {
	if IsKeyWord(name) {
		logrus.Errorf("%d is keyword", name)
		return
	}
	_, ok := f.Variables[f.GetCurrentBlock()]
	if !ok {
		f.Variables[f.GetCurrentBlock()] = make(map[string]value.Value)
	}
	f.Variables[f.GetCurrentBlock()][name] = value2
}

//func (f *FuncDecl) GetFunc(name string) *ir.Func {
//	for _, value := range f.FuncDecls {
//		if value.Name() == name {
//			return value
//		}
//	}
//	fmt.Println("not find func", name)
//	return nil
//}

//only for array and struts
func (f *FuncDecl) doCompositeLit(lit *ast.CompositeLit) value.Value {
	switch lit.Type.(type) {
	case *ast.ArrayType: //array
		var c []constant.Constant
		for _, value := range lit.Elts {
			toConstant := f.BasicLitToConstant(value.(*ast.BasicLit))
			c = append(c, toConstant)
		}
		name := f.GetCurrent().Name()
		array := constant.NewArray(c...)
		def := f.m.NewGlobalDef(name+"."+strconv.Itoa(len(f.m.Globals)), array)
		def.Immutable = true
		return def
	case *ast.Ident: //struct
		name := GetIdentName(lit.Type.(*ast.Ident))
		i, ok := f.GlobDef[name]
		if lit.Elts == nil {
			if !ok {
				f.typeSpec(lit.Type.(*ast.Ident).Obj.Decl.(*ast.TypeSpec))
			}
			return f.GetCurrentBlock().NewAlloca(i)
		} else {
			var s []constant.Constant
			for key, value := range f.StructDefs[name] {
				find := false
				for _, value := range lit.Elts { //
					keyValueExpr := value.(*ast.KeyValueExpr)
					if key == GetIdentName(keyValueExpr.Key.(*ast.Ident)) {
						s = append(s, f.BasicLitToConstant(keyValueExpr.Value.(*ast.BasicLit)))
						find = true
						break
					}
				}
				if !find {
					s = append(s, InitZeroConstant(value.Typ))
				}
			}
			def := f.m.NewGlobalDef(name+"."+strconv.Itoa(len(f.m.Globals)), constant.NewStruct(s...))
			def.ContentType = i
			def.Typ = types.NewPointer(i)
			def.Immutable = true
			return def
		}
	default:
		fmt.Println("not impl doCompositeLit")
	}
	return nil
}

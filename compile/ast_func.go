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
	"toir/llvm"
	"toir/runtime/core"
	"toir/stdlib"

	"strconv"
)

type StructDef struct {
	Name  string
	Order int
	Typ   types.Type
	Fun   *ir.Func
}

type KVVariable struct {
	Key string
	V   value.Value
}

type FuncDecl struct {
	mPackage  string
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
	StructDefs map[string]map[string]StructDef //Strut.Field
	//constant---
	Constants []constant.Constant //for constant
	//for
	forBreak    *ir.Block
	forContinue *ir.Block
	//runtime
	r *core.Runtime
}

func DoFunc(m *ir.Module, fset *token.FileSet, pkg string, r *core.Runtime) *FuncDecl {
	return &FuncDecl{
		m:          m,
		fset:       fset,
		FuncHeap:   new([]*ir.Func),
		Variables:  make(map[*ir.Block]map[string]value.Value),
		blockHeap:  make(map[*ir.Func][]*ir.Block),
		FuncDecls:  make(map[*ast.FuncDecl]*ir.Func),
		GlobDef:    make(map[string]types.Type),
		StructDefs: make(map[string]map[string]StructDef),
		mPackage:   pkg,
		r:          r,
	}
}

//types.NewFunc()
func (f *FuncDecl) doFunType(funcTyp *ast.FuncType) ([]*ir.Param, *types.FuncType) {
	fields := funcTyp.Params.List
	//param
	var params []*ir.Param
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
			case *ast.ArrayType:
				paramKind = types.NewPointer(f.GetSliceType()) //slice type
			case *ast.SelectorExpr:
				paramKind = f.doSelector(nil, value.Type.(*ast.SelectorExpr), "type").Type()
			default:
				logrus.Error("func type not impl")
			}
			newParam := ir.NewParam(paramName, paramKind)
			params = append(params, newParam)
			//
		}
	}

	paramTypes := make([]types.Type, len(params))
	for i, param := range params {
		paramTypes[i] = param.Type()
	}

	//return
	if funcTyp.Results == nil {
		return params, types.NewFunc(types.Void, paramTypes...)
	}
	List := funcTyp.Results.List
	mul := false
	if len(List) > 1 {
		mul = true
	}

	var ty []types.Type
	for _, value := range List {
		switch value.Type.(type) {
		case *ast.Ident:
			identName := GetIdentName(value.Type.(*ast.Ident))
			ty = append(ty, f.GetTypeFromName(identName))
		case *ast.SelectorExpr:
			selector := f.doSelector(nil, value.Type.(*ast.SelectorExpr), "type")
			ty = append(ty, selector.Type())
		default:
			logrus.Error("not known type")
		}
	}
	if mul {
		newTypeDef := f.m.NewTypeDef(f.GetCurrent().Name()+".return", types.NewStruct(ty...))
		return params, types.NewFunc(newTypeDef, paramTypes...)
	} else {
		return params, types.NewFunc(ty[0], paramTypes...)
	}
}

//&
func (f *FuncDecl) doUnaryExpr(unaryExpr *ast.UnaryExpr) value.Value {
	var variable value.Value
	switch unaryExpr.X.(type) {
	case *ast.Ident:
		name := GetIdentName(unaryExpr.X.(*ast.Ident))
		variable = f.GetVariable(name)
	case *ast.CompositeLit: //
		variable = f.doCompositeLit(unaryExpr.X.(*ast.CompositeLit))
	}
	switch unaryExpr.Op {
	case token.AND:
		if _, ok := variable.(*ir.InstAlloca); ok {
			return variable
		} else {
			return f.ToPtr(variable)
		}
	default:
		fmt.Println("doUnaryExpr not impl")
	}
	return nil

}

//*
func (f *FuncDecl) doStartExpr(x *ast.StarExpr) value.Value {
	var v value.Value
	switch x.X.(type) {
	case *ast.Ident:
		v = f.doIdent(x.X.(*ast.Ident))
	case *ast.StarExpr:
		v = f.doStartExpr(x.X.(*ast.StarExpr))
	default:
		name := GetIdentName(x.X.(*ast.Ident))
		if p := f.GetVariable(name); p != nil {
			v = p
		} else {
			fmt.Println("not find in doStartExpr")
		}
	}
	if f.GetCurrentBlock() != nil {
		return f.GetCurrentBlock().NewLoad(v)
	} else {
		param := v.(*ir.Param)
		return ir.NewParam(param.Name(), types.NewPointer(param.Type()))
	}
}

func (f *FuncDecl) GetCurrent() *ir.Func {
	if len(*f.FuncHeap) == 0 {
		return nil
	}
	return (*f.FuncHeap)[len(*f.FuncHeap)-1]
}

func (f *FuncDecl) CreatFunc(name string, params []*ir.Param, sig *types.FuncType) *ir.Func {
	p := &ir.Func{Sig: sig, Params: params}
	p.SetName(name)
	p.Type()
	return p
}

func (f *FuncDecl) DoFunDecl(pkg string, funDecl *ast.FuncDecl) *ir.Func {
	i, ok := f.FuncDecls[funDecl]
	if ok {
		return i
	}
	////////////////////////////method begin//////////////////////////////
	//func name
	var StructTyp string
	funName := funDecl.Name.Name
	//deal struct
	if funDecl.Recv != nil {
		switch funDecl.Recv.List[0].Type.(type) {
		case *ast.Ident:
			StructTyp = GetIdentName(funDecl.Recv.List[0].Type.(*ast.Ident))
		case *ast.StarExpr:
			starExpr := funDecl.Recv.List[0].Type.(*ast.StarExpr)
			StructTyp = GetIdentName(starExpr.X.(*ast.Ident))
		}
		funName = f.mPackage + "." + StructTyp + "." + funDecl.Name.Name
	}

	//func type
	params, funTyp := f.doFunType(funDecl.Type)
	tempFunc := f.CreatFunc(funName, params, funTyp)
	Push(f.FuncHeap, tempFunc)

	//deal struct
	if funDecl.Recv != nil {
		varName := GetIdentName(funDecl.Recv.List[0].Names[0])
		tempFunc.Params = append(tempFunc.Params, ir.NewParam(varName, types.NewPointer(f.GlobDef[StructTyp])))
		f.StructDefs[StructTyp][funDecl.Name.Name] = StructDef{Name: funDecl.Name.Name, Fun: tempFunc}
	}

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
	f.m.Funcs = append(f.m.Funcs, f.GetCurrent())
	for index, value := range f.GetCurrent().Blocks {
		if value.Term == nil {
			logrus.Errorf("index %d %s block ret is nil", index, value.Name())
			f.GetCurrent().Blocks[index].NewRet(nil)
		}
	}
	return Pop(f.FuncHeap)
}

//must return start
func (f *FuncDecl) doBlockStmt(block *ast.BlockStmt) (start *ir.Block, end *ir.Block) {
	//ast.Print(f.fset, block)
	newBlock := f.newBlock()
	startBlock := newBlock
	endBlock := newBlock
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
			startBlock, endBlock = f.doIfStmt(value.(*ast.IfStmt))
		case *ast.ReturnStmt:
			returnStmt := value.(*ast.ReturnStmt)
			f.doReturnStmt(returnStmt)
		case *ast.ForStmt:
			startBlock, endBlock = f.doForStmt(value.(*ast.ForStmt))
		case *ast.IncDecStmt:
			f.doIncDecStmt(value.(*ast.IncDecStmt))
		case *ast.AssignStmt:
			assignStmt := value.(*ast.AssignStmt)
			f.doAssignStmt(assignStmt)
		case *ast.DeclStmt:
			f.doDeclStmt(value.(*ast.DeclStmt))
		case *ast.RangeStmt:
			f.doRangeStmt(value.(*ast.RangeStmt))
		case *ast.BranchStmt:
			f.doBranchStmt(value.(*ast.BranchStmt))
		default:
			fmt.Println("doBlockStmt not impl")
		}
	}
	return startBlock, endBlock
}

func (f *FuncDecl) initFuncParam() {
	for _, value := range f.GetCurrent().Params {
		newAlloca := f.NewType(value.Typ)
		f.GetCurrentBlock().NewStore(value, newAlloca)
		if f.IsSlice(newAlloca) { //slice *
			f.PutVariable(value.Name(), f.GetCurrentBlock().NewLoad(newAlloca))
		} else if types.IsFunc(GetBaseType(newAlloca.Type())) {
			f.PutVariable(value.Name(), f.GetCurrentBlock().NewLoad(newAlloca))
		} else {
			f.PutVariable(value.Name(), newAlloca)
		}
		logrus.Debugf("put Variable %s", value.Name())

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
			logrus.Debugf("not find Variable %s", name)
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
			var s = make([]constant.Constant, getFieldNum(f.StructDefs[name]))
			for key, v := range f.StructDefs[name] {
				if v.Fun == nil {
					find := false
					for _, value := range lit.Elts { //
						keyValueExpr := value.(*ast.KeyValueExpr)
						if key == GetIdentName(keyValueExpr.Key.(*ast.Ident)) {
							s[v.Order] = f.BasicLitToConstant(keyValueExpr.Value.(*ast.BasicLit))
							find = true
							break
						}
					}
					if !find {
						s[v.Order] = InitZeroConstant(v.Typ)
					}
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

func (f *FuncDecl) doBranchStmt(stmt *ast.BranchStmt) {
	switch stmt.Tok {
	case token.BREAK:
		f.forBreak = f.GetCurrentBlock()
	case token.CONTINUE:
		f.forContinue = f.GetCurrentBlock()
	}

}

func (f *FuncDecl) doSliceExpr(expr *ast.SliceExpr) value.Value {
	variable := f.GetVariable(GetIdentName(expr.X.(*ast.Ident)))
	low := f.BasicLitToConstant(expr.Low.(*ast.BasicLit))
	higt := f.BasicLitToConstant(expr.High.(*ast.BasicLit))
	if f.IsSlice(variable) {
		array := variable.(*SliceArray)
		slice := f.NewAllocSlice(types.NewArray(0, array.emt))
		sub := f.GetCurrentBlock().NewSub(higt, low)
		mul := f.GetCurrentBlock().NewMul(sub, f.GetBytes(variable))
		call := f.StdCall(stdlib.Malloc, mul)
		f.SetLen(slice, sub)
		f.SetCap(slice, sub)
		f.StdCall(llvm.Mencpy,
			call,
			f.GetCurrentBlock().NewBitCast(f.GetSliceIndex(variable, low), types.I8Ptr),
			mul,
			constant.NewBool(false))
		f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewBitCast(call, types.NewPointer(types.I8Ptr)), f.GetPSlice(slice))
		return slice
	}
	logrus.Error("doSliceExpr not sliceArray")
	return nil
}

func (f *FuncDecl) doArrayType(arrayType *ast.ArrayType) value.Value {
	identName := GetIdentName(arrayType.Elt.(*ast.Ident))
	typ := f.GetTypeFromName(identName)
	return ir.NewParam("", types.NewArray(0, typ))
}

func (f *FuncDecl) doFuncLit(fun *ast.FuncLit) value.Value {
	params, funTyp := f.doFunType(fun.Type)
	tempFunc := f.CreatFunc("", params, funTyp)
	Push(f.FuncHeap, tempFunc)
	f.doBlockStmt(fun.Body)
	f.pop()
	return tempFunc
}

func (f *FuncDecl) doIdent(ident *ast.Ident) value.Value {
	if ident.Obj != nil {
		switch ident.Obj.Kind {
		case ast.Var:
			//constant,Glob,alloa,param
			variable := f.GetVariable(ident.Name)
			if variable != nil {
				if f.IsSlice(variable) {
					return variable
				} else {
					if types.IsPointer(variable.Type()) {
						return f.GetCurrentBlock().NewLoad(variable) //f.GetCurrentBlock().NewLoad(
					} else {
						return variable //f.GetCurrentBlock().NewLoad(
					}
				}
			} else {
				logrus.Error("not find in variable")
			}
		case ast.Typ:
			typ, ok := f.GlobDef[ident.Name]
			if ok {
				return ir.NewParam("type", typ)
			} else {
				logrus.Error("GlobDef not find")
			}
		default:
			logrus.Error("not find ast.xx")
		}
	} else {
		identName := GetIdentName(ident)
		if IsKeyWord(identName) {
			return ir.NewParam("", f.GetTypeFromName(identName))
		} else {
			return ir.NewParam(identName, f.GetTypeFromName(identName))
		}
	}
	return nil
}

func getFieldNum(m map[string]StructDef) int {
	a := 0
	for _, value := range m {
		if value.Fun == nil {
			a++
		}
	}
	return a
}

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
	"toir/runtime/core"
	"toir/utils"
)

type StructDef struct {
	Name      string
	Order     int
	Typ       types.Type
	Fun       *ir.Func
	IsInherit bool
}

type FuncDecl struct {
	mPackage  string
	m         *ir.Module
	fSet      *token.FileSet
	Funs      map[string]*ir.Func
	FuncHeap  *[]*ir.Func
	FuncDecls map[*ast.FuncDecl]*ir.Func
	blockHeap map[*ir.Func][]*ir.Block
	//variables
	Variables     map[*ir.Block]map[string]value.Value
	tempVariables []map[string]value.Value
	tempV         int
	//struct---
	GlobDef    map[string]types.Type           //for type
	StructDefs map[string]map[string]StructDef //Strut.Field
	//constant---
	Constants []constant.Constant //for constant
	//for
	forBreak    *ir.Block
	forContinue *ir.Block
	forVarBlock *ir.Block
	//runtime
	r *core.Runtime
	//slice cast map
	sliceCastPool map[*ir.InstAlloca]value.Value
	//types
	typeSpecs map[*ast.TypeSpec]types.Type
	//malloc
	openAlloc bool
	//*ast.CompositeLit
	compositeLits map[*ast.CompositeLit]*Composete
}

func DoFunc(m *ir.Module, fset *token.FileSet, pkg string, r *core.Runtime) *FuncDecl {
	decl := &FuncDecl{
		m:             m,
		fSet:          fset,
		FuncHeap:      new([]*ir.Func),
		Variables:     make(map[*ir.Block]map[string]value.Value),
		tempVariables: make([]map[string]value.Value, 10),
		tempV:         0,
		blockHeap:     make(map[*ir.Func][]*ir.Block),
		FuncDecls:     make(map[*ast.FuncDecl]*ir.Func),
		GlobDef:       make(map[string]types.Type),
		StructDefs:    make(map[string]map[string]StructDef),
		mPackage:      pkg,
		r:             r,
		typeSpecs:     make(map[*ast.TypeSpec]types.Type),
		openAlloc:     false,
		compositeLits: make(map[*ast.CompositeLit]*Composete),
	}
	decl.Init()
	return decl
}

func (f *FuncDecl) Init() {
	f.tempVariables[0] = make(map[string]value.Value)
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
				paramKind = f.doStartExpr(value.Type.(*ast.StarExpr), "type").Type()
			case *ast.ArrayType:
				arrayType := value.Type.(*ast.ArrayType)
				paramKind = f.doArrayType(arrayType)
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
		case *ast.StarExpr:
			ty = append(ty, f.doStartExpr(value.Type.(*ast.StarExpr), "type").Type())
		case *ast.ArrayType:
			ty = append(ty, f.doArrayType(value.Type.(*ast.ArrayType)))
		default:
			logrus.Error("not known type")
		}
	}
	if len(ty) == 0 {
		ty = append(ty, types.Void)
	}
	if mul {
		newTypeDef := f.m.NewTypeDef("return."+f.GetReturnName(), types.NewStruct(ty...))
		return params, types.NewFunc(newTypeDef, paramTypes...)
	} else {
		return params, types.NewFunc(ty[0], paramTypes...)
	}
}
func (f *FuncDecl) GetReturnName() string {
	i := len(f.m.Funcs)
	if i == 0 {
		return "0.0"
	} else {
		return strconv.Itoa(i) + "." + strconv.Itoa(len(f.m.Funcs[i-1].Blocks))
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
	case *ast.SelectorExpr:
		variable = f.doSelector(nil, unaryExpr.X.(*ast.SelectorExpr), "call")
	default:
		logrus.Error("not impl")
	}
	switch unaryExpr.Op {
	case token.AND:
		if a, ok := variable.(*ir.InstAlloca); ok {
			return a
		}
		if l, ok := variable.(*ir.InstLoad); ok {
			return l.Src
		}
		logrus.Error("doUnaryExpr not find the type")
		return variable
	case token.RANGE:
		return f.doIdent(unaryExpr.X.(*ast.Ident))
	default:
		fmt.Println("doUnaryExpr not impl")
	}
	return nil

}

//*
func (f *FuncDecl) doStartExpr(x *ast.StarExpr, typ string) value.Value {
	switch typ {
	case "type":
		switch x.X.(type) {
		case *ast.Ident:
			ident := f.doIdent(x.X.(*ast.Ident))
			return ir.NewParam("", types.NewPointer(ident.Type()))
		default:
			logrus.Error("type not impl")
		}
	case "value":
		var v value.Value
		switch x.X.(type) {
		case *ast.Ident:
			v = f.GetCurrentBlock().NewLoad(FixAlloc(f.GetCurrentBlock(), f.doIdent(x.X.(*ast.Ident))))
		case *ast.StarExpr:
			v = f.GetCurrentBlock().NewLoad(f.doStartExpr(x.X.(*ast.StarExpr), "value"))
		default:
			name := GetIdentName(x.X.(*ast.Ident))
			if p := f.GetVariable(name); p != nil {
				v = FixAlloc(f.GetCurrentBlock(), p)
			} else {
				fmt.Println("not find in doStartExpr")
			}
		}
		if p, ok := v.(*ir.Param); ok {
			return ir.NewParam(p.Name(), types.NewPointer(p.Type()))
		}
		return v
	}
	return nil
}

func (f *FuncDecl) useMalloc() {
	f.openAlloc = true
	logrus.Debug("use malloc !!!")
}

func (f *FuncDecl) closeMalloc() {
	f.openAlloc = false
	logrus.Debug("close malloc !!!")
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
	f.pushFunc(tempFunc)

	//deal struct func
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
	pop := f.popFunc()
	f.FuncDecls[funDecl] = pop

	return pop

}

func (f *FuncDecl) popFunc() *ir.Func {
	f.m.Funcs = append(f.m.Funcs, f.GetCurrent())
	for index, value := range f.GetCurrent().Blocks {
		if value.Term == nil {
			logrus.Errorf("index %d %s block ret is nil", index, value.Name())
			f.GetCurrent().Blocks[index].NewRet(nil)
		}
	}
	return PopFunc(f.FuncHeap)
}

func (f *FuncDecl) pushFunc(fun *ir.Func) {
	PushFunc(f.FuncHeap, fun)
}

//must return start
func (f *FuncDecl) doBlockStmt(block *ast.BlockStmt) (start *ir.Block, end *ir.Block) {
	//ast.Print(f.fSet, block)
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
			f.doExprStmt(exprStmt)
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
			startBlock, endBlock = f.doRangeStmt(value.(*ast.RangeStmt))
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
		//pointer not copy args
		if types.IsPointer(value.Type()) {
			f.PutVariable(value.Name(), value)
			continue
		}
		//TODO WARN
		newAlloca := f.NewType(value.Typ)
		f.GetCurrentBlock().NewStore(value, newAlloca)
		if f.IsSlice(newAlloca) { //slice *
			f.PutVariable(value.Name(), newAlloca)
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
	x = FixAlloc(f.GetCurrentBlock(), x)
	if types.IsPointer(x.Type()) {
		x = f.GetCurrentBlock().NewLoad(x)
	}
	switch decl.Tok {
	case token.INC: //++
		add := f.GetCurrentBlock().NewAdd(x, constant.NewInt(types.I32, 1))
		f.GetCurrentBlock().NewStore(add, f.GetSrcPtr(x))
		return add
	case token.DEC: //--
		sub := f.GetCurrentBlock().NewSub(x, constant.NewInt(types.I32, 1))
		f.GetCurrentBlock().NewStore(sub, f.GetSrcPtr(x))
		return sub
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

//only for array and struts return value
func (f *FuncDecl) doCompositeLit(lit *ast.CompositeLit) value.Value {
	switch lit.Type.(type) {
	case *ast.ArrayType: //array
		var c []constant.Constant
		for _, value := range lit.Elts {
			switch value.(type) {
			case *ast.Ident:
				c = append(c, f.doIdent(value.(*ast.Ident)).(constant.Constant))
			case *ast.BasicLit:
				toConstant := f.BasicLitToConstant(value.(*ast.BasicLit))
				c = append(c, toConstant)
			}

		}
		name := f.GetCurrent().Name()
		array := constant.NewArray(c...)
		def := f.m.NewGlobalDef(name+"."+strconv.Itoa(len(f.m.Globals)), array)
		def.Immutable = true
		return f.InitConstantValue(array.Type(), def)
	case *ast.Ident: //struct
		name := GetIdentName(lit.Type.(*ast.Ident))
		structType, ok := f.GlobDef[name]
		//check types
		base := true
		structDefs := f.StructDefs[name]

		for _, value := range lit.Elts {
			switch value.(type) {
			case *ast.KeyValueExpr:
				keyValueExpr := value.(*ast.KeyValueExpr)
				if _, ok := keyValueExpr.Value.(*ast.BasicLit); !ok {
					base = false
					break
				}
			case *ast.Ident:
				base = false
				break
			case *ast.BasicLit:
			default:
				logrus.Warn(value)
			}
		}

		if lit.Elts == nil {
			if !ok {
				f.typeSpec(lit.Type.(*ast.Ident).Obj.Decl.(*ast.TypeSpec))
			}
			return FixAlloc(f.GetCurrentBlock(), f.GetCurrentBlock().NewAlloca(structType))
		}
		getStructFiledType := func(structDefs map[string]StructDef, order int) types.Type {
			for _, value := range structDefs {
				if value.Order == order {
					return value.Typ
				}
			}
			return nil
		}
		if base {
			var s = make([]constant.Constant, getFieldNum(f.StructDefs[name]))
			for index, value := range lit.Elts { //
				switch value.(type) {
				case *ast.KeyValueExpr:
					keyValueExpr := value.(*ast.KeyValueExpr)
					identName := GetIdentName(keyValueExpr.Key.(*ast.Ident))
					def := structDefs[identName]
					switch keyValueExpr.Value.(type) {
					case *ast.BasicLit:
						s[def.Order] = f.BasicLitToConstant(keyValueExpr.Value.(*ast.BasicLit))
					default:
						logrus.Error("bbbbbb")
					}
				case *ast.BasicLit:
					s[index] = f.BasicLitToConstant(value.(*ast.BasicLit))
				default:
					logrus.Error("aaaaaa")
				}
			}
			//init
			for i := 0; i < len(s); i++ {
				if s[i] == nil {
					s[i] = InitZeroConstant(getStructFiledType(structDefs, i))
				}
			}
			newStruct := constant.NewStruct(s...)
			def := f.m.NewGlobalDef(name+"."+strconv.Itoa(len(f.m.Globals)), newStruct)
			def.ContentType = structType
			def.Typ = types.NewPointer(structType)
			def.Immutable = true
			return f.InitConstantValue(structType, def)
		} else {
			return f.GetCurrentBlock().NewLoad(f.StructInit(lit, structType))
		}
	default:
		fmt.Println("not impl doCompositeLit")
	}
	return nil
}

type Composete struct {
	pre      *Composete
	params   []*ast.Ident
	next     *Composete
	param    *ir.Param
	paramsKV map[string]int
}

func (f *FuncDecl) GetStructInitGlob(lit *ast.CompositeLit) *Composete {
	if l, ok := f.compositeLits[lit]; ok {
		return l
	}
	composete := &Composete{}
	var ids []*ast.Ident
	for _, value := range lit.Elts {
		switch value.(type) {
		case *ast.KeyValueExpr:
			keyValueExpr := value.(*ast.KeyValueExpr)
			if t, ok := keyValueExpr.Value.(*ast.Ident); ok {
				if t.Name != "nil" {
					ids = append(ids, t)
				}
			}
			if s, ok := keyValueExpr.Value.(*ast.CompositeLit); ok {
				glob := f.GetStructInitGlob(s)
				composete.params = glob.params
				glob.pre = composete
				composete.next = glob
				ids = append(ids, glob.params...)
			}
			if s, ok := keyValueExpr.Value.(*ast.UnaryExpr); ok {
				switch s.X.(type) {
				case *ast.CompositeLit:
					glob := f.GetStructInitGlob(s.X.(*ast.CompositeLit))
					composete.params = glob.params
					glob.pre = composete
					composete.next = glob
					ids = append(ids, glob.params...)
				case *ast.Ident:
					ident := s.X.(*ast.Ident)
					if ident.Name != "nil" {
						ids = append(ids, ident)
					}
				}

			}
		case *ast.Ident:
			ident := value.(*ast.Ident)
			if ident.Name != "nil" {
				ids = append(ids, ident)
			}
		case *ast.CompositeLit:
			glob := f.GetStructInitGlob(value.(*ast.CompositeLit))
			composete.params = glob.params
			glob.pre = composete
			composete.next = glob
			ids = append(ids, glob.params...)
		default:
			logrus.Warn(value)
		}
	}
	composete.params = ids
	f.compositeLits[lit] = composete
	return composete
}

func (f *FuncDecl) StructInit(lit *ast.CompositeLit, structType types.Type) value.Value {

	//init param
	utils.NewComment(f.GetCurrentBlock(), "init param")
	s := &types.StructType{}
	glob := f.GetStructInitGlob(lit)
	var vs []value.Value
	var paramsKV map[string]int
	var newFunc *ir.Func
	var initParam *ir.Param
	var v []value.Value
	fName := "init." + structType.Name() + "." + utils.GetRandNum(4)
	param := ir.NewParam("", types.NewPointer(structType))
	if glob != nil && len(glob.params) != 0 {
		var paKV = make(map[string]int)
		for index, value := range glob.params {
			if glob.pre == nil {
				variable := FixAlloc(f.GetCurrentBlock(), f.doIdent(value))
				s.Fields = append(s.Fields, variable.Type())
				paKV[value.Name] = index
				vs = append(vs, variable)
			}
		}
		if glob.pre == nil && len(s.Fields) != 0 {
			typeDef := f.m.NewTypeDef("struct."+strconv.Itoa(len(f.m.TypeDefs)), s)
			initParam = ir.NewParam("", types.NewPointer(typeDef))
			glob.param = initParam
			glob.paramsKV = paKV
			paramsKV = paKV
			ef := f.NewType(typeDef)
			for index, value := range vs {
				indexStruct := utils.IndexStruct(f.GetCurrentBlock(), ef, index)
				f.GetCurrentBlock().NewStore(value, indexStruct)
			}
			v = append(v, ef)
		} else {
			initParam = glob.pre.param
			glob.param = initParam
			v = append(v, initParam)
			paramsKV = glob.pre.paramsKV
			glob.paramsKV = paramsKV
		}
		newFunc = ir.NewFunc(fName, types.Void, initParam, param)
	} else {
		newFunc = ir.NewFunc(fName, types.Void, param)
	}
	utils.NewComment(f.GetCurrentBlock(), "end param")
	f.useMalloc()
	f.pushFunc(newFunc)
	f.newBlock()
	//inject ver
	for key, value := range paramsKV {
		indexStruct := utils.IndexStruct(f.GetCurrentBlock(), initParam, value)
		f.PutVariable(key, &Scope{f.GetCurrentBlock().NewLoad(indexStruct), 1})
	}

	structDefs := f.StructDefs[structType.Name()]
	for index, val := range lit.Elts { //
		switch val.(type) {
		case *ast.KeyValueExpr:
			keyValueExpr := val.(*ast.KeyValueExpr)
			identName := GetIdentName(keyValueExpr.Key.(*ast.Ident))
			structDef, _ := structDefs[identName]
			var indexStruct value.Value = utils.IndexStruct(f.GetCurrentBlock(), param, structDef.Order)
			switch keyValueExpr.Value.(type) {
			case *ast.BasicLit:
				f.GetCurrentBlock().NewStore(f.BasicLitToConstant(keyValueExpr.Value.(*ast.BasicLit)), indexStruct)
			case *ast.UnaryExpr:
				expr := f.doUnaryExpr(keyValueExpr.Value.(*ast.UnaryExpr))
				f.GetCurrentBlock().NewStore(expr, indexStruct)
			case *ast.CompositeLit:
				compositeLit := f.doCompositeLit(keyValueExpr.Value.(*ast.CompositeLit))
				f.GetCurrentBlock().NewStore(compositeLit, indexStruct)
			case *ast.Ident:
				name := GetIdentName(keyValueExpr.Value.(*ast.Ident))
				//variable := f.GetVariable(name)
				//f.GetCurrentBlock().NewStore(variable, indexStruct)
				if name == "nil" {
					null := constant.NewNull(types.NewPointer(GetBaseType(indexStruct.Type())))
					f.GetCurrentBlock().NewStore(null, indexStruct)
				} else {
					variable := f.GetVariable(name)
					f.GetCurrentBlock().NewStore(variable, indexStruct)
				}
			default:
				logrus.Error("bbbbbb StructInit")
			}
		case *ast.BasicLit:
			var indexStruct value.Value = utils.IndexStruct(f.GetCurrentBlock(), param, index)
			f.GetCurrentBlock().NewStore(f.BasicLitToConstant(val.(*ast.BasicLit)), indexStruct)
		case *ast.Ident:
			var indexStruct value.Value = utils.IndexStruct(f.GetCurrentBlock(), param, index)
			name := GetIdentName(val.(*ast.Ident))
			if name == "nil" {
				null := constant.NewNull(types.NewPointer(GetBaseType(indexStruct.Type())))
				f.GetCurrentBlock().NewStore(null, indexStruct)
			} else {
				variable := f.GetVariable(name)
				f.GetCurrentBlock().NewStore(variable, indexStruct)
			}

		default:
			logrus.Error("aaaaaa StructInit")
		}
	}

	f.ClearVariable(1)
	defer f.closeMalloc()
	f.popBlock()
	f.popFunc()
	//

	newType := f.NewType(structType)
	v = append(v, newType)
	f.GetCurrentBlock().NewCall(newFunc, v...)
	return newType
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
	if f.IsSlice(variable) { //
		//i8* rangeSlice(i8* ptr,int low ,int high,int bytes)
		decl := f.DoFunDecl("runtime", f.r.GetFunc("rangeSlice"))
		utils.NewComment(f.GetCurrentBlock(), "end slice[]")
		pSlice := f.GetPSlice(f.GetSrcPtr(variable))
		slice := f.GetCurrentBlock().NewLoad(pSlice)
		stdCall := f.StdCall(decl,
			f.GetCurrentBlock().NewBitCast(slice, types.I8Ptr),
			low,
			higt,
			f.GetBytes(f.GetSrcPtr(variable)),
		)
		newSlice := f.CopyNewSlice(variable)
		getSlice := f.GetPSlice(newSlice)
		sub := f.GetCurrentBlock().NewSub(higt, low)
		f.SetLen(newSlice, sub)
		f.SetCap(newSlice, sub)
		f.GetCurrentBlock().NewStore(f.GetCurrentBlock().NewBitCast(stdCall, types.NewPointer(GetBaseType(getSlice.Type()))), getSlice)
		utils.NewComment(f.GetCurrentBlock(), "end slice[]")
		return utils.LoadValue(f.GetCurrentBlock(), newSlice)
	}
	logrus.Error("doSliceExpr not sliceArray")
	return nil
}

func (f *FuncDecl) doArrayType(arrayType *ast.ArrayType) types.Type {
	var kind types.Type
	switch arrayType.Elt.(type) {
	case *ast.Ident:
		ki := f.GetTypeFromName(GetIdentName(arrayType.Elt.(*ast.Ident)))
		kind = f.GetSliceType(ki)
	case *ast.ArrayType:
		kind = f.GetSliceType(f.doArrayType(arrayType.Elt.(*ast.ArrayType)))
	default:
		logrus.Error("not find doArrayType")
	}
	return kind
}

//inline func
func (f *FuncDecl) doFuncLit(fun *ast.FuncLit) value.Value {
	params, funTyp := f.doFunType(fun.Type)
	tempFunc := f.CreatFunc("", params, funTyp)
	f.pushFunc(tempFunc)
	f.doBlockStmt(fun.Body)
	f.popFunc()
	return tempFunc
}

func (f *FuncDecl) doIdent(ident *ast.Ident) value.Value {
	if ident.Obj != nil {
		switch ident.Obj.Kind {
		case ast.Var:
			//constant,Glob,alloa,param
			variable := f.GetVariable(ident.Name)
			if variable != nil {
				return variable
			} else {
				logrus.Error("not find in variable")
			}
		case ast.Typ:
			typ, ok := f.GlobDef[ident.Name]
			if ok {
				return ir.NewParam("type", typ)
			} else {
				return ir.NewParam("type", f.typeSpec(ident.Obj.Decl.(*ast.TypeSpec)))
			}
		default:
			logrus.Error("not find ast.xx")
		}
	} else {
		identName := GetIdentName(ident)
		if identName == "nil" {
			return constant.NewNull(types.I8Ptr)
		}
		if IsKeyWord(identName) {
			return ir.NewParam("", f.GetTypeFromName(identName))
		} else {
			return ir.NewParam(identName, f.GetTypeFromName(identName))
		}
	}
	return nil
}

func (f *FuncDecl) doExprStmt(exprStmt *ast.ExprStmt) {
	switch exprStmt.X.(type) {
	case *ast.CallExpr:
		callExpr := exprStmt.X.(*ast.CallExpr)
		f.doCallExpr(callExpr)
	case *ast.IndexExpr:
		callExpr := exprStmt.X.(*ast.IndexExpr)
		f.doIndexExpr(callExpr)
	case *ast.CompositeLit:
		callExpr := exprStmt.X.(*ast.CompositeLit)
		f.doCompositeLit(callExpr)
	case *ast.SliceExpr:
		callExpr := exprStmt.X.(*ast.SliceExpr)
		f.doSliceExpr(callExpr)
	case *ast.UnaryExpr:
		callExpr := exprStmt.X.(*ast.UnaryExpr)
		f.doUnaryExpr(callExpr)
	case *ast.SelectorExpr:
		callExpr := exprStmt.X.(*ast.SelectorExpr)
		f.doSelectorExpr(callExpr)
	default:
		logrus.Error("doBlockStmt.ExprStmt not impl")
	}
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

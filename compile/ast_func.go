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
	mPackage      string
	m             *ir.Module
	fSet          *token.FileSet
	Funs          map[string]*ir.Func
	FuncHeap      *[]*ir.Func
	FuncDecls     map[*ast.FuncDecl]*ir.Func
	PreStrutsFunc map[string]map[string]*ast.FuncDecl
	blockHeap     map[*ir.Func][]*ir.Block
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
	r  *core.Runtime
	rf bool
	//slice cast map
	sliceCastPool map[*ir.InstAlloca]value.Value
	//types
	typeSpecs map[*ast.TypeSpec]types.Type
	//malloc
	openAlloc bool
	//*ast.CompositeLit
	compositeLits map[*ast.CompositeLit]*Composete
	//slice
	sliceInitsFunc map[string]*ir.Func
	sliceTypes     []types.Type
	//swith v
	swiV *ast.Expr
}

func DoFunc(m *ir.Module, fset *token.FileSet, pkg string, r *core.Runtime) *FuncDecl {
	decl := &FuncDecl{
		m:              m,
		fSet:           fset,
		FuncHeap:       new([]*ir.Func),
		Variables:      make(map[*ir.Block]map[string]value.Value),
		tempVariables:  make([]map[string]value.Value, 10),
		tempV:          0,
		blockHeap:      make(map[*ir.Func][]*ir.Block),
		FuncDecls:      make(map[*ast.FuncDecl]*ir.Func),
		GlobDef:        make(map[string]types.Type),
		StructDefs:     make(map[string]map[string]StructDef),
		mPackage:       pkg,
		r:              r,
		typeSpecs:      make(map[*ast.TypeSpec]types.Type),
		openAlloc:      false,
		compositeLits:  make(map[*ast.CompositeLit]*Composete),
		PreStrutsFunc:  make(map[string]map[string]*ast.FuncDecl),
		sliceInitsFunc: make(map[string]*ir.Func),
	}
	decl.Init()
	return decl
}

func (f *FuncDecl) Init() {
	f.tempVariables[0] = make(map[string]value.Value)

}

//types.NewFunc()
func (f *FuncDecl) FunType(funcTyp *ast.FuncType) ([]*ir.Param, *types.FuncType) {
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
				paramKind = f.StartExpr(value.Type.(*ast.StarExpr), "type").Type()
			case *ast.ArrayType:
				arrayType := value.Type.(*ast.ArrayType)
				paramKind = f.ArrayType(arrayType)
			case *ast.SelectorExpr:
				paramKind = f.doSelector(nil, value.Type.(*ast.SelectorExpr), "type").Type()
			case *ast.InterfaceType:
				paramKind = types.I8Ptr
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
			ty = append(ty, f.StartExpr(value.Type.(*ast.StarExpr), "type").Type())
		case *ast.ArrayType:
			ty = append(ty, types.NewPointer(f.ArrayType(value.Type.(*ast.ArrayType))))
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
func (f *FuncDecl) UnaryExpr(unaryExpr *ast.UnaryExpr) value.Value {
	var variable value.Value
	switch unaryExpr.X.(type) {
	case *ast.Ident:
		name := GetIdentName(unaryExpr.X.(*ast.Ident))
		variable = f.GetVariable(name)
	case *ast.CompositeLit: //
		variable = f.CompositeLit(unaryExpr.X.(*ast.CompositeLit))
	case *ast.SelectorExpr:
		variable = f.doSelector(nil, unaryExpr.X.(*ast.SelectorExpr), "call")
	default:
		logrus.Error("not impl")
	}
	switch unaryExpr.Op {
	case token.AND:
		return f.GetSrcPtr(variable)
	case token.RANGE:
		return f.Ident(unaryExpr.X.(*ast.Ident))
	case token.SUB:
		return f.GetCurrentBlock().NewMul(f.BasicLit(unaryExpr.X.(*ast.BasicLit)), constant.NewInt(types.I32, -1))
	default:
		fmt.Println("UnaryExpr not impl")
	}
	return nil

}

//*
func (f *FuncDecl) StartExpr(x *ast.StarExpr, typ string) value.Value {
	switch typ {
	case "type":
		switch x.X.(type) {
		case *ast.Ident:
			ident := f.Ident(x.X.(*ast.Ident))
			return ir.NewParam("", types.NewPointer(ident.Type()))
		default:
			logrus.Error("type not impl")
		}
	case "value":
		var v value.Value
		switch x.X.(type) {
		case *ast.Ident:
			v = f.GetCurrentBlock().NewLoad(FixAlloc(f.GetCurrentBlock(), f.Ident(x.X.(*ast.Ident))))
		case *ast.StarExpr:
			v = f.GetCurrentBlock().NewLoad(f.StartExpr(x.X.(*ast.StarExpr), "value"))
		default:
			name := GetIdentName(x.X.(*ast.Ident))
			if p := f.GetVariable(name); p != nil {
				v = FixAlloc(f.GetCurrentBlock(), p)
			} else {
				fmt.Println("not find in StartExpr")
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

func (f *FuncDecl) GetRecvType(funDecl *ast.FuncDecl) types.Type {
	var structTyp types.Type
	if nil != funDecl.Recv {
		switch funDecl.Recv.List[0].Type.(type) {
		case *ast.Ident:
			structTyp = f.GetTypeFromName(GetIdentName(funDecl.Recv.List[0].Type.(*ast.Ident)))
		case *ast.StarExpr:
			starExpr := funDecl.Recv.List[0].Type.(*ast.StarExpr)
			structTyp = types.NewPointer(f.GetTypeFromName(GetIdentName(starExpr.X.(*ast.Ident))))
		}
	}
	return structTyp
}

func (f *FuncDecl) InitFunc(funDecl []*ast.FuncDecl) {
	for _, value := range funDecl {
		if value.Recv != nil {
			recvType := utils.GetBaseType(f.GetRecvType(value))
			name := recvType.Name()
			if f.PreStrutsFunc[name] == nil {
				f.PreStrutsFunc[name] = make(map[string]*ast.FuncDecl)
			}
			f.PreStrutsFunc[name][value.Name.Name] = value
		}
	}
}

func (f *FuncDecl) DoFunDecl(pkg string, funDecl *ast.FuncDecl) *ir.Func {
	i, ok := f.FuncDecls[funDecl]
	if ok {
		return i
	}
	////////////////////////////method begin//////////////////////////////
	//func name
	var structTyp = f.GetRecvType(funDecl)
	funName := funDecl.Name.Name
	//deal struct
	if structTyp != nil {
		funName = f.mPackage + "." + utils.GetBaseType(structTyp).Name() + "." + funDecl.Name.Name
	} else {
		if pkg != "" {
			funName = pkg + "." + funName
		}
	}
	//func type
	params, funTyp := f.FunType(funDecl.Type)
	tempFunc := f.CreatFunc(funName, params, funTyp)
	f.FuncDecls[funDecl] = tempFunc
	f.pushFunc(tempFunc)

	//deal struct func
	if funDecl.Recv != nil {
		s := utils.GetBaseType(structTyp).Name()
		varName := GetIdentName(funDecl.Recv.List[0].Names[0])
		tempFunc.Params = append(tempFunc.Params, ir.NewParam(varName, structTyp))
		f.StructDefs[s][funDecl.Name.Name] = StructDef{Name: funDecl.Name.Name, Fun: tempFunc, Order: -1}
	}

	//func body
	blockStmt := funDecl.Body
	f.BlockStmt(blockStmt)
	//body
	////////////////////////////method end/////////////////////////

	if f.GetCurrent() != nil && f.GetCurrent().Sig.RetType == nil {
		f.GetCurrent().Sig.RetType = types.Void
	}
	pop := f.popFunc()

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
func (f *FuncDecl) BlockStmt(block *ast.BlockStmt) (start *ir.Block, end *ir.Block) {
	//ast.Print(f.fSet, block)
	newBlock := f.newBlock()
	utils.NewComment(f.GetCurrentBlock(), "block start")
	startBlock := newBlock
	//var endBlock *ir.Block
	//copy func param
	if len(f.GetCurrent().Blocks) == 1 {
		f.initFuncParam()
	}
	defer f.popBlock()
	for _, v := range block.List {
		utils.GCCall(f, v)
	}
	utils.NewComment(f.GetCurrentBlock(), "end block")
	return startBlock, f.GetCurrentBlock()
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
		f.NewStore(value, newAlloca)
		if f.IsSlice(newAlloca) { //slice *
			f.PutVariable(value.Name(), newAlloca)
		} else if types.IsFunc(utils.GetBaseType(newAlloca.Type())) {
			f.PutVariable(value.Name(), f.GetCurrentBlock().NewLoad(newAlloca))
		} else {
			f.PutVariable(value.Name(), newAlloca)
		}
		logrus.Debugf("put Variable %s", value.Name())

	}
}

func (f *FuncDecl) IncDecStmt(decl *ast.IncDecStmt) value.Value {
	var x = utils.GCCall(f, decl.X)[0].(value.Value)
	x = FixAlloc(f.GetCurrentBlock(), x)
	if types.IsPointer(x.Type()) {
		x = f.GetCurrentBlock().NewLoad(x)
	}
	switch decl.Tok {
	case token.INC: //++
		add := f.GetCurrentBlock().NewAdd(x, constant.NewInt(types.I32, 1))
		f.NewStore(add, f.GetSrcPtr(x))
		return add
	case token.DEC: //--
		sub := f.GetCurrentBlock().NewSub(x, constant.NewInt(types.I32, 1))
		f.NewStore(sub, f.GetSrcPtr(x))
		return sub
	default:
		fmt.Println("decl.Tok not impl")
	}
	return nil
}

func (f *FuncDecl) DeclStmt(decl *ast.DeclStmt) {
	utils.GCCall(f, decl.Decl)
}

func (f *FuncDecl) GetAstArrayEmType(arr *ast.ArrayType) types.Type {
	switch arr.Elt.(type) {
	case *ast.Ident:
		typ := f.GetTypeFromName(GetIdentName(arr.Elt.(*ast.Ident)))
		return typ
	case *ast.ArrayType:
		arrayType := arr.Elt.(*ast.ArrayType)
		emType := f.GetAstArrayEmType(arrayType)
		return f.GetNewSliceType(emType)
	}
	return nil
}

func (f *FuncDecl) GetNilAstArrayEmType(lit *ast.CompositeLit) types.Type {
	if lit.Type == nil {
		switch lit.Elts[0].(type) {
		case *ast.CompositeLit:
			return f.GetNewSliceType(f.GetNilAstArrayEmType(lit.Elts[0].(*ast.CompositeLit)))
		case *ast.BasicLit:
			return f.BasicLit(lit.Elts[0].(*ast.BasicLit)).Type()
		default:
			logrus.Error("GetNilAstArrayEmType not impl")
		}

	}
	arrayType := lit.Type.(*ast.ArrayType)
	return f.GetAstArrayEmType(arrayType)
}

func (f *FuncDecl) sliceInit(lit *ast.CompositeLit) value.Value {
	isConstant := false
	for _, value := range lit.Elts {
		if b, ok := value.(*ast.BasicLit); ok && b.Kind != token.STRING {
			isConstant = true
			break
		}
		if t, ok := value.(*ast.Ident); ok && (t.Name == "true" || t.Name == "false") {
			isConstant = true
		}
	}
	if isConstant {
		var c []constant.Constant
		for _, v := range lit.Elts {
			i := utils.GCCall(f, v)[0]
			c = append(c, i.(constant.Constant))
		}
		name := f.GetCurrent().Name()
		array := constant.NewArray(c...)
		def := f.m.NewGlobalDef(f.mPackage+"."+name+"."+strconv.Itoa(len(f.m.Globals)), array)
		def.Immutable = true
		return f.InitConstantValue(array.Type(), def)
	} else {
		var dSlice value.Value
		typ := f.GetNilAstArrayEmType(lit)
		dSlice = f.NewSlice(typ, constant.NewInt(types.I32, int64(len(lit.Elts))))
		slice := f.GetVSlice(dSlice)
		for index, v := range lit.Elts {
			utils.NewComment(f.GetCurrentBlock(), "init slice "+strconv.Itoa(index))
			ptr := f.GetCurrentBlock().NewGetElementPtr(slice, constant.NewInt(types.I32, int64(index)))
			call := utils.GCCall(f, v)[0].(value.Value)
			loadValue := utils.LoadValue(f.GetCurrentBlock(), call)
			f.NewStore(loadValue, ptr)
		}
		utils.NewComment(f.GetCurrentBlock(), "end init slice")
		return dSlice

	}
}

//TODO struct init
//only for array and struts init return value
func (f *FuncDecl) CompositeLit(lit *ast.CompositeLit) value.Value {
	//done with type
	if lit.Type == nil {
		return f.sliceInit(lit)
	}
	switch lit.Type.(type) {
	case *ast.ArrayType: //array
		return f.sliceInit(lit)
	case *ast.Ident: //struct
		name := GetIdentName(lit.Type.(*ast.Ident))
		structType, _ := f.GlobDef[name]
		//check types
		base := true
		structDefs := f.StructDefs[name]

		for _, value := range lit.Elts {
			switch value.(type) {
			case *ast.KeyValueExpr:
				keyValueExpr := value.(*ast.KeyValueExpr)
				if b, ok := keyValueExpr.Value.(*ast.BasicLit); !ok || b.Kind == token.STRING {
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

		//if lit.Elts == nil {
		//	if !ok {
		//		f.typeSpec(lit.Type.(*ast.Ident).Obj.Decl.(*ast.TypeSpec))
		//	}
		//	return FixAlloc(f.GetCurrentBlock(), f.NewType(structType))
		//}
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
						if t, ok := def.Typ.(*types.IntType); ok {
							s[def.Order] = f.BasicLitType(keyValueExpr.Value.(*ast.BasicLit), t).(constant.Constant)
						} else {
							s[def.Order] = f.BasicLit(keyValueExpr.Value.(*ast.BasicLit)).(constant.Constant)
						}
					default:
						logrus.Error("bbbbbb")
					}
				case *ast.BasicLit:
					s[index] = f.BasicLit(value.(*ast.BasicLit)).(constant.Constant)
				default:
					logrus.Error("aaaaaa")
				}
			}
			//init
			for i := 0; i < len(s); i++ {
				if s[i] == nil {
					s[i] = f.InitZeroConstant(getStructFiledType(structDefs, i))
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
		fmt.Println("not impl CompositeLit")

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
				variable := FixAlloc(f.GetCurrentBlock(), f.Ident(value))
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
				f.NewStore(value, indexStruct)
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

	//inject var
	utils.NewComment(f.GetCurrentBlock(), "<inject var")
	for key, value := range paramsKV {
		indexStruct := utils.IndexStruct(f.GetCurrentBlock(), initParam, value)
		f.PutVariable(key, &Scope{f.GetCurrentBlock().NewLoad(indexStruct), 1, nil})
	}
	utils.NewComment(f.GetCurrentBlock(), "inject var>")

	//set value
	structDefs := f.StructDefs[structType.Name()]
	record := make(map[int]int)
	for index, val := range lit.Elts { //
		switch val.(type) {
		case *ast.KeyValueExpr:
			keyValueExpr := val.(*ast.KeyValueExpr)
			identName := GetIdentName(keyValueExpr.Key.(*ast.Ident))
			structDef, _ := structDefs[identName]
			var indexStruct value.Value = utils.IndexStruct(f.GetCurrentBlock(), param, structDef.Order)
			record[structDef.Order] = 1
			switch keyValueExpr.Value.(type) {
			case *ast.BasicLit:
				f.NewStore(f.BasicLit(keyValueExpr.Value.(*ast.BasicLit)), indexStruct)
			case *ast.UnaryExpr:
				expr := f.UnaryExpr(keyValueExpr.Value.(*ast.UnaryExpr))
				f.NewStore(expr, indexStruct)
			case *ast.CompositeLit:
				compositeLit := f.CompositeLit(keyValueExpr.Value.(*ast.CompositeLit))
				f.NewStore(compositeLit, indexStruct)
			case *ast.Ident:
				name := GetIdentName(keyValueExpr.Value.(*ast.Ident))
				if name == "nil" {
					null := constant.NewNull(types.NewPointer(utils.GetBaseType(indexStruct.Type())))
					f.NewStore(null, indexStruct)
				} else {
					variable := f.GetVariable(name)
					f.NewStore(variable, indexStruct)
				}
			default:
				logrus.Error("bbbbbb StructInit")
			}
		case *ast.BasicLit:
			record[index] = 0
			var indexStruct value.Value = utils.IndexStruct(f.GetCurrentBlock(), param, index)
			f.NewStore(f.BasicLit(val.(*ast.BasicLit)), indexStruct)
		case *ast.Ident:
			record[index] = 0
			var indexStruct value.Value = utils.IndexStruct(f.GetCurrentBlock(), param, index)
			name := GetIdentName(val.(*ast.Ident))
			if name == "nil" {
				null := constant.NewNull(types.NewPointer(utils.GetBaseType(indexStruct.Type())))
				f.NewStore(null, indexStruct)
			} else {
				variable := f.GetVariable(name)
				f.NewStore(variable, indexStruct)
			}

		default:
			logrus.Error("aaaaaa StructInit")
		}
	}
	//fix string
	utils.NewComment(f.GetCurrentBlock(), "<init string>")
	t := structType.(*types.StructType)
	for index, typ := range t.Fields {
		if _, ok := record[index]; f.IsString(typ) && !ok {
			structValue := utils.IndexStruct(f.GetCurrentBlock(), param, index)
			indexStruct := utils.IndexStruct(f.GetCurrentBlock(), structValue, 1)
			f.NewStore(constant.NewNull(types.I8Ptr), indexStruct)
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

func (f *FuncDecl) BranchStmt(stmt *ast.BranchStmt) {
	switch stmt.Tok {
	case token.BREAK:
		f.forBreak = f.GetCurrentBlock()
	case token.CONTINUE:
		f.forContinue = f.GetCurrentBlock()
	}

}

func (f *FuncDecl) SliceExpr(expr *ast.SliceExpr) value.Value {
	variable := utils.GCCall(f, expr.X)[0].(value.Value)
	var low value.Value = constant.NewInt(types.I32, 0)
	var higt value.Value
	if expr.Low != nil {
		low = f.BasicLit(expr.Low.(*ast.BasicLit))
	}
	if expr.High != nil {
		higt = f.BasicLit(expr.High.(*ast.BasicLit))
	} else {
		higt = f.GetLen(variable)
	}
	if expr.Low == nil && expr.High == nil {
		return variable
	}
	decl := f.DoFunDecl("runtime", f.r.GetFunc("rangePtr"))
	switch {
	case f.IsString(variable.Type()):
		utils.NewComment(f.GetCurrentBlock(), "start string range[]")
		pString := f.GetPString(f.GetSrcPtr(variable))
		stringV := f.GetCurrentBlock().NewLoad(pString)
		stdCall := f.StdCall(decl,
			f.GetCurrentBlock().NewBitCast(stringV, types.I8Ptr),
			low,
			higt,
			constant.NewInt(types.I32, 1),
		)
		sub := f.GetCurrentBlock().NewSub(higt, low)
		newString := f.NewString(sub)
		getSlice := f.GetPString(newString)
		f.NewStore(f.GetCurrentBlock().NewBitCast(stdCall, types.NewPointer(utils.GetBaseType(getSlice.Type()))), getSlice)
		utils.NewComment(f.GetCurrentBlock(), "end string range[]")
		return utils.LoadValue(f.GetCurrentBlock(), newString)
	case f.IsSlice(variable):
		//i8* rangeSlice(i8* ptr,int low ,int high,int bytes)
		utils.NewComment(f.GetCurrentBlock(), "start slice[]")
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
		f.NewStore(f.GetCurrentBlock().NewBitCast(stdCall, types.NewPointer(utils.GetBaseType(getSlice.Type()))), getSlice)
		utils.NewComment(f.GetCurrentBlock(), "end slice[]")
		return utils.LoadValue(f.GetCurrentBlock(), newSlice)
	default:
		logrus.Error("SliceExpr not sliceArray")
	}
	return nil
}

func (f *FuncDecl) ArrayType(arrayType *ast.ArrayType) types.Type {
	var kind types.Type
	switch arrayType.Elt.(type) {
	case *ast.Ident:
		ki := f.GetTypeFromName(GetIdentName(arrayType.Elt.(*ast.Ident)))
		kind = f.GetNewSliceType(ki)
	case *ast.ArrayType:
		kind = f.GetNewSliceType(f.ArrayType(arrayType.Elt.(*ast.ArrayType)))
	default:
		logrus.Error("not find ArrayType")
	}
	return kind
}

//inline func
func (f *FuncDecl) FuncLit(fun *ast.FuncLit) value.Value {
	params, funTyp := f.FunType(fun.Type)
	tempFunc := f.CreatFunc("", params, funTyp)
	f.pushFunc(tempFunc)
	f.BlockStmt(fun.Body)
	f.popFunc()
	return tempFunc
}

func (f *FuncDecl) Ident(ident *ast.Ident) value.Value {
	if ident.Obj != nil {
		switch ident.Obj.Kind {
		case ast.Var:
			//constant,Glob,alloa,param
			variable := f.GetVariable(ident.Name)
			if variable != nil {
				return variable
			} else {
				return ir.NewParam(ident.Name, nil)
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
			if identName == "true" || identName == "false" {
				parseBool, _ := strconv.ParseBool(identName)
				return constant.NewBool(parseBool)
			} else {
				return ir.NewParam("", f.GetTypeFromName(identName))
			}
		} else {
			return ir.NewParam(identName, f.GetTypeFromName(identName))
		}
	}
	return nil
}

func (f *FuncDecl) ExprStmt(exprStmt *ast.ExprStmt) {
	utils.GCCall(f, exprStmt.X)
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

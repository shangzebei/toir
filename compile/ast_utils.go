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
	"regexp"
	"strconv"
	"strings"
	"toir/utils"
)

func GetCallFuncName(call *ast.SelectorExpr) string {
	return GetIdentName(call.X.(*ast.Ident)) + "." + GetIdentName(call.Sel)
}

func GetIdentName(i *ast.Ident) string {
	return i.Name
}

var MapDefTypes map[string]types.Type

var MapNamesTypes = map[string]types.Type{
	"bool":  types.I1,
	"int":   types.I32,
	"int8":  types.I8,
	"int32": types.I32,
	"int64": types.I64,
	//"string":  types.I8Ptr,
	"float32": types.Float,
	"float64": types.Float,
	"byte":    types.I8,
	//runtime types
	"i8":    types.I8,
	"i8*":   types.I8Ptr,
	"i32":   types.I32,
	"i64":   types.I64,
	"i8p":   types.I8Ptr,
	"i32p":  types.I32Ptr,
	"i64p":  types.I64Ptr,
	"float": types.Float,
}

func (f *FuncDecl) isBaseType(p types.Type) bool {
	for _, value := range MapNamesTypes {
		if p == value {
			return true
		}
	}
	return false
}

func (f *FuncDecl) GetTypes(typ token.Token) types.Type {
	if v, ok := MapNamesTypes[strings.ToLower(typ.String())]; ok {
		return v
	}
	if g, ok := f.GlobDef[typ.String()]; ok {
		return g
	}
	fmt.Println("GetTypes error", typ)
	return nil
}

func (f *FuncDecl) GetTypeFromName(name string) types.Type {

	//base types
	if v, ok := MapNamesTypes[strings.ToLower(name)]; ok {
		return v
	}
	//type def
	if v, ok := MapDefTypes[name]; ok {
		return v
	}
	//Glob Struct
	if g, ok := f.GlobDef[name]; ok {
		return g
	}
	fmt.Println("GetTypeFromName error", name)
	return nil
}

func (f *FuncDecl) StringType() *types.StructType {
	str := f.GetTypeFromName("string")
	return str.(*types.StructType)
}

func (f *FuncDecl) BasicLitType(base *ast.BasicLit, intType *types.IntType) value.Value {
	switch base.Kind {
	case token.INT:
		atoi, _ := strconv.Atoi(base.Value)
		return constant.NewInt(intType, int64(atoi))
	case token.STRING:
		itoa := strconv.Itoa(len(f.Constants))
		str, _ := strconv.Unquote(base.Value)
		fromString := constant.NewCharArrayFromString(str + "\x00")
		globalDef := f.m.NewGlobalDef("str."+itoa, fromString)
		globalDef.Immutable = true
		f.Constants = append(f.Constants, globalDef)
		ptr := constant.NewGetElementPtr(globalDef, constant.NewInt(types.I64, 0), constant.NewInt(types.I64, 0))
		ptr.Typ = types.I8Ptr
		ptr.InBounds = true
		/////
		i := len(fromString.X)
		newString := f.NewString(constant.NewInt(types.I32, int64(i-1)))
		f.InitStringValue(newString, ptr)
		return f.GetCurrentBlock().NewLoad(newString)
	case token.FLOAT:
		parseFloat, _ := strconv.ParseFloat(base.Value, 32)
		return constant.NewFloat(types.Float, parseFloat)
	default:
		fmt.Println("BasicLit not impl")
	}
	return nil
}

func (f *FuncDecl) BasicLit(base *ast.BasicLit) value.Value {
	return f.BasicLitType(base, types.I32)
}

func (f *FuncDecl) ValeSpec(spec *ast.ValueSpec) value.Value {
	name := GetIdentName(spec.Names[0])
	for _, value := range spec.Values {
		switch value.(type) {
		case ast.Expr:
			expr := value.(ast.Expr)
			return f.BasicLit(expr.(*ast.BasicLit))
		default:
			fmt.Println("no impl ValeSpec")
		}
	}
	if len(spec.Values) == 0 {
		return f.GetVariable(name)
	}
	fmt.Println("ValeSpec return null")
	return nil
}

func (f *FuncDecl) checkType(v value.Value) value.Value {
	return f.GetCurrentBlock().NewLoad(v)
}

func doSymbol(name string) string {
	compile, _ := regexp.Compile("[*%]")
	return compile.ReplaceAllString(name, "")
}

func (f *FuncDecl) StdCall(v value.Value, args ...value.Value) value.Value {
	return utils.StdCall(f.m, f.GetCurrentBlock(), v, args...)
}

func (f *FuncDecl) ToPtr(src value.Value) *ir.InstGetElementPtr {
	return utils.Toi8Ptr(f.GetCurrentBlock(), src)
}

//return i8*
func (f *FuncDecl) GetSrcPtr(src value.Value) value.Value {
	logrus.Debugf("GetSrcPtr begin %s", src)
	if _, ok := src.(*ir.InstAlloca); ok {
		logrus.Debugf("GetSrcPtr end %s", src)
		return src
	}
	if _, ok := src.(*ir.InstBitCast); ok {
		return src
	}

	if l, ok := src.(*ir.InstLoad); ok {
		logrus.Debugf("GetSrcPtr end InstLoad.Src %s", l.Src)
		return l.Src
	}
	if l, ok := src.(*Scope); ok {
		return f.GetSrcPtr(l.V)
	}
	return src
}

func GetRealType(value2 types.Type) types.Type {
	typ := value2
	if t, ok := value2.(*types.PointerType); ok {
		typ = t.ElemType
	}
	return typ
}

func GetSliceBytes(arrayType *types.ArrayType) int64 {
	return int64(GetBytes(arrayType.ElemType)) * int64(arrayType.Len)
}

func GetBytes(typ types.Type) int {
	var l int
	switch typ.(type) {
	case *types.IntType:
		intType := typ.(*types.IntType)
		l = int(intType.BitSize / 8)
	case *types.PointerType:
		l = 8
	case *types.FloatType:
		l = 8
	case *types.ArrayType:
		arrayType := typ.(*types.ArrayType)
		l = int(GetSliceBytes(arrayType))
	case *types.StructType:
		arrayType := typ.(*types.StructType)
		l = GetStructBytes(arrayType)
	default:
		fmt.Println("unkonw types size")
	}
	return l
}

func (f *FuncDecl) InitZeroConstant(typ types.Type) constant.Constant {
	switch {
	case types.IsPointer(typ):
		return constant.NewNull(typ.(*types.PointerType))
	case types.IsInt(typ):
		return constant.NewInt(types.I32, int64(0))
	case types.IsFloat(typ):
		return constant.NewFloat(types.Float, float64(0))
	//case f.IsString(typ):
	//	structType := typ.(*types.StructType)
	//	def := f.m.NewGlobalDef("eof", constant.NewCharArrayFromString("aaaaaaaaaaaaaa\x00"))
	//	def.Immutable = true
	//	ptr := constant.NewGetElementPtr(def,
	//		constant.NewInt(types.I64, 0),
	//		constant.NewInt(types.I64, 0),
	//	)
	//	ptr.InBounds = true
	//	newStruct := constant.NewStruct(constant.NewInt(types.I32, 8), ptr)
	//	newStruct.Typ = structType
	//	return newStruct
	case types.IsStruct(typ):
		structType := typ.(*types.StructType)
		var pp []constant.Constant
		for _, value := range structType.Fields {
			pp = append(pp, f.InitZeroConstant(value))
		}
		newStruct := constant.NewStruct(pp...)
		newStruct.Typ = structType
		return newStruct
	default:
		fmt.Println("InitZeroValue type not impl", typ)
	}
	return nil
}

func GetStructBytes(v types.Type) int {
	a := 0
	if t, ok := utils.GetBaseType(v).(*types.StructType); ok {
		for _, value := range t.Fields {
			bytes := GetBytes(value)
			a += bytes
			if a%bytes != 0 {
				a += bytes
			}
		}
	}
	return a
}

func FixAlloc(b *ir.Block, value2 value.Value) value.Value {
	if _, ok := value2.(*ir.InstBitCast); ok {
		return b.NewLoad(value2)
	}
	if a, ok := value2.(*ir.InstAlloca); ok {
		return b.NewLoad(a)
	}
	return value2
}

func FixNil(value2 value.Value, p types.Type) value.Value {
	if t, ok := value2.(*constant.Null); ok {
		t.Typ = types.NewPointer(utils.GetBaseType(p))
		return t
	}
	if t, ok := value2.(*ir.Param); ok && t.Name() == "nil" {
		return constant.NewNull(types.NewPointer(utils.GetBaseType(p)))
	}
	return value2
}

func IsIgnore(i *ast.Ident) bool {
	if i.Name == "_" {
		return true
	} else {
		return false
	}
}

func (f *FuncDecl) NewStore(src, dst value.Value) {
	if types.IsInt(src.Type()) && types.IsInt(utils.GetBaseType(dst.Type())) {
		src = f.IntType(src, utils.GetBaseType(dst.Type()))
	}
	if types.IsInt(utils.GetBaseType(src.Type())) && types.IsFloat(utils.GetBaseType(dst.Type())) {
		src = f.Float32(src)
	}
	f.GetCurrentBlock().NewStore(src, dst)

}

func (f *FuncDecl) CallRuntime(funName string, args ...value.Value) value.Value {
	f.rf = true
	getFunc := f.r.GetFunc(funName)
	decl := f.DoFunDecl("runtime", getFunc)
	f.rf = false
	return f.GetCurrentBlock().NewCall(decl, args...)

}

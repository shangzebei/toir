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
	"bool":    types.I8,
	"int":     types.I32,
	"int8":    types.I8,
	"int32":   types.I32,
	"int64":   types.I64,
	"string":  types.I8Ptr,
	"float32": types.Float,
	"float64": types.Float,
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

func (f *FuncDecl) BasicLitToConstant(base *ast.BasicLit) constant.Constant {
	switch base.Kind {
	case token.INT:
		atoi, _ := strconv.Atoi(base.Value)
		return constant.NewInt(types.I32, int64(atoi))
	case token.STRING:
		itoa := strconv.Itoa(len(f.Constants))
		str, _ := strconv.Unquote(base.Value)
		globalDef := f.m.NewGlobalDef("str."+itoa, constant.NewCharArrayFromString(str+"\x00"))
		globalDef.Immutable = true
		f.Constants = append(f.Constants, globalDef)
		ptr := constant.NewGetElementPtr(globalDef, constant.NewInt(types.I64, 0), constant.NewInt(types.I64, 0))
		ptr.Typ = types.I8Ptr
		ptr.InBounds = true
		return ptr
	case token.FLOAT:
		parseFloat, _ := strconv.ParseFloat(base.Value, 32)
		return constant.NewFloat(types.Float, parseFloat)
	default:
		fmt.Println("BasicLitToConstant not impl")
	}
	return nil
}

func (f *FuncDecl) doValeSpec(spec *ast.ValueSpec) value.Value {
	name := GetIdentName(spec.Names[0])
	for _, value := range spec.Values {
		switch value.(type) {
		case ast.Expr:
			expr := value.(ast.Expr)
			return f.BasicLitToConstant(expr.(*ast.BasicLit))
		default:
			fmt.Println("no impl doValeSpec")
		}
	}
	if len(spec.Values) == 0 {
		return f.GetVariable(name)
	}
	fmt.Println("doValeSpec return null")
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
	logrus.Debugf("GetSrcPtr  %s", src)
	if a, ok := src.(*ir.InstAlloca); ok && types.IsPointer(a.ElemType) {
		return f.GetCurrentBlock().NewLoad(src)
	} else if _, ok := src.(*ir.InstAlloca); ok {
		return src
	}
	if l, ok := src.(*ir.InstLoad); ok {
		return l.Src
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
		l = 8
	default:
		fmt.Println("unkonw types size")
	}
	return l
}

func InitZeroConstant(typ types.Type) constant.Constant {
	switch typ {
	case types.I8Ptr:
		return constant.NewNull(types.I8Ptr)
	case types.I8, types.I32, types.I16, types.I64:
		return constant.NewInt(types.I32, int64(0))
	case types.Float:
		return constant.NewFloat(types.Float, float64(0))
	default:
		if t, ok := typ.(*types.PointerType); ok {
			return constant.NewNull(t)
		} else {
			fmt.Println("InitZeroValue type not impl")
		}
	}
	return nil
}

func GetBaseType(v types.Type) types.Type {
	if p, ok := v.(*types.PointerType); ok {
		return GetBaseType(p.ElemType)
	} else {
		return v
	}
}

func GetStructBytes(v value.Value) int {
	a := 0
	if t, ok := v.Type().(*types.StructType); ok {
		for _, value := range t.Fields {
			a += GetBytes(value)
		}
	}
	if _, ok := v.(*SliceValue); ok {
		a += 24
	}
	return a
}

func FixAlloc(b *ir.Block, value2 value.Value) value.Value {
	if a, ok := value2.(*ir.InstAlloca); ok {
		return b.NewLoad(a)
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

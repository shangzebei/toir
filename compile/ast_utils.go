package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
	"regexp"
	"strconv"
	"strings"
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

func (f *FuncDecl) IdentToValue(id *ast.Ident) []value.Value {
	if id.Obj.Kind == ast.Var {
		switch id.Obj.Decl.(type) {
		case *ast.Field:
			//field := id.Obj.Decl.(*ast.Field)
			fName := id.Name
			return []value.Value{f.GetVariable(fName)}
		case *ast.ValueSpec:
			valueSpec := id.Obj.Decl.(*ast.ValueSpec)
			return []value.Value{f.doValeSpec(valueSpec)}
		case *ast.AssignStmt:
			variable := f.GetVariable(id.Name)
			if variable == nil {
				return f.doAssignStmt(id.Obj.Decl.(*ast.AssignStmt))
			} else {
				return []value.Value{variable}
			}
		default:
			fmt.Println("id.Obj.Decl.(type)")
		}
	}
	fmt.Println("IdentToValue no impl")
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

func (f *FuncDecl) convertTypeTo(from value.Value, to types.Type) value.Value {
	if from.Type() != to {
		if _, ok := to.(*types.IntType); ok {
			if _, ok := from.Type().(*types.PointerType); ok {
				return f.GetCurrentBlock().NewLoad(from)
			} else {
				fmt.Println("convertTypeTo unknown type")
			}
		}
		if _, ok := to.(*types.PointerType); ok {
			if _, ok := from.Type().(*types.IntType); ok {
				return f.GetCurrentBlock().NewGetElementPtr(from, constant.NewInt(types.I64, 0), constant.NewInt(types.I64, 0))
			} else {
				fmt.Println("convertTypeTo unknown type")
			}
		}
	}
	return nil
}

func (f *FuncDecl) StdCall(v value.Value, args ...value.Value) value.Value {
	return f.Call(f.GetCurrentBlock(), v, args...)
}

func (f *FuncDecl) Call(b *ir.Block, v value.Value, args ...value.Value) value.Value {
	typ := v.Type()
	if p, ok := v.Type().(*types.PointerType); ok {
		typ = p.ElemType
	}
	if _, ok := typ.(*types.FuncType); ok {
		ex := false
		i := v.(*ir.Func)
		for _, value := range f.m.Funcs {
			if i.GlobalName == value.GlobalName {
				ex = true
				break
			}
		}
		if !ex {
			f.m.Funcs = append(f.m.Funcs, v.(*ir.Func))
		}
		return b.NewCall(v, args...)
	} else {
		fmt.Println("type error")
	}
	return nil
}

func (f *FuncDecl) ToPtr(src value.Value) *ir.InstGetElementPtr {
	return Toi8Ptr(f.GetCurrentBlock(), src)
}

func Toi8Ptr(b *ir.Block, src value.Value) *ir.InstGetElementPtr {
	return b.NewGetElementPtr(src, constant.NewInt(types.I64, 0), constant.NewInt(types.I64, 0))
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

func GetStructBytes(v value.Value) int {
	a := 0
	if t, ok := v.Type().(*types.StructType); ok {
		for _, value := range t.Fields {
			a += GetBytes(value)
		}
	}
	if _, ok := v.(*SliceArray); ok {
		a += 24
	}
	return a
}

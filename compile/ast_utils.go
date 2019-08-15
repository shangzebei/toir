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

var MapNamesTypes = map[string]types.Type{
	"int":     types.I32,
	"string":  types.I8Ptr,
	"float32": types.Float,
}

func GetTypes(typ token.Token) types.Type {
	v, ok := MapNamesTypes[strings.ToLower(typ.String())]
	if ok {
		return v
	} else {
		fmt.Println("error", typ)
	}
	return nil
}

func GetTypeFromName(name string) types.Type {
	v, ok := MapNamesTypes[strings.ToLower(name)]
	if ok {
		return v
	} else {
		fmt.Println("error", name)
	}
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
		globalDef := f.m.NewGlobalDef("str."+itoa, constant.NewCharArrayFromString(str))
		globalDef.Immutable = true
		f.Constants = append(f.Constants, globalDef)
		return globalDef
	case token.FLOAT:
		parseFloat, _ := strconv.ParseFloat(base.Value, 32)
		return constant.NewFloat(types.Float, parseFloat)
	default:
		fmt.Println("BasicLitToConstant not impl")
	}
	return nil
}

func (f *FuncDecl) IdentToValue(id *ast.Ident) value.Value {
	if id.Obj.Kind == ast.Var {
		switch id.Obj.Decl.(type) {
		case *ast.Field:
			field := id.Obj.Decl.(*ast.Field)
			fName := id.Name
			switch GetIdentName(field.Type.(*ast.Ident)) {
			case "int":
				return ir.NewParam(fName, types.I32)
			case "float":
				return ir.NewParam(fName, types.Float)
			case "string":
				return ir.NewParam(fName, types.I8Ptr)
			default:
				fmt.Println(fName)
			}
		case *ast.ValueSpec: //TODO warn !
			valueSpec := id.Obj.Decl.(*ast.ValueSpec)
			return f.doValeSpec(valueSpec)
		case *ast.AssignStmt: //TODO create new variable
			variable := f.GetVariable(id.Name)
			if variable == nil {
				return f.doAssignStmt(id.Obj.Decl.(*ast.AssignStmt))
			} else {
				return variable
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
	var kind types.Type
	for _, value := range spec.Values {
		switch value.(type) {
		case ast.Expr:
			expr := value.(ast.Expr)
			return f.BasicLitToConstant(expr.(*ast.BasicLit))
		default:
			fmt.Println("no impl doValeSpec")
		}
	}

	if spec.Type != nil {
		kind = GetTypeFromName(GetIdentName(spec.Type.(*ast.Ident)))
	}
	if len(spec.Values) == 0 {
		return ir.NewParam(name, kind)
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

func (f *FuncDecl) StdCall(v value.Value, args ...value.Value) {
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
		f.GetCurrentBlock().NewCall(v, args...)
	} else {
		fmt.Println("type error")
	}
}

func (f *FuncDecl) Toi8Ptr(src value.Value) *ir.InstGetElementPtr {
	return f.GetCurrentBlock().NewGetElementPtr(src, constant.NewInt(types.I64, 0), constant.NewInt(types.I64, 0))
}

func GetRealType(value2 types.Type) types.Type {
	typ := value2
	if t, ok := value2.(*types.PointerType); ok {
		typ = t.ElemType
	}
	return typ
}

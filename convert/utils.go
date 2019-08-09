package convert

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
	"strconv"
	"strings"
)

func GetCallFunc(call *ast.CallExpr) string {
	switch call.Fun.(type) {
	case *ast.SelectorExpr:
		return GetIdentName(call.Fun.(*ast.SelectorExpr).X.(*ast.Ident)) + "." + GetIdentName(call.Fun.(*ast.SelectorExpr).Sel)
	case *ast.Ident:
		return call.Fun.(*ast.Ident).Name
	}
	return ""
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

func Toi8Ptr(block *ir.Block, src value.Value) *ir.InstGetElementPtr {
	return block.NewGetElementPtr(src, constant.NewInt(types.I64, 0), constant.NewInt(types.I64, 0))
}

func BasicLitToValue(base *ast.BasicLit) constant.Constant {
	switch base.Kind {
	case token.INT:
		atoi, _ := strconv.Atoi(base.Value)
		return constant.NewInt(types.I32, int64(atoi))
	case token.STRING:
		return constant.NewCharArrayFromString(base.Value)
	case token.FLOAT:
		parseFloat, _ := strconv.ParseFloat(base.Value, 32)
		return constant.NewFloat(types.Float, parseFloat)
	}
	return nil
}

func IdentToValue(id *ast.Ident) value.Value {
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
			}
		}
	}
	fmt.Println("IdentToValue no impl")
	return nil
}

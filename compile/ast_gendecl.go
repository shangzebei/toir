package compile

import (
	"fmt"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
	"strconv"
	"toir/llvm"
	"toir/utils"
)

//glob is Glob def
func (f *FuncDecl) GenDecl(decl *ast.GenDecl) {
	switch decl.Tok {
	case token.VAR:
		for _, v := range decl.Specs {
			spec := v.(*ast.ValueSpec)
			f.valueSpec(spec, decl.Tok)
		}
	case token.TYPE:
		for _, v := range decl.Specs {
			spec := v.(*ast.TypeSpec)
			f.typeSpec(spec)
		}
	case token.IMPORT:
		fmt.Println("not impl import")
	default:
		fmt.Println("GenDecl not type")
	}
}

func (f *FuncDecl) valueSpec(spec *ast.ValueSpec, t token.Token) {
	var kind types.Type
	if spec.Type != nil {
		switch spec.Type.(type) {
		case *ast.Ident:
			kind = f.GetTypeFromName(spec.Type.(*ast.Ident).Name)
		case *ast.ArrayType: //TODO Warn must return types.NewArray
			arrayType := spec.Type.(*ast.ArrayType)
			var doArrayType types.Type
			if i, ok := arrayType.Elt.(*ast.Ident); ok {
				doArrayType = f.GetTypeFromName(GetIdentName(i))
			} else if a, ok := arrayType.Elt.(*ast.ArrayType); ok {
				doArrayType = f.ArrayType(a)
			}
			if arrayType.Len == nil {
				kind = types.NewArray(0, doArrayType)
			} else {
				toConstant := f.BasicLit(arrayType.Len.(*ast.BasicLit))
				len, _ := strconv.Atoi(toConstant.Ident())
				kind = types.NewArray(uint64(len), doArrayType)
			}
		case *ast.StarExpr:
			kind = f.StartExpr(spec.Type.(*ast.StarExpr), "type").Type()
		default:
			fmt.Println("not impl GenDecl")
		}

	}
	for index, name := range spec.Names {
		var v value.Value
		//get values
		if len(spec.Values) > index {
			v = utils.CCall(f, spec.Values[index])[0].(value.Value)
			if kind == nil {
				kind = v.Type()
			}
		}
		////////////////////////////////
		if f.GetCurrent() == nil {
			if t == token.VAR || v != nil {
				var v constant.Constant
				if v == nil {
					v = InitZeroConstant(kind)
				} else {
					v = v.(constant.Constant)
				}
				f.m.NewGlobalDef(name.Name, v)
			} else {
				f.m.NewGlobal(name.Name, kind)
			}
		} else {
			if v != nil {
				f.PutVariable(name.Name, v)
			} else {
				f.PutVariable(name.Name, f.NewType(kind))
			}
		}
	}
}

//init value which def and return value
func (f *FuncDecl) InitConstantValue(kind types.Type, def value.Value) value.Value {
	//alloca := f.GetCurrentBlock().NewAlloca(GetRealType(kind))
	var alloca value.Value
	if p, ok := kind.(*types.PointerType); ok {
		kind = p.ElemType
	}
	switch kind.(type) {
	case *types.ArrayType:
		arrayType := kind.(*types.ArrayType)
		sliceValue := f.NewType(arrayType)
		f.SetLen(sliceValue, constant.NewInt(types.I32, int64(arrayType.Len)))
		alloca = sliceValue
		bytes := GetSliceBytes(arrayType)
		f.StdCall(
			llvm.Mencpy,
			f.GetCurrentBlock().NewBitCast(f.GetVSlice(alloca), types.I8Ptr),
			f.GetCurrentBlock().NewBitCast(def, types.I8Ptr),
			constant.NewInt(types.I32, bytes),
			constant.NewBool(false),
		)

	case *types.StructType:
		var l int64
		alloca = f.NewType(GetBaseType(kind))
		structType := kind.(*types.StructType)
		for _, value := range structType.Fields {
			l += int64(GetBytes(value))
		}
		f.StdCall(
			llvm.Mencpy,
			f.GetCurrentBlock().NewBitCast(alloca, types.I8Ptr),
			f.GetCurrentBlock().NewBitCast(def, types.I8Ptr),
			constant.NewInt(types.I32, l),
			constant.NewBool(false),
		)
	case *types.IntType:
		alloca = f.NewType(GetBaseType(kind))
		f.NewStore(def, alloca)
	default:
		alloca = f.NewType(GetBaseType(kind))
		fmt.Println("not find types")
	}
	return f.GetCurrentBlock().NewLoad(alloca)
}

func (f *FuncDecl) doStructType(typ *types.StructType) {

}

//for struts info reg
func (f *FuncDecl) typeSpec(spec *ast.TypeSpec) types.Type {
	if t, ok := f.typeSpecs[spec]; ok {
		return t
	}
	if MapDefTypes == nil {
		MapDefTypes = make(map[string]types.Type)
	}
	name := spec.Name.Name

	switch spec.Type.(type) {
	case *ast.StructType:
		if _, ok := f.StructDefs[name]; !ok {
			f.StructDefs[name] = make(map[string]StructDef)
		}
		i := types.StructType{}
		structType := spec.Type.(*ast.StructType)
		typeDef := f.m.NewTypeDef(name, &i)
		f.typeSpecs[spec] = typeDef
		for index, value := range structType.Fields.List {
			var ftyp types.Type
			switch value.Type.(type) {
			case *ast.Ident:
				ftyp = f.Ident(value.Type.(*ast.Ident)).Type()
			case *ast.SelectorExpr:
				ftyp = f.doSelector(nil, value.Type.(*ast.SelectorExpr), "type").Type()
			case *ast.StarExpr:
				ftyp = f.StartExpr(value.Type.(*ast.StarExpr), "type").Type()
			default:
				logrus.Error("struct type don`t know")
			}
			fName := GetBaseType(ftyp).Name()
			if value.Names != nil {
				fName = value.Names[0].Name
				f.StructDefs[name][fName] = StructDef{
					Name:      fName,
					Order:     index,
					Typ:       ftyp,
					IsInherit: false,
				}
			} else {
				f.StructDefs[name][fName] = StructDef{
					Name:      fName,
					Order:     index,
					Typ:       ftyp,
					IsInherit: true,
				}
			}
			i.Fields = append(i.Fields, ftyp)
		}
		//get value

		_, ok := f.GlobDef[name]
		if ok {
			logrus.Error("GlobDef has name", name)
		}
		f.GlobDef[name] = typeDef
		//if f.GetCurrent() != nil {
		//	f.PutVariable(name, f.GetCurrentBlock().NewAlloca(typeDef))
		//}
	case *ast.Ident:
		typDef := spec.Type.(*ast.Ident)
		MapDefTypes[name] = f.GetTypeFromName(GetIdentName(typDef))
		f.typeSpecs[spec] = MapDefTypes[name]
	case *ast.FuncType:
		_, funcType := f.FunType(spec.Type.(*ast.FuncType))
		MapDefTypes[name] = types.NewPointer(funcType)
		f.typeSpecs[spec] = MapDefTypes[name]
	default:
		logrus.Error("not find typeSpec")
	}
	return f.typeSpecs[spec]
}

package compile

import (
	"fmt"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
	"toir/llvm"

	"strconv"
)

//glob is Glob def
func (f *FuncDecl) DoGenDecl(decl *ast.GenDecl) {
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
		fmt.Println("DoGenDecl not type")
	}
}

func (f *FuncDecl) valueSpec(spec *ast.ValueSpec, t token.Token) {
	var kind types.Type
	if spec.Type != nil {
		switch spec.Type.(type) {
		case *ast.Ident:
			kind = f.GetTypeFromName(spec.Type.(*ast.Ident).Name)
		case *ast.ArrayType:
			arrayType := spec.Type.(*ast.ArrayType)
			if arrayType.Len == nil {
				kind = types.NewArray(0, f.GetTypeFromName(GetIdentName(arrayType.Elt.(*ast.Ident))))
			} else {
				toConstant := f.BasicLitToConstant(arrayType.Len.(*ast.BasicLit))
				len, _ := strconv.Atoi(toConstant.Ident())
				kind = types.NewArray(uint64(len), toConstant.Type())
			}
		case *ast.StarExpr:
			kind = f.doStartExpr(spec.Type.(*ast.StarExpr)).Type()
		default:
			fmt.Println("not impl DoGenDecl")
		}

	}
	for index, name := range spec.Names {
		var value value.Value
		//get values
		if len(spec.Values) > index {
			switch spec.Values[index].(type) {
			case *ast.BasicLit:
				value = f.BasicLitToConstant(spec.Values[index].(*ast.BasicLit))
			case *ast.BinaryExpr:
				value = f.doBinary(spec.Values[index].(*ast.BinaryExpr))
			case *ast.CompositeLit:
				value = f.doCompositeLit(spec.Values[index].(*ast.CompositeLit))
			case *ast.IndexExpr:
				value = f.doIndexExpr(spec.Values[index].(*ast.IndexExpr))
			case *ast.CallExpr:
				value = f.doCallExpr(spec.Values[index].(*ast.CallExpr))
			default:
				fmt.Println("doGenDecl spec.Names not impl")
			}
			if kind == nil {
				kind = value.Type()
			}
		}
		////////////////////////////////
		if f.GetCurrent() == nil {
			if t == token.VAR || value != nil {
				var v constant.Constant
				if value == nil {
					v = InitZeroConstant(kind)
				} else {
					v = value.(constant.Constant)
				}
				f.m.NewGlobalDef(name.Name, v)
			} else {
				f.m.NewGlobal(name.Name, kind)
			}
		} else {
			if value != nil {
				f.PutVariable(name.Name, value)
			} else {
				f.PutVariable(name.Name, f.NewType(kind))
			}
		}
	}
}

//init value which def
func (f *FuncDecl) InitValue(kind types.Type, def value.Value) value.Value {
	//alloca := f.GetCurrentBlock().NewAlloca(GetRealType(kind))
	var alloca value.Value
	if p, ok := kind.(*types.PointerType); ok {
		kind = p.ElemType
	}
	switch kind.(type) {
	case *types.ArrayType:
		sliceValue := f.NewType(GetBaseType(kind))
		alloca = sliceValue
		arrayType := kind.(*types.ArrayType)
		bytes := GetSliceBytes(arrayType)
		f.StdCall(
			llvm.Mencpy,
			f.GetVSlice(alloca),
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
		f.GetCurrentBlock().NewStore(def, alloca)
	default:
		alloca = f.NewType(GetBaseType(kind))
		fmt.Println("not find types")
	}
	return alloca
}

func (f *FuncDecl) doStructType(typ *types.StructType) {

}

//for struts info reg
func (f *FuncDecl) typeSpec(spec *ast.TypeSpec) {
	var strums []types.Type
	if MapDefTypes == nil {
		MapDefTypes = make(map[string]types.Type)
	}
	name := spec.Name.Name
	switch spec.Type.(type) {
	case *ast.StructType:
		structType := spec.Type.(*ast.StructType)
		if _, ok := f.StructDefs[name]; !ok {
			f.StructDefs[name] = make(map[string]StructDef)
		}
		for index, value := range structType.Fields.List {
			fname := value.Names[0].Name
			var ftyp types.Type
			switch value.Type.(type) {
			case *ast.Ident:
				ftyp = f.GetTypeFromName(GetIdentName(value.Type.(*ast.Ident)))
			case *ast.SelectorExpr:
				ftyp = f.doSelector(nil, value.Type.(*ast.SelectorExpr), "type").Type()
			default:
				logrus.Error("struct type don`t know")
			}
			f.StructDefs[name][fname] = StructDef{
				Name:  fname,
				Order: index,
				Typ:   ftyp,
			}
			strums = append(strums, ftyp)
		}
		//if len(strums) == 0 {
		//	strums = append(strums, types.I8)
		//}
		//get value
		newTypeDef := f.m.NewTypeDef(name, types.NewStruct(strums...))
		_, ok := f.GlobDef[name]
		if ok {
			logrus.Error("GlobDef has name", name)
		}
		f.GlobDef[name] = newTypeDef
		if f.GetCurrent() != nil {
			f.PutVariable(name, f.GetCurrentBlock().NewAlloca(newTypeDef))
		}
	case *ast.Ident:
		typDef := spec.Type.(*ast.Ident)
		MapDefTypes[name] = f.GetTypeFromName(GetIdentName(typDef))
	case *ast.FuncType:
		_, funcType := f.doFunType(spec.Type.(*ast.FuncType))
		MapDefTypes[name] = types.NewPointer(funcType)
	default:
		logrus.Error("not find typeSpec")
	}

}

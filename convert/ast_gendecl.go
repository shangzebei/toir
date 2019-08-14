package convert

import (
	"fmt"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
	"strconv"
)

//glob is Glob def
func (f *FuncDecl) DoGenDecl(decl *ast.GenDecl) {
	switch decl.Tok {
	case token.VAR:
		for _, v := range decl.Specs {
			spec := v.(*ast.ValueSpec)
			f.valueSpec(spec)
		}
	case token.TYPE:
		for _, v := range decl.Specs {
			spec := v.(*ast.TypeSpec)
			f.typeSpec(spec)
		}
	default:
		fmt.Println("not type")
	}
}

func (f *FuncDecl) valueSpec(spec *ast.ValueSpec) {
	var kind types.Type
	if spec.Type != nil {
		switch spec.Type.(type) {
		case *ast.Ident:
			kind = GetTypeFromName(spec.Type.(*ast.Ident).Name)
		case *ast.ArrayType:
			arrayType := spec.Type.(*ast.ArrayType)
			toConstant := BasicLitToConstant(arrayType.Len.(*ast.BasicLit))
			len, _ := strconv.Atoi(toConstant.Ident())
			kind = types.NewArray(uint64(len), toConstant.Type())
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
				value = BasicLitToConstant(spec.Values[index].(*ast.BasicLit))
			case *ast.BinaryExpr:
				value = f.doBinary(spec.Values[index].(*ast.BinaryExpr))
			case *ast.CompositeLit:
				value = f.doCompositeLit(spec.Values[index].(*ast.CompositeLit))
			default:
				fmt.Println("doGenDecl spec.Names not impl")
			}
			if kind == nil {
				kind = value.Type()
			}
		}
		////////////////////////////////
		if f.GetCurrent() == nil {
			if value != nil {
				f.m.NewGlobalDef(name.Name, value.(constant.Constant))
			} else {
				f.m.NewGlobal(name.Name, kind)
			}
		} else {
			if value != nil {
				alloca := f.GetCurrentBlock().NewAlloca(kind)
				f.GetCurrentBlock().NewStore(value, alloca)
				f.PutVariable(name.Name, alloca)
			} else {
				f.PutVariable(name.Name, f.GetCurrentBlock().NewAlloca(kind))
			}
		}
	}
}

func (f *FuncDecl) typeSpec(spec *ast.TypeSpec) {
	var strums []types.Type
	name := spec.Name.Name
	//get type
	structType := spec.Type.(*ast.StructType)

	if _, ok := f.StructDefs[name]; !ok {
		f.StructDefs[name] = make(map[string]StructDef)
	}

	for index, value := range structType.Fields.List {
		fname := value.Names[0].Name
		ftyp := GetTypeFromName(GetIdentName(value.Type.(*ast.Ident)))
		f.StructDefs[name][fname] = StructDef{
			Name:  fname,
			Order: index,
			Typ:   ftyp,
		}
		strums = append(strums, ftyp)
	}
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

}

package compile

import (
	"fmt"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
	"learn/llvm"
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
	case token.IMPORT:
		fmt.Println("not impl import")
	default:
		fmt.Println("DoGenDecl not type")
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
			toConstant := f.BasicLitToValue(arrayType.Len.(*ast.BasicLit))
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
				value = f.BasicLitToValue(spec.Values[index].(*ast.BasicLit))
			case *ast.BinaryExpr:
				value = f.doBinary(spec.Values[index].(*ast.BinaryExpr))
			case *ast.CompositeLit:
				value = f.doCompositeLit(spec.Values[index].(*ast.CompositeLit))
			case *ast.IndexExpr:
				value = f.doIndexExpr(spec.Values[index].(*ast.IndexExpr))
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
				f.InitValue(name.Name, kind, value)
			} else {
				f.PutVariable(name.Name, f.GetCurrentBlock().NewAlloca(kind))
			}
		}
	}
}

func (f *FuncDecl) InitValue(name string, kind types.Type, value2 value.Value) {
	alloca := f.GetCurrentBlock().NewAlloca(GetRealType(kind))
	if p, ok := kind.(*types.PointerType); ok {
		kind = p.ElemType
	}
	switch kind.(type) {
	case *types.ArrayType:
		f.StdCall(
			llvm.Mencpy,
			f.GetCurrentBlock().NewBitCast(alloca, types.I8Ptr),
			f.GetCurrentBlock().NewBitCast(value2, types.I8Ptr),
			constant.NewInt(types.I32, 2),
			constant.NewBool(false),
		)
	case *types.IntType:
		f.GetCurrentBlock().NewStore(value2, alloca)
	default:
		fmt.Println("not find types")
	}
	f.PutVariable(name, alloca)

}

//for struts info reg
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

package convert

import (
	"fmt"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
	"strconv"
)

//glob is Glob def
func (f *FuncDecl) DoGenDecl(decl *ast.GenDecl) {
	if decl.Tok == token.VAR {
		for _, v := range decl.Specs {
			spec := v.(*ast.ValueSpec)
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
						value = f.doBinary("", spec.Values[index].(*ast.BinaryExpr))
					case *ast.CompositeLit:
						exprs := spec.Values[index].(*ast.CompositeLit).Elts
						fmt.Println("array init no impl", exprs)
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
	}
}

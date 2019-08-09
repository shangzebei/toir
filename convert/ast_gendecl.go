package convert

import (
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"go/token"
)

//glob is Glob def
func (f *FuncDecl) DoGenDecl(glob bool, decl *ast.GenDecl) {
	if decl.Tok == token.VAR {
		for _, v := range decl.Specs {
			spec := v.(*ast.ValueSpec)
			var kind types.Type
			if spec.Type != nil {
				kind = GetTypeFromName(spec.Type.(*ast.Ident).Name)
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
					}
					if kind == nil {
						kind = value.Type()
					}
				}
				////////////////////////////////
				if glob {
					if value != nil {
						f.m.NewGlobalDef(name.Name, value.(constant.Constant))
					} else {
						f.m.NewGlobal(name.Name, kind)
					}
				} else {
					if value != nil {
						alloca := f.GetCurrentBlock().NewAlloca(kind)
						f.GetCurrentBlock().NewStore(value, alloca)
					} else {
						f.GetCurrentBlock().NewAlloca(kind)
					}
				}
			}

		}
	}
}

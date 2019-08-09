package convert

import (
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"go/ast"
	"go/token"
)

type variable struct {
	name  string
	kind  types.Type
	value constant.Constant
}

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
				var value constant.Constant
				if len(spec.Values) > index {
					value = BasicLitToConstant(spec.Values[index].(*ast.BasicLit))
				}
				if glob {
					if value != nil {
						f.m.NewGlobalDef(name.Name, value)
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

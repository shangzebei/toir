package compile

import (
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"go/ast"
	"go/parser"
	"go/token"
	"toir/utils"
)

var ifs = `package p; func f() { if f(T{}) {} };`

func (f *FuncDecl) SwitchStmt(swi *ast.SwitchStmt) {
	//ast.Print(f.fSet,swi)
	newType := f.NewType(types.I1)
	f.GetCurrentBlock().NewStore(constant.NewBool(false), newType)
	f.tempVariables[0]["switchv"] = newType
	if swi.Tag != nil {
		f.swiV = swi.Tag.(*ast.Ident)
	}
	f.OpenTempVariable()
	temp := f.GetCurrentBlock()
	start, end := f.BlockStmt(swi.Body)
	temp.NewBr(start)
	f.popBlock() //close main
	block := f.newBlock()
	utils.NewComment(f.GetCurrentBlock(), "SWITCH NEW")
	end.NewBr(block)
	f.CloseTempVariable()

}

func (f *FuncDecl) CaseClause(cas *ast.CaseClause) {
	stmt := &ast.AssignStmt{
		Lhs: []ast.Expr{
			&ast.Ident{
				NamePos: 0,
				Name:    "switchv",
				Obj: &ast.Object{
					Kind: ast.Var,
					Name: "switchv",
				},
			},
		},
		TokPos: 0,
		Tok:    token.ASSIGN,
		Rhs: []ast.Expr{
			&ast.Ident{
				NamePos: 0,
				Name:    "true",
				Obj:     nil,
			},
		},
	}
	if cas.List == nil {
		utils.NewComment(f.GetCurrentBlock(), "default Case")
		stmt := ast.IfStmt{
			If:   0,
			Init: nil,
			Cond: &ast.BinaryExpr{
				X: &ast.Ident{
					Name: "switchv",
					Obj:  &ast.Object{Kind: ast.Var},
				},
				Op: token.EQL,
				Y: &ast.Ident{
					Name: "false",
				},
			},
			Body: &ast.BlockStmt{
				Lbrace: 0,
				List:   cas.Body,
				Rbrace: 0,
			},
		}
		f.IfStmt(&stmt)
	} else {

		var con ast.Expr
		var sm []ast.Stmt
		sm = append(sm, stmt)
		if cas.Body != nil {
			sm = append(sm, cas.Body...)
		}
		v := cas.List[0]
		switch v.(type) {
		case *ast.BinaryExpr:
			con = v
		case *ast.BasicLit:
			t, _ := parser.ParseExpr("a==1")
			binaryExpr := t.(*ast.BinaryExpr)
			binaryExpr.X = f.swiV
			binaryExpr.Y = v
			con = binaryExpr
		}
		stmt := ast.IfStmt{
			If:   0,
			Init: nil,
			Cond: con,
			Body: &ast.BlockStmt{
				Lbrace: 0,
				List:   sm,
				Rbrace: 0,
			},
			Else: nil,
		}
		f.IfStmt(&stmt)
	}
}

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
	f.swiV = swi.Tag.(*ast.Ident)
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
	expr, _ := parser.ParseExpr("a==1")
	binaryExpr := expr.(*ast.BinaryExpr)
	binaryExpr.X = f.swiV
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
		var sm []ast.Stmt
		sm = append(sm, stmt)
		sm = append(sm, cas.Body...)
		v := cas.List[0]
		binaryExpr.Y = v
		stmt := ast.IfStmt{
			If:   0,
			Init: nil,
			Cond: expr,
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

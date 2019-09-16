package compile

import (
	"github.com/jinzhu/copier"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"go/ast"
	"toir/utils"
)

var rge = `
func rangeTemp() {
	var key int
	var value int
	var zrangzwrLen int
	var f []int
	for zrangzwr := 0; zrangzwr < zrangzwrLen; zrangzwr++ {
		key = zrangzwr
		value = f[zrangzwr]
	}
}
`

func (f *FuncDecl) RangeStmt(stmt *ast.RangeStmt) (start *ir.Block, end *ir.Block) {
	utils.NewComment(f.GetCurrentBlock(), "[range start]")
	var va = utils.GCCall(f, stmt.X)[0].(value.Value)
	var name = "rangeV"
	f.tempVariables[0][name] = va
	var emType types.Type
	if f.IsString(va.Type()) {
		emType = types.I8
	} else {
		emType = GetSliceEmType(utils.GetBaseType(va.Type())) //I32*
	}
	//init len
	getLen := f.GetLen(f.GetSrcPtr(va))
	f.tempVariables[0]["zrangzwrLen"] = getLen
	getFunc := f.r.GetFunc("rangeTemp")
	//ast.Print(f.fSet, getFunc)
	blockStmt := getFunc.Body
	var assgn []*ast.AssignStmt
	var forStmt ast.ForStmt
	for _, value := range blockStmt.List {
		if f, ok := value.(*ast.ForStmt); ok {
			_ = copier.Copy(&forStmt, f)
		}
	}
	for _, value := range forStmt.Body.List {
		if i, ok := value.(*ast.AssignStmt); ok {
			assgn = append(assgn, i)
		}
	}
	var st []ast.Stmt
	//init key
	if stmt.Key != nil && !IsIgnore(stmt.Key.(*ast.Ident)) {
		keyName := GetIdentName(stmt.Key.(*ast.Ident))
		keyAlloca := f.GetCurrentBlock().NewAlloca(types.I32)
		f.tempVariables[0][keyName] = keyAlloca
		assgn[0].Lhs[0].(*ast.Ident).Name = keyName
		st = append(st, assgn[0])
	}
	//init value
	if stmt.Value != nil && !IsIgnore(stmt.Value.(*ast.Ident)) {
		valueName := GetIdentName(stmt.Value.(*ast.Ident))
		valueAlloca := f.GetCurrentBlock().NewAlloca(GetRealType(emType))
		f.tempVariables[0][valueName] = valueAlloca
		assgn[1].Lhs[0].(*ast.Ident).Name = valueName
		indexExpr := assgn[1].Rhs[0].(*ast.IndexExpr)
		indexExpr.X = &ast.Ident{
			NamePos: 0,
			Name:    name,
			Obj:     nil,
		}
		st = append(st, assgn[1])
	}

	forStmt.Body.List = append(st, stmt.Body.List...)
	utils.NewComment(f.GetCurrentBlock(), "[range end]")
	return f.ForStmt(&forStmt)
}

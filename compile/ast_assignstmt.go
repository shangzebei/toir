package compile

import (
	"fmt"
	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
	"github.com/sirupsen/logrus"
	"go/ast"
	"go/token"
	"strconv"
	"strings"
	"toir/utils"
)

func (f *FuncDecl) doAssignStmt(assignStmt *ast.AssignStmt) []value.Value {
	//ast.Print(f.fSet, assignStmt)
	//c:=a+b
	//a+b
	var r []value.Value
	var l []value.Value
	//0
	for _, value := range assignStmt.Rhs {
		switch value.(type) {
		case *ast.BinaryExpr:
			r = append(r, f.doBinary(value.(*ast.BinaryExpr)))
		case *ast.Ident: //
			//f.IdentToValue(value.(*ast.Ident))
			variable := f.GetVariable(value.(*ast.Ident).Name)
			if variable == nil {
				r = append(r, ir.NewParam(value.(*ast.Ident).Name, nil))
			} else {
				r = append(r, FixAlloc(f.GetCurrentBlock(), variable))
			}
		case *ast.BasicLit:
			toConstant := f.BasicLitToConstant(value.(*ast.BasicLit))
			r = append(r, toConstant)
		case *ast.CallExpr:
			r = append(r, f.doCallExpr(value.(*ast.CallExpr)))
		case *ast.IndexExpr:
			r = append(r, f.doIndexExpr(value.(*ast.IndexExpr)))
		case *ast.CompositeLit:
			r = append(r, f.doCompositeLit(value.(*ast.CompositeLit)))
		case *ast.SelectorExpr:
			r = append(r, f.doSelectorExpr(value.(*ast.SelectorExpr)))
		case *ast.UnaryExpr:
			r = append(r, f.doUnaryExpr(value.(*ast.UnaryExpr)))
		case *ast.StarExpr:
			r = append(r, f.doStartExpr(value.(*ast.StarExpr), "value"))
		case *ast.SliceExpr:
			r = append(r, f.doSliceExpr(value.(*ast.SliceExpr)))
		default:
			logrus.Error("not impl assignStmt.Rhs")
		}
	}
	//V
	for _, value := range assignStmt.Lhs {
		switch value.(type) {
		case *ast.Ident:
			s := value.(*ast.Ident)
			l = append(l, ir.NewParam(s.Name, nil))
		case *ast.BinaryExpr:
			l = append(l, f.doBinary(value.(*ast.BinaryExpr)))
		case *ast.BasicLit:
			l = append(l, f.BasicLitToConstant(value.(*ast.BasicLit)))
		case *ast.IndexExpr:
			l = append(l, f.doIndexExpr(value.(*ast.IndexExpr)))
		case *ast.CompositeLit:
			l = append(l, f.doCompositeLit(value.(*ast.CompositeLit)))
		case *ast.SelectorExpr: //TODO struts
			selectorExpr := value.(*ast.SelectorExpr)
			l = append(l, f.doSelectorExpr(selectorExpr))
		case *ast.StarExpr:
			l = append(l, f.doStartExpr(value.(*ast.StarExpr), "value"))
		default:
			fmt.Println("no impl assignStmt.Lhs")
		}
	}

	//check return
	if len(r) != len(l) {
		if len(r) == 1 && len(l) != 1 {
			if re, ok := r[0].Type().(*types.StructType); ok && strings.HasPrefix(re.Name(), "return.") { //return
				for index := range re.Fields {
					r = append(r, f.GetCurrentBlock().NewExtractValue(r[0], uint64(index)))
				}
			}
		} else {
			logrus.Error("not common return")
		}
	}
	//check
	for index := range l {
		if len(l) > index && len(r) > index {
			r[index] = f.doBoolean(r[index], l[index].Type())
		}
	}

	//check nil
	for index := range l {
		r[index] = FixNil(r[index], l[index].Type())
	}

	//ops
	switch assignStmt.Tok {
	case token.DEFINE: // :=
		var rep []value.Value
		for lindex, lvalue := range l {
			vName := lvalue.(*ir.Param).Name()
			if _, ok := r[lindex].(constant.Constant); ok {
				switch GetBaseType(r[lindex].Type()).(type) {
				case *types.IntType:
					newAlloc := f.NewType(r[lindex].Type())
					f.GetCurrentBlock().NewStore(r[lindex], newAlloc)
					f.PutVariable(vName, newAlloc)
				default:
					newAlloc := f.NewType(GetRealType(r[lindex].Type()))
					f.GetCurrentBlock().NewStore(r[lindex], newAlloc)
					f.PutVariable(vName, newAlloc)
				}
				rep = append(rep, f.GetVariable(vName))
			} else if f.IsSlice(r[lindex]) {
				i := r[lindex]
				f.PutVariable(vName, i)
				rep = append(rep, i)
			} else {
				newAlloc := f.NewType(r[lindex].Type())
				f.GetCurrentBlock().NewStore(r[lindex], newAlloc)
				f.PutVariable(vName, newAlloc)
				rep = append(rep, f.GetVariable(vName))
			}
			//else if types.IsStruct(r[lindex].Type()) {
			//	newAlloc := f.NewType(r[lindex].Type())
			//	f.CopyStruct(newAlloc, f.GetSrcPtr(r[lindex]))
			//	f.PutVariable(vName, newAlloc)
			//	rep = append(rep, newAlloc)
			//}
		}
		return rep
	case token.ASSIGN: // =
		var rep []value.Value
		for lIndex, lvalue := range l {
			var lv value.Value
			if p, ok := lvalue.(*ir.Param); ok {
				lv = f.GetSrcPtr(f.GetVariable(p.Name()))
			} else {
				lv = f.GetSrcPtr(lvalue)
			}
			f.GetCurrentBlock().NewStore(r[lIndex], lv)
			rep = append(rep, lvalue)
		}
		return rep
	case token.ADD_ASSIGN:
		var rep []value.Value
		for lIndex, lvalue := range l {
			vName := lvalue.(*ir.Param).Name()
			variable := f.GetVariable(vName)
			newAdd := f.GetCurrentBlock().NewAdd(utils.LoadValue(f.GetCurrentBlock(), variable), r[lIndex])
			f.GetCurrentBlock().NewStore(newAdd, f.GetSrcPtr(variable))
			rep = append(rep, lvalue)
		}
		return rep
	case token.SHR_ASSIGN:
		var rep []value.Value
		for lIndex, lvalue := range l {
			vName := lvalue.(*ir.Param).Name()
			variable := f.GetVariable(vName)
			newAdd := f.GetCurrentBlock().NewAShr(utils.LoadValue(f.GetCurrentBlock(), variable), r[lIndex])
			f.GetCurrentBlock().NewStore(newAdd, f.GetSrcPtr(variable))
			rep = append(rep, lvalue)
		}
		return rep
	case token.XOR_ASSIGN:
		var rep []value.Value
		for lIndex, lvalue := range l {
			vName := lvalue.(*ir.Param).Name()
			variable := f.GetVariable(vName)
			newAdd := f.GetCurrentBlock().NewXor(utils.LoadValue(f.GetCurrentBlock(), variable), r[lIndex])
			f.GetCurrentBlock().NewStore(newAdd, f.GetSrcPtr(variable))
			rep = append(rep, lvalue)
		}
		return rep
	case token.OR_ASSIGN:
		var rep []value.Value
		for lIndex, lvalue := range l {
			vName := lvalue.(*ir.Param).Name()
			variable := f.GetVariable(vName)
			newAdd := f.GetCurrentBlock().NewOr(utils.LoadValue(f.GetCurrentBlock(), variable), r[lIndex])
			f.GetCurrentBlock().NewStore(newAdd, f.GetSrcPtr(variable))
			rep = append(rep, lvalue)
		}
		return rep
	case token.AND_ASSIGN:
		var rep []value.Value
		for lIndex, lvalue := range l {
			vName := lvalue.(*ir.Param).Name()
			variable := f.GetVariable(vName)
			newAdd := f.GetCurrentBlock().NewAnd(utils.LoadValue(f.GetCurrentBlock(), variable), r[lIndex])
			f.GetCurrentBlock().NewStore(newAdd, f.GetSrcPtr(variable))
			rep = append(rep, lvalue)
		}
		return rep
	default:
		fmt.Println("doAssignStmt no impl")
	}
	return nil
}

//struts.v
func (f *FuncDecl) doSelectorExpr(selectorExpr *ast.SelectorExpr) value.Value {
	switch selectorExpr.X.(type) {
	case *ast.Ident:
		varName := GetIdentName(selectorExpr.X.(*ast.Ident))
		variable := f.GetVariable(varName)
		if a, ok := variable.(*ir.InstAlloca); ok && types.IsPointer(a.ElemType) { //pointer
			load := f.GetCurrentBlock().NewLoad(a)
			v, order, _ := f.GetStructDef(load, variable.Type(), selectorExpr.Sel)
			indexStruct := utils.IndexStruct(f.GetCurrentBlock(), v, order.Order)
			return utils.LoadValue(f.GetCurrentBlock(), indexStruct)
		} else {
			v, order, _ := f.GetStructDef(variable, variable.Type(), selectorExpr.Sel)
			indexStruct := utils.IndexStruct(f.GetCurrentBlock(), f.GetSrcPtr(v), order.Order)
			return utils.LoadValue(f.GetCurrentBlock(), indexStruct)
		}
	case *ast.CallExpr:
		callExpr := f.doCallExpr(selectorExpr.X.(*ast.CallExpr))
		v, order, _ := f.GetStructDef(callExpr, callExpr.Type(), selectorExpr.Sel)
		indexStruct := utils.IndexStruct(f.GetCurrentBlock(), f.GetSrcPtr(v), order.Order)
		return utils.LoadValue(f.GetCurrentBlock(), indexStruct)
	case *ast.SelectorExpr:
		expr := f.doSelectorExpr(selectorExpr.X.(*ast.SelectorExpr))
		v, order, _ := f.GetStructDef(expr, expr.Type(), selectorExpr.Sel)
		if types.IsPointer(expr.Type()) {
			indexStruct := utils.IndexStruct(f.GetCurrentBlock(), v, order.Order)
			return utils.LoadValue(f.GetCurrentBlock(), indexStruct)
		} else {
			indexStruct := utils.IndexStruct(f.GetCurrentBlock(), f.GetSrcPtr(v), order.Order)
			return utils.LoadValue(f.GetCurrentBlock(), indexStruct)
		}
	case *ast.CompositeLit:
		callExpr := f.doCompositeLit(selectorExpr.X.(*ast.CompositeLit))
		v, order, _ := f.GetStructDef(callExpr, callExpr.Type(), selectorExpr.Sel)
		indexStruct := utils.IndexStruct(f.GetCurrentBlock(), f.GetSrcPtr(v), order.Order)
		return utils.LoadValue(f.GetCurrentBlock(), indexStruct)
	default:
		logrus.Error("doSelectorExpr not impl")
	}
	return nil
}

type Inherit struct {
	Current StructDef
	Next    *Inherit
}

func (f *FuncDecl) find(m map[string]StructDef, name string) *Inherit {
	inherit := Inherit{}
	if t, ok := m[name]; ok {
		inherit.Current = t
		return &inherit
	}
	for key, value := range m {
		if value.IsInherit {
			defs, ok := f.StructDefs[key]
			if ok {
				inherit.Current = value
				inherit.Next = f.find(defs, name)
			}
		}
	}
	return &inherit
}

func (f *FuncDecl) GetStructDef(orig value.Value, typ types.Type, sel *ast.Ident) (value.Value, *StructDef, bool) {
	baseType := GetBaseType(typ)
	structDefs := f.StructDefs[baseType.Name()]
	identName := GetIdentName(sel)
	def, ok := structDefs[identName]
	if ok {
		return orig, &def, true
	} else {
		find := f.find(structDefs, identName)
		var v value.Value = orig
		for nil != find.Next {
			if types.IsPointer(find.Current.Typ) {
				indexStruct := utils.IndexStruct(f.GetCurrentBlock(), v, find.Current.Order)
				v = f.GetCurrentBlock().NewLoad(indexStruct)
			} else {
				v = utils.IndexStruct(f.GetCurrentBlock(), v, find.Current.Order)
			}
			find = find.Next
		}
		return v, &find.Current, true
	}
}

//do Boolean
func (f *FuncDecl) doBoolean(v value.Value, tyt types.Type) value.Value {
	if p, ok := v.(*ir.Param); ok && IsKeyWord(p.Name()) {
		parseBool, e := strconv.ParseBool(p.Name())
		if e != nil {
			return v
		}
		if parseBool {
			return constant.NewInt(types.I1, 1)
		} else {
			return constant.NewInt(types.I1, 0)
		}
	}
	return v
}

//index array return i8*
func (f *FuncDecl) doIndexExpr(index *ast.IndexExpr) value.Value {
	var kv value.Value
	switch index.Index.(type) {
	case *ast.BasicLit:
		kv = f.BasicLitToConstant(index.Index.(*ast.BasicLit))
	case *ast.CallExpr:
		kv = f.doCallExpr(index.Index.(*ast.CallExpr))
	case *ast.Ident:
		kv = f.doIdent(index.Index.(*ast.Ident))
	case *ast.BinaryExpr:
		kv = f.doBinary(index.Index.(*ast.BinaryExpr))
	case *ast.IndexExpr:
		kv = f.doIndexExpr(index.Index.(*ast.IndexExpr))
	case *ast.SelectorExpr:
		kv = f.doSelectorExpr(index.Index.(*ast.SelectorExpr))
	default:
		fmt.Println("doIndex not impl")
	}
	if _, ok := kv.Type().(*types.PointerType); ok {
		kv = f.GetCurrentBlock().NewLoad(kv)
	}
	switch index.X.(type) {
	case *ast.Ident:
		ident := index.X.(*ast.Ident)
		variable := f.GetVariable(ident.Name)
		//emType := f.FindSliceEmType(ident.Obj)
		return f.GetSliceIndex(variable, kv)
	//case *ast.CallExpr:
	//	expr := f.doCallExpr(index.X.(*ast.CallExpr))
	//	return f.GetSliceIndex(expr, kv)
	case *ast.SliceExpr: //return slice
		sliceExpr := index.X.(*ast.SliceExpr)
		//emType := f.FindSliceEmType(sliceExpr.X.(*ast.Ident).Obj)
		expr := f.doSliceExpr(sliceExpr)
		return f.GetSliceIndex(expr, kv)
	default:
		logrus.Error("no impl index.X")
	}
	return nil
}

func (f *FuncDecl) FindSliceEmType(id *ast.Object) types.Type {
	switch id.Decl.(type) {
	case *ast.AssignStmt:
		exprs := id.Decl.(*ast.AssignStmt).Rhs
		switch exprs[0].(type) {
		case *ast.SliceExpr:
			expr := exprs[0].(*ast.SliceExpr)
			return f.FindSliceEmType(expr.X.(*ast.Ident).Obj)
		case *ast.CompositeLit:
			expr := (exprs[0].(*ast.CompositeLit).Type).(*ast.ArrayType).Elt
			return f.GetTypeFromName(GetIdentName(expr.(*ast.Ident)))
		case *ast.CallExpr:
			expr := (exprs[0].(*ast.CallExpr).Args[0]).(*ast.Ident)
			return f.FindSliceEmType(expr.Obj)
		default:
			fmt.Println("asdfasdfasdfasdfsd")
		}
	case *ast.ValueSpec:
		expr := id.Decl.(*ast.ValueSpec).Type.(*ast.ArrayType).Elt
		return f.GetTypeFromName(GetIdentName(expr.(*ast.Ident)))
	default:
		logrus.Error("not find Slice em type")
	}
	return nil
}

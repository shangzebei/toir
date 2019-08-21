package compile

var keywords = map[string]struct{}{
	"if":          {},
	"else":        {},
	"func":        {},
	"return":      {},
	"type":        {},
	"struct":      {},
	"var":         {},
	"package":     {},
	"for":         {},
	"break":       {},
	"continue":    {},
	"import":      {},
	"true":        {},
	"false":       {},
	"interface":   {},
	"range":       {},
	"switch":      {},
	"case":        {},
	"fallthrough": {},
	"default":     {},
}

func IsKeyWord(key string) bool {
	_, ok := keywords[key]
	return ok
}

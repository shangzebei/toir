package convert

var kv map[string]interface{}

func Store(name string, v interface{}) {
	if kv == nil {
		kv = make(map[string]interface{})
	}
	kv[name] = v
}

func Get(name string) interface{} {
	i, ok := kv[name]
	if ok {
		return i
	}
	return nil
}

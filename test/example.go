package test

type SS struct {
	Len   int
	Cap   int
	bytes int
}

//i8 * checkAppend(slice *)
func checkAppend(s *SS) {
	if s.Len >= s.Cap {
		//return def.SliceIntToI8(make([]int, s.Len+4))
	} else {
		//return def.SliceToI8(s)
	}
}

func main() {
	//test.test()
}

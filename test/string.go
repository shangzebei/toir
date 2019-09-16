package test

func main() {
	stringBase()
}

//
//
//
//func sadd() {
//	a := "asdfasdfsdfsd"
//	b := a + "hello"
//	print(b)
//}
//
//func kk()  {
//	strings.HasPrefix()
//}

//func string2bytes() {
//	var kk = []byte("shangzebei")
//	for _, value := range kk {
//		print("%d", value)
//	}
//}

func stringBase() {
	a := "shangzebei"
	print("%s\n", a)
	print("%d\n", len(a))
	print("%c\n", a[1])
	for key, value := range a {
		print("%d==%c\n", key, value)
	}
	print("%s\n", a[3:5])
}

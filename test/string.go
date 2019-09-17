package test

func main() {
	stringBase()
	stringJoin()
	string2bytes()
}

func stringJoin() {
	a := "shangzebei"
	print("%d\n", len(a))
	b := "hello"
	print("%d\n", len(b))
	c := a + b
	print("%d\n", len(c))
	print(c)
}

func string2bytes() {
	b := []byte("shangzebei")
	for _, value := range b {
		print("%d ", value)
	}
}

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

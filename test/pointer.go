package test

type A struct {
	Name string
}

func main() {
	a := 90
	b := 80
	swap(&a, &b)
	print("%d-%d\n", a, b)
	i := A{Name: "ttttt"}
	do(i)
}

func swap(a *int, b *int) {
	*a = 44
	*b = 23
}

func swapFloat(a *int64, b *int64) {

}

func do(a A) {
	print("%s\n", a.Name)
}

package test

func main() {
	sw1()
	sw2()
	sw3()
}
func sw1() {
	a := 60
	show(-1000)
	switch a {
	case 70:
		show(1)
	case 60:
		show(2)
	case 81:
		show(3)
	default:
		show(200)
	}
	show(1000)
}

func sw2() {
	a := 80
	show(-1000)
	switch a {
	case 70:
		show(1)
	case 60:
		show(2)
	case 81:
		show(3)
	default:
		show(200)
	}
	show(1000)
}

func sw3() {
	a := 80
	show(-1000)
	switch {
	case a == 70:
		show(1)
	case a == 60:
		show(2)
	case a == 80:
		show(3)
	default:
		show(200)
	}
	show(1000)
}

func show(a int) {
	print("%d\n", a)
}

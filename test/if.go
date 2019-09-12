package test

func main() {
	if1234()
	//f2()
	if1(101)    // yes
	if1else(12) //yes
	if3()       //this is true
	//if4And()    //
	//if5()
}

func f2() {
	a := 23
	b := 100
	if a > 10 || b < 10 {
		print("this is true\n")
	}
}

func if1(a int) {
	if a > 100 {
		print("f2 yes\n")
	}
}

func if1else(a int) {
	if a > 100 {
		print("yes\n")
	} else {
		print("no\n")
	}
}

func if3() {
	a := 23
	b := 100
	c := 80
	if a > 40 || b < 10 || c < 100 {
		print("this is true\n")
	}
}

func if4And() {
	a := 23
	b := 100
	c := 80
	if a < 40 && b < 101 && c < 100 {
		print("if4And\n")
	}
}

func if5() {
	var a int
	if a = 90; a > 50 {
		print("%d\n", a)
	}
}

func if1234() {
	a := 190
	print("aaaaaaaaaaaaaaaa\n")
	if a > 100 {
		print("yes\n")
	} else {
		print("no\n")
	}
	print("bbbbbbbbbbbbbbbb\n")

}

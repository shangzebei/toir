package test

import "fmt"

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
		fmt.Printf("this is true\n")
	}
}

func if1(a int) {
	if a > 100 {
		fmt.Printf("f2 yes\n")
	}
}

func if1else(a int) {
	if a > 100 {
		fmt.Printf("yes\n")
	} else {
		fmt.Printf("no\n")
	}
}

func if3() {
	a := 23
	b := 100
	c := 80
	if a > 40 || b < 10 || c < 100 {
		fmt.Printf("this is true\n")
	}
}

func if4And() {
	a := 23
	b := 100
	c := 80
	if a < 40 && b < 101 && c < 100 {
		fmt.Printf("if4And\n")
	}
}

func if5() {
	var a int
	if a = 90; a > 50 {
		fmt.Printf("%d\n", a)
	}
}

func if1234() {
	a := 190
	fmt.Printf("aaaaaaaaaaaaaaaa\n")
	if a > 100 {
		fmt.Printf("yes\n")
	} else {
		fmt.Printf("no\n")
	}
	fmt.Printf("bbbbbbbbbbbbbbbb\n")

}

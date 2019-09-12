package test

import "fmt"

//type KK int
//type PP KK

func main() {
	//var a PP
	//a = PP(1)
	typeFun(func() {
		print("asdfsadfsdfsd\n")
	})
}

type F func()

//func typeV(pp PP)  {
//
//}

func typeFun(f F) {
	f()
}

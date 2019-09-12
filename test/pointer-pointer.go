package main

import "external"

func main() {
	i := 100
	iptr1 := &i
	iptr2 := &iptr1
	iptr3 := &iptr2

	print("i: %d\n", i)               // i: 100
	print("*iptr1: %d\n", *iptr1)     // *iptr1: 100
	print("**iptr2: %d\n", **iptr2)   // **iptr2: 100
	print("***iptr3: %d\n", ***iptr3) // ***iptr3: 100

	i = 200
	print("i: %d\n", i)               // i: 200
	print("*iptr1: %d\n", *iptr1)     // *iptr1: 200
	print("**iptr2: %d\n", **iptr2)   // **iptr2: 200
	print("***iptr3: %d\n", ***iptr3) // ***iptr3: 200

	*iptr1 = 300
	print("i: %d\n", i)               // i: 300
	print("*iptr1: %d\n", *iptr1)     // *iptr1: 300
	print("**iptr2: %d\n", **iptr2)   // **iptr2: 300
	print("***iptr3: %d\n", ***iptr3) // ***iptr3: 300
	//
	**iptr2 = 400
	print("i: %d\n", i)               // i: 400
	print("*iptr1: %d\n", *iptr1)     // *iptr1: 400
	print("**iptr2: %d\n", **iptr2)   // **iptr2: 400
	print("***iptr3: %d\n", ***iptr3) // ***iptr3: 400
	////
	***iptr3 = 500
	print("i: %d\n", i)               // i: 500
	print("*iptr1: %d\n", *iptr1)     // *iptr1: 500
	print("**iptr2: %d\n", **iptr2)   // **iptr2: 500
	print("***iptr3: %d\n", ***iptr3) // ***iptr3: 500

}

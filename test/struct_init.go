package test

//import "fmt"

type ListNode struct {
	Val  int
	Next *KK
}
type KK struct {
	T int
	B int
	C int
}

func init1() {
	a := 90
	b := 11
	c := 22
	node := ListNode{Val: a, Next: &KK{
		19,
		b,
		c,
	}}
	fmt.Printf("22-%d\n", node.Next.C)
	fmt.Printf("11-%d\n", node.Next.B)
	fmt.Printf("19-%d\n", node.Next.T)
}

func main() {
	init1()
	init2()
	init3()
	inin4()
}

func init2() {
	node := ListNode{Val: 111, Next: &KK{
		T: 11,
		B: 22,
		C: 99,
	}}

	fmt.Printf("99-%d\n", node.Next.C)
	fmt.Printf("22-%d\n", node.Next.B)
	fmt.Printf("11-%d\n", node.Next.T)
}

type AA struct {
	Val  int
	Next *AA
}

type B struct {
	*AA
	Pre *B
}

func init3() {
	aa := AA{
		Val:  11,
		Next: nil,
	}
	i := B{
		AA:  &aa,
		Pre: nil,
	}
	fmt.Printf("11-%d\n", i.AA.Val)
}

type Bar struct {
	num int64
}

type Foo struct {
	num int64
	bar *Bar
}

func GetFooPtr() *Foo {
	f := Foo{
		num: 300,
		bar: &Bar{num: 400},
	}
	return &f
}

func inin4()  {
	foo := &Foo{
		num: 100,
		bar: &Bar{num: 200},
	}

	fmt.Printf("foo.bar.num: %d\n", foo.bar.num) // foo.bar.num: 200
	fmt.Printf("foo.num: %d\n", foo.num)         // foo.num: 100
	fmt.Printf("foo.bar.num: %d\n", foo.bar.num) // foo.bar.num: 200
	fmt.Printf("foo.num: %d\n", foo.num)         // foo.num: 100

	foo2 := GetFooPtr()
	fmt.Printf("foo2.bar.num: %d\n", foo2.bar.num) // foo2.bar.num: 400
	fmt.Printf("foo2.num: %d\n", foo2.num)         // foo2.num: 300
	fmt.Printf("foo2.bar.num: %d\n", foo2.bar.num) // foo2.bar.num: 400
	fmt.Printf("foo2.num: %d\n", foo2.num)         // foo2.num: 300
}
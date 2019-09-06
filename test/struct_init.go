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

func main() {
	init1()
	init2()
}

func init2() {
	node := ListNode{Val: 111, Next: &KK{
		T: 11,
		B: 22,
		C: 99,
	}}

	fmt.Printf("%d\n", node.Next.C)
	fmt.Printf("%d\n", node.Next.B)
	fmt.Printf("%d\n", node.Next.T)
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
	fmt.Printf("%d\n", node.Next.C)
	fmt.Printf("%d\n", node.Next.B)
	fmt.Printf("%d\n", node.Next.T)
}

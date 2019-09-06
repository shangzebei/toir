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
	node := ListNode{Val: 111, Next: &KK{
		T: 11,
		B: 22,
		C: 99,
	}}
	fmt.Printf("%d\n", node.Next.C)
	fmt.Printf("%d\n", node.Next.B)
	fmt.Printf("%d\n", node.Next.T)
}

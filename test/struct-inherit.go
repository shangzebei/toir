package test

import "fmt"

type ListNode struct {
	Val  int
	Next *ListNode
}

type CircularListNode struct {
	ListNode
	Pre *CircularListNode
}

func main() {
	node := CircularListNode{}
	node.Val = 89
	fmt.Printf("%d\n", node.ListNode.Val)
	fmt.Printf("%d\n", node.Val)
}

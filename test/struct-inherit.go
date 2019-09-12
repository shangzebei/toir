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
	print("%d\n", node.ListNode.Val)
	print("%d\n", node.Val)
}

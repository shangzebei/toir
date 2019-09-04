package llvm

import (
	"fmt"
	"testing"
)

type TT struct {
}

func TestName(t *testing.T) {
	fmt.Println(totalHammingDistance([]int{4, 14, 2}))
}

func totalHammingDistance(nums []int) int {
	max := 0
	for _, num := range nums {
		if num > max {
			max = num
		}
	}
	distance := 0
	for i := 0; max > 0; i++ {
		binaryOnes := 0
		for _, num := range nums {
			if 1 == (num >> uint(i) & 1) {
				binaryOnes += 1
			}
		}
		distance += (len(nums) - binaryOnes) * binaryOnes
		max >>= 1
	}
	return distance
}

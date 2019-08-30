package llvm

import (
	"testing"
)

type TT struct {
}

func TestName(t *testing.T) {
	aaa(&TT{})
}

func aaa(t *TT) {

}

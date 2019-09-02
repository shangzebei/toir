package utils

import (
	"github.com/llir/llvm/ir"
	"strings"
)

func NewComment(block *ir.Block, s string) *Comment {
	comment := &Comment{
		Text: s,
	}

	block.Insts = append(block.Insts, comment)
	return comment
}

type Comment struct {
	Text string
	// embed a dummy ir.Instruction to have Comment implement the ir.Instruction
	// interface.
	ir.Instruction
}

func (c *Comment) LLString() string {
	return "; " + strings.Replace(c.Text, "\n", "; ", -1)
}

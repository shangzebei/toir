package convert

import (
	"fmt"
	"github.com/llir/llvm/ir"
)

/////////////////////////////////////////////////////

func (f *FuncDecl) popBlock() {
	fmt.Println("pop block ###### ")
	//f.blockPointer[f.GetCurrent().ID()]=
	f.blockPointer[f.GetCurrent()] = f.blockPointer[f.GetCurrent()] - 1

}

func (f *FuncDecl) newBlock() *ir.Block {
	fmt.Println("push block ###### ")
	newBlock := f.GetCurrent().NewBlock("")
	f.blockPointer[f.GetCurrent()] = f.blockPointer[f.GetCurrent()] + 1
	return newBlock
}

func (f *FuncDecl) GetCurrentBlock() *ir.Block {
	blocks := f.GetCurrent().Blocks
	if len(blocks) == 0 {
		fmt.Println("this fun is no block!")
		return nil
	}
	i, ok := f.blockPointer[f.GetCurrent()]
	if ok {
		return blocks[i-1]
	} else {
		return blocks[0]
	}

}

/////////////////////////////////////////////////////

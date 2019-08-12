package convert

import (
	"fmt"
	"github.com/llir/llvm/ir"
)

/////////////////////////////////////////////////////

func (f *FuncDecl) popBlock() {
	fmt.Println("pop block ###### ")
	blocks := f.blockHeap[f.GetCurrent()]
	f.blockHeap[f.GetCurrent()] = f.blockHeap[f.GetCurrent()][0 : len(blocks)-1]

}

func (f *FuncDecl) newBlock() *ir.Block {
	//ul := uuid.NewV4()
	newBlock := f.GetCurrent().NewBlock("")
	fmt.Println("push block ###### ")
	f.blockHeap[f.GetCurrent()] = append(f.blockHeap[f.GetCurrent()], newBlock)
	return newBlock
}

func (f *FuncDecl) GetCurrentBlock() *ir.Block {
	blocks := f.blockHeap[f.GetCurrent()]
	return f.blockHeap[f.GetCurrent()][len(blocks)-1]
}

/////////////////////////////////////////////////////

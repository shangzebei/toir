package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
)

/////////////////////////////////////////////////////

func (f *FuncDecl) popBlock() {
	blocks := f.blockHeap[f.GetCurrent()]
	logrus.Debugf("popFunc block ### %p ### ", blocks[len(blocks)-1])
	f.blockHeap[f.GetCurrent()] = blocks[0 : len(blocks)-1]
}

func (f *FuncDecl) newBlock() *ir.Block {
	//ul := uuid.NewV4()
	newBlock := f.GetCurrent().NewBlock("")
	blocks := f.blockHeap[f.GetCurrent()]
	logrus.Debugf("push block ### %p ### ", newBlock)
	f.blockHeap[f.GetCurrent()] = append(blocks, newBlock)
	return newBlock
}

func (f *FuncDecl) GetCurrentBlock() *ir.Block {
	blocks := f.blockHeap[f.GetCurrent()]
	if blocks == nil {
		logrus.Warn("current not find block")
		return nil
	}
	return f.blockHeap[f.GetCurrent()][len(blocks)-1]
}

/////////////////////////////////////////////////////

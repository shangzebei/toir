package compile

import (
	"github.com/llir/llvm/ir"
	"github.com/sirupsen/logrus"
)

/////////////////////////////////////////////////////

func (f *FuncDecl) popBlock() {
	logrus.Debug("pop block ###### ")
	blocks := f.blockHeap[f.GetCurrent()]
	f.blockHeap[f.GetCurrent()] = f.blockHeap[f.GetCurrent()][0 : len(blocks)-1]

}

func (f *FuncDecl) newBlock() *ir.Block {
	//ul := uuid.NewV4()
	newBlock := f.GetCurrent().NewBlock("")
	logrus.Debug("push block ###### ")
	f.blockHeap[f.GetCurrent()] = append(f.blockHeap[f.GetCurrent()], newBlock)
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

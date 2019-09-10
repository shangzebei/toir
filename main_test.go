package main

import (
	"fmt"
	"io/ioutil"
	"os/exec"
	"strings"
	"testing"
)

func TestAll(t *testing.T) {
	dir, _ := ioutil.ReadDir("test")
	for _, value := range dir {
		if !value.IsDir() {
			fmt.Println("test:::: ", "test/"+value.Name())
			index := strings.LastIndex(value.Name(), ".")
			i := value.Name()[:index]
			s := "test/temp/" + value.Name()[:index]
			Build("test/"+value.Name(), s)
			cmd := exec.Command("lli", s+".ll")
			output, _ := cmd.CombinedOutput()
			ioutil.WriteFile("test/testdata/"+i+".txt", output, 0644)
		}
	}
}

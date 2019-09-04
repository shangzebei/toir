package main

import (
	"fmt"
	"io/ioutil"
	"testing"
)

func TestAll(t *testing.T) {
	dir, _ := ioutil.ReadDir("test")
	for _, value := range dir {
		if !value.IsDir() {
			fmt.Println("test:::: ", "test/"+value.Name())
			Build("test/" + value.Name())
		}
	}
}

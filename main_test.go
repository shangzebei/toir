package main

import (
	"fmt"
	"io/ioutil"
	"strings"
	"testing"
)

func TestAll(t *testing.T) {
	dir, _ := ioutil.ReadDir("test")
	for _, value := range dir {
		if !value.IsDir() {
			fmt.Println("test:::: ", "test/"+value.Name())
			index := strings.LastIndex(value.Name(), ".")
			Build("test/"+value.Name(), "test/bin/"+value.Name()[:index])
		}
	}
}

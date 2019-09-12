package test

func main() {
	for2break()
}

func for2break() {
	for j := 0; j < 10; j++ {
		for i := 0; i < 10; i++ {
			if i > 5 {
				print("break\n")
				break
			} else {
				print("no\n")
			}
		}
		print("bbbbbbbbbbbbbbbb\n")
	}
}

func for1break() {
	for i := 0; i < 10; i++ {
		if i > 5 {
			print("break\n")
			break
		} else {
			print("no\n")
		}
	}
	print("bbbbbbbbbbbbbbbbb\n")
}

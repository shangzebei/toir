%One = type {}
%Two = type {}

@str.0 = constant [10 x i8] c"aaaaaaaa\0A\00"

define void @a2() {
; <label>:0
	call void @a1()
	ret void
}

declare i32 @printf(i8*, ...)

define void @a1() {
; <label>:0
	call void @a2()
	%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.0, i64 0, i64 0))
	ret void
}

define void @main.One.Kkkk(%One* %t) {
; <label>:0
	ret void
}

define void @main.Two.two1(%Two* %t) {
; <label>:0
	call void @main.Two.two(%Two* %t)
	ret void
}

define void @main.Two.two(%Two* %t) {
; <label>:0
	call void @main.Two.two1(%Two* %t)
	ret void
}

define void @main() {
; <label>:0
	ret void
}

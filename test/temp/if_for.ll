@str.0 = constant [6 x i8] c"hello\00"

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = alloca i32
	store i32 100, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp sgt i32 %2, 50
	br i1 %3, label %4, label %11

; <label>:4
	%5 = load i32, i32* %1
	%6 = icmp sgt i32 %5, 60
	br i1 %6, label %7, label %9

; <label>:7
	%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.0, i64 0, i64 0))
	br label %10

; <label>:9
	br label %10

; <label>:10
	ret void

; <label>:11
	br label %12

; <label>:12
	ret void
}

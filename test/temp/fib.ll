@str.0 = constant [10 x i8] c"fib = %d\0A\00"

define i32 @fib(i32 %num) {
; <label>:0
	%1 = alloca i32
	store i32 %num, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp slt i32 %2, 2
	br i1 %3, label %4, label %6

; <label>:4
	%5 = load i32, i32* %1
	ret i32 %5

; <label>:6
	br label %7

; <label>:7
	%8 = load i32, i32* %1
	%9 = sub i32 %8, 2
	%10 = call i32 @fib(i32 %9)
	%11 = load i32, i32* %1
	%12 = sub i32 %11, 1
	%13 = call i32 @fib(i32 %12)
	%14 = add i32 %10, %13
	ret i32 %14
}

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = call i32 @fib(i32 34)
	%2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.0, i64 0, i64 0), i32 %1)
	ret void
}

@str.0 = constant [4 x i8] c"%d\0A\00"

define i32 @add(i32 %a, i32 %b) {
; <label>:0
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca i32
	store i32 %b, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = add i32 %3, %4
	ret i32 %5
}

define i32 @sul(i32 %a, i32 %b) {
; <label>:0
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca i32
	store i32 %b, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = sub i32 %3, %4
	ret i32 %5
}

define i32 @call() {
; <label>:0
	%1 = call i32 @add(i32 5, i32 6)
	ret i32 %1
}

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = add i32 1, 1
	%2 = sub i32 %1, 1
	%3 = call i32 @call()
	%4 = call i32 @sul(i32 %3, i32 1)
	%5 = call i32 @add(i32 %2, i32 %4)
	%6 = alloca i32
	store i32 %5, i32* %6
	%7 = load i32, i32* %6
	%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0), i32 %7)
	ret void
}

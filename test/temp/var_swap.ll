@str.0 = constant [7 x i8] c"%d-%d\0A\00"

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = alloca i32
	store i32 5, i32* %1
	%2 = alloca i32
	store i32 6, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0), i32 %3, i32 %4)
	ret void
}

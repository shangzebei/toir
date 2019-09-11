%return.2.1 = type { i32, i32 }

@str.0 = constant [7 x i8] c"%d %d\0A\00"
@str.1 = constant [10 x i8] c"%d %d %d\0A\00"
@str.2 = constant [8 x i8] c"%d--%d\0A\00"

declare i32 @printf(i8*, ...)

define void @mulVar() {
; <label>:0
	%1 = alloca i32
	store i32 10, i32* %1
	%2 = alloca i32
	store i32 20, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0), i32 %3, i32 %4)
	%6 = alloca i32
	store i32 10, i32* %6
	%7 = alloca i32
	store i32 20, i32* %7
	%8 = alloca i32
	store i32 30, i32* %8
	%9 = load i32, i32* %6
	%10 = load i32, i32* %7
	%11 = load i32, i32* %8
	%12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0), i32 %9, i32 %10, i32 %11)
	ret void
}

define %return.2.1 @mulFunc(i32 %a) {
; <label>:0
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca %return.2.1
	%3 = getelementptr %return.2.1, %return.2.1* %2, i32 0, i32 0
	store i32 1, i32* %3
	%4 = getelementptr %return.2.1, %return.2.1* %2, i32 0, i32 1
	store i32 5, i32* %4
	%5 = load %return.2.1, %return.2.1* %2
	ret %return.2.1 %5
}

define void @main() {
; <label>:0
	%1 = call %return.2.1 @mulFunc(i32 1)
	%2 = extractvalue %return.2.1 %1, 0
	%3 = extractvalue %return.2.1 %1, 1
	%4 = alloca i32
	store i32 %2, i32* %4
	%5 = alloca i32
	store i32 %3, i32* %5
	%6 = load i32, i32* %4
	%7 = load i32, i32* %5
	%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.2, i64 0, i64 0), i32 %6, i32 %7)
	call void @mulVar()
	ret void
}

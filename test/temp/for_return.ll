@str.0 = constant [7 x i8] c"begin\0A\00"
@str.1 = constant [17 x i8] c"asdfasdfsdf--%d\0A\00"
@str.2 = constant [5 x i8] c">5 \0A\00"
@str.3 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"

declare i32 @printf(i8*, ...)

define i32 @forr() {
; <label>:0
	%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0))
	; init block
	%2 = alloca i32
	store i32 0, i32* %2
	br label %6

; <label>:3
	; add block
	%4 = load i32, i32* %2
	%5 = add i32 %4, 1
	store i32 %5, i32* %2
	br label %6

; <label>:6
	; cond Block begin
	%7 = load i32, i32* %2
	%8 = icmp sle i32 %7, 11
	; cond Block end
	br i1 %8, label %9, label %18

; <label>:9
	%10 = load i32, i32* %2
	%11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.1, i64 0, i64 0), i32 %10)
	%12 = load i32, i32* %2
	%13 = icmp sgt i32 %12, 5
	br i1 %13, label %14, label %16

; <label>:14
	%15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.2, i64 0, i64 0))
	br label %17

; <label>:16
	br label %17

; <label>:17
	br label %3

; <label>:18
	; empty block
	ret i32 0
}

define i32 @ifrr() {
; <label>:0
	%1 = alloca i32
	store i32 9, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp sgt i32 %2, 5
	br i1 %3, label %4, label %6

; <label>:4
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.3, i64 0, i64 0))
	ret i32 1

; <label>:6
	br label %7

; <label>:7
	ret i32 0
}

define void @main() {
; <label>:0
	%1 = call i32 @forr()
	%2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0), i32 %1)
	%3 = call i32 @ifrr()
	%4 = call i32 @forr()
	ret void
}

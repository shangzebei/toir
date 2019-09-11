@str.0 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.1 = constant [14 x i8] c"bbbbbbbbbbbb\0A\00"
@str.2 = constant [4 x i8] c"%d\0A\00"
@str.3 = constant [16 x i8] c"ggggggggggggggg\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [18 x i8] c"asdfasdfasd%d-%d\0A\00"
@str.6 = constant [14 x i8] c"bbbbbbbbbbbb\0A\00"
@str.7 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.8 = constant [17 x i8] c"cccccccccccc %d\0A\00"

define i32 @max() {
; <label>:0
	ret i32 3
}

declare i32 @printf(i8*, ...)

define void @for1() {
; <label>:0
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = call i32 @max()
	%7 = load i32, i32* %1
	%8 = icmp sle i32 %7, %6
	; cond Block end
	br i1 %8, label %9, label %11

; <label>:9
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.0, i64 0, i64 0))
	br label %2

; <label>:11
	; empty block
	%12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.1, i64 0, i64 0))
	; init block
	%13 = alloca i32
	store i32 0, i32* %13
	br label %17

; <label>:14
	; add block
	%15 = load i32, i32* %13
	%16 = add i32 %15, 1
	store i32 %16, i32* %13
	br label %17

; <label>:17
	; cond Block begin
	%18 = load i32, i32* %13
	%19 = icmp sle i32 %18, 2
	; cond Block end
	br i1 %19, label %20, label %23

; <label>:20
	%21 = load i32, i32* %13
	%22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0), i32 %21)
	br label %14

; <label>:23
	; empty block
	%24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.3, i64 0, i64 0))
	ret void
}

define void @for2() {
; <label>:0
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 10
	; cond Block end
	br i1 %7, label %8, label %11

; <label>:8
	%9 = load i32, i32* %1
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0), i32 %9)
	br label %2

; <label>:11
	; empty block
	ret void
}

define i32 @for23() {
; <label>:0
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 3
	; cond Block end
	br i1 %7, label %8, label %21

; <label>:8
	; init block
	%9 = alloca i32
	store i32 0, i32* %9
	br label %13

; <label>:10
	; add block
	%11 = load i32, i32* %9
	%12 = add i32 %11, 1
	store i32 %12, i32* %9
	br label %13

; <label>:13
	; cond Block begin
	%14 = load i32, i32* %9
	%15 = icmp slt i32 %14, 3
	; cond Block end
	br i1 %15, label %16, label %20

; <label>:16
	%17 = load i32, i32* %1
	%18 = load i32, i32* %9
	%19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.5, i64 0, i64 0), i32 %17, i32 %18)
	br label %10

; <label>:20
	; empty block
	br label %2

; <label>:21
	; empty block
	ret i32 0
}

define void @for4() {
; <label>:0
	%1 = alloca i32
	store i32 90, i32* %1
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
	%8 = icmp slt i32 %7, 3
	; cond Block end
	br i1 %8, label %9, label %21

; <label>:9
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.6, i64 0, i64 0))
	; init block
	%11 = alloca i32
	store i32 0, i32* %11
	br label %15

; <label>:12
	; add block
	%13 = load i32, i32* %11
	%14 = add i32 %13, 1
	store i32 %14, i32* %11
	br label %15

; <label>:15
	; cond Block begin
	%16 = load i32, i32* %11
	%17 = icmp slt i32 %16, 2
	; cond Block end
	br i1 %17, label %18, label %20

; <label>:18
	%19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.7, i64 0, i64 0))
	br label %12

; <label>:20
	; empty block
	br label %3

; <label>:21
	; empty block
	%22 = load i32, i32* %1
	%23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.8, i64 0, i64 0), i32 %22)
	ret void
}

define void @for5() {
; <label>:0
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %3

; <label>:2
	; add block
	br label %3

; <label>:3
	; cond Block begin
	; cond Block end
	br label %4

; <label>:4
	%5 = load i32, i32* %1
	%6 = add i32 %5, 1
	store i32 %6, i32* %1
	%7 = load i32, i32* %1
	%8 = icmp sgt i32 %7, 5
	br i1 %8, label %9, label %10

; <label>:9
	br label %12

; <label>:10
	br label %11

; <label>:11
	br label %2

; <label>:12
	; empty block
	ret void
}

define void @main() {
; <label>:0
	call void @for2()
	%1 = call i32 @for23()
	call void @for1()
	call void @for4()
	ret void
}

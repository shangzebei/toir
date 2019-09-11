@str.0 = constant [7 x i8] c"break\0A\00"
@str.1 = constant [4 x i8] c"no\0A\00"
@str.2 = constant [18 x i8] c"bbbbbbbbbbbbbbbb\0A\00"
@str.3 = constant [7 x i8] c"break\0A\00"
@str.4 = constant [4 x i8] c"no\0A\00"
@str.5 = constant [19 x i8] c"bbbbbbbbbbbbbbbbb\0A\00"

declare i32 @printf(i8*, ...)

define void @for2break() {
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
	br i1 %7, label %8, label %26

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
	%15 = icmp slt i32 %14, 10
	; cond Block end
	br i1 %15, label %16, label %24

; <label>:16
	%17 = load i32, i32* %9
	%18 = icmp sgt i32 %17, 5
	br i1 %18, label %19, label %21

; <label>:19
	%20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0))
	br label %24

; <label>:21
	%22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0))
	br label %23

; <label>:23
	br label %10

; <label>:24
	; empty block
	%25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.2, i64 0, i64 0))
	br label %2

; <label>:26
	; empty block
	ret void
}

define void @for1break() {
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
	br i1 %7, label %8, label %16

; <label>:8
	%9 = load i32, i32* %1
	%10 = icmp sgt i32 %9, 5
	br i1 %10, label %11, label %13

; <label>:11
	%12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.3, i64 0, i64 0))
	br label %16

; <label>:13
	%14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0))
	br label %15

; <label>:15
	br label %2

; <label>:16
	; empty block
	%17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.5, i64 0, i64 0))
	ret void
}

define void @main() {
; <label>:0
	call void @for2break()
	ret void
}

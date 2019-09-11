@str.0 = constant [14 x i8] c"this is true\0A\00"
@str.1 = constant [8 x i8] c"f2 yes\0A\00"
@str.2 = constant [5 x i8] c"yes\0A\00"
@str.3 = constant [4 x i8] c"no\0A\00"
@str.4 = constant [14 x i8] c"this is true\0A\00"
@str.5 = constant [8 x i8] c"if4And\0A\00"
@str.6 = constant [4 x i8] c"%d\0A\00"
@str.7 = constant [18 x i8] c"aaaaaaaaaaaaaaaa\0A\00"
@str.8 = constant [5 x i8] c"yes\0A\00"
@str.9 = constant [4 x i8] c"no\0A\00"
@str.10 = constant [18 x i8] c"bbbbbbbbbbbbbbbb\0A\00"

declare i32 @printf(i8*, ...)

define void @f2() {
; <label>:0
	%1 = alloca i32
	store i32 23, i32* %1
	%2 = alloca i32
	store i32 100, i32* %2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 10
	br i1 %4, label %5, label %8

; <label>:5
	%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.0, i64 0, i64 0))
	br label %11

; <label>:7
	br label %11

; <label>:8
	%9 = load i32, i32* %2
	%10 = icmp slt i32 %9, 10
	br i1 %4, label %5, label %7

; <label>:11
	ret void
}

define void @if1(i32 %a) {
; <label>:0
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp sgt i32 %2, 100
	br i1 %3, label %4, label %6

; <label>:4
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0))
	br label %7

; <label>:6
	br label %7

; <label>:7
	ret void
}

define void @if1else(i32 %a) {
; <label>:0
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp sgt i32 %2, 100
	br i1 %3, label %4, label %6

; <label>:4
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.2, i64 0, i64 0))
	br label %8

; <label>:6
	%7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0))
	br label %8

; <label>:8
	ret void
}

define void @if3() {
; <label>:0
	%1 = alloca i32
	store i32 23, i32* %1
	%2 = alloca i32
	store i32 100, i32* %2
	%3 = alloca i32
	store i32 80, i32* %3
	%4 = load i32, i32* %1
	%5 = icmp sgt i32 %4, 40
	br i1 %5, label %6, label %9

; <label>:6
	%7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.4, i64 0, i64 0))
	br label %15

; <label>:8
	br label %15

; <label>:9
	%10 = load i32, i32* %2
	%11 = icmp slt i32 %10, 10
	br i1 %5, label %6, label %12

; <label>:12
	%13 = load i32, i32* %3
	%14 = icmp slt i32 %13, 100
	br i1 %5, label %6, label %8

; <label>:15
	ret void
}

define void @if4And() {
; <label>:0
	%1 = alloca i32
	store i32 23, i32* %1
	%2 = alloca i32
	store i32 100, i32* %2
	%3 = alloca i32
	store i32 80, i32* %3
	%4 = load i32, i32* %1
	%5 = icmp slt i32 %4, 40
	br i1 %5, label %9, label %8

; <label>:6
	%7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.5, i64 0, i64 0))
	br label %15

; <label>:8
	br label %15

; <label>:9
	%10 = load i32, i32* %2
	%11 = icmp slt i32 %10, 101
	br i1 %5, label %12, label %8

; <label>:12
	%13 = load i32, i32* %3
	%14 = icmp slt i32 %13, 100
	br i1 %5, label %6, label %8

; <label>:15
	ret void
}

define void @if5() {
; <label>:0
	%1 = alloca i32
	store i32 90, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp sgt i32 %2, 50
	br i1 %3, label %4, label %7

; <label>:4
	%5 = load i32, i32* %1
	%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.6, i64 0, i64 0), i32 %5)
	br label %8

; <label>:7
	br label %8

; <label>:8
	ret void
}

define void @if1234() {
; <label>:0
	%1 = alloca i32
	store i32 190, i32* %1
	%2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.7, i64 0, i64 0))
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 100
	br i1 %4, label %5, label %7

; <label>:5
	%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.8, i64 0, i64 0))
	br label %9

; <label>:7
	%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.9, i64 0, i64 0))
	br label %9

; <label>:9
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.10, i64 0, i64 0))
	ret void
}

define void @main() {
; <label>:0
	call void @if1234()
	call void @if1(i32 101)
	call void @if1else(i32 12)
	call void @if3()
	ret void
}

%string = type { i32, i8* }
%mapStruct = type {}

@str.0 = constant [14 x i8] c"this is true\0A\00"
@str.1 = constant [8 x i8] c"f2 yes\0A\00"
@str.2 = constant [5 x i8] c"yes\0A\00"
@str.3 = constant [4 x i8] c"no\0A\00"
@str.4 = constant [8 x i8] c"bbbbbb\0A\00"
@str.5 = constant [8 x i8] c"aaaaaa\0A\00"
@str.6 = constant [8 x i8] c"12 has\0A\00"
@str.7 = constant [14 x i8] c"this is true\0A\00"
@str.8 = constant [8 x i8] c"if4And\0A\00"
@str.9 = constant [4 x i8] c"%d\0A\00"
@str.10 = constant [18 x i8] c"aaaaaaaaaaaaaaaa\0A\00"
@str.11 = constant [5 x i8] c"yes\0A\00"
@str.12 = constant [4 x i8] c"no\0A\00"
@str.13 = constant [18 x i8] c"bbbbbbbbbbbbbbbb\0A\00"

declare i8* @malloc(i32)

define %string* @newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 12)
	%3 = bitcast i8* %2 to %string*
	%4 = alloca %string*
	store %string* %3, %string** %4
	br label %5

; <label>:5
	%6 = load i32, i32* %1
	%7 = icmp eq i32 %6, 0
	br i1 %7, label %8, label %10

; <label>:8
	; block start
	%9 = load %string*, %string** %4
	; end block
	ret %string* %9

; <label>:10
	br label %11

; <label>:11
	%12 = load i32, i32* %1
	%13 = sub i32 %12, 1
	%14 = load %string*, %string** %4
	%15 = getelementptr %string, %string* %14, i32 0, i32 0
	%16 = load i32, i32* %15
	store i32 %13, i32* %15
	%17 = load i32, i32* %1
	%18 = call i8* @malloc(i32 %17)
	%19 = load %string*, %string** %4
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	store i8* %18, i8** %20
	%22 = load %string*, %string** %4
	; end block
	ret %string* %22
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @f2() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 23, i32* %1
	%2 = alloca i32
	store i32 100, i32* %2
	br label %3

; <label>:3
	%4 = load i32, i32* %1
	%5 = icmp sgt i32 %4, 10
	br i1 %5, label %9, label %6

; <label>:6
	%7 = load i32, i32* %2
	%8 = icmp slt i32 %7, 10
	br i1 %5, label %9, label %19

; <label>:9
	; block start
	%10 = call %string* @newString(i32 14)
	%11 = getelementptr %string, %string* %10, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 14, i1 false)
	%15 = load %string, %string* %10
	%16 = getelementptr %string, %string* %10, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17)
	; end block
	br label %20

; <label>:19
	br label %20

; <label>:20
	; end block
	ret void
}

define void @if1(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 100
	br i1 %4, label %5, label %15

; <label>:5
	; block start
	%6 = call %string* @newString(i32 8)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 8, i1 false)
	%11 = load %string, %string* %6
	%12 = getelementptr %string, %string* %6, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13)
	; end block
	br label %16

; <label>:15
	br label %16

; <label>:16
	; end block
	ret void
}

define void @if1else(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 100
	br i1 %4, label %5, label %15

; <label>:5
	; block start
	%6 = call %string* @newString(i32 5)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 5, i1 false)
	%11 = load %string, %string* %6
	%12 = getelementptr %string, %string* %6, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13)
	; end block
	br label %25

; <label>:15
	; block start
	%16 = call %string* @newString(i32 4)
	%17 = getelementptr %string, %string* %16, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = bitcast i8* %18 to i8*
	%20 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %20, i32 4, i1 false)
	%21 = load %string, %string* %16
	%22 = getelementptr %string, %string* %16, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = call i32 (i8*, ...) @printf(i8* %23)
	; end block
	br label %25

; <label>:25
	; end block
	ret void
}

define void @ifelseif() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 12, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp slt i32 %3, 11
	br i1 %4, label %5, label %15

; <label>:5
	; block start
	%6 = call %string* @newString(i32 8)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 8, i1 false)
	%11 = load %string, %string* %6
	%12 = getelementptr %string, %string* %6, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13)
	; end block
	br label %44

; <label>:15
	%16 = load i32, i32* %1
	%17 = icmp sgt i32 %16, 22
	br i1 %17, label %18, label %28

; <label>:18
	; block start
	%19 = call %string* @newString(i32 8)
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 8, i1 false)
	%24 = load %string, %string* %19
	%25 = getelementptr %string, %string* %19, i32 0, i32 1
	%26 = load i8*, i8** %25
	%27 = call i32 (i8*, ...) @printf(i8* %26)
	; end block
	br label %43

; <label>:28
	%29 = load i32, i32* %1
	%30 = icmp eq i32 %29, 12
	br i1 %30, label %31, label %41

; <label>:31
	; block start
	%32 = call %string* @newString(i32 8)
	%33 = getelementptr %string, %string* %32, i32 0, i32 1
	%34 = load i8*, i8** %33
	%35 = bitcast i8* %34 to i8*
	%36 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %35, i8* %36, i32 8, i1 false)
	%37 = load %string, %string* %32
	%38 = getelementptr %string, %string* %32, i32 0, i32 1
	%39 = load i8*, i8** %38
	%40 = call i32 (i8*, ...) @printf(i8* %39)
	; end block
	br label %42

; <label>:41
	br label %42

; <label>:42
	ret void

; <label>:43
	ret void

; <label>:44
	; end block
	ret void
}

define void @if3() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 23, i32* %1
	%2 = alloca i32
	store i32 100, i32* %2
	%3 = alloca i32
	store i32 80, i32* %3
	br label %4

; <label>:4
	%5 = load i32, i32* %1
	%6 = icmp sgt i32 %5, 40
	br i1 %6, label %13, label %7

; <label>:7
	%8 = load i32, i32* %2
	%9 = icmp slt i32 %8, 10
	br i1 %6, label %13, label %10

; <label>:10
	%11 = load i32, i32* %3
	%12 = icmp slt i32 %11, 100
	br i1 %6, label %13, label %23

; <label>:13
	; block start
	%14 = call %string* @newString(i32 14)
	%15 = getelementptr %string, %string* %14, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to i8*
	%18 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %17, i8* %18, i32 14, i1 false)
	%19 = load %string, %string* %14
	%20 = getelementptr %string, %string* %14, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = call i32 (i8*, ...) @printf(i8* %21)
	; end block
	br label %24

; <label>:23
	br label %24

; <label>:24
	; end block
	ret void
}

define void @if4And() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 23, i32* %1
	%2 = alloca i32
	store i32 100, i32* %2
	%3 = alloca i32
	store i32 80, i32* %3
	br label %4

; <label>:4
	%5 = load i32, i32* %1
	%6 = icmp slt i32 %5, 40
	br i1 %6, label %7, label %23

; <label>:7
	%8 = load i32, i32* %2
	%9 = icmp slt i32 %8, 101
	br i1 %6, label %10, label %23

; <label>:10
	%11 = load i32, i32* %3
	%12 = icmp slt i32 %11, 100
	br i1 %6, label %13, label %23

; <label>:13
	; block start
	%14 = call %string* @newString(i32 8)
	%15 = getelementptr %string, %string* %14, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to i8*
	%18 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %17, i8* %18, i32 8, i1 false)
	%19 = load %string, %string* %14
	%20 = getelementptr %string, %string* %14, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = call i32 (i8*, ...) @printf(i8* %21)
	; end block
	br label %24

; <label>:23
	br label %24

; <label>:24
	; end block
	ret void
}

define void @if5() {
; <label>:0
	; block start
	%1 = alloca i32
	br label %2

; <label>:2
	store i32 90, i32* %1
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %16

; <label>:5
	; block start
	%6 = call %string* @newString(i32 4)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.9, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 4, i1 false)
	%11 = load %string, %string* %6
	%12 = load i32, i32* %1
	%13 = getelementptr %string, %string* %6, i32 0, i32 1
	%14 = load i8*, i8** %13
	%15 = call i32 (i8*, ...) @printf(i8* %14, i32 %12)
	; end block
	br label %17

; <label>:16
	br label %17

; <label>:17
	; end block
	ret void
}

define void @if1234() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 190, i32* %1
	%2 = call %string* @newString(i32 18)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.10, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 18, i1 false)
	%7 = load %string, %string* %2
	%8 = getelementptr %string, %string* %2, i32 0, i32 1
	%9 = load i8*, i8** %8
	%10 = call i32 (i8*, ...) @printf(i8* %9)
	br label %11

; <label>:11
	%12 = load i32, i32* %1
	%13 = icmp sgt i32 %12, 100
	br i1 %13, label %14, label %24

; <label>:14
	; block start
	%15 = call %string* @newString(i32 5)
	%16 = getelementptr %string, %string* %15, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to i8*
	%19 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.11, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 5, i1 false)
	%20 = load %string, %string* %15
	%21 = getelementptr %string, %string* %15, i32 0, i32 1
	%22 = load i8*, i8** %21
	%23 = call i32 (i8*, ...) @printf(i8* %22)
	; end block
	br label %34

; <label>:24
	; block start
	%25 = call %string* @newString(i32 4)
	%26 = getelementptr %string, %string* %25, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = bitcast i8* %27 to i8*
	%29 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.12, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %28, i8* %29, i32 4, i1 false)
	%30 = load %string, %string* %25
	%31 = getelementptr %string, %string* %25, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = call i32 (i8*, ...) @printf(i8* %32)
	; end block
	br label %34

; <label>:34
	%35 = call %string* @newString(i32 18)
	%36 = getelementptr %string, %string* %35, i32 0, i32 1
	%37 = load i8*, i8** %36
	%38 = bitcast i8* %37 to i8*
	%39 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.13, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %38, i8* %39, i32 18, i1 false)
	%40 = load %string, %string* %35
	%41 = getelementptr %string, %string* %35, i32 0, i32 1
	%42 = load i8*, i8** %41
	%43 = call i32 (i8*, ...) @printf(i8* %42)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @if1234()
	call void @if1(i32 101)
	call void @if1else(i32 12)
	call void @if3()
	call void @ifelseif()
	; end block
	ret void
}

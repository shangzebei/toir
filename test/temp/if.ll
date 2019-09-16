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

define void @init_slice_i8({ i32, i32, i32, i8* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 2
	store i32 1, i32* %1
	%2 = mul i32 %len, 1
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to i8*
	store i8* %5, i8** %4
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
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
	br i1 %5, label %9, label %21

; <label>:9
	; block start
	%10 = call i8* @malloc(i32 20)
	%11 = bitcast i8* %10 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %11, i32 14)
	%12 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 0
	store i32 14, i32* %12
	%13 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%14 = load i8*, i8** %13
	%15 = bitcast i8* %14 to i8*
	%16 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %15, i8* %16, i32 14, i1 false)
	%17 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19)
	; end block
	br label %22

; <label>:21
	br label %22

; <label>:22
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
	br i1 %4, label %5, label %17

; <label>:5
	; block start
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 8)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 8, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 8, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15)
	; end block
	br label %18

; <label>:17
	br label %18

; <label>:18
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
	br i1 %4, label %5, label %17

; <label>:5
	; block start
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 5)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 5, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 5, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15)
	; end block
	br label %29

; <label>:17
	; block start
	%18 = call i8* @malloc(i32 20)
	%19 = bitcast i8* %18 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %19, i32 4)
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 0
	store i32 4, i32* %20
	%21 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 3
	%22 = load i8*, i8** %21
	%23 = bitcast i8* %22 to i8*
	%24 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %23, i8* %24, i32 4, i1 false)
	%25 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19
	%26 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 3
	%27 = load i8*, i8** %26
	%28 = call i32 (i8*, ...) @printf(i8* %27)
	; end block
	br label %29

; <label>:29
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
	br i1 %4, label %5, label %17

; <label>:5
	; block start
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 8)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 8, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 8, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15)
	; end block
	br label %50

; <label>:17
	%18 = load i32, i32* %1
	%19 = icmp sgt i32 %18, 22
	br i1 %19, label %20, label %32

; <label>:20
	; block start
	%21 = call i8* @malloc(i32 20)
	%22 = bitcast i8* %21 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %22, i32 8)
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 0
	store i32 8, i32* %23
	%24 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to i8*
	%27 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 8, i1 false)
	%28 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22
	%29 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%30 = load i8*, i8** %29
	%31 = call i32 (i8*, ...) @printf(i8* %30)
	; end block
	br label %49

; <label>:32
	%33 = load i32, i32* %1
	%34 = icmp eq i32 %33, 12
	br i1 %34, label %35, label %47

; <label>:35
	; block start
	%36 = call i8* @malloc(i32 20)
	%37 = bitcast i8* %36 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %37, i32 8)
	%38 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 0
	store i32 8, i32* %38
	%39 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 3
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 8, i1 false)
	%43 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37
	%44 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 3
	%45 = load i8*, i8** %44
	%46 = call i32 (i8*, ...) @printf(i8* %45)
	; end block
	br label %48

; <label>:47
	br label %48

; <label>:48
	ret void

; <label>:49
	ret void

; <label>:50
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
	br i1 %6, label %13, label %25

; <label>:13
	; block start
	%14 = call i8* @malloc(i32 20)
	%15 = bitcast i8* %14 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %15, i32 14)
	%16 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15, i32 0, i32 0
	store i32 14, i32* %16
	%17 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15, i32 0, i32 3
	%18 = load i8*, i8** %17
	%19 = bitcast i8* %18 to i8*
	%20 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %20, i32 14, i1 false)
	%21 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15
	%22 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15, i32 0, i32 3
	%23 = load i8*, i8** %22
	%24 = call i32 (i8*, ...) @printf(i8* %23)
	; end block
	br label %26

; <label>:25
	br label %26

; <label>:26
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
	br i1 %6, label %7, label %25

; <label>:7
	%8 = load i32, i32* %2
	%9 = icmp slt i32 %8, 101
	br i1 %6, label %10, label %25

; <label>:10
	%11 = load i32, i32* %3
	%12 = icmp slt i32 %11, 100
	br i1 %6, label %13, label %25

; <label>:13
	; block start
	%14 = call i8* @malloc(i32 20)
	%15 = bitcast i8* %14 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %15, i32 8)
	%16 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15, i32 0, i32 0
	store i32 8, i32* %16
	%17 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15, i32 0, i32 3
	%18 = load i8*, i8** %17
	%19 = bitcast i8* %18 to i8*
	%20 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %20, i32 8, i1 false)
	%21 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15
	%22 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15, i32 0, i32 3
	%23 = load i8*, i8** %22
	%24 = call i32 (i8*, ...) @printf(i8* %23)
	; end block
	br label %26

; <label>:25
	br label %26

; <label>:26
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
	br i1 %4, label %5, label %18

; <label>:5
	; block start
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 4)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 4, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.9, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 4, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = load i32, i32* %1
	%15 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %16, i32 %14)
	; end block
	br label %19

; <label>:18
	br label %19

; <label>:19
	; end block
	ret void
}

define void @if1234() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 190, i32* %1
	%2 = call i8* @malloc(i32 20)
	%3 = bitcast i8* %2 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %3, i32 18)
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 0
	store i32 18, i32* %4
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.10, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 18, i1 false)
	%9 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3
	%10 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%11 = load i8*, i8** %10
	%12 = call i32 (i8*, ...) @printf(i8* %11)
	br label %13

; <label>:13
	%14 = load i32, i32* %1
	%15 = icmp sgt i32 %14, 100
	br i1 %15, label %16, label %28

; <label>:16
	; block start
	%17 = call i8* @malloc(i32 20)
	%18 = bitcast i8* %17 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %18, i32 5)
	%19 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 0
	store i32 5, i32* %19
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 3
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.11, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 5, i1 false)
	%24 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18
	%25 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 3
	%26 = load i8*, i8** %25
	%27 = call i32 (i8*, ...) @printf(i8* %26)
	; end block
	br label %40

; <label>:28
	; block start
	%29 = call i8* @malloc(i32 20)
	%30 = bitcast i8* %29 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %30, i32 4)
	%31 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 0
	store i32 4, i32* %31
	%32 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 3
	%33 = load i8*, i8** %32
	%34 = bitcast i8* %33 to i8*
	%35 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.12, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %34, i8* %35, i32 4, i1 false)
	%36 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30
	%37 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 3
	%38 = load i8*, i8** %37
	%39 = call i32 (i8*, ...) @printf(i8* %38)
	; end block
	br label %40

; <label>:40
	%41 = call i8* @malloc(i32 20)
	%42 = bitcast i8* %41 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %42, i32 18)
	%43 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %42, i32 0, i32 0
	store i32 18, i32* %43
	%44 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %42, i32 0, i32 3
	%45 = load i8*, i8** %44
	%46 = bitcast i8* %45 to i8*
	%47 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.13, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %46, i8* %47, i32 18, i1 false)
	%48 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %42
	%49 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %42, i32 0, i32 3
	%50 = load i8*, i8** %49
	%51 = call i32 (i8*, ...) @printf(i8* %50)
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

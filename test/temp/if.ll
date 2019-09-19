%mapStruct = type {}
%string = type { i32, i8* }

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

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 20)
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
	; IF NEW BLOCK
	%12 = load %string*, %string** %4
	%13 = getelementptr %string, %string* %12, i32 0, i32 0
	%14 = load i32, i32* %13
	%15 = load i32, i32* %1
	store i32 %15, i32* %13
	%16 = load i32, i32* %1
	%17 = add i32 %16, 1
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

define void @test.f2() {
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
	br i1 %5, label %9, label %22

; <label>:9
	; block start
	%10 = call %string* @runtime.newString(i32 13)
	%11 = getelementptr %string, %string* %10, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.0, i64 0, i64 0) to i8*
	%15 = getelementptr %string, %string* %10, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = add i32 %16, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 %17, i1 false)
	%18 = load %string, %string* %10
	%19 = getelementptr %string, %string* %10, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20)
	; end block
	br label %23

; <label>:22
	br label %23

; <label>:23
	; IF NEW BLOCK
	; end block
	ret void
}

define void @test.if1(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 100
	br i1 %4, label %5, label %18

; <label>:5
	; block start
	%6 = call %string* @runtime.newString(i32 7)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = getelementptr %string, %string* %6, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %16)
	; end block
	br label %19

; <label>:18
	br label %19

; <label>:19
	; IF NEW BLOCK
	; end block
	ret void
}

define void @test.if1else(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 100
	br i1 %4, label %5, label %18

; <label>:5
	; block start
	%6 = call %string* @runtime.newString(i32 4)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.2, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = getelementptr %string, %string* %6, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %16)
	; end block
	br label %31

; <label>:18
	; block start
	%19 = call %string* @runtime.newString(i32 3)
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	%24 = getelementptr %string, %string* %19, i32 0, i32 0
	%25 = load i32, i32* %24
	%26 = add i32 %25, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 %26, i1 false)
	%27 = load %string, %string* %19
	%28 = getelementptr %string, %string* %19, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %29)
	; end block
	br label %31

; <label>:31
	; IF NEW BLOCK
	; end block
	ret void
}

define void @test.ifelseif() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 12, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp slt i32 %3, 11
	br i1 %4, label %5, label %18

; <label>:5
	; block start
	%6 = call %string* @runtime.newString(i32 7)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.4, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = getelementptr %string, %string* %6, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %16)
	; end block
	br label %53

; <label>:18
	%19 = load i32, i32* %1
	%20 = icmp sgt i32 %19, 22
	br i1 %20, label %21, label %34

; <label>:21
	; block start
	%22 = call %string* @runtime.newString(i32 7)
	%23 = getelementptr %string, %string* %22, i32 0, i32 1
	%24 = load i8*, i8** %23
	%25 = bitcast i8* %24 to i8*
	%26 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.5, i64 0, i64 0) to i8*
	%27 = getelementptr %string, %string* %22, i32 0, i32 0
	%28 = load i32, i32* %27
	%29 = add i32 %28, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %25, i8* %26, i32 %29, i1 false)
	%30 = load %string, %string* %22
	%31 = getelementptr %string, %string* %22, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = call i32 (i8*, ...) @printf(i8* %32)
	; end block
	br label %52

; <label>:34
	%35 = load i32, i32* %1
	%36 = icmp eq i32 %35, 12
	br i1 %36, label %37, label %50

; <label>:37
	; block start
	%38 = call %string* @runtime.newString(i32 7)
	%39 = getelementptr %string, %string* %38, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.6, i64 0, i64 0) to i8*
	%43 = getelementptr %string, %string* %38, i32 0, i32 0
	%44 = load i32, i32* %43
	%45 = add i32 %44, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 %45, i1 false)
	%46 = load %string, %string* %38
	%47 = getelementptr %string, %string* %38, i32 0, i32 1
	%48 = load i8*, i8** %47
	%49 = call i32 (i8*, ...) @printf(i8* %48)
	; end block
	br label %51

; <label>:50
	br label %51

; <label>:51
	; IF NEW BLOCK
	ret void

; <label>:52
	; IF NEW BLOCK
	ret void

; <label>:53
	; IF NEW BLOCK
	; end block
	ret void
}

define void @test.if3() {
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
	br i1 %6, label %13, label %26

; <label>:13
	; block start
	%14 = call %string* @runtime.newString(i32 13)
	%15 = getelementptr %string, %string* %14, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to i8*
	%18 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.7, i64 0, i64 0) to i8*
	%19 = getelementptr %string, %string* %14, i32 0, i32 0
	%20 = load i32, i32* %19
	%21 = add i32 %20, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %17, i8* %18, i32 %21, i1 false)
	%22 = load %string, %string* %14
	%23 = getelementptr %string, %string* %14, i32 0, i32 1
	%24 = load i8*, i8** %23
	%25 = call i32 (i8*, ...) @printf(i8* %24)
	; end block
	br label %27

; <label>:26
	br label %27

; <label>:27
	; IF NEW BLOCK
	; end block
	ret void
}

define void @test.if4And() {
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
	br i1 %6, label %7, label %26

; <label>:7
	%8 = load i32, i32* %2
	%9 = icmp slt i32 %8, 101
	br i1 %6, label %10, label %26

; <label>:10
	%11 = load i32, i32* %3
	%12 = icmp slt i32 %11, 100
	br i1 %6, label %13, label %26

; <label>:13
	; block start
	%14 = call %string* @runtime.newString(i32 7)
	%15 = getelementptr %string, %string* %14, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = bitcast i8* %16 to i8*
	%18 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.8, i64 0, i64 0) to i8*
	%19 = getelementptr %string, %string* %14, i32 0, i32 0
	%20 = load i32, i32* %19
	%21 = add i32 %20, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %17, i8* %18, i32 %21, i1 false)
	%22 = load %string, %string* %14
	%23 = getelementptr %string, %string* %14, i32 0, i32 1
	%24 = load i8*, i8** %23
	%25 = call i32 (i8*, ...) @printf(i8* %24)
	; end block
	br label %27

; <label>:26
	br label %27

; <label>:27
	; IF NEW BLOCK
	; end block
	ret void
}

define void @test.if5() {
; <label>:0
	; block start
	%1 = alloca i32
	br label %2

; <label>:2
	store i32 90, i32* %1
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %19

; <label>:5
	; block start
	%6 = call %string* @runtime.newString(i32 3)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.9, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = load i32, i32* %1
	%16 = getelementptr %string, %string* %6, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17, i32 %15)
	; end block
	br label %20

; <label>:19
	br label %20

; <label>:20
	; IF NEW BLOCK
	; end block
	ret void
}

define void @test.if1234() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 190, i32* %1
	%2 = call %string* @runtime.newString(i32 17)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.10, i64 0, i64 0) to i8*
	%7 = getelementptr %string, %string* %2, i32 0, i32 0
	%8 = load i32, i32* %7
	%9 = add i32 %8, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 %9, i1 false)
	%10 = load %string, %string* %2
	%11 = getelementptr %string, %string* %2, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12)
	br label %14

; <label>:14
	%15 = load i32, i32* %1
	%16 = icmp sgt i32 %15, 100
	br i1 %16, label %17, label %30

; <label>:17
	; block start
	%18 = call %string* @runtime.newString(i32 4)
	%19 = getelementptr %string, %string* %18, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = bitcast i8* %20 to i8*
	%22 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.11, i64 0, i64 0) to i8*
	%23 = getelementptr %string, %string* %18, i32 0, i32 0
	%24 = load i32, i32* %23
	%25 = add i32 %24, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %21, i8* %22, i32 %25, i1 false)
	%26 = load %string, %string* %18
	%27 = getelementptr %string, %string* %18, i32 0, i32 1
	%28 = load i8*, i8** %27
	%29 = call i32 (i8*, ...) @printf(i8* %28)
	; end block
	br label %43

; <label>:30
	; block start
	%31 = call %string* @runtime.newString(i32 3)
	%32 = getelementptr %string, %string* %31, i32 0, i32 1
	%33 = load i8*, i8** %32
	%34 = bitcast i8* %33 to i8*
	%35 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.12, i64 0, i64 0) to i8*
	%36 = getelementptr %string, %string* %31, i32 0, i32 0
	%37 = load i32, i32* %36
	%38 = add i32 %37, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %34, i8* %35, i32 %38, i1 false)
	%39 = load %string, %string* %31
	%40 = getelementptr %string, %string* %31, i32 0, i32 1
	%41 = load i8*, i8** %40
	%42 = call i32 (i8*, ...) @printf(i8* %41)
	; end block
	br label %43

; <label>:43
	; IF NEW BLOCK
	%44 = call %string* @runtime.newString(i32 17)
	%45 = getelementptr %string, %string* %44, i32 0, i32 1
	%46 = load i8*, i8** %45
	%47 = bitcast i8* %46 to i8*
	%48 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.13, i64 0, i64 0) to i8*
	%49 = getelementptr %string, %string* %44, i32 0, i32 0
	%50 = load i32, i32* %49
	%51 = add i32 %50, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %47, i8* %48, i32 %51, i1 false)
	%52 = load %string, %string* %44
	%53 = getelementptr %string, %string* %44, i32 0, i32 1
	%54 = load i8*, i8** %53
	%55 = call i32 (i8*, ...) @printf(i8* %54)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.if1234()
	call void @test.if1(i32 101)
	call void @test.if1else(i32 12)
	call void @test.if3()
	call void @test.ifelseif()
	; end block
	ret void
}

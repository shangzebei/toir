%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.1 = constant [14 x i8] c"bbbbbbbbbbbb\0A\00"
@str.2 = constant [4 x i8] c"%d\0A\00"
@str.3 = constant [16 x i8] c"ggggggggggggggg\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [18 x i8] c"asdfasdfasd%d-%d\0A\00"
@str.6 = constant [14 x i8] c"bbbbbbbbbbbb\0A\00"
@str.7 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.8 = constant [17 x i8] c"cccccccccccc %d\0A\00"

define i32 @test.max() {
; <label>:0
	; block start
	; end block
	ret i32 3
}

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

define void @test.for1() {
; <label>:0
	; block start
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
	%6 = call i32 @test.max()
	%7 = load i32, i32* %1
	%8 = icmp sle i32 %7, %6
	; cond Block end
	br i1 %8, label %9, label %22

; <label>:9
	; block start
	%10 = call %string* @runtime.newString(i32 12)
	%11 = getelementptr %string, %string* %10, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.0, i64 0, i64 0) to i8*
	%15 = getelementptr %string, %string* %10, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = add i32 %16, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 %17, i1 false)
	%18 = load %string, %string* %10
	%19 = getelementptr %string, %string* %10, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20)
	; end block
	br label %2

; <label>:22
	; empty block
	%23 = call %string* @runtime.newString(i32 13)
	%24 = getelementptr %string, %string* %23, i32 0, i32 1
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to i8*
	%27 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.1, i64 0, i64 0) to i8*
	%28 = getelementptr %string, %string* %23, i32 0, i32 0
	%29 = load i32, i32* %28
	%30 = add i32 %29, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 %30, i1 false)
	%31 = load %string, %string* %23
	%32 = getelementptr %string, %string* %23, i32 0, i32 1
	%33 = load i8*, i8** %32
	%34 = call i32 (i8*, ...) @printf(i8* %33)
	; init block
	%35 = alloca i32
	store i32 0, i32* %35
	br label %39

; <label>:36
	; add block
	%37 = load i32, i32* %35
	%38 = add i32 %37, 1
	store i32 %38, i32* %35
	br label %39

; <label>:39
	; cond Block begin
	%40 = load i32, i32* %35
	%41 = icmp sle i32 %40, 2
	; cond Block end
	br i1 %41, label %42, label %56

; <label>:42
	; block start
	%43 = call %string* @runtime.newString(i32 3)
	%44 = getelementptr %string, %string* %43, i32 0, i32 1
	%45 = load i8*, i8** %44
	%46 = bitcast i8* %45 to i8*
	%47 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	%48 = getelementptr %string, %string* %43, i32 0, i32 0
	%49 = load i32, i32* %48
	%50 = add i32 %49, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %46, i8* %47, i32 %50, i1 false)
	%51 = load %string, %string* %43
	%52 = load i32, i32* %35
	%53 = getelementptr %string, %string* %43, i32 0, i32 1
	%54 = load i8*, i8** %53
	%55 = call i32 (i8*, ...) @printf(i8* %54, i32 %52)
	; end block
	br label %36

; <label>:56
	; empty block
	%57 = call %string* @runtime.newString(i32 15)
	%58 = getelementptr %string, %string* %57, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = bitcast i8* %59 to i8*
	%61 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.3, i64 0, i64 0) to i8*
	%62 = getelementptr %string, %string* %57, i32 0, i32 0
	%63 = load i32, i32* %62
	%64 = add i32 %63, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %60, i8* %61, i32 %64, i1 false)
	%65 = load %string, %string* %57
	%66 = getelementptr %string, %string* %57, i32 0, i32 1
	%67 = load i8*, i8** %66
	%68 = call i32 (i8*, ...) @printf(i8* %67)
	; end block
	ret void
}

define void @test.for2() {
; <label>:0
	; block start
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
	br i1 %7, label %8, label %22

; <label>:8
	; block start
	%9 = call %string* @runtime.newString(i32 3)
	%10 = getelementptr %string, %string* %9, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	%14 = getelementptr %string, %string* %9, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = add i32 %15, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 %16, i1 false)
	%17 = load %string, %string* %9
	%18 = load i32, i32* %1
	%19 = getelementptr %string, %string* %9, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20, i32 %18)
	; end block
	br label %2

; <label>:22
	; empty block
	; end block
	ret void
}

define i32 @test.for23() {
; <label>:0
	; block start
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
	br i1 %7, label %8, label %32

; <label>:8
	; block start
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
	br i1 %15, label %16, label %31

; <label>:16
	; block start
	%17 = call %string* @runtime.newString(i32 17)
	%18 = getelementptr %string, %string* %17, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.5, i64 0, i64 0) to i8*
	%22 = getelementptr %string, %string* %17, i32 0, i32 0
	%23 = load i32, i32* %22
	%24 = add i32 %23, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 %24, i1 false)
	%25 = load %string, %string* %17
	%26 = load i32, i32* %1
	%27 = load i32, i32* %9
	%28 = getelementptr %string, %string* %17, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %29, i32 %26, i32 %27)
	; end block
	br label %10

; <label>:31
	; empty block
	; end block
	br label %2

; <label>:32
	; empty block
	; end block
	ret i32 0
}

define void @test.for4() {
; <label>:0
	; block start
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
	br i1 %8, label %9, label %43

; <label>:9
	; block start
	%10 = call %string* @runtime.newString(i32 13)
	%11 = getelementptr %string, %string* %10, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.6, i64 0, i64 0) to i8*
	%15 = getelementptr %string, %string* %10, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = add i32 %16, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 %17, i1 false)
	%18 = load %string, %string* %10
	%19 = getelementptr %string, %string* %10, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20)
	; init block
	%22 = alloca i32
	store i32 0, i32* %22
	br label %26

; <label>:23
	; add block
	%24 = load i32, i32* %22
	%25 = add i32 %24, 1
	store i32 %25, i32* %22
	br label %26

; <label>:26
	; cond Block begin
	%27 = load i32, i32* %22
	%28 = icmp slt i32 %27, 2
	; cond Block end
	br i1 %28, label %29, label %42

; <label>:29
	; block start
	%30 = call %string* @runtime.newString(i32 12)
	%31 = getelementptr %string, %string* %30, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to i8*
	%34 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.7, i64 0, i64 0) to i8*
	%35 = getelementptr %string, %string* %30, i32 0, i32 0
	%36 = load i32, i32* %35
	%37 = add i32 %36, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %33, i8* %34, i32 %37, i1 false)
	%38 = load %string, %string* %30
	%39 = getelementptr %string, %string* %30, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = call i32 (i8*, ...) @printf(i8* %40)
	; end block
	br label %23

; <label>:42
	; empty block
	; end block
	br label %3

; <label>:43
	; empty block
	%44 = call %string* @runtime.newString(i32 16)
	%45 = getelementptr %string, %string* %44, i32 0, i32 1
	%46 = load i8*, i8** %45
	%47 = bitcast i8* %46 to i8*
	%48 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.8, i64 0, i64 0) to i8*
	%49 = getelementptr %string, %string* %44, i32 0, i32 0
	%50 = load i32, i32* %49
	%51 = add i32 %50, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %47, i8* %48, i32 %51, i1 false)
	%52 = load %string, %string* %44
	%53 = load i32, i32* %1
	%54 = getelementptr %string, %string* %44, i32 0, i32 1
	%55 = load i8*, i8** %54
	%56 = call i32 (i8*, ...) @printf(i8* %55, i32 %53)
	; end block
	ret void
}

define void @test.for5() {
; <label>:0
	; block start
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
	; block start
	%5 = load i32, i32* %1
	%6 = add i32 %5, 1
	store i32 %6, i32* %1
	br label %7

; <label>:7
	%8 = load i32, i32* %1
	%9 = icmp sgt i32 %8, 5
	br i1 %9, label %10, label %11

; <label>:10
	; block start
	; end block
	br label %13

; <label>:11
	br label %12

; <label>:12
	; IF NEW BLOCK
	; end block
	br label %2

; <label>:13
	; empty block
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.for2()
	%1 = call i32 @test.for23()
	call void @test.for1()
	call void @test.for4()
	; end block
	ret void
}

%mapStruct = type {}
%string = type { i32, i8* }

@main.test.range1asdfasdfs.0 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.0 = constant [22 x i8] c"asdfasdfasdfsdfsdf%d\0A\00"
@main.test.range2.2 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.1 = constant [7 x i8] c"%d-%d\0A\00"
@main.test.range3.4 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.2 = constant [4 x i8] c"%d\0A\00"
@main.test.range4.6 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.3 = constant [4 x i8] c"%d\0A\00"
@main.test.range5.8 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@main.test.range5.9 = constant [5 x i32] [i32 11, i32 22, i32 33, i32 44, i32 55]
@str.4 = constant [20 x i8] c"=====[row %d]==== \0A\00"
@str.5 = constant [4 x i8] c"%d \00"
@str.6 = constant [5 x i8] c"end\0A\00"

declare i8* @malloc(i32)

define void @slice.init.aTMy({ i32, i32, i32, i32* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %ptr, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 %len, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 16)
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

declare i32 @printf(i8*, ...)

define void @test.range1asdfasdfs() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %2, i32 5)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 5, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [5 x i32]* @main.test.range1asdfasdfs.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 20, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; [range start]
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%10 = load i32, i32* %9
	%11 = alloca i32
	; [range end]
	; init block
	%12 = alloca i32
	store i32 0, i32* %12
	br label %16

; <label>:13
	; add block
	%14 = load i32, i32* %12
	%15 = add i32 %14, 1
	store i32 %15, i32* %12
	br label %16

; <label>:16
	; cond Block begin
	%17 = load i32, i32* %12
	%18 = icmp slt i32 %17, %10
	; cond Block end
	br i1 %18, label %19, label %34

; <label>:19
	; block start
	%20 = load i32, i32* %12
	store i32 %20, i32* %11
	%21 = call %string* @runtime.newString(i32 21)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.0, i64 0, i64 0) to i8*
	%26 = getelementptr %string, %string* %21, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = add i32 %27, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 %28, i1 false)
	%29 = load %string, %string* %21
	%30 = load i32, i32* %11
	%31 = getelementptr %string, %string* %21, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = call i32 (i8*, ...) @printf(i8* %32, i32 %30)
	; end block
	br label %13

; <label>:34
	; empty block
	; end block
	ret void
}

define void @test.range2() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %2, i32 5)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 5, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [5 x i32]* @main.test.range2.2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 20, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; [range start]
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%10 = load i32, i32* %9
	%11 = alloca i32
	%12 = alloca i32
	; [range end]
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
	%19 = icmp slt i32 %18, %10
	; cond Block end
	br i1 %19, label %20, label %41

; <label>:20
	; block start
	%21 = load i32, i32* %13
	store i32 %21, i32* %11
	%22 = load i32, i32* %13
	; get slice index
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%24 = load i32*, i32** %23
	%25 = getelementptr i32, i32* %24, i32 %22
	%26 = load i32, i32* %25
	store i32 %26, i32* %12
	%27 = call %string* @runtime.newString(i32 6)
	%28 = getelementptr %string, %string* %27, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0) to i8*
	%32 = getelementptr %string, %string* %27, i32 0, i32 0
	%33 = load i32, i32* %32
	%34 = add i32 %33, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 %34, i1 false)
	%35 = load %string, %string* %27
	%36 = load i32, i32* %11
	%37 = load i32, i32* %12
	%38 = getelementptr %string, %string* %27, i32 0, i32 1
	%39 = load i8*, i8** %38
	%40 = call i32 (i8*, ...) @printf(i8* %39, i32 %36, i32 %37)
	; end block
	br label %14

; <label>:41
	; empty block
	; end block
	ret void
}

define void @test.range3() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %2, i32 5)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 5, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [5 x i32]* @main.test.range3.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 20, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; [range start]
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%10 = load i32, i32* %9
	%11 = alloca i32
	; [range end]
	; init block
	%12 = alloca i32
	store i32 0, i32* %12
	br label %16

; <label>:13
	; add block
	%14 = load i32, i32* %12
	%15 = add i32 %14, 1
	store i32 %15, i32* %12
	br label %16

; <label>:16
	; cond Block begin
	%17 = load i32, i32* %12
	%18 = icmp slt i32 %17, %10
	; cond Block end
	br i1 %18, label %19, label %38

; <label>:19
	; block start
	%20 = load i32, i32* %12
	; get slice index
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%22 = load i32*, i32** %21
	%23 = getelementptr i32, i32* %22, i32 %20
	%24 = load i32, i32* %23
	store i32 %24, i32* %11
	%25 = call %string* @runtime.newString(i32 3)
	%26 = getelementptr %string, %string* %25, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = bitcast i8* %27 to i8*
	%29 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	%30 = getelementptr %string, %string* %25, i32 0, i32 0
	%31 = load i32, i32* %30
	%32 = add i32 %31, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %28, i8* %29, i32 %32, i1 false)
	%33 = load %string, %string* %25
	%34 = load i32, i32* %11
	%35 = getelementptr %string, %string* %25, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = call i32 (i8*, ...) @printf(i8* %36, i32 %34)
	; end block
	br label %13

; <label>:38
	; empty block
	; end block
	ret void
}

define void @test.range4() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %2, i32 5)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 5, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [5 x i32]* @main.test.range4.6 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 20, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; [range start]
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%10 = load i32, i32* %9
	%11 = alloca i32
	; [range end]
	; init block
	%12 = alloca i32
	store i32 0, i32* %12
	br label %16

; <label>:13
	; add block
	%14 = load i32, i32* %12
	%15 = add i32 %14, 1
	store i32 %15, i32* %12
	br label %16

; <label>:16
	; cond Block begin
	%17 = load i32, i32* %12
	%18 = icmp slt i32 %17, %10
	; cond Block end
	br i1 %18, label %19, label %34

; <label>:19
	; block start
	%20 = load i32, i32* %12
	store i32 %20, i32* %11
	%21 = call %string* @runtime.newString(i32 3)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	%26 = getelementptr %string, %string* %21, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = add i32 %27, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 %28, i1 false)
	%29 = load %string, %string* %21
	%30 = load i32, i32* %11
	%31 = getelementptr %string, %string* %21, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = call i32 (i8*, ...) @printf(i8* %32, i32 %30)
	; end block
	br label %13

; <label>:34
	; empty block
	; end block
	ret void
}

define void @test.range5() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %2, i32 5)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 5, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [5 x i32]* @main.test.range5.8 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 20, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call i8* @malloc(i32 24)
	%10 = bitcast i8* %9 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %10, i32 5)
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 0
	store i32 5, i32* %11
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%13 = load i32*, i32** %12
	%14 = bitcast i32* %13 to i8*
	%15 = bitcast [5 x i32]* @main.test.range5.9 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 20, i1 false)
	%16 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10
	; [range start]
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%18 = load i32, i32* %17
	%19 = alloca i32
	; [range end]
	; init block
	%20 = alloca i32
	store i32 0, i32* %20
	br label %24

; <label>:21
	; add block
	%22 = load i32, i32* %20
	%23 = add i32 %22, 1
	store i32 %23, i32* %20
	br label %24

; <label>:24
	; cond Block begin
	%25 = load i32, i32* %20
	%26 = icmp slt i32 %25, %18
	; cond Block end
	br i1 %26, label %27, label %84

; <label>:27
	; block start
	%28 = load i32, i32* %20
	store i32 %28, i32* %19
	%29 = call %string* @runtime.newString(i32 19)
	%30 = getelementptr %string, %string* %29, i32 0, i32 1
	%31 = load i8*, i8** %30
	%32 = bitcast i8* %31 to i8*
	%33 = bitcast i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.4, i64 0, i64 0) to i8*
	%34 = getelementptr %string, %string* %29, i32 0, i32 0
	%35 = load i32, i32* %34
	%36 = add i32 %35, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %32, i8* %33, i32 %36, i1 false)
	%37 = load %string, %string* %29
	%38 = load i32, i32* %19
	%39 = getelementptr %string, %string* %29, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = call i32 (i8*, ...) @printf(i8* %40, i32 %38)
	; [range start]
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 0
	%43 = load i32, i32* %42
	%44 = alloca i32
	; [range end]
	; init block
	%45 = alloca i32
	store i32 0, i32* %45
	br label %49

; <label>:46
	; add block
	%47 = load i32, i32* %45
	%48 = add i32 %47, 1
	store i32 %48, i32* %45
	br label %49

; <label>:49
	; cond Block begin
	%50 = load i32, i32* %45
	%51 = icmp slt i32 %50, %43
	; cond Block end
	br i1 %51, label %52, label %71

; <label>:52
	; block start
	%53 = load i32, i32* %45
	; get slice index
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%55 = load i32*, i32** %54
	%56 = getelementptr i32, i32* %55, i32 %53
	%57 = load i32, i32* %56
	store i32 %57, i32* %44
	%58 = call %string* @runtime.newString(i32 3)
	%59 = getelementptr %string, %string* %58, i32 0, i32 1
	%60 = load i8*, i8** %59
	%61 = bitcast i8* %60 to i8*
	%62 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	%63 = getelementptr %string, %string* %58, i32 0, i32 0
	%64 = load i32, i32* %63
	%65 = add i32 %64, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %61, i8* %62, i32 %65, i1 false)
	%66 = load %string, %string* %58
	%67 = load i32, i32* %44
	%68 = getelementptr %string, %string* %58, i32 0, i32 1
	%69 = load i8*, i8** %68
	%70 = call i32 (i8*, ...) @printf(i8* %69, i32 %67)
	; end block
	br label %46

; <label>:71
	; empty block
	%72 = call %string* @runtime.newString(i32 4)
	%73 = getelementptr %string, %string* %72, i32 0, i32 1
	%74 = load i8*, i8** %73
	%75 = bitcast i8* %74 to i8*
	%76 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.6, i64 0, i64 0) to i8*
	%77 = getelementptr %string, %string* %72, i32 0, i32 0
	%78 = load i32, i32* %77
	%79 = add i32 %78, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %75, i8* %76, i32 %79, i1 false)
	%80 = load %string, %string* %72
	%81 = getelementptr %string, %string* %72, i32 0, i32 1
	%82 = load i8*, i8** %81
	%83 = call i32 (i8*, ...) @printf(i8* %82)
	; end block
	br label %21

; <label>:84
	; empty block
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.range1asdfasdfs()
	call void @test.range2()
	call void @test.range3()
	call void @test.range4()
	call void @test.range5()
	; end block
	ret void
}

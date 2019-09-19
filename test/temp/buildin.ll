%mapStruct = type {}
%string = type { i32, i8* }
%Per = type { %string }

@main.test.copyt.0 = constant [3 x i32] [i32 1, i32 2, i32 3]
@main.test.copyt.1 = constant [6 x i32] [i32 4, i32 5, i32 6, i32 7, i32 8, i32 9]
@str.0 = constant [19 x i8] c"%d-%d-%d-%d-%d-%d\0A\00"
@str.1 = constant [6 x i8] c"see@ \00"
@str.2 = constant [19 x i8] c"%s len=%d cap=%d \0A\00"
@str.3 = constant [4 x i8] c"%d\0A\00"
@str.4 = constant [12 x i8] c"asdfasdfasd\00"
@str.5 = constant [4 x i8] c"%s\0A\00"

declare i8* @malloc(i32)

define void @slice.init.i32({ i32, i32, i32, i32* }* %ptr, i32 %len) {
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

define void @test.copyt() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 3, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [3 x i32]* @main.test.copyt.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 12, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call i8* @malloc(i32 24)
	%10 = bitcast i8* %9 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %10, i32 6)
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 0
	store i32 6, i32* %11
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%13 = load i32*, i32** %12
	%14 = bitcast i32* %13 to i8*
	%15 = bitcast [6 x i32]* @main.test.copyt.1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 24, i1 false)
	%16 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10
	; copy ptr..........start
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%18 = load i32, i32* %17
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%20 = load i32*, i32** %19
	%21 = bitcast i32* %20 to i8*
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%23 = load i32*, i32** %22
	%24 = bitcast i32* %23 to i8*
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%26 = load i32, i32* %25
	%27 = mul i32 %18, %26
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %21, i8* %24, i32 %27, i1 false)
	; copy ptr..........end
	%28 = call %string* @runtime.newString(i32 18)
	%29 = getelementptr %string, %string* %28, i32 0, i32 1
	%30 = load i8*, i8** %29
	%31 = bitcast i8* %30 to i8*
	%32 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.0, i64 0, i64 0) to i8*
	%33 = getelementptr %string, %string* %28, i32 0, i32 0
	%34 = load i32, i32* %33
	%35 = add i32 %34, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %31, i8* %32, i32 %35, i1 false)
	%36 = load %string, %string* %28
	; get slice index
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%38 = load i32*, i32** %37
	%39 = getelementptr i32, i32* %38, i32 0
	%40 = load i32, i32* %39
	; get slice index
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%42 = load i32*, i32** %41
	%43 = getelementptr i32, i32* %42, i32 1
	%44 = load i32, i32* %43
	; get slice index
	%45 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%46 = load i32*, i32** %45
	%47 = getelementptr i32, i32* %46, i32 2
	%48 = load i32, i32* %47
	; get slice index
	%49 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%50 = load i32*, i32** %49
	%51 = getelementptr i32, i32* %50, i32 3
	%52 = load i32, i32* %51
	; get slice index
	%53 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%54 = load i32*, i32** %53
	%55 = getelementptr i32, i32* %54, i32 4
	%56 = load i32, i32* %55
	; get slice index
	%57 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%58 = load i32*, i32** %57
	%59 = getelementptr i32, i32* %58, i32 5
	%60 = load i32, i32* %59
	%61 = getelementptr %string, %string* %28, i32 0, i32 1
	%62 = load i8*, i8** %61
	%63 = call i32 (i8*, ...) @printf(i8* %62, i32 %40, i32 %44, i32 %48, i32 %52, i32 %56, i32 %60)
	; end block
	ret void
}

define void @printSlice(%string %s, { i32, i32, i32, i32* } %x) {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 0)
	store %string %s, %string* %1
	%2 = call i8* @malloc(i32 24)
	%3 = bitcast i8* %2 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* } %x, { i32, i32, i32, i32* }* %3
	%4 = call %string* @runtime.newString(i32 18)
	%5 = getelementptr %string, %string* %4, i32 0, i32 1
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.2, i64 0, i64 0) to i8*
	%9 = getelementptr %string, %string* %4, i32 0, i32 0
	%10 = load i32, i32* %9
	%11 = add i32 %10, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 %11, i1 false)
	%12 = load %string, %string* %4
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 1
	%18 = load i32, i32* %17
	%19 = getelementptr %string, %string* %4, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = getelementptr %string, %string* %1, i32 0, i32 1
	%22 = load i8*, i8** %21
	%23 = call i32 (i8*, ...) @printf(i8* %20, i8* %22, i32 %15, i32 %18)
	; end block
	ret void
}

define void @test.make1() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %2, i32 3)
	%3 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%4 = call %string* @runtime.newString(i32 5)
	%5 = getelementptr %string, %string* %4, i32 0, i32 1
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0) to i8*
	%9 = getelementptr %string, %string* %4, i32 0, i32 0
	%10 = load i32, i32* %9
	%11 = add i32 %10, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 %11, i1 false)
	%12 = load %string, %string* %4
	call void @printSlice(%string %12, { i32, i32, i32, i32* } %3)
	; get slice index
	%13 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%14 = load i32*, i32** %13
	%15 = getelementptr i32, i32* %14, i32 0
	%16 = load i32, i32* %15
	store i32 90, i32* %15
	; get slice index
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%18 = load i32*, i32** %17
	%19 = getelementptr i32, i32* %18, i32 1
	%20 = load i32, i32* %19
	store i32 50, i32* %19
	; get slice index
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%22 = load i32*, i32** %21
	%23 = getelementptr i32, i32* %22, i32 2
	%24 = load i32, i32* %23
	store i32 70, i32* %23
	; init block
	%25 = alloca i32
	store i32 0, i32* %25
	br label %29

; <label>:26
	; add block
	%27 = load i32, i32* %25
	%28 = add i32 %27, 1
	store i32 %28, i32* %25
	br label %29

; <label>:29
	; cond Block begin
	%30 = load i32, i32* %25
	%31 = icmp slt i32 %30, 3
	; cond Block end
	br i1 %31, label %32, label %50

; <label>:32
	; block start
	%33 = call %string* @runtime.newString(i32 3)
	%34 = getelementptr %string, %string* %33, i32 0, i32 1
	%35 = load i8*, i8** %34
	%36 = bitcast i8* %35 to i8*
	%37 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	%38 = getelementptr %string, %string* %33, i32 0, i32 0
	%39 = load i32, i32* %38
	%40 = add i32 %39, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %36, i8* %37, i32 %40, i1 false)
	%41 = load %string, %string* %33
	%42 = load i32, i32* %25
	; get slice index
	%43 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%44 = load i32*, i32** %43
	%45 = getelementptr i32, i32* %44, i32 %42
	%46 = load i32, i32* %45
	%47 = getelementptr %string, %string* %33, i32 0, i32 1
	%48 = load i8*, i8** %47
	%49 = call i32 (i8*, ...) @printf(i8* %48, i32 %46)
	; end block
	br label %26

; <label>:50
	; empty block
	; end block
	ret void
}

define void @test.newF() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %Per*
	%3 = alloca %Per*
	store %Per* %2, %Per** %3
	%4 = call %string* @runtime.newString(i32 11)
	%5 = getelementptr %string, %string* %4, i32 0, i32 1
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.4, i64 0, i64 0) to i8*
	%9 = getelementptr %string, %string* %4, i32 0, i32 0
	%10 = load i32, i32* %9
	%11 = add i32 %10, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 %11, i1 false)
	%12 = load %string, %string* %4
	%13 = load %Per*, %Per** %3
	%14 = getelementptr %Per, %Per* %13, i32 0, i32 0
	%15 = load %string, %string* %14
	store %string %12, %string* %14
	%16 = call %string* @runtime.newString(i32 3)
	%17 = getelementptr %string, %string* %16, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = bitcast i8* %18 to i8*
	%20 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	%21 = getelementptr %string, %string* %16, i32 0, i32 0
	%22 = load i32, i32* %21
	%23 = add i32 %22, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %20, i32 %23, i1 false)
	%24 = load %string, %string* %16
	%25 = load %Per*, %Per** %3
	%26 = getelementptr %Per, %Per* %25, i32 0, i32 0
	%27 = load %string, %string* %26
	%28 = getelementptr %string, %string* %16, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = getelementptr %string, %string* %26, i32 0, i32 1
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %29, i8* %31)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.copyt()
	call void @test.newF()
	call void @test.make1()
	; end block
	ret void
}

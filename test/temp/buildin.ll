%mapStruct = type {}
%string = type { i32, i8* }
%Per = type { %string }

@copyt.0 = constant [3 x i32] [i32 1, i32 2, i32 3]
@copyt.1 = constant [6 x i32] [i32 4, i32 5, i32 6, i32 7, i32 8, i32 9]
@str.0 = constant [19 x i8] c"%d-%d-%d-%d-%d-%d\0A\00"
@str.1 = constant [6 x i8] c"see@ \00"
@str.2 = constant [19 x i8] c"%s len=%d cap=%d \0A\00"
@str.3 = constant [4 x i8] c"%d\0A\00"
@str.4 = constant [12 x i8] c"asdfasdfasd\00"
@str.5 = constant [4 x i8] c"%s\0A\00"

declare i8* @malloc(i32)

define void @init_slice_i32({ i32, i32, i32, i32* }* %ptr, i32 %len) {
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

declare i32 @printf(i8*, ...)

define void @copyt() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 3, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [3 x i32]* @copyt.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 12, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call i8* @malloc(i32 20)
	%10 = bitcast i8* %9 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %10, i32 6)
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 0
	store i32 6, i32* %11
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%13 = load i32*, i32** %12
	%14 = bitcast i32* %13 to i8*
	%15 = bitcast [6 x i32]* @copyt.1 to i8*
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
	%28 = call %string* @newString(i32 19)
	%29 = getelementptr %string, %string* %28, i32 0, i32 1
	%30 = load i8*, i8** %29
	%31 = bitcast i8* %30 to i8*
	%32 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %31, i8* %32, i32 19, i1 false)
	%33 = load %string, %string* %28
	; get slice index
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%35 = load i32*, i32** %34
	%36 = getelementptr i32, i32* %35, i32 0
	%37 = load i32, i32* %36
	; get slice index
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%39 = load i32*, i32** %38
	%40 = getelementptr i32, i32* %39, i32 1
	%41 = load i32, i32* %40
	; get slice index
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%43 = load i32*, i32** %42
	%44 = getelementptr i32, i32* %43, i32 2
	%45 = load i32, i32* %44
	; get slice index
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%47 = load i32*, i32** %46
	%48 = getelementptr i32, i32* %47, i32 3
	%49 = load i32, i32* %48
	; get slice index
	%50 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%51 = load i32*, i32** %50
	%52 = getelementptr i32, i32* %51, i32 4
	%53 = load i32, i32* %52
	; get slice index
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%55 = load i32*, i32** %54
	%56 = getelementptr i32, i32* %55, i32 5
	%57 = load i32, i32* %56
	%58 = getelementptr %string, %string* %28, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = call i32 (i8*, ...) @printf(i8* %59, i32 %37, i32 %41, i32 %45, i32 %49, i32 %53, i32 %57)
	; end block
	ret void
}

define void @printSlice(%string %s, { i32, i32, i32, i32* } %x) {
; <label>:0
	; block start
	%1 = call %string* @newString(i32 0)
	store %string %s, %string* %1
	%2 = call i8* @malloc(i32 20)
	%3 = bitcast i8* %2 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* } %x, { i32, i32, i32, i32* }* %3
	%4 = call %string* @newString(i32 19)
	%5 = getelementptr %string, %string* %4, i32 0, i32 1
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 19, i1 false)
	%9 = load %string, %string* %4
	%10 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 1
	%15 = load i32, i32* %14
	%16 = getelementptr %string, %string* %4, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = getelementptr %string, %string* %1, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %17, i8* %19, i32 %12, i32 %15)
	; end block
	ret void
}

define void @make1() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %2, i32 3)
	%3 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%4 = call %string* @newString(i32 6)
	%5 = getelementptr %string, %string* %4, i32 0, i32 1
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 6, i1 false)
	%9 = load %string, %string* %4
	call void @printSlice(%string %9, { i32, i32, i32, i32* } %3)
	; get slice index
	%10 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%11 = load i32*, i32** %10
	%12 = getelementptr i32, i32* %11, i32 0
	%13 = load i32, i32* %12
	store i32 90, i32* %12
	; get slice index
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%15 = load i32*, i32** %14
	%16 = getelementptr i32, i32* %15, i32 1
	%17 = load i32, i32* %16
	store i32 50, i32* %16
	; get slice index
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%19 = load i32*, i32** %18
	%20 = getelementptr i32, i32* %19, i32 2
	%21 = load i32, i32* %20
	store i32 70, i32* %20
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
	%28 = icmp slt i32 %27, 3
	; cond Block end
	br i1 %28, label %29, label %44

; <label>:29
	; block start
	%30 = call %string* @newString(i32 4)
	%31 = getelementptr %string, %string* %30, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to i8*
	%34 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %33, i8* %34, i32 4, i1 false)
	%35 = load %string, %string* %30
	%36 = load i32, i32* %22
	; get slice index
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%38 = load i32*, i32** %37
	%39 = getelementptr i32, i32* %38, i32 %36
	%40 = load i32, i32* %39
	%41 = getelementptr %string, %string* %30, i32 0, i32 1
	%42 = load i8*, i8** %41
	%43 = call i32 (i8*, ...) @printf(i8* %42, i32 %40)
	; end block
	br label %23

; <label>:44
	; empty block
	; end block
	ret void
}

define void @newF() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 8)
	%2 = bitcast i8* %1 to %Per*
	%3 = alloca %Per*
	store %Per* %2, %Per** %3
	%4 = call %string* @newString(i32 12)
	%5 = getelementptr %string, %string* %4, i32 0, i32 1
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 12, i1 false)
	%9 = load %string, %string* %4
	%10 = load %Per*, %Per** %3
	%11 = getelementptr %Per, %Per* %10, i32 0, i32 0
	%12 = load %string, %string* %11
	store %string %9, %string* %11
	%13 = call %string* @newString(i32 4)
	%14 = getelementptr %string, %string* %13, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = bitcast i8* %15 to i8*
	%17 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %16, i8* %17, i32 4, i1 false)
	%18 = load %string, %string* %13
	%19 = load %Per*, %Per** %3
	%20 = getelementptr %Per, %Per* %19, i32 0, i32 0
	%21 = load %string, %string* %20
	%22 = getelementptr %string, %string* %13, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = getelementptr %string, %string* %20, i32 0, i32 1
	%25 = load i8*, i8** %24
	%26 = call i32 (i8*, ...) @printf(i8* %23, i8* %25)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @copyt()
	call void @newF()
	call void @make1()
	; end block
	ret void
}

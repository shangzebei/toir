%mapStruct = type {}
%string = type { i32, i8* }

@test.sliceRange.0 = constant [12 x i32] [i32 9, i32 7, i32 3, i32 5, i32 5, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8]
@str.0 = constant [21 x i8] c"len=%d cap=%d %d-%d\0A\00"
@test.slicecp.2 = constant [5 x i32] [i32 9, i32 7, i32 3, i32 5, i32 5]
@test.slicecp.3 = constant [4 x i32] [i32 9, i32 7, i32 3, i32 9]
@str.1 = constant [7 x i8] c"%d-%d\0A\00"
@str.2 = constant [4 x i8] c"%d\0A\00"
@str.3 = constant [4 x i8] c"%s\0A\00"
@test.sliceslice.7 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.4 = constant [4 x i8] c"%d\0A\00"

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

define i8* @runtime.rangePtr(i8* %ptr, i32 %low, i32 %high, i32 %bytes) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %low, i32* %1
	%2 = alloca i32
	store i32 %high, i32* %2
	%3 = alloca i32
	store i32 %bytes, i32* %3
	%4 = load i32, i32* %2
	%5 = load i32, i32* %1
	%6 = sub i32 %4, %5
	%7 = alloca i32
	store i32 %6, i32* %7
	%8 = load i32, i32* %7
	%9 = load i32, i32* %3
	%10 = mul i32 %8, %9
	%11 = alloca i32
	store i32 %10, i32* %11
	%12 = load i32, i32* %11
	%13 = call i8* @malloc(i32 %12)
	%14 = alloca i8*
	store i8* %13, i8** %14
	%15 = load i8*, i8** %14
	%16 = load i32, i32* %3
	%17 = load i32, i32* %1
	%18 = mul i32 %16, %17
	%19 = getelementptr i8, i8* %ptr, i32 %18
	%20 = load i32, i32* %11
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %15, i8* %19, i32 %20, i1 false)
	%21 = load i8*, i8** %14
	; end block
	ret i8* %21
}

define %string* @runtime.newString(i32 %size) {
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

define void @test.sliceRange() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %2, i32 12)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 12, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [12 x i32]* @test.sliceRange.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 48, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; start slice[]
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%13 = load i32, i32* %12
	%14 = call i8* @runtime.rangePtr(i8* %11, i32 3, i32 5, i32 %13)
	; copy and new slice
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = call i8* @malloc(i32 20)
	%18 = bitcast i8* %17 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %18, i32 %16)
	%19 = bitcast { i32, i32, i32, i32* }* %18 to i8*
	%20 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %20, i32 20, i1 false)
	; copy and end slice
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 3
	%22 = sub i32 5, 3
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 0
	store i32 %22, i32* %23
	%24 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 1
	store i32 %22, i32* %24
	%25 = bitcast i8* %14 to i32*
	store i32* %25, i32** %21
	; end slice[]
	%26 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18
	%27 = call %string* @runtime.newString(i32 20)
	%28 = getelementptr %string, %string* %27, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([21 x i8], [21 x i8]* @str.0, i64 0, i64 0) to i8*
	%32 = getelementptr %string, %string* %27, i32 0, i32 0
	%33 = load i32, i32* %32
	%34 = add i32 %33, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 %34, i1 false)
	%35 = load %string, %string* %27
	%36 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 0
	%37 = load i32, i32* %36
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 1
	%39 = load i32, i32* %38
	; get slice index
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 3
	%41 = load i32*, i32** %40
	%42 = getelementptr i32, i32* %41, i32 0
	%43 = load i32, i32* %42
	; get slice index
	%44 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 3
	%45 = load i32*, i32** %44
	%46 = getelementptr i32, i32* %45, i32 1
	%47 = load i32, i32* %46
	%48 = getelementptr %string, %string* %27, i32 0, i32 1
	%49 = load i8*, i8** %48
	%50 = call i32 (i8*, ...) @printf(i8* %49, i32 %37, i32 %39, i32 %43, i32 %47)
	; end block
	ret void
}

define void @test.slicecp() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %2, i32 5)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 5, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [5 x i32]* @test.slicecp.2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 20, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call i8* @malloc(i32 20)
	%10 = bitcast i8* %9 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %10, i32 4)
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 0
	store i32 4, i32* %11
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%13 = load i32*, i32** %12
	%14 = bitcast i32* %13 to i8*
	%15 = bitcast [4 x i32]* @test.slicecp.3 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 16, i1 false)
	%16 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10
	store { i32, i32, i32, i32* } %16, { i32, i32, i32, i32* }* %2
	%17 = call %string* @runtime.newString(i32 6)
	%18 = getelementptr %string, %string* %17, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0) to i8*
	%22 = getelementptr %string, %string* %17, i32 0, i32 0
	%23 = load i32, i32* %22
	%24 = add i32 %23, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 %24, i1 false)
	%25 = load %string, %string* %17
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%29 = load i32, i32* %28
	%30 = getelementptr %string, %string* %17, i32 0, i32 1
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %31, i32 %27, i32 %29)
	; end block
	ret void
}

define void @test.slicet() {
; <label>:0
	; block start
	%1 = alloca i32
	%2 = call i8* @malloc(i32 20)
	%3 = bitcast i8* %2 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %3, i32 4)
	; get slice index
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = getelementptr i32, i32* %5, i32 0
	%7 = load i32, i32* %6
	store i32 52, i32* %6
	; get slice index
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 3
	%9 = load i32*, i32** %8
	%10 = getelementptr i32, i32* %9, i32 1
	%11 = load i32, i32* %10
	store i32 0, i32* %10
	; get slice index
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 3
	%13 = load i32*, i32** %12
	%14 = getelementptr i32, i32* %13, i32 0
	%15 = load i32, i32* %14
	store i32 %15, i32* %1
	%16 = call %string* @runtime.newString(i32 3)
	%17 = getelementptr %string, %string* %16, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = bitcast i8* %18 to i8*
	%20 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	%21 = getelementptr %string, %string* %16, i32 0, i32 0
	%22 = load i32, i32* %21
	%23 = add i32 %22, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %20, i32 %23, i1 false)
	%24 = load %string, %string* %16
	; get slice index
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 3
	%26 = load i32*, i32** %25
	%27 = getelementptr i32, i32* %26, i32 0
	%28 = load i32, i32* %27
	%29 = getelementptr %string, %string* %16, i32 0, i32 1
	%30 = load i8*, i8** %29
	%31 = call i32 (i8*, ...) @printf(i8* %30, i32 %28)
	%32 = call %string* @runtime.newString(i32 3)
	%33 = getelementptr %string, %string* %32, i32 0, i32 1
	%34 = load i8*, i8** %33
	%35 = bitcast i8* %34 to i8*
	%36 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	%37 = getelementptr %string, %string* %32, i32 0, i32 0
	%38 = load i32, i32* %37
	%39 = add i32 %38, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %35, i8* %36, i32 %39, i1 false)
	%40 = load %string, %string* %32
	; get slice index
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %3, i32 0, i32 3
	%42 = load i32*, i32** %41
	%43 = getelementptr i32, i32* %42, i32 0
	%44 = load i32, i32* %43
	%45 = getelementptr %string, %string* %32, i32 0, i32 1
	%46 = load i8*, i8** %45
	%47 = call i32 (i8*, ...) @printf(i8* %46, i32 %44)
	; end block
	ret void
}

define void @"init_slice_{ i32, i32, i32, i32* }"({ i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 0, i32 2
	store i32 8, i32* %1
	%2 = mul i32 %len, 8
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* }* %5, { i32, i32, i32, i32* }** %4
	%6 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

define void @test.sliceslice() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	call void @"init_slice_{ i32, i32, i32, i32* }"({ i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 1)
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %4, i32 5)
	%5 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 0, i32 0
	store i32 5, i32* %5
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 0, i32 3
	%7 = load i32*, i32** %6
	%8 = bitcast i32* %7 to i8*
	%9 = bitcast [5 x i32]* @test.sliceslice.7 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 20, i1 false)
	%10 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4
	; get slice index
	%11 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 3
	%12 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %11
	%13 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %12, i32 0
	%14 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %13
	store { i32, i32, i32, i32* } %10, { i32, i32, i32, i32* }* %13
	; [range start]
	; get slice index
	%15 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 3
	%16 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %15
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0
	%18 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %17
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %17, i32 0, i32 0
	%20 = load i32, i32* %19
	%21 = alloca i32
	; [range end]
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
	%28 = icmp slt i32 %27, %20
	; cond Block end
	br i1 %28, label %29, label %48

; <label>:29
	; block start
	%30 = load i32, i32* %22
	; get slice index
	%31 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %17, i32 0, i32 3
	%32 = load i32*, i32** %31
	%33 = getelementptr i32, i32* %32, i32 %30
	%34 = load i32, i32* %33
	store i32 %34, i32* %21
	%35 = call %string* @runtime.newString(i32 3)
	%36 = getelementptr %string, %string* %35, i32 0, i32 1
	%37 = load i8*, i8** %36
	%38 = bitcast i8* %37 to i8*
	%39 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	%40 = getelementptr %string, %string* %35, i32 0, i32 0
	%41 = load i32, i32* %40
	%42 = add i32 %41, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %38, i8* %39, i32 %42, i1 false)
	%43 = load %string, %string* %35
	%44 = load i32, i32* %21
	%45 = getelementptr %string, %string* %35, i32 0, i32 1
	%46 = load i8*, i8** %45
	%47 = call i32 (i8*, ...) @printf(i8* %46, i32 %44)
	; end block
	br label %23

; <label>:48
	; empty block
	; end block
	ret void
}

define { i32, i32, i32, { i32, i32, i32, i32* }* }* @test.kkp({ i32, i32, i32, { i32, i32, i32, i32* }* } %kk) {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	store { i32, i32, i32, { i32, i32, i32, i32* }* } %kk, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2
	%3 = load { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2
	; end block
	ret { i32, i32, i32, { i32, i32, i32, i32* }* }* %2
}

define void @main() {
; <label>:0
	; block start
	call void @test.sliceRange()
	call void @test.sliceslice()
	; end block
	ret void
}

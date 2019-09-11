@sliceRange.0 = constant [12 x i32] [i32 9, i32 7, i32 3, i32 5, i32 5, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8]
@str.0 = constant [21 x i8] c"len=%d cap=%d %d-%d\0A\00"
@slicecp.2 = constant [5 x i32] [i32 9, i32 7, i32 3, i32 5, i32 5]
@slicecp.3 = constant [4 x i32] [i32 9, i32 7, i32 3, i32 9]
@str.1 = constant [7 x i8] c"%d-%d\0A\00"
@str.2 = constant [4 x i8] c"%d\0A\00"
@str.3 = constant [7 x i8] c"asaaa\0A\00"
@str.4 = constant [7 x i8] c"bbbbb\0A\00"
@slicet.8 = constant [2 x i8*] [i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.3, i64 0, i64 0), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.4, i64 0, i64 0)]
@str.5 = constant [4 x i8] c"%s\0A\00"
@sliceslice.10 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.6 = constant [4 x i8] c"%d\0A\00"

declare i8* @malloc(i32)

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define i8* @rangeSlice(i8* %ptr, i32 %low, i32 %high, i32 %bytes) {
; <label>:0
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
	ret i8* %21
}

declare i32 @printf(i8*, ...)

define void @sliceRange() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, i32* }
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 12, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	store i32 12, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 12, i32* %7
	; end init slice.................
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 12, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = bitcast [12 x i32]* @sliceRange.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 48, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; end slice[]
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%15 = load i32*, i32** %14
	%16 = bitcast i32* %15 to i8*
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%18 = load i32, i32* %17
	%19 = call i8* @rangeSlice(i8* %16, i32 3, i32 5, i32 %18)
	; copy and new slice
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%21 = load i32, i32* %20
	; init slice...............
	%array.36 = alloca { i32, i32, i32, i32* }
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 2
	store i32 4, i32* %22
	%23 = mul i32 %21, 4
	%24 = call i8* @malloc(i32 %23)
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 3
	%26 = bitcast i8* %24 to i32*
	store i32* %26, i32** %25
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 1
	store i32 %21, i32* %27
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 0
	store i32 %21, i32* %28
	; end init slice.................
	%29 = bitcast { i32, i32, i32, i32* }* %array.36 to i8*
	%30 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %29, i8* %30, i32 20, i1 false)
	; copy and end slice
	%31 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 3
	%32 = sub i32 5, 3
	%33 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 0
	store i32 %32, i32* %33
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 1
	store i32 %32, i32* %34
	%35 = bitcast i8* %19 to i32*
	store i32* %35, i32** %31
	; end slice[]
	%36 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 0
	%38 = load i32, i32* %37
	%39 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 1
	%40 = load i32, i32* %39
	; get slice index
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 3
	%42 = load i32*, i32** %41
	%43 = getelementptr i32, i32* %42, i32 0
	%44 = load i32, i32* %43
	; get slice index
	%45 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.36, i32 0, i32 3
	%46 = load i32*, i32** %45
	%47 = getelementptr i32, i32* %46, i32 1
	%48 = load i32, i32* %47
	%49 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @str.0, i64 0, i64 0), i32 %38, i32 %40, i32 %44, i32 %48)
	ret void
}

define void @slicecp() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, i32* }
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 5, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	store i32 5, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 5, i32* %7
	; end init slice.................
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 5, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = bitcast [5 x i32]* @slicecp.2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 20, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; init slice...............
	%array.26 = alloca { i32, i32, i32, i32* }
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 2
	store i32 4, i32* %14
	%15 = mul i32 4, 4
	%16 = call i8* @malloc(i32 %15)
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%18 = bitcast i8* %16 to i32*
	store i32* %18, i32** %17
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 1
	store i32 4, i32* %19
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 0
	store i32 4, i32* %20
	; end init slice.................
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 0
	store i32 4, i32* %21
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%23 = load i32*, i32** %22
	%24 = bitcast i32* %23 to i8*
	%25 = bitcast [4 x i32]* @slicecp.3 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 16, i1 false)
	%26 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26
	store { i32, i32, i32, i32* } %26, { i32, i32, i32, i32* }* %array.4
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%28 = load i32, i32* %27
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%30 = load i32, i32* %29
	%31 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0), i32 %28, i32 %30)
	ret void
}

define void @slicet() {
; <label>:0
	%1 = alloca i32
	; init slice...............
	%array.5 = alloca { i32, i32, i32, i32* }
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 2
	store i32 4, i32* %2
	%3 = mul i32 4, 4
	%4 = call i8* @malloc(i32 %3)
	%5 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 3
	%6 = bitcast i8* %4 to i32*
	store i32* %6, i32** %5
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 1
	store i32 4, i32* %7
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 0
	store i32 4, i32* %8
	; end init slice.................
	; get slice index
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = getelementptr i32, i32* %10, i32 0
	%12 = load i32, i32* %11
	store i32 52, i32* %11
	; get slice index
	%13 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 3
	%14 = load i32*, i32** %13
	%15 = getelementptr i32, i32* %14, i32 1
	%16 = load i32, i32* %15
	store i32 0, i32* %15
	; get slice index
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 3
	%18 = load i32*, i32** %17
	%19 = getelementptr i32, i32* %18, i32 0
	%20 = load i32, i32* %19
	store i32 %20, i32* %1
	; get slice index
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 3
	%22 = load i32*, i32** %21
	%23 = getelementptr i32, i32* %22, i32 0
	%24 = load i32, i32* %23
	%25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0), i32 %24)
	; init slice...............
	%array.43 = alloca { i32, i32, i32, i8** }
	%26 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %array.43, i32 0, i32 2
	store i32 8, i32* %26
	%27 = mul i32 2, 8
	%28 = call i8* @malloc(i32 %27)
	%29 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %array.43, i32 0, i32 3
	%30 = bitcast i8* %28 to i8**
	store i8** %30, i8*** %29
	%31 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %array.43, i32 0, i32 1
	store i32 2, i32* %31
	%32 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %array.43, i32 0, i32 0
	store i32 2, i32* %32
	; end init slice.................
	%33 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %array.43, i32 0, i32 0
	store i32 2, i32* %33
	%34 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %array.43, i32 0, i32 3
	%35 = load i8**, i8*** %34
	%36 = bitcast i8** %35 to i8*
	%37 = bitcast [2 x i8*]* @slicet.8 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %36, i8* %37, i32 16, i1 false)
	%38 = load { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %array.43
	; get slice index
	%39 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.5, i32 0, i32 3
	%40 = load i32*, i32** %39
	%41 = getelementptr i32, i32* %40, i32 0
	%42 = load i32, i32* %41
	; get slice index
	%43 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %array.43, i32 0, i32 3
	%44 = load i8**, i8*** %43
	%45 = getelementptr i8*, i8** %44, i32 %42
	%46 = load i8*, i8** %45
	%47 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0), i8* %46)
	ret void
}

define void @sliceslice() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, { i32, i32, i32, i32* }* }
	%1 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %array.4, i32 0, i32 2
	store i32 8, i32* %1
	%2 = mul i32 1, 8
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* }* %5, { i32, i32, i32, i32* }** %4
	%6 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %array.4, i32 0, i32 1
	store i32 1, i32* %6
	%7 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %array.4, i32 0, i32 0
	store i32 1, i32* %7
	; end init slice.................
	; init slice...............
	%array.18 = alloca { i32, i32, i32, i32* }
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.18, i32 0, i32 2
	store i32 4, i32* %8
	%9 = mul i32 5, 4
	%10 = call i8* @malloc(i32 %9)
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.18, i32 0, i32 3
	%12 = bitcast i8* %10 to i32*
	store i32* %12, i32** %11
	%13 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.18, i32 0, i32 1
	store i32 5, i32* %13
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.18, i32 0, i32 0
	store i32 5, i32* %14
	; end init slice.................
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.18, i32 0, i32 0
	store i32 5, i32* %15
	%16 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.18, i32 0, i32 3
	%17 = load i32*, i32** %16
	%18 = bitcast i32* %17 to i8*
	%19 = bitcast [5 x i32]* @sliceslice.10 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 20, i1 false)
	%20 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.18
	; get slice index
	%21 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %array.4, i32 0, i32 3
	%22 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %21
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %22, i32 0
	%24 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %23
	store { i32, i32, i32, i32* } %20, { i32, i32, i32, i32* }* %23
	; [range start]
	; get slice index
	%25 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %array.4, i32 0, i32 3
	%26 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %25
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %26, i32 0
	%28 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %27
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %27, i32 0, i32 0
	%30 = load i32, i32* %29
	%31 = alloca i32
	; [range end]
	; init block
	%32 = alloca i32
	store i32 0, i32* %32
	br label %36

; <label>:33
	; add block
	%34 = load i32, i32* %32
	%35 = add i32 %34, 1
	store i32 %35, i32* %32
	br label %36

; <label>:36
	; cond Block begin
	%37 = load i32, i32* %32
	%38 = icmp slt i32 %37, %30
	; cond Block end
	br i1 %38, label %39, label %47

; <label>:39
	%40 = load i32, i32* %32
	; get slice index
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %27, i32 0, i32 3
	%42 = load i32*, i32** %41
	%43 = getelementptr i32, i32* %42, i32 %40
	%44 = load i32, i32* %43
	store i32 %44, i32* %31
	%45 = load i32, i32* %31
	%46 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.6, i64 0, i64 0), i32 %45)
	br label %33

; <label>:47
	; empty block
	ret void
}

define { i32, i32, i32, { i32, i32, i32, i32* }* } @kkp({ i32, i32, i32, { i32, i32, i32, i32* }* } %kk) {
; <label>:0
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	store { i32, i32, i32, { i32, i32, i32, i32* }* } %kk, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2
	%3 = load { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2
	ret { i32, i32, i32, { i32, i32, i32, i32* }* } %3
}

define void @main() {
; <label>:0
	call void @sliceRange()
	call void @sliceslice()
	ret void
}

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

define { i32, i32, i32, i32* }* @init_slice_i32(i32 %len) {
; <label>:0
	; init slice...............
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	store i32 4, i32* %3
	%4 = mul i32 %len, 4
	%5 = call i8* @malloc(i32 %4)
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%7 = bitcast i8* %5 to i32*
	store i32* %7, i32** %6
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	store i32 %len, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 %len, i32* %9
	; end init slice.................
	ret { i32, i32, i32, i32* }* %2
}

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
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 12)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 12, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [12 x i32]* @sliceRange.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 48, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	; end slice[]
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%9 = load i32*, i32** %8
	%10 = bitcast i32* %9 to i8*
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%12 = load i32, i32* %11
	%13 = call i8* @rangeSlice(i8* %10, i32 3, i32 5, i32 %12)
	; copy and new slice
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %15)
	%17 = bitcast { i32, i32, i32, i32* }* %16 to i8*
	%18 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %17, i8* %18, i32 20, i1 false)
	; copy and end slice
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 3
	%20 = sub i32 5, 3
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 0
	store i32 %20, i32* %21
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 1
	store i32 %20, i32* %22
	%23 = bitcast i8* %13 to i32*
	store i32* %23, i32** %19
	; end slice[]
	%24 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 0
	%26 = load i32, i32* %25
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 1
	%28 = load i32, i32* %27
	; get slice index
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 3
	%30 = load i32*, i32** %29
	%31 = getelementptr i32, i32* %30, i32 0
	%32 = load i32, i32* %31
	; get slice index
	%33 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 3
	%34 = load i32*, i32** %33
	%35 = getelementptr i32, i32* %34, i32 1
	%36 = load i32, i32* %35
	%37 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @str.0, i64 0, i64 0), i32 %26, i32 %28, i32 %32, i32 %36)
	ret void
}

define void @slicecp() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 5)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 5, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [5 x i32]* @slicecp.2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 20, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	%8 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 4)
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 0
	store i32 4, i32* %9
	%10 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%11 = load i32*, i32** %10
	%12 = bitcast i32* %11 to i8*
	%13 = bitcast [4 x i32]* @slicecp.3 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 16, i1 false)
	%14 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8
	store { i32, i32, i32, i32* } %14, { i32, i32, i32, i32* }* %1
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%18 = load i32, i32* %17
	%19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0), i32 %16, i32 %18)
	ret void
}

define { i32, i32, i32, i8** }* @"init_slice_i8*"(i32 %len) {
; <label>:0
	; init slice...............
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i8** }*
	%3 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %2, i32 0, i32 2
	store i32 8, i32* %3
	%4 = mul i32 %len, 8
	%5 = call i8* @malloc(i32 %4)
	%6 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %2, i32 0, i32 3
	%7 = bitcast i8* %5 to i8**
	store i8** %7, i8*** %6
	%8 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %2, i32 0, i32 1
	store i32 %len, i32* %8
	%9 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %2, i32 0, i32 0
	store i32 %len, i32* %9
	; end init slice.................
	ret { i32, i32, i32, i8** }* %2
}

define void @slicet() {
; <label>:0
	%1 = alloca i32
	%2 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 4)
	; get slice index
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = getelementptr i32, i32* %4, i32 0
	%6 = load i32, i32* %5
	store i32 52, i32* %5
	; get slice index
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%8 = load i32*, i32** %7
	%9 = getelementptr i32, i32* %8, i32 1
	%10 = load i32, i32* %9
	store i32 0, i32* %9
	; get slice index
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%12 = load i32*, i32** %11
	%13 = getelementptr i32, i32* %12, i32 0
	%14 = load i32, i32* %13
	store i32 %14, i32* %1
	; get slice index
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%16 = load i32*, i32** %15
	%17 = getelementptr i32, i32* %16, i32 0
	%18 = load i32, i32* %17
	%19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0), i32 %18)
	%20 = call { i32, i32, i32, i8** }* @"init_slice_i8*"(i32 2)
	%21 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %20, i32 0, i32 0
	store i32 2, i32* %21
	%22 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %20, i32 0, i32 3
	%23 = load i8**, i8*** %22
	%24 = bitcast i8** %23 to i8*
	%25 = bitcast [2 x i8*]* @slicet.8 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 16, i1 false)
	%26 = load { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %20
	; get slice index
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%28 = load i32*, i32** %27
	%29 = getelementptr i32, i32* %28, i32 0
	%30 = load i32, i32* %29
	; get slice index
	%31 = getelementptr { i32, i32, i32, i8** }, { i32, i32, i32, i8** }* %20, i32 0, i32 3
	%32 = load i8**, i8*** %31
	%33 = getelementptr i8*, i8** %32, i32 %30
	%34 = load i8*, i8** %33
	%35 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0), i8* %34)
	ret void
}

define { i32, i32, i32, { i32, i32, i32, i32* }* }* @"init_slice_{ i32, i32, i32, i32* }"(i32 %len) {
; <label>:0
	; init slice...............
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	%3 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 2
	store i32 8, i32* %3
	%4 = mul i32 %len, 8
	%5 = call i8* @malloc(i32 %4)
	%6 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 3
	%7 = bitcast i8* %5 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* }* %7, { i32, i32, i32, i32* }** %6
	%8 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 1
	store i32 %len, i32* %8
	%9 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 0
	store i32 %len, i32* %9
	; end init slice.................
	ret { i32, i32, i32, { i32, i32, i32, i32* }* }* %2
}

define void @sliceslice() {
; <label>:0
	%1 = call { i32, i32, i32, { i32, i32, i32, i32* }* }* @"init_slice_{ i32, i32, i32, i32* }"(i32 1)
	%2 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 5)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 5, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [5 x i32]* @sliceslice.10 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 20, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; get slice index
	%9 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %1, i32 0, i32 3
	%10 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %9
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0
	%12 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %11
	store { i32, i32, i32, i32* } %8, { i32, i32, i32, i32* }* %11
	; [range start]
	; get slice index
	%13 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %1, i32 0, i32 3
	%14 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %13
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %14, i32 0
	%16 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %15
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %15, i32 0, i32 0
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
	br i1 %26, label %27, label %35

; <label>:27
	%28 = load i32, i32* %20
	; get slice index
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %15, i32 0, i32 3
	%30 = load i32*, i32** %29
	%31 = getelementptr i32, i32* %30, i32 %28
	%32 = load i32, i32* %31
	store i32 %32, i32* %19
	%33 = load i32, i32* %19
	%34 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.6, i64 0, i64 0), i32 %33)
	br label %21

; <label>:35
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

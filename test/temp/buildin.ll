%Per = type { i8* }

@copyt.0 = constant [3 x i32] [i32 1, i32 2, i32 3]
@copyt.1 = constant [6 x i32] [i32 4, i32 5, i32 6, i32 7, i32 8, i32 9]
@str.0 = constant [19 x i8] c"%d-%d-%d-%d-%d-%d\0A\00"
@str.1 = constant [6 x i8] c"see@ \00"
@str.2 = constant [19 x i8] c"%s len=%d cap=%d \0A\00"
@str.3 = constant [4 x i8] c"%d\0A\00"
@str.4 = constant [12 x i8] c"asdfasdfasd\00"
@str.5 = constant [4 x i8] c"%s\0A\00"

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

declare i32 @printf(i8*, ...)

define void @copyt() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 3)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 3, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [3 x i32]* @copyt.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 12, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	%8 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 6)
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 0
	store i32 6, i32* %9
	%10 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%11 = load i32*, i32** %10
	%12 = bitcast i32* %11 to i8*
	%13 = bitcast [6 x i32]* @copyt.1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 24, i1 false)
	%14 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8
	; copy ptr..........start
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%18 = load i32*, i32** %17
	%19 = bitcast i32* %18 to i8*
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%21 = load i32*, i32** %20
	%22 = bitcast i32* %21 to i8*
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%24 = load i32, i32* %23
	%25 = mul i32 %16, %24
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %22, i32 %25, i1 false)
	; copy ptr..........end
	; get slice index
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%27 = load i32*, i32** %26
	%28 = getelementptr i32, i32* %27, i32 0
	%29 = load i32, i32* %28
	; get slice index
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%31 = load i32*, i32** %30
	%32 = getelementptr i32, i32* %31, i32 1
	%33 = load i32, i32* %32
	; get slice index
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%35 = load i32*, i32** %34
	%36 = getelementptr i32, i32* %35, i32 2
	%37 = load i32, i32* %36
	; get slice index
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%39 = load i32*, i32** %38
	%40 = getelementptr i32, i32* %39, i32 3
	%41 = load i32, i32* %40
	; get slice index
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%43 = load i32*, i32** %42
	%44 = getelementptr i32, i32* %43, i32 4
	%45 = load i32, i32* %44
	; get slice index
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%47 = load i32*, i32** %46
	%48 = getelementptr i32, i32* %47, i32 5
	%49 = load i32, i32* %48
	%50 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.0, i64 0, i64 0), i32 %29, i32 %33, i32 %37, i32 %41, i32 %45, i32 %49)
	ret void
}

define void @printSlice(i8* %s, { i32, i32, i32, i32* } %x) {
; <label>:0
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* } %x, { i32, i32, i32, i32* }* %2
	%3 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%5 = load i32, i32* %4
	%6 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%8 = load i32, i32* %7
	%9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.2, i64 0, i64 0), i8* %s, i32 %5, i32 %8)
	ret void
}

define void @make1() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 3)
	%2 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	call void @printSlice(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0), { i32, i32, i32, i32* } %2)
	; get slice index
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = getelementptr i32, i32* %4, i32 0
	%6 = load i32, i32* %5
	store i32 90, i32* %5
	; get slice index
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%8 = load i32*, i32** %7
	%9 = getelementptr i32, i32* %8, i32 1
	%10 = load i32, i32* %9
	store i32 50, i32* %9
	; get slice index
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%12 = load i32*, i32** %11
	%13 = getelementptr i32, i32* %12, i32 2
	%14 = load i32, i32* %13
	store i32 70, i32* %13
	; init block
	%15 = alloca i32
	store i32 0, i32* %15
	br label %19

; <label>:16
	; add block
	%17 = load i32, i32* %15
	%18 = add i32 %17, 1
	store i32 %18, i32* %15
	br label %19

; <label>:19
	; cond Block begin
	%20 = load i32, i32* %15
	%21 = icmp slt i32 %20, 3
	; cond Block end
	br i1 %21, label %22, label %29

; <label>:22
	%23 = load i32, i32* %15
	; get slice index
	%24 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%25 = load i32*, i32** %24
	%26 = getelementptr i32, i32* %25, i32 %23
	%27 = load i32, i32* %26
	%28 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0), i32 %27)
	br label %16

; <label>:29
	; empty block
	ret void
}

define void @newF() {
; <label>:0
	%1 = call i8* @malloc(i32 8)
	%2 = bitcast i8* %1 to %Per*
	%3 = alloca %Per*
	store %Per* %2, %Per** %3
	%4 = load %Per*, %Per** %3
	%5 = getelementptr %Per, %Per* %4, i32 0, i32 0
	%6 = load i8*, i8** %5
	store i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.4, i64 0, i64 0), i8** %5
	%7 = load %Per*, %Per** %3
	%8 = getelementptr %Per, %Per* %7, i32 0, i32 0
	%9 = load i8*, i8** %8
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0), i8* %9)
	ret void
}

define void @main() {
; <label>:0
	call void @copyt()
	call void @newF()
	call void @make1()
	ret void
}

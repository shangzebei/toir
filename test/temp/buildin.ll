%Per = type { { i32, i32, i32, i8* } }

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
	%28 = call i8* @malloc(i32 20)
	%29 = bitcast i8* %28 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %29, i32 19)
	%30 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %29, i32 0, i32 0
	store i32 19, i32* %30
	%31 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %29, i32 0, i32 3
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to i8*
	%34 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %33, i8* %34, i32 19, i1 false)
	%35 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %29
	; get slice index
	%36 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%37 = load i32*, i32** %36
	%38 = getelementptr i32, i32* %37, i32 0
	%39 = load i32, i32* %38
	; get slice index
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%41 = load i32*, i32** %40
	%42 = getelementptr i32, i32* %41, i32 1
	%43 = load i32, i32* %42
	; get slice index
	%44 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%45 = load i32*, i32** %44
	%46 = getelementptr i32, i32* %45, i32 2
	%47 = load i32, i32* %46
	; get slice index
	%48 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%49 = load i32*, i32** %48
	%50 = getelementptr i32, i32* %49, i32 3
	%51 = load i32, i32* %50
	; get slice index
	%52 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%53 = load i32*, i32** %52
	%54 = getelementptr i32, i32* %53, i32 4
	%55 = load i32, i32* %54
	; get slice index
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%57 = load i32*, i32** %56
	%58 = getelementptr i32, i32* %57, i32 5
	%59 = load i32, i32* %58
	%60 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %29, i32 0, i32 3
	%61 = load i8*, i8** %60
	%62 = call i32 (i8*, ...) @printf(i8* %61, i32 %39, i32 %43, i32 %47, i32 %51, i32 %55, i32 %59)
	; end block
	ret void
}

define void @printSlice({ i32, i32, i32, i8* } %s, { i32, i32, i32, i32* } %x) {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %2, i32 0)
	store { i32, i32, i32, i8* } %s, { i32, i32, i32, i8* }* %2
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* } %x, { i32, i32, i32, i32* }* %4
	%5 = call i8* @malloc(i32 20)
	%6 = bitcast i8* %5 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %6, i32 19)
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 0
	store i32 19, i32* %7
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 3
	%9 = load i8*, i8** %8
	%10 = bitcast i8* %9 to i8*
	%11 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %11, i32 19, i1 false)
	%12 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 0, i32 1
	%18 = load i32, i32* %17
	%19 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 3
	%20 = load i8*, i8** %19
	%21 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%22 = load i8*, i8** %21
	%23 = call i32 (i8*, ...) @printf(i8* %20, i8* %22, i32 %15, i32 %18)
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
	%4 = call i8* @malloc(i32 20)
	%5 = bitcast i8* %4 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %5, i32 6)
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5, i32 0, i32 0
	store i32 6, i32* %6
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5, i32 0, i32 3
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 6, i1 false)
	%11 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5
	call void @printSlice({ i32, i32, i32, i8* } %11, { i32, i32, i32, i32* } %3)
	; get slice index
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%13 = load i32*, i32** %12
	%14 = getelementptr i32, i32* %13, i32 0
	%15 = load i32, i32* %14
	store i32 90, i32* %14
	; get slice index
	%16 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%17 = load i32*, i32** %16
	%18 = getelementptr i32, i32* %17, i32 1
	%19 = load i32, i32* %18
	store i32 50, i32* %18
	; get slice index
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%21 = load i32*, i32** %20
	%22 = getelementptr i32, i32* %21, i32 2
	%23 = load i32, i32* %22
	store i32 70, i32* %22
	; init block
	%24 = alloca i32
	store i32 0, i32* %24
	br label %28

; <label>:25
	; add block
	%26 = load i32, i32* %24
	%27 = add i32 %26, 1
	store i32 %27, i32* %24
	br label %28

; <label>:28
	; cond Block begin
	%29 = load i32, i32* %24
	%30 = icmp slt i32 %29, 3
	; cond Block end
	br i1 %30, label %31, label %48

; <label>:31
	; block start
	%32 = call i8* @malloc(i32 20)
	%33 = bitcast i8* %32 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %33, i32 4)
	%34 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %33, i32 0, i32 0
	store i32 4, i32* %34
	%35 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %33, i32 0, i32 3
	%36 = load i8*, i8** %35
	%37 = bitcast i8* %36 to i8*
	%38 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %37, i8* %38, i32 4, i1 false)
	%39 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %33
	%40 = load i32, i32* %24
	; get slice index
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%42 = load i32*, i32** %41
	%43 = getelementptr i32, i32* %42, i32 %40
	%44 = load i32, i32* %43
	%45 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %33, i32 0, i32 3
	%46 = load i8*, i8** %45
	%47 = call i32 (i8*, ...) @printf(i8* %46, i32 %44)
	; end block
	br label %25

; <label>:48
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
	%4 = call i8* @malloc(i32 20)
	%5 = bitcast i8* %4 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %5, i32 12)
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5, i32 0, i32 0
	store i32 12, i32* %6
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5, i32 0, i32 3
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 12, i1 false)
	%11 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5
	%12 = load %Per*, %Per** %3
	%13 = getelementptr %Per, %Per* %12, i32 0, i32 0
	%14 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %13
	store { i32, i32, i32, i8* } %11, { i32, i32, i32, i8* }* %13
	%15 = call i8* @malloc(i32 20)
	%16 = bitcast i8* %15 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %16, i32 4)
	%17 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 0
	store i32 4, i32* %17
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 4, i1 false)
	%22 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16
	%23 = load %Per*, %Per** %3
	%24 = getelementptr %Per, %Per* %23, i32 0, i32 0
	%25 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %24
	%26 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 3
	%27 = load i8*, i8** %26
	%28 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %24, i32 0, i32 3
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %27, i8* %29)
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

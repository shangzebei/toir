@range1asdfasdfs.0 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.0 = constant [22 x i8] c"asdfasdfasdfsdfsdf%d\0A\00"
@range2.2 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.1 = constant [7 x i8] c"%d-%d\0A\00"
@range3.4 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.2 = constant [4 x i8] c"%d\0A\00"
@range4.6 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.3 = constant [4 x i8] c"%d\0A\00"
@range5.8 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@range5.9 = constant [5 x i32] [i32 11, i32 22, i32 33, i32 44, i32 55]
@str.4 = constant [20 x i8] c"=====[row %d]==== \0A\00"
@str.5 = constant [4 x i8] c"%d \00"
@str.6 = constant [5 x i8] c"end\0A\00"

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

define void @range1asdfasdfs() {
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
	%7 = bitcast [5 x i32]* @range1asdfasdfs.0 to i8*
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
	br i1 %18, label %19, label %33

; <label>:19
	; block start
	%20 = load i32, i32* %12
	store i32 %20, i32* %11
	%21 = call i8* @malloc(i32 20)
	%22 = bitcast i8* %21 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %22, i32 22)
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 0
	store i32 22, i32* %23
	%24 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to i8*
	%27 = bitcast i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 22, i1 false)
	%28 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22
	%29 = load i32, i32* %11
	%30 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %31, i32 %29)
	; end block
	br label %13

; <label>:33
	; empty block
	; end block
	ret void
}

define void @range2() {
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
	%7 = bitcast [5 x i32]* @range2.2 to i8*
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
	br i1 %19, label %20, label %40

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
	%27 = call i8* @malloc(i32 20)
	%28 = bitcast i8* %27 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %28, i32 7)
	%29 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 0
	store i32 7, i32* %29
	%30 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 3
	%31 = load i8*, i8** %30
	%32 = bitcast i8* %31 to i8*
	%33 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %32, i8* %33, i32 7, i1 false)
	%34 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28
	%35 = load i32, i32* %11
	%36 = load i32, i32* %12
	%37 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 3
	%38 = load i8*, i8** %37
	%39 = call i32 (i8*, ...) @printf(i8* %38, i32 %35, i32 %36)
	; end block
	br label %14

; <label>:40
	; empty block
	; end block
	ret void
}

define void @range3() {
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
	%7 = bitcast [5 x i32]* @range3.4 to i8*
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
	br i1 %18, label %19, label %37

; <label>:19
	; block start
	%20 = load i32, i32* %12
	; get slice index
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%22 = load i32*, i32** %21
	%23 = getelementptr i32, i32* %22, i32 %20
	%24 = load i32, i32* %23
	store i32 %24, i32* %11
	%25 = call i8* @malloc(i32 20)
	%26 = bitcast i8* %25 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %26, i32 4)
	%27 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 0
	store i32 4, i32* %27
	%28 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 3
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 4, i1 false)
	%32 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26
	%33 = load i32, i32* %11
	%34 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 3
	%35 = load i8*, i8** %34
	%36 = call i32 (i8*, ...) @printf(i8* %35, i32 %33)
	; end block
	br label %13

; <label>:37
	; empty block
	; end block
	ret void
}

define void @range4() {
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
	%7 = bitcast [5 x i32]* @range4.6 to i8*
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
	br i1 %18, label %19, label %33

; <label>:19
	; block start
	%20 = load i32, i32* %12
	store i32 %20, i32* %11
	%21 = call i8* @malloc(i32 20)
	%22 = bitcast i8* %21 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %22, i32 4)
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 0
	store i32 4, i32* %23
	%24 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to i8*
	%27 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 4, i1 false)
	%28 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22
	%29 = load i32, i32* %11
	%30 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %31, i32 %29)
	; end block
	br label %13

; <label>:33
	; empty block
	; end block
	ret void
}

define void @range5() {
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
	%7 = bitcast [5 x i32]* @range5.8 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 20, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call i8* @malloc(i32 20)
	%10 = bitcast i8* %9 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %10, i32 5)
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 0
	store i32 5, i32* %11
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%13 = load i32*, i32** %12
	%14 = bitcast i32* %13 to i8*
	%15 = bitcast [5 x i32]* @range5.9 to i8*
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
	br i1 %26, label %27, label %81

; <label>:27
	; block start
	%28 = load i32, i32* %20
	store i32 %28, i32* %19
	%29 = call i8* @malloc(i32 20)
	%30 = bitcast i8* %29 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %30, i32 20)
	%31 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 0
	store i32 20, i32* %31
	%32 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 3
	%33 = load i8*, i8** %32
	%34 = bitcast i8* %33 to i8*
	%35 = bitcast i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %34, i8* %35, i32 20, i1 false)
	%36 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30
	%37 = load i32, i32* %19
	%38 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 3
	%39 = load i8*, i8** %38
	%40 = call i32 (i8*, ...) @printf(i8* %39, i32 %37)
	; [range start]
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 0
	%42 = load i32, i32* %41
	%43 = alloca i32
	; [range end]
	; init block
	%44 = alloca i32
	store i32 0, i32* %44
	br label %48

; <label>:45
	; add block
	%46 = load i32, i32* %44
	%47 = add i32 %46, 1
	store i32 %47, i32* %44
	br label %48

; <label>:48
	; cond Block begin
	%49 = load i32, i32* %44
	%50 = icmp slt i32 %49, %42
	; cond Block end
	br i1 %50, label %51, label %69

; <label>:51
	; block start
	%52 = load i32, i32* %44
	; get slice index
	%53 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%54 = load i32*, i32** %53
	%55 = getelementptr i32, i32* %54, i32 %52
	%56 = load i32, i32* %55
	store i32 %56, i32* %43
	%57 = call i8* @malloc(i32 20)
	%58 = bitcast i8* %57 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %58, i32 4)
	%59 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %58, i32 0, i32 0
	store i32 4, i32* %59
	%60 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %58, i32 0, i32 3
	%61 = load i8*, i8** %60
	%62 = bitcast i8* %61 to i8*
	%63 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %62, i8* %63, i32 4, i1 false)
	%64 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %58
	%65 = load i32, i32* %43
	%66 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %58, i32 0, i32 3
	%67 = load i8*, i8** %66
	%68 = call i32 (i8*, ...) @printf(i8* %67, i32 %65)
	; end block
	br label %45

; <label>:69
	; empty block
	%70 = call i8* @malloc(i32 20)
	%71 = bitcast i8* %70 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %71, i32 5)
	%72 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %71, i32 0, i32 0
	store i32 5, i32* %72
	%73 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %71, i32 0, i32 3
	%74 = load i8*, i8** %73
	%75 = bitcast i8* %74 to i8*
	%76 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %75, i8* %76, i32 5, i1 false)
	%77 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %71
	%78 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %71, i32 0, i32 3
	%79 = load i8*, i8** %78
	%80 = call i32 (i8*, ...) @printf(i8* %79)
	; end block
	br label %21

; <label>:81
	; empty block
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @range1asdfasdfs()
	call void @range2()
	call void @range3()
	call void @range4()
	call void @range5()
	; end block
	ret void
}

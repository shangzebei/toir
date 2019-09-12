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

define void @range1asdfasdfs() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 5)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 5, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [5 x i32]* @range1asdfasdfs.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 20, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	; [range start]
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = alloca i32
	; [range end]
	; init block
	%11 = alloca i32
	store i32 0, i32* %11
	br label %15

; <label>:12
	; add block
	%13 = load i32, i32* %11
	%14 = add i32 %13, 1
	store i32 %14, i32* %11
	br label %15

; <label>:15
	; cond Block begin
	%16 = load i32, i32* %11
	%17 = icmp slt i32 %16, %9
	; cond Block end
	br i1 %17, label %18, label %22

; <label>:18
	%19 = load i32, i32* %11
	store i32 %19, i32* %10
	%20 = load i32, i32* %10
	%21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.0, i64 0, i64 0), i32 %20)
	br label %12

; <label>:22
	; empty block
	ret void
}

define void @range2() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 5)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 5, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [5 x i32]* @range2.2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 20, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	; [range start]
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = alloca i32
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
	%18 = icmp slt i32 %17, %9
	; cond Block end
	br i1 %18, label %19, label %29

; <label>:19
	%20 = load i32, i32* %12
	store i32 %20, i32* %10
	%21 = load i32, i32* %12
	; get slice index
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%23 = load i32*, i32** %22
	%24 = getelementptr i32, i32* %23, i32 %21
	%25 = load i32, i32* %24
	store i32 %25, i32* %11
	%26 = load i32, i32* %10
	%27 = load i32, i32* %11
	%28 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0), i32 %26, i32 %27)
	br label %13

; <label>:29
	; empty block
	ret void
}

define void @range3() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 5)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 5, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [5 x i32]* @range3.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 20, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	; [range start]
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = alloca i32
	; [range end]
	; init block
	%11 = alloca i32
	store i32 0, i32* %11
	br label %15

; <label>:12
	; add block
	%13 = load i32, i32* %11
	%14 = add i32 %13, 1
	store i32 %14, i32* %11
	br label %15

; <label>:15
	; cond Block begin
	%16 = load i32, i32* %11
	%17 = icmp slt i32 %16, %9
	; cond Block end
	br i1 %17, label %18, label %26

; <label>:18
	%19 = load i32, i32* %11
	; get slice index
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%21 = load i32*, i32** %20
	%22 = getelementptr i32, i32* %21, i32 %19
	%23 = load i32, i32* %22
	store i32 %23, i32* %10
	%24 = load i32, i32* %10
	%25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0), i32 %24)
	br label %12

; <label>:26
	; empty block
	ret void
}

define void @range4() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 5)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 5, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [5 x i32]* @range4.6 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 20, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	; [range start]
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = alloca i32
	; [range end]
	; init block
	%11 = alloca i32
	store i32 0, i32* %11
	br label %15

; <label>:12
	; add block
	%13 = load i32, i32* %11
	%14 = add i32 %13, 1
	store i32 %14, i32* %11
	br label %15

; <label>:15
	; cond Block begin
	%16 = load i32, i32* %11
	%17 = icmp slt i32 %16, %9
	; cond Block end
	br i1 %17, label %18, label %22

; <label>:18
	%19 = load i32, i32* %11
	store i32 %19, i32* %10
	%20 = load i32, i32* %10
	%21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0), i32 %20)
	br label %12

; <label>:22
	; empty block
	ret void
}

define void @range5() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 5)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 5, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [5 x i32]* @range5.8 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 20, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	%8 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 5)
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 0
	store i32 5, i32* %9
	%10 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%11 = load i32*, i32** %10
	%12 = bitcast i32* %11 to i8*
	%13 = bitcast [5 x i32]* @range5.9 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 20, i1 false)
	%14 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8
	; [range start]
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = alloca i32
	; [range end]
	; init block
	%18 = alloca i32
	store i32 0, i32* %18
	br label %22

; <label>:19
	; add block
	%20 = load i32, i32* %18
	%21 = add i32 %20, 1
	store i32 %21, i32* %18
	br label %22

; <label>:22
	; cond Block begin
	%23 = load i32, i32* %18
	%24 = icmp slt i32 %23, %16
	; cond Block end
	br i1 %24, label %25, label %49

; <label>:25
	%26 = load i32, i32* %18
	store i32 %26, i32* %17
	%27 = load i32, i32* %17
	%28 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.4, i64 0, i64 0), i32 %27)
	; [range start]
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 0
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
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %8, i32 0, i32 3
	%42 = load i32*, i32** %41
	%43 = getelementptr i32, i32* %42, i32 %40
	%44 = load i32, i32* %43
	store i32 %44, i32* %31
	%45 = load i32, i32* %31
	%46 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0), i32 %45)
	br label %33

; <label>:47
	; empty block
	%48 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.6, i64 0, i64 0))
	br label %19

; <label>:49
	; empty block
	ret void
}

define void @main() {
; <label>:0
	call void @range1asdfasdfs()
	call void @range2()
	call void @range3()
	call void @range4()
	call void @range5()
	ret void
}

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

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @range1asdfasdfs() {
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
	%12 = bitcast [5 x i32]* @range1asdfasdfs.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 20, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; [range start]
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = alloca i32
	; [range end]
	; init block
	%17 = alloca i32
	store i32 0, i32* %17
	br label %21

; <label>:18
	; add block
	%19 = load i32, i32* %17
	%20 = add i32 %19, 1
	store i32 %20, i32* %17
	br label %21

; <label>:21
	; cond Block begin
	%22 = load i32, i32* %17
	%23 = icmp slt i32 %22, %15
	; cond Block end
	br i1 %23, label %24, label %28

; <label>:24
	%25 = load i32, i32* %17
	store i32 %25, i32* %16
	%26 = load i32, i32* %16
	%27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.0, i64 0, i64 0), i32 %26)
	br label %18

; <label>:28
	; empty block
	ret void
}

define void @range2() {
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
	%12 = bitcast [5 x i32]* @range2.2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 20, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; [range start]
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = alloca i32
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
	%24 = icmp slt i32 %23, %15
	; cond Block end
	br i1 %24, label %25, label %35

; <label>:25
	%26 = load i32, i32* %18
	store i32 %26, i32* %16
	%27 = load i32, i32* %18
	; get slice index
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%29 = load i32*, i32** %28
	%30 = getelementptr i32, i32* %29, i32 %27
	%31 = load i32, i32* %30
	store i32 %31, i32* %17
	%32 = load i32, i32* %16
	%33 = load i32, i32* %17
	%34 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0), i32 %32, i32 %33)
	br label %19

; <label>:35
	; empty block
	ret void
}

define void @range3() {
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
	%12 = bitcast [5 x i32]* @range3.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 20, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; [range start]
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = alloca i32
	; [range end]
	; init block
	%17 = alloca i32
	store i32 0, i32* %17
	br label %21

; <label>:18
	; add block
	%19 = load i32, i32* %17
	%20 = add i32 %19, 1
	store i32 %20, i32* %17
	br label %21

; <label>:21
	; cond Block begin
	%22 = load i32, i32* %17
	%23 = icmp slt i32 %22, %15
	; cond Block end
	br i1 %23, label %24, label %32

; <label>:24
	%25 = load i32, i32* %17
	; get slice index
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%27 = load i32*, i32** %26
	%28 = getelementptr i32, i32* %27, i32 %25
	%29 = load i32, i32* %28
	store i32 %29, i32* %16
	%30 = load i32, i32* %16
	%31 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0), i32 %30)
	br label %18

; <label>:32
	; empty block
	ret void
}

define void @range4() {
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
	%12 = bitcast [5 x i32]* @range4.6 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 20, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; [range start]
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = alloca i32
	; [range end]
	; init block
	%17 = alloca i32
	store i32 0, i32* %17
	br label %21

; <label>:18
	; add block
	%19 = load i32, i32* %17
	%20 = add i32 %19, 1
	store i32 %20, i32* %17
	br label %21

; <label>:21
	; cond Block begin
	%22 = load i32, i32* %17
	%23 = icmp slt i32 %22, %15
	; cond Block end
	br i1 %23, label %24, label %28

; <label>:24
	%25 = load i32, i32* %17
	store i32 %25, i32* %16
	%26 = load i32, i32* %16
	%27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0), i32 %26)
	br label %18

; <label>:28
	; empty block
	ret void
}

define void @range5() {
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
	%12 = bitcast [5 x i32]* @range5.8 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 20, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; init slice...............
	%array.26 = alloca { i32, i32, i32, i32* }
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 2
	store i32 4, i32* %14
	%15 = mul i32 5, 4
	%16 = call i8* @malloc(i32 %15)
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%18 = bitcast i8* %16 to i32*
	store i32* %18, i32** %17
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 1
	store i32 5, i32* %19
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 0
	store i32 5, i32* %20
	; end init slice.................
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 0
	store i32 5, i32* %21
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%23 = load i32*, i32** %22
	%24 = bitcast i32* %23 to i8*
	%25 = bitcast [5 x i32]* @range5.9 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 20, i1 false)
	%26 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26
	; [range start]
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%28 = load i32, i32* %27
	%29 = alloca i32
	; [range end]
	; init block
	%30 = alloca i32
	store i32 0, i32* %30
	br label %34

; <label>:31
	; add block
	%32 = load i32, i32* %30
	%33 = add i32 %32, 1
	store i32 %33, i32* %30
	br label %34

; <label>:34
	; cond Block begin
	%35 = load i32, i32* %30
	%36 = icmp slt i32 %35, %28
	; cond Block end
	br i1 %36, label %37, label %61

; <label>:37
	%38 = load i32, i32* %30
	store i32 %38, i32* %29
	%39 = load i32, i32* %29
	%40 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.4, i64 0, i64 0), i32 %39)
	; [range start]
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 0
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
	br i1 %50, label %51, label %59

; <label>:51
	%52 = load i32, i32* %44
	; get slice index
	%53 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%54 = load i32*, i32** %53
	%55 = getelementptr i32, i32* %54, i32 %52
	%56 = load i32, i32* %55
	store i32 %56, i32* %43
	%57 = load i32, i32* %43
	%58 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0), i32 %57)
	br label %45

; <label>:59
	; empty block
	%60 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.6, i64 0, i64 0))
	br label %31

; <label>:61
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

%mapStruct = type {}
%string = type { i32, i8* }

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
	br i1 %18, label %19, label %31

; <label>:19
	; block start
	%20 = load i32, i32* %12
	store i32 %20, i32* %11
	%21 = call %string* @newString(i32 22)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 22, i1 false)
	%26 = load %string, %string* %21
	%27 = load i32, i32* %11
	%28 = getelementptr %string, %string* %21, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %29, i32 %27)
	; end block
	br label %13

; <label>:31
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
	br i1 %19, label %20, label %38

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
	%27 = call %string* @newString(i32 7)
	%28 = getelementptr %string, %string* %27, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 7, i1 false)
	%32 = load %string, %string* %27
	%33 = load i32, i32* %11
	%34 = load i32, i32* %12
	%35 = getelementptr %string, %string* %27, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = call i32 (i8*, ...) @printf(i8* %36, i32 %33, i32 %34)
	; end block
	br label %14

; <label>:38
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
	br i1 %18, label %19, label %35

; <label>:19
	; block start
	%20 = load i32, i32* %12
	; get slice index
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%22 = load i32*, i32** %21
	%23 = getelementptr i32, i32* %22, i32 %20
	%24 = load i32, i32* %23
	store i32 %24, i32* %11
	%25 = call %string* @newString(i32 4)
	%26 = getelementptr %string, %string* %25, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = bitcast i8* %27 to i8*
	%29 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %28, i8* %29, i32 4, i1 false)
	%30 = load %string, %string* %25
	%31 = load i32, i32* %11
	%32 = getelementptr %string, %string* %25, i32 0, i32 1
	%33 = load i8*, i8** %32
	%34 = call i32 (i8*, ...) @printf(i8* %33, i32 %31)
	; end block
	br label %13

; <label>:35
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
	br i1 %18, label %19, label %31

; <label>:19
	; block start
	%20 = load i32, i32* %12
	store i32 %20, i32* %11
	%21 = call %string* @newString(i32 4)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 4, i1 false)
	%26 = load %string, %string* %21
	%27 = load i32, i32* %11
	%28 = getelementptr %string, %string* %21, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %29, i32 %27)
	; end block
	br label %13

; <label>:31
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
	br i1 %26, label %27, label %75

; <label>:27
	; block start
	%28 = load i32, i32* %20
	store i32 %28, i32* %19
	%29 = call %string* @newString(i32 20)
	%30 = getelementptr %string, %string* %29, i32 0, i32 1
	%31 = load i8*, i8** %30
	%32 = bitcast i8* %31 to i8*
	%33 = bitcast i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %32, i8* %33, i32 20, i1 false)
	%34 = load %string, %string* %29
	%35 = load i32, i32* %19
	%36 = getelementptr %string, %string* %29, i32 0, i32 1
	%37 = load i8*, i8** %36
	%38 = call i32 (i8*, ...) @printf(i8* %37, i32 %35)
	; [range start]
	%39 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 0
	%40 = load i32, i32* %39
	%41 = alloca i32
	; [range end]
	; init block
	%42 = alloca i32
	store i32 0, i32* %42
	br label %46

; <label>:43
	; add block
	%44 = load i32, i32* %42
	%45 = add i32 %44, 1
	store i32 %45, i32* %42
	br label %46

; <label>:46
	; cond Block begin
	%47 = load i32, i32* %42
	%48 = icmp slt i32 %47, %40
	; cond Block end
	br i1 %48, label %49, label %65

; <label>:49
	; block start
	%50 = load i32, i32* %42
	; get slice index
	%51 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %10, i32 0, i32 3
	%52 = load i32*, i32** %51
	%53 = getelementptr i32, i32* %52, i32 %50
	%54 = load i32, i32* %53
	store i32 %54, i32* %41
	%55 = call %string* @newString(i32 4)
	%56 = getelementptr %string, %string* %55, i32 0, i32 1
	%57 = load i8*, i8** %56
	%58 = bitcast i8* %57 to i8*
	%59 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %58, i8* %59, i32 4, i1 false)
	%60 = load %string, %string* %55
	%61 = load i32, i32* %41
	%62 = getelementptr %string, %string* %55, i32 0, i32 1
	%63 = load i8*, i8** %62
	%64 = call i32 (i8*, ...) @printf(i8* %63, i32 %61)
	; end block
	br label %43

; <label>:65
	; empty block
	%66 = call %string* @newString(i32 5)
	%67 = getelementptr %string, %string* %66, i32 0, i32 1
	%68 = load i8*, i8** %67
	%69 = bitcast i8* %68 to i8*
	%70 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %69, i8* %70, i32 5, i1 false)
	%71 = load %string, %string* %66
	%72 = getelementptr %string, %string* %66, i32 0, i32 1
	%73 = load i8*, i8** %72
	%74 = call i32 (i8*, ...) @printf(i8* %73)
	; end block
	br label %21

; <label>:75
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

@str.0 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.1 = constant [14 x i8] c"bbbbbbbbbbbb\0A\00"
@str.2 = constant [4 x i8] c"%d\0A\00"
@str.3 = constant [16 x i8] c"ggggggggggggggg\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [18 x i8] c"asdfasdfasd%d-%d\0A\00"
@str.6 = constant [14 x i8] c"bbbbbbbbbbbb\0A\00"
@str.7 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.8 = constant [17 x i8] c"cccccccccccc %d\0A\00"

define i32 @max() {
; <label>:0
	; block start
	; end block
	ret i32 3
}

declare i8* @malloc(i32)

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

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @for1() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = call i32 @max()
	%7 = load i32, i32* %1
	%8 = icmp sle i32 %7, %6
	; cond Block end
	br i1 %8, label %9, label %21

; <label>:9
	; block start
	%10 = call i8* @malloc(i32 20)
	%11 = bitcast i8* %10 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %11, i32 13)
	%12 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 0
	store i32 13, i32* %12
	%13 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%14 = load i8*, i8** %13
	%15 = bitcast i8* %14 to i8*
	%16 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %15, i8* %16, i32 13, i1 false)
	%17 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19)
	; end block
	br label %2

; <label>:21
	; empty block
	%22 = call i8* @malloc(i32 20)
	%23 = bitcast i8* %22 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %23, i32 14)
	%24 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %23, i32 0, i32 0
	store i32 14, i32* %24
	%25 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %23, i32 0, i32 3
	%26 = load i8*, i8** %25
	%27 = bitcast i8* %26 to i8*
	%28 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %27, i8* %28, i32 14, i1 false)
	%29 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %23
	%30 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %23, i32 0, i32 3
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %31)
	; init block
	%33 = alloca i32
	store i32 0, i32* %33
	br label %37

; <label>:34
	; add block
	%35 = load i32, i32* %33
	%36 = add i32 %35, 1
	store i32 %36, i32* %33
	br label %37

; <label>:37
	; cond Block begin
	%38 = load i32, i32* %33
	%39 = icmp sle i32 %38, 2
	; cond Block end
	br i1 %39, label %40, label %53

; <label>:40
	; block start
	%41 = call i8* @malloc(i32 20)
	%42 = bitcast i8* %41 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %42, i32 4)
	%43 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %42, i32 0, i32 0
	store i32 4, i32* %43
	%44 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %42, i32 0, i32 3
	%45 = load i8*, i8** %44
	%46 = bitcast i8* %45 to i8*
	%47 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %46, i8* %47, i32 4, i1 false)
	%48 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %42
	%49 = load i32, i32* %33
	%50 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %42, i32 0, i32 3
	%51 = load i8*, i8** %50
	%52 = call i32 (i8*, ...) @printf(i8* %51, i32 %49)
	; end block
	br label %34

; <label>:53
	; empty block
	%54 = call i8* @malloc(i32 20)
	%55 = bitcast i8* %54 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %55, i32 16)
	%56 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %55, i32 0, i32 0
	store i32 16, i32* %56
	%57 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %55, i32 0, i32 3
	%58 = load i8*, i8** %57
	%59 = bitcast i8* %58 to i8*
	%60 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %59, i8* %60, i32 16, i1 false)
	%61 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %55
	%62 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %55, i32 0, i32 3
	%63 = load i8*, i8** %62
	%64 = call i32 (i8*, ...) @printf(i8* %63)
	; end block
	ret void
}

define void @for2() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 10
	; cond Block end
	br i1 %7, label %8, label %21

; <label>:8
	; block start
	%9 = call i8* @malloc(i32 20)
	%10 = bitcast i8* %9 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %10, i32 4)
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 0
	store i32 4, i32* %11
	%12 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 4, i1 false)
	%16 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10
	%17 = load i32, i32* %1
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19, i32 %17)
	; end block
	br label %2

; <label>:21
	; empty block
	; end block
	ret void
}

define i32 @for23() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 3
	; cond Block end
	br i1 %7, label %8, label %31

; <label>:8
	; block start
	; init block
	%9 = alloca i32
	store i32 0, i32* %9
	br label %13

; <label>:10
	; add block
	%11 = load i32, i32* %9
	%12 = add i32 %11, 1
	store i32 %12, i32* %9
	br label %13

; <label>:13
	; cond Block begin
	%14 = load i32, i32* %9
	%15 = icmp slt i32 %14, 3
	; cond Block end
	br i1 %15, label %16, label %30

; <label>:16
	; block start
	%17 = call i8* @malloc(i32 20)
	%18 = bitcast i8* %17 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %18, i32 18)
	%19 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 0
	store i32 18, i32* %19
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 3
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 18, i1 false)
	%24 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18
	%25 = load i32, i32* %1
	%26 = load i32, i32* %9
	%27 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 3
	%28 = load i8*, i8** %27
	%29 = call i32 (i8*, ...) @printf(i8* %28, i32 %25, i32 %26)
	; end block
	br label %10

; <label>:30
	; empty block
	; end block
	br label %2

; <label>:31
	; empty block
	; end block
	ret i32 0
}

define void @for4() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	; init block
	%2 = alloca i32
	store i32 0, i32* %2
	br label %6

; <label>:3
	; add block
	%4 = load i32, i32* %2
	%5 = add i32 %4, 1
	store i32 %5, i32* %2
	br label %6

; <label>:6
	; cond Block begin
	%7 = load i32, i32* %2
	%8 = icmp slt i32 %7, 3
	; cond Block end
	br i1 %8, label %9, label %41

; <label>:9
	; block start
	%10 = call i8* @malloc(i32 20)
	%11 = bitcast i8* %10 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %11, i32 14)
	%12 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 0
	store i32 14, i32* %12
	%13 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%14 = load i8*, i8** %13
	%15 = bitcast i8* %14 to i8*
	%16 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %15, i8* %16, i32 14, i1 false)
	%17 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19)
	; init block
	%21 = alloca i32
	store i32 0, i32* %21
	br label %25

; <label>:22
	; add block
	%23 = load i32, i32* %21
	%24 = add i32 %23, 1
	store i32 %24, i32* %21
	br label %25

; <label>:25
	; cond Block begin
	%26 = load i32, i32* %21
	%27 = icmp slt i32 %26, 2
	; cond Block end
	br i1 %27, label %28, label %40

; <label>:28
	; block start
	%29 = call i8* @malloc(i32 20)
	%30 = bitcast i8* %29 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %30, i32 13)
	%31 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 0
	store i32 13, i32* %31
	%32 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 3
	%33 = load i8*, i8** %32
	%34 = bitcast i8* %33 to i8*
	%35 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %34, i8* %35, i32 13, i1 false)
	%36 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30
	%37 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %30, i32 0, i32 3
	%38 = load i8*, i8** %37
	%39 = call i32 (i8*, ...) @printf(i8* %38)
	; end block
	br label %22

; <label>:40
	; empty block
	; end block
	br label %3

; <label>:41
	; empty block
	%42 = call i8* @malloc(i32 20)
	%43 = bitcast i8* %42 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %43, i32 17)
	%44 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %43, i32 0, i32 0
	store i32 17, i32* %44
	%45 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %43, i32 0, i32 3
	%46 = load i8*, i8** %45
	%47 = bitcast i8* %46 to i8*
	%48 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %47, i8* %48, i32 17, i1 false)
	%49 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %43
	%50 = load i32, i32* %1
	%51 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %43, i32 0, i32 3
	%52 = load i8*, i8** %51
	%53 = call i32 (i8*, ...) @printf(i8* %52, i32 %50)
	; end block
	ret void
}

define void @for5() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %3

; <label>:2
	; add block
	br label %3

; <label>:3
	; cond Block begin
	; cond Block end
	br label %4

; <label>:4
	; block start
	%5 = load i32, i32* %1
	%6 = add i32 %5, 1
	store i32 %6, i32* %1
	br label %7

; <label>:7
	%8 = load i32, i32* %1
	%9 = icmp sgt i32 %8, 5
	br i1 %9, label %10, label %11

; <label>:10
	; block start
	; end block
	br label %13

; <label>:11
	br label %12

; <label>:12
	; end block
	br label %2

; <label>:13
	; empty block
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @for2()
	%1 = call i32 @for23()
	call void @for1()
	call void @for4()
	; end block
	ret void
}

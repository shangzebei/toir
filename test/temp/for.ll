%mapStruct = type {}
%string = type { i32, i8* }

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
	br i1 %8, label %9, label %19

; <label>:9
	; block start
	%10 = call %string* @newString(i32 13)
	%11 = getelementptr %string, %string* %10, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 13, i1 false)
	%15 = load %string, %string* %10
	%16 = getelementptr %string, %string* %10, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17)
	; end block
	br label %2

; <label>:19
	; empty block
	%20 = call %string* @newString(i32 14)
	%21 = getelementptr %string, %string* %20, i32 0, i32 1
	%22 = load i8*, i8** %21
	%23 = bitcast i8* %22 to i8*
	%24 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %23, i8* %24, i32 14, i1 false)
	%25 = load %string, %string* %20
	%26 = getelementptr %string, %string* %20, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = call i32 (i8*, ...) @printf(i8* %27)
	; init block
	%29 = alloca i32
	store i32 0, i32* %29
	br label %33

; <label>:30
	; add block
	%31 = load i32, i32* %29
	%32 = add i32 %31, 1
	store i32 %32, i32* %29
	br label %33

; <label>:33
	; cond Block begin
	%34 = load i32, i32* %29
	%35 = icmp sle i32 %34, 2
	; cond Block end
	br i1 %35, label %36, label %47

; <label>:36
	; block start
	%37 = call %string* @newString(i32 4)
	%38 = getelementptr %string, %string* %37, i32 0, i32 1
	%39 = load i8*, i8** %38
	%40 = bitcast i8* %39 to i8*
	%41 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %40, i8* %41, i32 4, i1 false)
	%42 = load %string, %string* %37
	%43 = load i32, i32* %29
	%44 = getelementptr %string, %string* %37, i32 0, i32 1
	%45 = load i8*, i8** %44
	%46 = call i32 (i8*, ...) @printf(i8* %45, i32 %43)
	; end block
	br label %30

; <label>:47
	; empty block
	%48 = call %string* @newString(i32 16)
	%49 = getelementptr %string, %string* %48, i32 0, i32 1
	%50 = load i8*, i8** %49
	%51 = bitcast i8* %50 to i8*
	%52 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %51, i8* %52, i32 16, i1 false)
	%53 = load %string, %string* %48
	%54 = getelementptr %string, %string* %48, i32 0, i32 1
	%55 = load i8*, i8** %54
	%56 = call i32 (i8*, ...) @printf(i8* %55)
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
	br i1 %7, label %8, label %19

; <label>:8
	; block start
	%9 = call %string* @newString(i32 4)
	%10 = getelementptr %string, %string* %9, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 4, i1 false)
	%14 = load %string, %string* %9
	%15 = load i32, i32* %1
	%16 = getelementptr %string, %string* %9, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17, i32 %15)
	; end block
	br label %2

; <label>:19
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
	br i1 %7, label %8, label %29

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
	br i1 %15, label %16, label %28

; <label>:16
	; block start
	%17 = call %string* @newString(i32 18)
	%18 = getelementptr %string, %string* %17, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 18, i1 false)
	%22 = load %string, %string* %17
	%23 = load i32, i32* %1
	%24 = load i32, i32* %9
	%25 = getelementptr %string, %string* %17, i32 0, i32 1
	%26 = load i8*, i8** %25
	%27 = call i32 (i8*, ...) @printf(i8* %26, i32 %23, i32 %24)
	; end block
	br label %10

; <label>:28
	; empty block
	; end block
	br label %2

; <label>:29
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
	br i1 %8, label %9, label %37

; <label>:9
	; block start
	%10 = call %string* @newString(i32 14)
	%11 = getelementptr %string, %string* %10, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 14, i1 false)
	%15 = load %string, %string* %10
	%16 = getelementptr %string, %string* %10, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17)
	; init block
	%19 = alloca i32
	store i32 0, i32* %19
	br label %23

; <label>:20
	; add block
	%21 = load i32, i32* %19
	%22 = add i32 %21, 1
	store i32 %22, i32* %19
	br label %23

; <label>:23
	; cond Block begin
	%24 = load i32, i32* %19
	%25 = icmp slt i32 %24, 2
	; cond Block end
	br i1 %25, label %26, label %36

; <label>:26
	; block start
	%27 = call %string* @newString(i32 13)
	%28 = getelementptr %string, %string* %27, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 13, i1 false)
	%32 = load %string, %string* %27
	%33 = getelementptr %string, %string* %27, i32 0, i32 1
	%34 = load i8*, i8** %33
	%35 = call i32 (i8*, ...) @printf(i8* %34)
	; end block
	br label %20

; <label>:36
	; empty block
	; end block
	br label %3

; <label>:37
	; empty block
	%38 = call %string* @newString(i32 17)
	%39 = getelementptr %string, %string* %38, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 17, i1 false)
	%43 = load %string, %string* %38
	%44 = load i32, i32* %1
	%45 = getelementptr %string, %string* %38, i32 0, i32 1
	%46 = load i8*, i8** %45
	%47 = call i32 (i8*, ...) @printf(i8* %46, i32 %44)
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

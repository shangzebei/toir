%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [7 x i8] c"begin\0A\00"
@str.1 = constant [17 x i8] c"asdfasdfsdf--%d\0A\00"
@str.2 = constant [5 x i8] c">5 \0A\00"
@str.3 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"

declare i8* @malloc(i32)

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 16)
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
	; IF NEW BLOCK
	%12 = load %string*, %string** %4
	%13 = getelementptr %string, %string* %12, i32 0, i32 0
	%14 = load i32, i32* %13
	%15 = load i32, i32* %1
	store i32 %15, i32* %13
	%16 = load i32, i32* %1
	%17 = add i32 %16, 1
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

define i32 @test.forr() {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 6)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	%6 = getelementptr %string, %string* %1, i32 0, i32 0
	%7 = load i32, i32* %6
	%8 = add i32 %7, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 %8, i1 false)
	%9 = load %string, %string* %1
	%10 = getelementptr %string, %string* %1, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = call i32 (i8*, ...) @printf(i8* %11)
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
	%19 = icmp sle i32 %18, 11
	; cond Block end
	br i1 %19, label %20, label %52

; <label>:20
	; block start
	%21 = call %string* @runtime.newString(i32 16)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.1, i64 0, i64 0) to i8*
	%26 = getelementptr %string, %string* %21, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = add i32 %27, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 %28, i1 false)
	%29 = load %string, %string* %21
	%30 = load i32, i32* %13
	%31 = getelementptr %string, %string* %21, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = call i32 (i8*, ...) @printf(i8* %32, i32 %30)
	br label %34

; <label>:34
	%35 = load i32, i32* %13
	%36 = icmp sgt i32 %35, 5
	br i1 %36, label %37, label %50

; <label>:37
	; block start
	%38 = call %string* @runtime.newString(i32 4)
	%39 = getelementptr %string, %string* %38, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.2, i64 0, i64 0) to i8*
	%43 = getelementptr %string, %string* %38, i32 0, i32 0
	%44 = load i32, i32* %43
	%45 = add i32 %44, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 %45, i1 false)
	%46 = load %string, %string* %38
	%47 = getelementptr %string, %string* %38, i32 0, i32 1
	%48 = load i8*, i8** %47
	%49 = call i32 (i8*, ...) @printf(i8* %48)
	; end block
	br label %51

; <label>:50
	br label %51

; <label>:51
	; IF NEW BLOCK
	; end block
	br label %14

; <label>:52
	; empty block
	; end block
	ret i32 0
}

define i32 @test.ifrr() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 9, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 5
	br i1 %4, label %5, label %18

; <label>:5
	; block start
	%6 = call %string* @runtime.newString(i32 12)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.3, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = getelementptr %string, %string* %6, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %16)
	; end block
	ret i32 1

; <label>:18
	br label %19

; <label>:19
	; IF NEW BLOCK
	; end block
	ret i32 0
}

define void @main() {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 3)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	%6 = getelementptr %string, %string* %1, i32 0, i32 0
	%7 = load i32, i32* %6
	%8 = add i32 %7, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 %8, i1 false)
	%9 = load %string, %string* %1
	%10 = call i32 @test.forr()
	%11 = getelementptr %string, %string* %1, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12, i32 %10)
	%14 = call i32 @test.ifrr()
	%15 = call i32 @test.forr()
	; end block
	ret void
}

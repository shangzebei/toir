%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [7 x i8] c"begin\0A\00"
@str.1 = constant [17 x i8] c"asdfasdfsdf--%d\0A\00"
@str.2 = constant [5 x i8] c">5 \0A\00"
@str.3 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"

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

define i32 @forr() {
; <label>:0
	; block start
	%1 = call %string* @newString(i32 7)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 7, i1 false)
	%6 = load %string, %string* %1
	%7 = getelementptr %string, %string* %1, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = call i32 (i8*, ...) @printf(i8* %8)
	; init block
	%10 = alloca i32
	store i32 0, i32* %10
	br label %14

; <label>:11
	; add block
	%12 = load i32, i32* %10
	%13 = add i32 %12, 1
	store i32 %13, i32* %10
	br label %14

; <label>:14
	; cond Block begin
	%15 = load i32, i32* %10
	%16 = icmp sle i32 %15, 11
	; cond Block end
	br i1 %16, label %17, label %43

; <label>:17
	; block start
	%18 = call %string* @newString(i32 17)
	%19 = getelementptr %string, %string* %18, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = bitcast i8* %20 to i8*
	%22 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %21, i8* %22, i32 17, i1 false)
	%23 = load %string, %string* %18
	%24 = load i32, i32* %10
	%25 = getelementptr %string, %string* %18, i32 0, i32 1
	%26 = load i8*, i8** %25
	%27 = call i32 (i8*, ...) @printf(i8* %26, i32 %24)
	br label %28

; <label>:28
	%29 = load i32, i32* %10
	%30 = icmp sgt i32 %29, 5
	br i1 %30, label %31, label %41

; <label>:31
	; block start
	%32 = call %string* @newString(i32 5)
	%33 = getelementptr %string, %string* %32, i32 0, i32 1
	%34 = load i8*, i8** %33
	%35 = bitcast i8* %34 to i8*
	%36 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %35, i8* %36, i32 5, i1 false)
	%37 = load %string, %string* %32
	%38 = getelementptr %string, %string* %32, i32 0, i32 1
	%39 = load i8*, i8** %38
	%40 = call i32 (i8*, ...) @printf(i8* %39)
	; end block
	br label %42

; <label>:41
	br label %42

; <label>:42
	; end block
	br label %11

; <label>:43
	; empty block
	; end block
	ret i32 0
}

define i32 @ifrr() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 9, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 5
	br i1 %4, label %5, label %15

; <label>:5
	; block start
	%6 = call %string* @newString(i32 13)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 13, i1 false)
	%11 = load %string, %string* %6
	%12 = getelementptr %string, %string* %6, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13)
	; end block
	ret i32 1

; <label>:15
	br label %16

; <label>:16
	; end block
	ret i32 0
}

define void @main() {
; <label>:0
	; block start
	%1 = call %string* @newString(i32 4)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 4, i1 false)
	%6 = load %string, %string* %1
	%7 = call i32 @forr()
	%8 = getelementptr %string, %string* %1, i32 0, i32 1
	%9 = load i8*, i8** %8
	%10 = call i32 (i8*, ...) @printf(i8* %9, i32 %7)
	%11 = call i32 @ifrr()
	%12 = call i32 @forr()
	; end block
	ret void
}

%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [16 x i8] c"aaaaaaaaaaaaaa\0A\00"
@str.1 = constant [17 x i8] c"bbbbbbbbbbbbbbb\0A\00"
@str.2 = constant [16 x i8] c"aaaaaaaaaaaaaa\0A\00"
@str.3 = constant [17 x i8] c"bbbbbbbbbbbbbbb\0A\00"
@str.4 = constant [13 x i8] c"asdfasfdsaf\0A\00"

declare i8* @malloc(i32)

define %string* @runtime.newString(i32 %size) {
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

define i32 @test.ifr2() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	; end block
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %18

; <label>:5
	; block start
	%6 = call %string* @runtime.newString(i32 15)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.0, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = getelementptr %string, %string* %6, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %16)
	; end block
	ret i32 0

; <label>:18
	; block start
	%19 = call %string* @runtime.newString(i32 16)
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.1, i64 0, i64 0) to i8*
	%24 = getelementptr %string, %string* %19, i32 0, i32 0
	%25 = load i32, i32* %24
	%26 = add i32 %25, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 %26, i1 false)
	%27 = load %string, %string* %19
	%28 = getelementptr %string, %string* %19, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %29)
	; end block
	ret i32 1
}

define i32 @test.ifr1() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %18

; <label>:5
	; block start
	%6 = call %string* @runtime.newString(i32 15)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.2, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = getelementptr %string, %string* %6, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %16)
	; end block
	br label %31

; <label>:18
	; block start
	%19 = call %string* @runtime.newString(i32 16)
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.3, i64 0, i64 0) to i8*
	%24 = getelementptr %string, %string* %19, i32 0, i32 0
	%25 = load i32, i32* %24
	%26 = add i32 %25, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 %26, i1 false)
	%27 = load %string, %string* %19
	%28 = getelementptr %string, %string* %19, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %29)
	; end block
	ret i32 1

; <label>:31
	; IF NEW BLOCK
	; end block
	ret i32 0
}

define void @test.ifr3() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %6

; <label>:5
	; block start
	; end block
	ret void

; <label>:6
	br label %7

; <label>:7
	; IF NEW BLOCK
	%8 = call %string* @runtime.newString(i32 12)
	%9 = getelementptr %string, %string* %8, i32 0, i32 1
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.4, i64 0, i64 0) to i8*
	%13 = getelementptr %string, %string* %8, i32 0, i32 0
	%14 = load i32, i32* %13
	%15 = add i32 %14, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 %15, i1 false)
	%16 = load %string, %string* %8
	%17 = getelementptr %string, %string* %8, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = call i32 (i8*, ...) @printf(i8* %18)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	%1 = call i32 @test.ifr1()
	%2 = call i32 @test.ifr2()
	call void @test.ifr3()
	; end block
	ret void
}

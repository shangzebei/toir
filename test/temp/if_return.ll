%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [16 x i8] c"aaaaaaaaaaaaaa\0A\00"
@str.1 = constant [17 x i8] c"bbbbbbbbbbbbbbb\0A\00"
@str.2 = constant [16 x i8] c"aaaaaaaaaaaaaa\0A\00"
@str.3 = constant [17 x i8] c"bbbbbbbbbbbbbbb\0A\00"
@str.4 = constant [13 x i8] c"asdfasfdsaf\0A\00"

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

define i32 @ifr2() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	; end block
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %15

; <label>:5
	; block start
	%6 = call %string* @newString(i32 16)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 16, i1 false)
	%11 = load %string, %string* %6
	%12 = getelementptr %string, %string* %6, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13)
	; end block
	ret i32 0

; <label>:15
	; block start
	%16 = call %string* @newString(i32 17)
	%17 = getelementptr %string, %string* %16, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = bitcast i8* %18 to i8*
	%20 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %20, i32 17, i1 false)
	%21 = load %string, %string* %16
	%22 = getelementptr %string, %string* %16, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = call i32 (i8*, ...) @printf(i8* %23)
	; end block
	ret i32 1
}

define i32 @ifr1() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %15

; <label>:5
	; block start
	%6 = call %string* @newString(i32 16)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 16, i1 false)
	%11 = load %string, %string* %6
	%12 = getelementptr %string, %string* %6, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13)
	; end block
	br label %25

; <label>:15
	; block start
	%16 = call %string* @newString(i32 17)
	%17 = getelementptr %string, %string* %16, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = bitcast i8* %18 to i8*
	%20 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %20, i32 17, i1 false)
	%21 = load %string, %string* %16
	%22 = getelementptr %string, %string* %16, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = call i32 (i8*, ...) @printf(i8* %23)
	; end block
	ret i32 1

; <label>:25
	; end block
	ret i32 0
}

define void @ifr3() {
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
	%8 = call %string* @newString(i32 13)
	%9 = getelementptr %string, %string* %8, i32 0, i32 1
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 13, i1 false)
	%13 = load %string, %string* %8
	%14 = getelementptr %string, %string* %8, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	%1 = call i32 @ifr1()
	%2 = call i32 @ifr2()
	call void @ifr3()
	; end block
	ret void
}

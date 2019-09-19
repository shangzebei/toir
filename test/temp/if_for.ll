%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [6 x i8] c"hello\00"

declare i8* @malloc(i32)

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 20)
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

define void @main() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 100, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %24

; <label>:5
	; block start
	br label %6

; <label>:6
	%7 = load i32, i32* %1
	%8 = icmp sgt i32 %7, 60
	br i1 %8, label %9, label %22

; <label>:9
	; block start
	%10 = call %string* @runtime.newString(i32 5)
	%11 = getelementptr %string, %string* %10, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.0, i64 0, i64 0) to i8*
	%15 = getelementptr %string, %string* %10, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = add i32 %16, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 %17, i1 false)
	%18 = load %string, %string* %10
	%19 = getelementptr %string, %string* %10, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20)
	; end block
	br label %23

; <label>:22
	br label %23

; <label>:23
	; IF NEW BLOCK
	; end block
	ret void

; <label>:24
	br label %25

; <label>:25
	; IF NEW BLOCK
	; end block
	ret void
}

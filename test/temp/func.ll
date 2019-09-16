%string = type { i32, i8* }
%mapStruct = type {}

@str.0 = constant [4 x i8] c"%d\0A\00"

define i32 @add(i32 %a, i32 %b) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca i32
	store i32 %b, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = add i32 %3, %4
	; end block
	ret i32 %5
}

define i32 @sul(i32 %a, i32 %b) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca i32
	store i32 %b, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = sub i32 %3, %4
	; end block
	ret i32 %5
}

define i32 @call() {
; <label>:0
	; block start
	%1 = call i32 @add(i32 5, i32 6)
	; end block
	ret i32 %1
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

define void @main() {
; <label>:0
	; block start
	%1 = add i32 1, 1
	%2 = sub i32 %1, 1
	%3 = call i32 @call()
	%4 = call i32 @sul(i32 %3, i32 1)
	%5 = call i32 @add(i32 %2, i32 %4)
	%6 = alloca i32
	store i32 %5, i32* %6
	%7 = call %string* @newString(i32 4)
	%8 = getelementptr %string, %string* %7, i32 0, i32 1
	%9 = load i8*, i8** %8
	%10 = bitcast i8* %9 to i8*
	%11 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %11, i32 4, i1 false)
	%12 = load %string, %string* %7
	%13 = load i32, i32* %6
	%14 = getelementptr %string, %string* %7, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15, i32 %13)
	; end block
	ret void
}

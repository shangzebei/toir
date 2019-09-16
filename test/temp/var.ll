%mapStruct = type {}
%string = type { i32, i8* }

@tt = global i32 0
@str.0 = constant [10 x i8] c"%d-%d=%d\0A\00"

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

define void @varBool1() {
; <label>:0
	; block start
	%1 = alloca i1
	store i1 true, i1* %1
	; end block
	ret void
}

define void @varBool2() {
; <label>:0
	; block start
	%1 = alloca i1
	store i1 true, i1* %1
	; end block
	ret void
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
	%1 = alloca i32
	store i32 4, i32* %1
	%2 = call %string* @newString(i32 10)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 10, i1 false)
	%7 = load %string, %string* %2
	%8 = load i32, i32* %1
	%9 = getelementptr %string, %string* %2, i32 0, i32 1
	%10 = load i8*, i8** %9
	%11 = call i32 (i8*, ...) @printf(i8* %10, i32 %8, i32 3, i32* @tt)
	; end block
	ret void
}

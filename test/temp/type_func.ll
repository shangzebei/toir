%string = type { i32, i8* }
%mapStruct = type {}

@str.0 = constant [15 x i8] c"asdfsadfsdfsd\0A\00"

define void @test.typeFun(void ()* %f) {
; <label>:0
	; block start
	call void %f()
	; end block
	ret void
}

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

define void @0() {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 14)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.0, i64 0, i64 0) to i8*
	%6 = getelementptr %string, %string* %1, i32 0, i32 0
	%7 = load i32, i32* %6
	%8 = add i32 %7, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 %8, i1 false)
	%9 = load %string, %string* %1
	%10 = getelementptr %string, %string* %1, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = call i32 (i8*, ...) @printf(i8* %11)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.typeFun(void ()* @0)
	; end block
	ret void
}

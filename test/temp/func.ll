%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [4 x i8] c"%d\0A\00"

define i32 @test.add(i32 %a, i32 %b) {
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

define i32 @test.sul(i32 %a, i32 %b) {
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

define i32 @test.call() {
; <label>:0
	; block start
	%1 = call i32 @test.add(i32 5, i32 6)
	; end block
	ret i32 %1
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
	%1 = add i32 1, 1
	%2 = sub i32 %1, 1
	%3 = call i32 @test.call()
	%4 = call i32 @test.sul(i32 %3, i32 1)
	%5 = call i32 @test.add(i32 %2, i32 %4)
	%6 = alloca i32
	store i32 %5, i32* %6
	%7 = call %string* @runtime.newString(i32 3)
	%8 = getelementptr %string, %string* %7, i32 0, i32 1
	%9 = load i8*, i8** %8
	%10 = bitcast i8* %9 to i8*
	%11 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	%12 = getelementptr %string, %string* %7, i32 0, i32 0
	%13 = load i32, i32* %12
	%14 = add i32 %13, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %11, i32 %14, i1 false)
	%15 = load %string, %string* %7
	%16 = load i32, i32* %6
	%17 = getelementptr %string, %string* %7, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = call i32 (i8*, ...) @printf(i8* %18, i32 %16)
	; end block
	ret void
}

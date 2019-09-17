%mapStruct = type {}
%string = type { i32, i8* }
%return.0.0 = type { i32, i32 }

@str.0 = constant [8 x i8] c"%d--%d\0A\00"

define i32 @k() {
; <label>:0
	; block start
	; end block
	ret i32 85
}

define %return.0.0 @test.mul2(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = call i32 @k()
	%3 = alloca %return.0.0
	%4 = getelementptr %return.0.0, %return.0.0* %3, i32 0, i32 0
	store i32 %2, i32* %4
	%5 = getelementptr %return.0.0, %return.0.0* %3, i32 0, i32 1
	store i32 5, i32* %5
	%6 = load %return.0.0, %return.0.0* %3
	; end block
	ret %return.0.0 %6
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
	%1 = call %return.0.0 @test.mul2(i32 1)
	%2 = extractvalue %return.0.0 %1, 0
	%3 = extractvalue %return.0.0 %1, 1
	%4 = alloca i32
	store i32 %2, i32* %4
	%5 = alloca i32
	store i32 %3, i32* %5
	%6 = call %string* @runtime.newString(i32 7)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.0, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = load i32, i32* %4
	%16 = load i32, i32* %5
	%17 = getelementptr %string, %string* %6, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = call i32 (i8*, ...) @printf(i8* %18, i32 %15, i32 %16)
	; end block
	ret void
}

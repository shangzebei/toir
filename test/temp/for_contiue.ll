%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [15 x i8] c"okkkkkkkkkkkk\0A\00"
@str.1 = constant [19 x i8] c"bbbbbbbbbbbbbbbbb\0A\00"

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

define void @test.for1con() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 10
	; cond Block end
	br i1 %7, label %8, label %27

; <label>:8
	; block start
	br label %9

; <label>:9
	%10 = load i32, i32* %1
	%11 = icmp sgt i32 %10, 5
	br i1 %11, label %12, label %13

; <label>:12
	; block start
	; end block
	br label %2

; <label>:13
	br label %14

; <label>:14
	; IF NEW BLOCK
	%15 = call %string* @runtime.newString(i32 14)
	%16 = getelementptr %string, %string* %15, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to i8*
	%19 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.0, i64 0, i64 0) to i8*
	%20 = getelementptr %string, %string* %15, i32 0, i32 0
	%21 = load i32, i32* %20
	%22 = add i32 %21, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 %22, i1 false)
	%23 = load %string, %string* %15
	%24 = getelementptr %string, %string* %15, i32 0, i32 1
	%25 = load i8*, i8** %24
	%26 = call i32 (i8*, ...) @printf(i8* %25)
	; end block
	br label %2

; <label>:27
	; empty block
	%28 = call %string* @runtime.newString(i32 18)
	%29 = getelementptr %string, %string* %28, i32 0, i32 1
	%30 = load i8*, i8** %29
	%31 = bitcast i8* %30 to i8*
	%32 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.1, i64 0, i64 0) to i8*
	%33 = getelementptr %string, %string* %28, i32 0, i32 0
	%34 = load i32, i32* %33
	%35 = add i32 %34, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %31, i8* %32, i32 %35, i1 false)
	%36 = load %string, %string* %28
	%37 = getelementptr %string, %string* %28, i32 0, i32 1
	%38 = load i8*, i8** %37
	%39 = call i32 (i8*, ...) @printf(i8* %38)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.for1con()
	; end block
	ret void
}

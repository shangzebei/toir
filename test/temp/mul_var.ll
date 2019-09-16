%mapStruct = type {}
%string = type { i32, i8* }
%return.5.1 = type { i32, i32 }

@str.0 = constant [7 x i8] c"%d %d\0A\00"
@str.1 = constant [10 x i8] c"%d %d %d\0A\00"
@str.2 = constant [8 x i8] c"%d--%d\0A\00"

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

define void @mulVar() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 10, i32* %1
	%2 = alloca i32
	store i32 20, i32* %2
	%3 = call %string* @newString(i32 7)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 7, i1 false)
	%8 = load %string, %string* %3
	%9 = load i32, i32* %1
	%10 = load i32, i32* %2
	%11 = getelementptr %string, %string* %3, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12, i32 %9, i32 %10)
	%14 = alloca i32
	store i32 10, i32* %14
	%15 = alloca i32
	store i32 20, i32* %15
	%16 = alloca i32
	store i32 30, i32* %16
	%17 = call %string* @newString(i32 10)
	%18 = getelementptr %string, %string* %17, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 10, i1 false)
	%22 = load %string, %string* %17
	%23 = load i32, i32* %14
	%24 = load i32, i32* %15
	%25 = load i32, i32* %16
	%26 = getelementptr %string, %string* %17, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = call i32 (i8*, ...) @printf(i8* %27, i32 %23, i32 %24, i32 %25)
	; end block
	ret void
}

define %return.5.1 @mulFunc(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca %return.5.1
	%3 = getelementptr %return.5.1, %return.5.1* %2, i32 0, i32 0
	store i32 1, i32* %3
	%4 = getelementptr %return.5.1, %return.5.1* %2, i32 0, i32 1
	store i32 5, i32* %4
	%5 = load %return.5.1, %return.5.1* %2
	; end block
	ret %return.5.1 %5
}

define void @main() {
; <label>:0
	; block start
	%1 = call %return.5.1 @mulFunc(i32 1)
	%2 = extractvalue %return.5.1 %1, 0
	%3 = extractvalue %return.5.1 %1, 1
	%4 = alloca i32
	store i32 %2, i32* %4
	%5 = alloca i32
	store i32 %3, i32* %5
	%6 = call %string* @newString(i32 8)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 8, i1 false)
	%11 = load %string, %string* %6
	%12 = load i32, i32* %4
	%13 = load i32, i32* %5
	%14 = getelementptr %string, %string* %6, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15, i32 %12, i32 %13)
	call void @mulVar()
	; end block
	ret void
}

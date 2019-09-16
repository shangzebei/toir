%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [15 x i8] c"okkkkkkkkkkkk\0A\00"
@str.1 = constant [19 x i8] c"bbbbbbbbbbbbbbbbb\0A\00"

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

define void @for1con() {
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
	br i1 %7, label %8, label %24

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
	%15 = call %string* @newString(i32 15)
	%16 = getelementptr %string, %string* %15, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to i8*
	%19 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 15, i1 false)
	%20 = load %string, %string* %15
	%21 = getelementptr %string, %string* %15, i32 0, i32 1
	%22 = load i8*, i8** %21
	%23 = call i32 (i8*, ...) @printf(i8* %22)
	; end block
	br label %2

; <label>:24
	; empty block
	%25 = call %string* @newString(i32 19)
	%26 = getelementptr %string, %string* %25, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = bitcast i8* %27 to i8*
	%29 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %28, i8* %29, i32 19, i1 false)
	%30 = load %string, %string* %25
	%31 = getelementptr %string, %string* %25, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = call i32 (i8*, ...) @printf(i8* %32)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @for1con()
	; end block
	ret void
}

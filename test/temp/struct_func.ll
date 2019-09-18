%mapStruct = type {}
%string = type { i32, i8* }
%Hello = type { %string, i32 }

@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [6 x i8] c"shang\00"
@str.2 = constant [4 x i8] c"%s\0A\00"

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

define void @main.Hello.Show(%Hello %h) {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %Hello*
	store %Hello %h, %Hello* %2
	%3 = call %string* @runtime.newString(i32 3)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	%8 = getelementptr %string, %string* %3, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = add i32 %9, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 %10, i1 false)
	%11 = load %string, %string* %3
	%12 = getelementptr %Hello, %Hello* %2, i32 0, i32 1
	%13 = load i32, i32* %12
	%14 = getelementptr %string, %string* %3, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15, i32 %13)
	; end block
	ret void
}

define void @init.Hello.18501568773736(%Hello*) {
; <label>:1
	%2 = getelementptr %Hello, %Hello* %0, i32 0, i32 0
	%3 = call %string* @runtime.newString(i32 5)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0) to i8*
	%8 = getelementptr %string, %string* %3, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = add i32 %9, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 %10, i1 false)
	%11 = load %string, %string* %3
	store %string %11, %string* %2
	%12 = getelementptr %Hello, %Hello* %0, i32 0, i32 1
	store i32 12, i32* %12
	ret void
}

define void @main() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %Hello*
	call void @init.Hello.18501568773736(%Hello* %2)
	%3 = load %Hello, %Hello* %2
	%4 = call i8* @malloc(i32 12)
	%5 = bitcast i8* %4 to %Hello*
	store %Hello %3, %Hello* %5
	%6 = load %Hello, %Hello* %5
	call void @main.Hello.Show(%Hello %6)
	%7 = call %string* @runtime.newString(i32 3)
	%8 = getelementptr %string, %string* %7, i32 0, i32 1
	%9 = load i8*, i8** %8
	%10 = bitcast i8* %9 to i8*
	%11 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	%12 = getelementptr %string, %string* %7, i32 0, i32 0
	%13 = load i32, i32* %12
	%14 = add i32 %13, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %11, i32 %14, i1 false)
	%15 = load %string, %string* %7
	%16 = getelementptr %Hello, %Hello* %5, i32 0, i32 0
	%17 = load %string, %string* %16
	%18 = getelementptr %string, %string* %7, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = getelementptr %string, %string* %16, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = call i32 (i8*, ...) @printf(i8* %19, i8* %21)
	; end block
	ret void
}

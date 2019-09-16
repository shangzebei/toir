%mapStruct = type {}
%string = type { i32, i8* }
%A = type { %string }

@str.0 = constant [4 x i8] c"%s\0A\00"
@str.1 = constant [7 x i8] c"%d-%d\0A\00"
@str.2 = constant [6 x i8] c"ttttt\00"

define void @swap(i32* %a, i32* %b) {
; <label>:0
	; block start
	%1 = load i32, i32* %a
	store i32 44, i32* %a
	%2 = load i32, i32* %b
	store i32 23, i32* %b
	; end block
	ret void
}

define void @swapFloat(i64* %a, i64* %b) {
; <label>:0
	; block start
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

define void @do(%A %a) {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 8)
	%2 = bitcast i8* %1 to %A*
	store %A %a, %A* %2
	%3 = call %string* @newString(i32 4)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 4, i1 false)
	%8 = load %string, %string* %3
	%9 = getelementptr %A, %A* %2, i32 0, i32 0
	%10 = load %string, %string* %9
	%11 = getelementptr %string, %string* %3, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = getelementptr %string, %string* %9, i32 0, i32 1
	%14 = load i8*, i8** %13
	%15 = call i32 (i8*, ...) @printf(i8* %12, i8* %14)
	; end block
	ret void
}

define void @init.A.17791568630589(%A*) {
; <label>:1
	%2 = getelementptr %A, %A* %0, i32 0, i32 0
	%3 = call %string* @newString(i32 6)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 6, i1 false)
	%8 = load %string, %string* %3
	store %string %8, %string* %2
	ret void
}

define void @main() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	%2 = alloca i32
	store i32 80, i32* %2
	call void @swap(i32* %1, i32* %2)
	%3 = call %string* @newString(i32 7)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 7, i1 false)
	%8 = load %string, %string* %3
	%9 = load i32, i32* %1
	%10 = load i32, i32* %2
	%11 = getelementptr %string, %string* %3, i32 0, i32 1
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12, i32 %9, i32 %10)
	; init param
	; end param
	%14 = call i8* @malloc(i32 8)
	%15 = bitcast i8* %14 to %A*
	call void @init.A.17791568630589(%A* %15)
	%16 = load %A, %A* %15
	%17 = call i8* @malloc(i32 8)
	%18 = bitcast i8* %17 to %A*
	store %A %16, %A* %18
	%19 = load %A, %A* %18
	call void @do(%A %19)
	; end block
	ret void
}

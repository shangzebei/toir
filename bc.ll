%slice = type { i32, i32, i32, i8* }
%UU = type { i32 }

@main.0 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.0 = constant [3 x i8] c"%d\00"
@str.1 = constant [21 x i8] c"rangeSlice bytes=%d\0A\00"
@str.2 = constant [19 x i8] c"out of range [%d]\0A\00"
@str.3 = constant [19 x i8] c"bytes=%d index=%d\0A\00"

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define %slice* @makeSlice(i32 %types) {
; <label>:0
	%1 = alloca i32
	store i32 %types, i32* %1
	%2 = alloca %slice
	%3 = load %slice, %slice* %2
	%4 = getelementptr %slice, %slice* %2, i32 0, i32 2
	%5 = load i32, i32* %4
	%6 = load i32, i32* %1
	store i32 %6, i32* %4
	ret %slice* %2
}

declare i8* @malloc(i32)

define %slice* @rangeSlice(%slice* %s, i32 %low, i32 %high) {
; <label>:0
	%1 = alloca i32
	store i32 %low, i32* %1
	%2 = alloca i32
	store i32 %high, i32* %2
	%3 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%4 = load i32, i32* %3
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @str.1, i64 0, i64 0), i32 %4)
	%6 = load i32, i32* %2
	%7 = load i32, i32* %1
	%8 = sub i32 %6, %7
	%9 = alloca i32
	store i32 %8, i32* %9
	%10 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%11 = load i32, i32* %10
	%12 = call %slice* @makeSlice(i32 %11)
	%13 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%14 = load i32, i32* %13
	%15 = load i32, i32* %9
	%16 = mul i32 %15, %14
	%17 = alloca i32
	store i32 %16, i32* %17
	%18 = load i32, i32* %17
	%19 = call i8* @malloc(i32 %18)
	%20 = alloca i8*
	store i8* %19, i8** %20
	%21 = load i8*, i8** %20
	%22 = getelementptr %slice, %slice* %s, i32 0, i32 3
	%23 = load i8*, i8** %22
	%24 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%25 = load i32, i32* %24
	%26 = load i32, i32* %9
	%27 = mul i32 %25, %26
	%28 = getelementptr i8, i8* %23, i32 %27
	%29 = load i32, i32* %17
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %21, i8* %28, i32 %29, i1 false)
	%30 = getelementptr %slice, %slice* %12, i32 0, i32 1
	%31 = load i32, i32* %30
	%32 = load i32, i32* %9
	store i32 %32, i32* %30
	%33 = getelementptr %slice, %slice* %12, i32 0, i32 0
	%34 = load i32, i32* %33
	%35 = load i32, i32* %9
	store i32 %35, i32* %33
	%36 = getelementptr %slice, %slice* %12, i32 0, i32 3
	%37 = load i8*, i8** %36
	%38 = load i8*, i8** %20
	store i8* %38, i8** %36
	ret %slice* %12
}

declare void @exit(i32)

define i8* @indexSlice(%slice* %s, i32 %index) {
; <label>:0
	%1 = alloca i32
	store i32 %index, i32* %1
	%2 = getelementptr %slice, %slice* %s, i32 0, i32 0
	%3 = load i32, i32* %2
	%4 = load i32, i32* %1
	%5 = icmp sge i32 %4, %3
	br i1 %5, label %6, label %9

; <label>:6
	%7 = load i32, i32* %1
	%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.2, i64 0, i64 0), i32 %7)
	call void @exit(i32 0)
	unreachable

; <label>:9
	br label %10

; <label>:10
	%11 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%12 = load i32, i32* %11
	%13 = load i32, i32* %1
	%14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.3, i64 0, i64 0), i32 %12, i32 %13)
	%15 = getelementptr %slice, %slice* %s, i32 0, i32 3
	%16 = load i8*, i8** %15
	%17 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%18 = load i32, i32* %17
	%19 = load i32, i32* %1
	%20 = mul i32 %18, %19
	%21 = getelementptr i8, i8* %16, i32 %20
	ret i8* %21
}

define void @main() {
; <label>:0
	%array.1 = alloca %slice
	%1 = getelementptr %slice, %slice* %array.1, i32 0, i32 2
	store i32 4, i32* %1
	%2 = alloca [5 x i32]
	%3 = bitcast [5 x i32]* %2 to i8*
	%4 = getelementptr %slice, %slice* %array.1, i32 0, i32 3
	store i8* %3, i8** %4
	%5 = getelementptr %slice, %slice* %array.1, i32 0, i32 0
	store i32 5, i32* %5
	%6 = getelementptr %slice, %slice* %array.1, i32 0, i32 1
	store i32 5, i32* %6
	%7 = getelementptr %slice, %slice* %array.1, i32 0, i32 3
	%8 = load i8*, i8** %7
	%9 = bitcast [5 x i32]* @main.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 20, i1 false)
	%10 = load %slice, %slice* %array.1
	%11 = call %slice* @rangeSlice(%slice* %array.1, i32 1, i32 4)
	%12 = load %slice, %slice* %11
	%13 = call i8* @indexSlice(%slice* %11, i32 0)
	%14 = load i8, i8* %13
	%15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.0, i64 0, i64 0), i8 %14)
	ret void
}

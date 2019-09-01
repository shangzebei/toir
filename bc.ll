%slice = type { i32, i32, i32, i8* }
%UU = type { i32 }

@str.0 = constant [4 x i8] c"%d\0A\00"
@main.1 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]
@str.1 = constant [19 x i8] c"out of range [%d]\0A\00"
@str.2 = constant [19 x i8] c"bytes=%d index=%d\0A\00"

declare i32 @printf(i8*, ...)

define void @nn(i32 %int2) {
; <label>:0
	%1 = alloca i32
	store i32 %int2, i32* %1
	%2 = load i32, i32* %1
	%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0), i32 %2)
	ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define i8* @indexSlice(%slice* %s, i32 %index) {
; <label>:0
	%1 = alloca i32
	store i32 %index, i32* %1
	%2 = getelementptr %slice, %slice* %s, i32 0, i32 0
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = icmp sge i32 %3, %4
	br i1 %5, label %6, label %9

; <label>:6
	%7 = load i32, i32* %1
	%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.1, i64 0, i64 0), i32 %7)
	unreachable

; <label>:9
	br label %10

; <label>:10
	%11 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%12 = load i32, i32* %11
	%13 = load i32, i32* %1
	%14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.2, i64 0, i64 0), i32 %12, i32 %13)
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
	%9 = bitcast [5 x i32]* @main.1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 20, i1 false)
	%10 = load %slice, %slice* %array.1
	%11 = call i8* @indexSlice(%slice* %array.1, i32 2)
	%12 = bitcast i8* %11 to i32*
	%13 = load i32, i32* %12
	%14 = alloca i32
	store i32 %13, i32* %14
	ret void
}

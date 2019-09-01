%slice = type { i32, i32, i32, i8* }
%UU = type { i32 }

@str.0 = constant [4 x i8] c"%d\0A\00"
@main.1 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]

define void @jj(i32* %int2) {
; <label>:0
	ret void
}

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

declare i8* @malloc(i32)

define i8* @checkGrow(%slice* %s) {
; <label>:0
	%1 = getelementptr %slice, %slice* %s, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = getelementptr %slice, %slice* %s, i32 0, i32 1
	%4 = load i32, i32* %3
	%5 = icmp sge i32 %2, %4
	br i1 %5, label %6, label %26

; <label>:6
	%7 = getelementptr %slice, %slice* %s, i32 0, i32 0
	%8 = load i32, i32* %7
	%9 = add i32 %8, 4
	%10 = alloca i32
	store i32 %9, i32* %10
	%11 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%12 = load i32, i32* %11
	%13 = load i32, i32* %10
	%14 = mul i32 %13, %12
	%15 = call i8* @malloc(i32 %14)
	%16 = alloca i8*
	store i8* %15, i8** %16
	%17 = load i8*, i8** %16
	%18 = getelementptr %slice, %slice* %s, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = getelementptr %slice, %slice* %s, i32 0, i32 0
	%21 = load i32, i32* %20
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %17, i8* %19, i32 %21, i1 false)
	%22 = getelementptr %slice, %slice* %s, i32 0, i32 1
	%23 = load i32, i32* %22
	%24 = load i32, i32* %10
	store i32 %24, i32* %22
	%25 = load i8*, i8** %16
	ret i8* %25

; <label>:26
	%27 = getelementptr %slice, %slice* %s, i32 0, i32 3
	%28 = load i8*, i8** %27
	ret i8* %28
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
	%11 = call i8* @checkGrow(%slice* %array.1)
	%12 = getelementptr %slice, %slice* %array.1, i32 0, i32 3
	store i8* %11, i8** %12
	%13 = getelementptr %slice, %slice* %array.1, i32 0, i32 0
	%14 = load i32, i32* %13
	%15 = bitcast i8** %12 to i32*
	%16 = getelementptr i32, i32* %15, i32 %14
	store i32 6, i32* %16
	%17 = add i32 %14, 1
	store i32 %17, i32* %13
	store %slice %10, %slice* %array.1
	ret void
}

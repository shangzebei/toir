%slice = type { i32, i32, i32, i8* }
%UU = type { i32 }

@main.0 = constant [5 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5]

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

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
	%3 = load i32, i32* %2
	%4 = load i32, i32* %1
	%5 = sub i32 %3, %4
	%6 = alloca i32
	store i32 %5, i32* %6
	%7 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%8 = load i32, i32* %7
	%9 = call %slice* @makeSlice(i32 %8)
	%10 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%11 = load i32, i32* %10
	%12 = load i32, i32* %6
	%13 = mul i32 %12, %11
	%14 = call i8* @malloc(i32 %13)
	%15 = alloca i8*
	store i8* %14, i8** %15
	%16 = getelementptr %slice, %slice* %9, i32 0, i32 1
	%17 = load i32, i32* %16
	%18 = load i32, i32* %6
	store i32 %18, i32* %16
	%19 = getelementptr %slice, %slice* %9, i32 0, i32 0
	%20 = load i32, i32* %19
	%21 = load i32, i32* %6
	store i32 %21, i32* %19
	%22 = load i8*, i8** %15
	%23 = getelementptr %slice, %slice* %s, i32 0, i32 3
	%24 = load i8*, i8** %23
	%25 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%26 = load i32, i32* %25
	%27 = load i32, i32* %6
	%28 = mul i32 %26, %27
	%29 = getelementptr i8, i8* %24, i32 %28
	%30 = load i32, i32* %6
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %29, i32 %30, i1 false)
	%31 = getelementptr %slice, %slice* %9, i32 0, i32 3
	%32 = load i8*, i8** %31
	%33 = load i8*, i8** %15
	store i8* %33, i8** %31
	ret %slice* %9
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
	ret void
}

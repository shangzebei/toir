%A = type { { i32, i32, i32, i8* } }

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

define void @init_slice_i8({ i32, i32, i32, i8* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 2
	store i32 1, i32* %1
	%2 = mul i32 %len, 1
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to i8*
	store i8* %5, i8** %4
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @do(%A %a) {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 8)
	%2 = bitcast i8* %1 to %A*
	store %A %a, %A* %2
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %4, i32 4)
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 0
	store i32 4, i32* %5
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 4, i1 false)
	%10 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	%11 = getelementptr %A, %A* %2, i32 0, i32 0
	%12 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11
	%13 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%14 = load i8*, i8** %13
	%15 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %14, i8* %16)
	; end block
	ret void
}

define void @init.A.17791568619438(%A*) {
; <label>:1
	%2 = getelementptr %A, %A* %0, i32 0, i32 0
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %4, i32 6)
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 0
	store i32 6, i32* %5
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 6, i1 false)
	%10 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	store { i32, i32, i32, i8* } %10, { i32, i32, i32, i8* }* %2
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
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %4, i32 7)
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 0
	store i32 7, i32* %5
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 7, i1 false)
	%10 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	%11 = load i32, i32* %1
	%12 = load i32, i32* %2
	%13 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%14 = load i8*, i8** %13
	%15 = call i32 (i8*, ...) @printf(i8* %14, i32 %11, i32 %12)
	; init param
	; end param
	%16 = call i8* @malloc(i32 8)
	%17 = bitcast i8* %16 to %A*
	call void @init.A.17791568619438(%A* %17)
	%18 = load %A, %A* %17
	%19 = call i8* @malloc(i32 8)
	%20 = bitcast i8* %19 to %A*
	store %A %18, %A* %20
	%21 = load %A, %A* %20
	call void @do(%A %21)
	; end block
	ret void
}

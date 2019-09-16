%return.5.1 = type { i32, i32 }

@str.0 = constant [7 x i8] c"%d %d\0A\00"
@str.1 = constant [10 x i8] c"%d %d %d\0A\00"
@str.2 = constant [8 x i8] c"%d--%d\0A\00"

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

define void @mulVar() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 10, i32* %1
	%2 = alloca i32
	store i32 20, i32* %2
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %4, i32 7)
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 0
	store i32 7, i32* %5
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 7, i1 false)
	%10 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	%11 = load i32, i32* %1
	%12 = load i32, i32* %2
	%13 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%14 = load i8*, i8** %13
	%15 = call i32 (i8*, ...) @printf(i8* %14, i32 %11, i32 %12)
	%16 = alloca i32
	store i32 10, i32* %16
	%17 = alloca i32
	store i32 20, i32* %17
	%18 = alloca i32
	store i32 30, i32* %18
	%19 = call i8* @malloc(i32 20)
	%20 = bitcast i8* %19 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %20, i32 10)
	%21 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %20, i32 0, i32 0
	store i32 10, i32* %21
	%22 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %20, i32 0, i32 3
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 10, i1 false)
	%26 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %20
	%27 = load i32, i32* %16
	%28 = load i32, i32* %17
	%29 = load i32, i32* %18
	%30 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %20, i32 0, i32 3
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %31, i32 %27, i32 %28, i32 %29)
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
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 8)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 8, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 8, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = load i32, i32* %4
	%15 = load i32, i32* %5
	%16 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17, i32 %14, i32 %15)
	call void @mulVar()
	; end block
	ret void
}

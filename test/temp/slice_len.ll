%return.3.0 = type { i8*, i32 }

@main.0 = constant [3 x i32] [i32 1, i32 2, i32 3]
@str.0 = constant [4 x i8] c"%d\0A\00"

declare i8* @malloc(i32)

define { i32, i32, i32, i32* }* @init_slice_i32(i32 %len) {
; <label>:0
	; init slice...............
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	store i32 4, i32* %3
	%4 = mul i32 %len, 4
	%5 = call i8* @malloc(i32 %4)
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%7 = bitcast i8* %5 to i32*
	store i32* %7, i32** %6
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	store i32 %len, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 %len, i32* %9
	; end init slice.................
	ret { i32, i32, i32, i32* }* %2
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define %return.3.0 @checkGrow(i8* %ptr, i32 %len, i32 %cap, i32 %bytes, i32 %insert) {
; <label>:0
	%1 = alloca i32
	store i32 %len, i32* %1
	%2 = alloca i32
	store i32 %cap, i32* %2
	%3 = alloca i32
	store i32 %bytes, i32* %3
	%4 = alloca i32
	store i32 %insert, i32* %4
	%5 = load i32, i32* %1
	%6 = load i32, i32* %2
	%7 = icmp sge i32 %5, %6
	br i1 %7, label %8, label %30

; <label>:8
	%9 = load i32, i32* %1
	%10 = load i32, i32* %4
	%11 = add i32 %9, %10
	%12 = add i32 %11, 4
	%13 = alloca i32
	store i32 %12, i32* %13
	%14 = load i32, i32* %13
	%15 = load i32, i32* %3
	%16 = mul i32 %14, %15
	%17 = call i8* @malloc(i32 %16)
	%18 = alloca i8*
	store i8* %17, i8** %18
	%19 = load i8*, i8** %18
	%20 = load i32, i32* %1
	%21 = load i32, i32* %3
	%22 = mul i32 %20, %21
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %19, i8* %ptr, i32 %22, i1 false)
	%23 = load i32, i32* %1
	store i32 %23, i32* %2
	%24 = load i8*, i8** %18
	%25 = load i32, i32* %13
	%26 = alloca %return.3.0
	%27 = getelementptr %return.3.0, %return.3.0* %26, i32 0, i32 0
	store i8* %24, i8** %27
	%28 = getelementptr %return.3.0, %return.3.0* %26, i32 0, i32 1
	store i32 %25, i32* %28
	%29 = load %return.3.0, %return.3.0* %26
	ret %return.3.0 %29

; <label>:30
	%31 = load i32, i32* %2
	%32 = alloca %return.3.0
	%33 = getelementptr %return.3.0, %return.3.0* %32, i32 0, i32 0
	store i8* %ptr, i8** %33
	%34 = getelementptr %return.3.0, %return.3.0* %32, i32 0, i32 1
	store i32 %31, i32* %34
	%35 = load %return.3.0, %return.3.0* %32
	ret %return.3.0 %35
}

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 3)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 3, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [3 x i32]* @main.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 12, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	; append start---------------------
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%9 = load i32*, i32** %8
	%10 = bitcast i32* %9 to i8*
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%14 = load i32, i32* %13
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%16 = load i32, i32* %15
	%17 = call %return.3.0 @checkGrow(i8* %10, i32 %12, i32 %14, i32 %16, i32 1)
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%19 = load i32, i32* %18
	; copy and new slice
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%21 = load i32, i32* %20
	%22 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %21)
	%23 = bitcast { i32, i32, i32, i32* }* %22 to i8*
	%24 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %23, i8* %24, i32 20, i1 false)
	; copy and end slice
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %22, i32 0, i32 3
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %22, i32 0, i32 0
	%27 = extractvalue %return.3.0 %17, 0
	%28 = extractvalue %return.3.0 %17, 1
	%29 = bitcast i8* %27 to i32*
	store i32* %29, i32** %25
	; store value
	%30 = load i32*, i32** %25
	%31 = bitcast i32* %30 to i32*
	%32 = add i32 %19, 0
	%33 = getelementptr i32, i32* %31, i32 %32
	store i32 8, i32* %33
	; add len
	%34 = add i32 %19, 1
	store i32 %34, i32* %26
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %22, i32 0, i32 1
	store i32 %28, i32* %35
	; append end-------------------------
	%36 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %22
	store { i32, i32, i32, i32* } %36, { i32, i32, i32, i32* }* %1
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%38 = load i32, i32* %37
	%39 = alloca i32
	store i32 %38, i32* %39
	%40 = load i32, i32* %39
	%41 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0), i32 %40)
	ret void
}

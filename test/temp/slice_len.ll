%return.2.0 = type { i8*, i32 }

@main.0 = constant [3 x i32] [i32 1, i32 2, i32 3]
@str.0 = constant [4 x i8] c"%d\0A\00"

declare i8* @malloc(i32)

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define %return.2.0 @checkGrow(i8* %ptr, i32 %len, i32 %cap, i32 %bytes, i32 %insert) {
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
	%26 = alloca %return.2.0
	%27 = getelementptr %return.2.0, %return.2.0* %26, i32 0, i32 0
	store i8* %24, i8** %27
	%28 = getelementptr %return.2.0, %return.2.0* %26, i32 0, i32 1
	store i32 %25, i32* %28
	%29 = load %return.2.0, %return.2.0* %26
	ret %return.2.0 %29

; <label>:30
	%31 = load i32, i32* %2
	%32 = alloca %return.2.0
	%33 = getelementptr %return.2.0, %return.2.0* %32, i32 0, i32 0
	store i8* %ptr, i8** %33
	%34 = getelementptr %return.2.0, %return.2.0* %32, i32 0, i32 1
	store i32 %31, i32* %34
	%35 = load %return.2.0, %return.2.0* %32
	ret %return.2.0 %35
}

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, i32* }
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 3, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	store i32 3, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 3, i32* %7
	; end init slice.................
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 3, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = bitcast [3 x i32]* @main.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 12, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; append start---------------------
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%15 = load i32*, i32** %14
	%16 = bitcast i32* %15 to i8*
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%18 = load i32, i32* %17
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%20 = load i32, i32* %19
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%22 = load i32, i32* %21
	%23 = call %return.2.0 @checkGrow(i8* %16, i32 %18, i32 %20, i32 %22, i32 1)
	%24 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%25 = load i32, i32* %24
	; copy and new slice
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%27 = load i32, i32* %26
	; init slice...............
	%array.42 = alloca { i32, i32, i32, i32* }
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.42, i32 0, i32 2
	store i32 4, i32* %28
	%29 = mul i32 %27, 4
	%30 = call i8* @malloc(i32 %29)
	%31 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.42, i32 0, i32 3
	%32 = bitcast i8* %30 to i32*
	store i32* %32, i32** %31
	%33 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.42, i32 0, i32 1
	store i32 %27, i32* %33
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.42, i32 0, i32 0
	store i32 %27, i32* %34
	; end init slice.................
	%35 = bitcast { i32, i32, i32, i32* }* %array.42 to i8*
	%36 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %35, i8* %36, i32 20, i1 false)
	; copy and end slice
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.42, i32 0, i32 3
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.42, i32 0, i32 0
	%39 = extractvalue %return.2.0 %23, 0
	%40 = extractvalue %return.2.0 %23, 1
	%41 = bitcast i8* %39 to i32*
	store i32* %41, i32** %37
	; store value
	%42 = load i32*, i32** %37
	%43 = bitcast i32* %42 to i32*
	%44 = add i32 %25, 0
	%45 = getelementptr i32, i32* %43, i32 %44
	store i32 8, i32* %45
	; add len
	%46 = add i32 %25, 1
	store i32 %46, i32* %38
	%47 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.42, i32 0, i32 1
	store i32 %40, i32* %47
	; append end-------------------------
	%48 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.42
	store { i32, i32, i32, i32* } %48, { i32, i32, i32, i32* }* %array.4
	%49 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%50 = load i32, i32* %49
	%51 = alloca i32
	store i32 %50, i32* %51
	%52 = load i32, i32* %51
	%53 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0), i32 %52)
	ret void
}

%return.4.0 = type { i8*, i32 }

@sli1.0 = constant [1 x i32] [i32 100]
@str.0 = constant [8 x i8] c"len-%d\0A\00"
@str.1 = constant [8 x i8] c"len-%d\0A\00"
@str.2 = constant [8 x i8] c"len-%d\0A\00"
@str.3 = constant [4 x i8] c"%d\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [4 x i8] c"%d\0A\00"
@sli2.7 = constant [1 x i32] [i32 100]
@str.6 = constant [15 x i8] c"len-%d cap-%d\0A\00"
@sli3.9 = constant [3 x i32] [i32 1, i32 2, i32 3]
@str.7 = constant [15 x i8] c"len-%d cap-%d\0A\00"
@str.8 = constant [4 x i8] c"%d\0A\00"
@othSli.12 = constant [3 x float] [float 1.0, float 2.0, float 3.0]
@str.9 = constant [6 x i8] c"%.2g\0A\00"

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

declare i32 @printf(i8*, ...)

define %return.4.0 @checkGrow(i8* %ptr, i32 %len, i32 %cap, i32 %bytes, i32 %insert) {
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
	%26 = alloca %return.4.0
	%27 = getelementptr %return.4.0, %return.4.0* %26, i32 0, i32 0
	store i8* %24, i8** %27
	%28 = getelementptr %return.4.0, %return.4.0* %26, i32 0, i32 1
	store i32 %25, i32* %28
	%29 = load %return.4.0, %return.4.0* %26
	ret %return.4.0 %29

; <label>:30
	%31 = load i32, i32* %2
	%32 = alloca %return.4.0
	%33 = getelementptr %return.4.0, %return.4.0* %32, i32 0, i32 0
	store i8* %ptr, i8** %33
	%34 = getelementptr %return.4.0, %return.4.0* %32, i32 0, i32 1
	store i32 %31, i32* %34
	%35 = load %return.4.0, %return.4.0* %32
	ret %return.4.0 %35
}

define void @sli1() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 1)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 1, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [1 x i32]* @sli1.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 4, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.0, i64 0, i64 0), i32 %9)
	; append start---------------------
	%11 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%12 = load i32*, i32** %11
	%13 = bitcast i32* %12 to i8*
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%17 = load i32, i32* %16
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%19 = load i32, i32* %18
	%20 = call %return.4.0 @checkGrow(i8* %13, i32 %15, i32 %17, i32 %19, i32 1)
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%22 = load i32, i32* %21
	; copy and new slice
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%24 = load i32, i32* %23
	%25 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %24)
	%26 = bitcast { i32, i32, i32, i32* }* %25 to i8*
	%27 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 20, i1 false)
	; copy and end slice
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 3
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 0
	%30 = extractvalue %return.4.0 %20, 0
	%31 = extractvalue %return.4.0 %20, 1
	%32 = bitcast i8* %30 to i32*
	store i32* %32, i32** %28
	; store value
	%33 = load i32*, i32** %28
	%34 = bitcast i32* %33 to i32*
	%35 = add i32 %22, 0
	%36 = getelementptr i32, i32* %34, i32 %35
	store i32 11, i32* %36
	; add len
	%37 = add i32 %22, 1
	store i32 %37, i32* %29
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 1
	store i32 %31, i32* %38
	; append end-------------------------
	%39 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25
	store { i32, i32, i32, i32* } %39, { i32, i32, i32, i32* }* %1
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%41 = load i32, i32* %40
	%42 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0), i32 %41)
	; append start---------------------
	%43 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%44 = load i32*, i32** %43
	%45 = bitcast i32* %44 to i8*
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%47 = load i32, i32* %46
	%48 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%49 = load i32, i32* %48
	%50 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%51 = load i32, i32* %50
	%52 = call %return.4.0 @checkGrow(i8* %45, i32 %47, i32 %49, i32 %51, i32 1)
	%53 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%54 = load i32, i32* %53
	; copy and new slice
	%55 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%56 = load i32, i32* %55
	%57 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %56)
	%58 = bitcast { i32, i32, i32, i32* }* %57 to i8*
	%59 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %58, i8* %59, i32 20, i1 false)
	; copy and end slice
	%60 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %57, i32 0, i32 3
	%61 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %57, i32 0, i32 0
	%62 = extractvalue %return.4.0 %52, 0
	%63 = extractvalue %return.4.0 %52, 1
	%64 = bitcast i8* %62 to i32*
	store i32* %64, i32** %60
	; store value
	%65 = load i32*, i32** %60
	%66 = bitcast i32* %65 to i32*
	%67 = add i32 %54, 0
	%68 = getelementptr i32, i32* %66, i32 %67
	store i32 12, i32* %68
	; add len
	%69 = add i32 %54, 1
	store i32 %69, i32* %61
	%70 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %57, i32 0, i32 1
	store i32 %63, i32* %70
	; append end-------------------------
	%71 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %57
	store { i32, i32, i32, i32* } %71, { i32, i32, i32, i32* }* %1
	%72 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%73 = load i32, i32* %72
	%74 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.2, i64 0, i64 0), i32 %73)
	; get slice index
	%75 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%76 = load i32*, i32** %75
	%77 = getelementptr i32, i32* %76, i32 0
	%78 = load i32, i32* %77
	%79 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0), i32 %78)
	; get slice index
	%80 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%81 = load i32*, i32** %80
	%82 = getelementptr i32, i32* %81, i32 1
	%83 = load i32, i32* %82
	%84 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0), i32 %83)
	; get slice index
	%85 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%86 = load i32*, i32** %85
	%87 = getelementptr i32, i32* %86, i32 2
	%88 = load i32, i32* %87
	%89 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0), i32 %88)
	ret void
}

define void @sli2() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 1)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 1, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [1 x i32]* @sli2.7 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 4, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	; init block
	%8 = alloca i32
	store i32 0, i32* %8
	br label %12

; <label>:9
	; add block
	%10 = load i32, i32* %8
	%11 = add i32 %10, 1
	store i32 %11, i32* %8
	br label %12

; <label>:12
	; cond Block begin
	%13 = load i32, i32* %8
	%14 = icmp slt i32 %13, 30
	; cond Block end
	br i1 %14, label %15, label %51

; <label>:15
	%16 = load i32, i32* %8
	; append start---------------------
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%18 = load i32*, i32** %17
	%19 = bitcast i32* %18 to i8*
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%21 = load i32, i32* %20
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%23 = load i32, i32* %22
	%24 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%25 = load i32, i32* %24
	%26 = call %return.4.0 @checkGrow(i8* %19, i32 %21, i32 %23, i32 %25, i32 1)
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%28 = load i32, i32* %27
	; copy and new slice
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%30 = load i32, i32* %29
	%31 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %30)
	%32 = bitcast { i32, i32, i32, i32* }* %31 to i8*
	%33 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %32, i8* %33, i32 20, i1 false)
	; copy and end slice
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %31, i32 0, i32 3
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %31, i32 0, i32 0
	%36 = extractvalue %return.4.0 %26, 0
	%37 = extractvalue %return.4.0 %26, 1
	%38 = bitcast i8* %36 to i32*
	store i32* %38, i32** %34
	; store value
	%39 = load i32*, i32** %34
	%40 = bitcast i32* %39 to i32*
	%41 = add i32 %28, 0
	%42 = getelementptr i32, i32* %40, i32 %41
	store i32 %16, i32* %42
	; add len
	%43 = add i32 %28, 1
	store i32 %43, i32* %35
	%44 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %31, i32 0, i32 1
	store i32 %37, i32* %44
	; append end-------------------------
	%45 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %31
	store { i32, i32, i32, i32* } %45, { i32, i32, i32, i32* }* %1
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%47 = load i32, i32* %46
	%48 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%49 = load i32, i32* %48
	%50 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.6, i64 0, i64 0), i32 %47, i32 %49)
	br label %9

; <label>:51
	; empty block
	ret void
}

define void @sli3() {
; <label>:0
	%1 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 3)
	%2 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	store i32 3, i32* %2
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%4 = load i32*, i32** %3
	%5 = bitcast i32* %4 to i8*
	%6 = bitcast [3 x i32]* @sli3.9 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 12, i1 false)
	%7 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1
	; init block
	%8 = alloca i32
	store i32 0, i32* %8
	br label %12

; <label>:9
	; add block
	%10 = load i32, i32* %8
	%11 = add i32 %10, 1
	store i32 %11, i32* %8
	br label %12

; <label>:12
	; cond Block begin
	%13 = load i32, i32* %8
	%14 = icmp slt i32 %13, 30
	; cond Block end
	br i1 %14, label %15, label %51

; <label>:15
	%16 = load i32, i32* %8
	; append start---------------------
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%18 = load i32*, i32** %17
	%19 = bitcast i32* %18 to i8*
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%21 = load i32, i32* %20
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%23 = load i32, i32* %22
	%24 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%25 = load i32, i32* %24
	%26 = call %return.4.0 @checkGrow(i8* %19, i32 %21, i32 %23, i32 %25, i32 1)
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%28 = load i32, i32* %27
	; copy and new slice
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%30 = load i32, i32* %29
	%31 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %30)
	%32 = bitcast { i32, i32, i32, i32* }* %31 to i8*
	%33 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %32, i8* %33, i32 20, i1 false)
	; copy and end slice
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %31, i32 0, i32 3
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %31, i32 0, i32 0
	%36 = extractvalue %return.4.0 %26, 0
	%37 = extractvalue %return.4.0 %26, 1
	%38 = bitcast i8* %36 to i32*
	store i32* %38, i32** %34
	; store value
	%39 = load i32*, i32** %34
	%40 = bitcast i32* %39 to i32*
	%41 = add i32 %28, 0
	%42 = getelementptr i32, i32* %40, i32 %41
	store i32 %16, i32* %42
	; add len
	%43 = add i32 %28, 1
	store i32 %43, i32* %35
	%44 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %31, i32 0, i32 1
	store i32 %37, i32* %44
	; append end-------------------------
	%45 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %31
	store { i32, i32, i32, i32* } %45, { i32, i32, i32, i32* }* %1
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%47 = load i32, i32* %46
	%48 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%49 = load i32, i32* %48
	%50 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.7, i64 0, i64 0), i32 %47, i32 %49)
	br label %9

; <label>:51
	; empty block
	; init block
	%52 = alloca i32
	store i32 0, i32* %52
	br label %56

; <label>:53
	; add block
	%54 = load i32, i32* %52
	%55 = add i32 %54, 1
	store i32 %55, i32* %52
	br label %56

; <label>:56
	; cond Block begin
	%57 = load i32, i32* %52
	%58 = icmp slt i32 %57, 33
	; cond Block end
	br i1 %58, label %59, label %66

; <label>:59
	%60 = load i32, i32* %52
	; get slice index
	%61 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%62 = load i32*, i32** %61
	%63 = getelementptr i32, i32* %62, i32 %60
	%64 = load i32, i32* %63
	%65 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.8, i64 0, i64 0), i32 %64)
	br label %53

; <label>:66
	; empty block
	ret void
}

define { i32, i32, i32, float* }* @init_slice_float(i32 %len) {
; <label>:0
	; init slice...............
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, float* }*
	%3 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 2
	store i32 8, i32* %3
	%4 = mul i32 %len, 8
	%5 = call i8* @malloc(i32 %4)
	%6 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 3
	%7 = bitcast i8* %5 to float*
	store float* %7, float** %6
	%8 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 1
	store i32 %len, i32* %8
	%9 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 0
	store i32 %len, i32* %9
	; end init slice.................
	ret { i32, i32, i32, float* }* %2
}

define void @othSli() {
; <label>:0
	%1 = call { i32, i32, i32, float* }* @init_slice_float(i32 3)
	%2 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 0
	store i32 3, i32* %2
	%3 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 3
	%4 = load float*, float** %3
	%5 = bitcast float* %4 to i8*
	%6 = bitcast [3 x float]* @othSli.12 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 24, i1 false)
	%7 = load { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1
	; append start---------------------
	%8 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 3
	%9 = load float*, float** %8
	%10 = bitcast float* %9 to i8*
	%11 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 1
	%14 = load i32, i32* %13
	%15 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 2
	%16 = load i32, i32* %15
	%17 = call %return.4.0 @checkGrow(i8* %10, i32 %12, i32 %14, i32 %16, i32 1)
	%18 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 0
	%19 = load i32, i32* %18
	; copy and new slice
	%20 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 0
	%21 = load i32, i32* %20
	%22 = call { i32, i32, i32, float* }* @init_slice_float(i32 %21)
	%23 = bitcast { i32, i32, i32, float* }* %22 to i8*
	%24 = bitcast { i32, i32, i32, float* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %23, i8* %24, i32 20, i1 false)
	; copy and end slice
	%25 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %22, i32 0, i32 3
	%26 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %22, i32 0, i32 0
	%27 = extractvalue %return.4.0 %17, 0
	%28 = extractvalue %return.4.0 %17, 1
	%29 = bitcast i8* %27 to float*
	store float* %29, float** %25
	; store value
	%30 = load float*, float** %25
	%31 = bitcast float* %30 to float*
	%32 = add i32 %19, 0
	%33 = getelementptr float, float* %31, i32 %32
	store float 0x40156BC280000000, float* %33
	; add len
	%34 = add i32 %19, 1
	store i32 %34, i32* %26
	%35 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %22, i32 0, i32 1
	store i32 %28, i32* %35
	; append end-------------------------
	%36 = load { i32, i32, i32, float* }, { i32, i32, i32, float* }* %22
	store { i32, i32, i32, float* } %36, { i32, i32, i32, float* }* %1
	; get slice index
	%37 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %1, i32 0, i32 3
	%38 = load float*, float** %37
	%39 = getelementptr float, float* %38, i32 3
	%40 = load float, float* %39
	%41 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.9, i64 0, i64 0), float %40)
	ret void
}

define void @main() {
; <label>:0
	call void @sli1()
	call void @sli2()
	call void @sli3()
	call void @othSli()
	ret void
}

%return.3.0 = type { i8*, i32 }

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

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

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

define void @sli1() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, i32* }
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 1, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	store i32 1, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 1, i32* %7
	; end init slice.................
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 1, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = bitcast [1 x i32]* @sli1.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 4, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.0, i64 0, i64 0), i32 %15)
	; append start---------------------
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%18 = load i32*, i32** %17
	%19 = bitcast i32* %18 to i8*
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%21 = load i32, i32* %20
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%23 = load i32, i32* %22
	%24 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%25 = load i32, i32* %24
	%26 = call %return.3.0 @checkGrow(i8* %19, i32 %21, i32 %23, i32 %25, i32 1)
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%28 = load i32, i32* %27
	; copy and new slice
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%30 = load i32, i32* %29
	; init slice...............
	%array.45 = alloca { i32, i32, i32, i32* }
	%31 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.45, i32 0, i32 2
	store i32 4, i32* %31
	%32 = mul i32 %30, 4
	%33 = call i8* @malloc(i32 %32)
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.45, i32 0, i32 3
	%35 = bitcast i8* %33 to i32*
	store i32* %35, i32** %34
	%36 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.45, i32 0, i32 1
	store i32 %30, i32* %36
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.45, i32 0, i32 0
	store i32 %30, i32* %37
	; end init slice.................
	%38 = bitcast { i32, i32, i32, i32* }* %array.45 to i8*
	%39 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %38, i8* %39, i32 20, i1 false)
	; copy and end slice
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.45, i32 0, i32 3
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.45, i32 0, i32 0
	%42 = extractvalue %return.3.0 %26, 0
	%43 = extractvalue %return.3.0 %26, 1
	%44 = bitcast i8* %42 to i32*
	store i32* %44, i32** %40
	; store value
	%45 = load i32*, i32** %40
	%46 = bitcast i32* %45 to i32*
	%47 = add i32 %28, 0
	%48 = getelementptr i32, i32* %46, i32 %47
	store i32 11, i32* %48
	; add len
	%49 = add i32 %28, 1
	store i32 %49, i32* %41
	%50 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.45, i32 0, i32 1
	store i32 %43, i32* %50
	; append end-------------------------
	%51 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.45
	store { i32, i32, i32, i32* } %51, { i32, i32, i32, i32* }* %array.4
	%52 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%53 = load i32, i32* %52
	%54 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0), i32 %53)
	; append start---------------------
	%55 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%56 = load i32*, i32** %55
	%57 = bitcast i32* %56 to i8*
	%58 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%59 = load i32, i32* %58
	%60 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%61 = load i32, i32* %60
	%62 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%63 = load i32, i32* %62
	%64 = call %return.3.0 @checkGrow(i8* %57, i32 %59, i32 %61, i32 %63, i32 1)
	%65 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%66 = load i32, i32* %65
	; copy and new slice
	%67 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%68 = load i32, i32* %67
	; init slice...............
	%array.102 = alloca { i32, i32, i32, i32* }
	%69 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.102, i32 0, i32 2
	store i32 4, i32* %69
	%70 = mul i32 %68, 4
	%71 = call i8* @malloc(i32 %70)
	%72 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.102, i32 0, i32 3
	%73 = bitcast i8* %71 to i32*
	store i32* %73, i32** %72
	%74 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.102, i32 0, i32 1
	store i32 %68, i32* %74
	%75 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.102, i32 0, i32 0
	store i32 %68, i32* %75
	; end init slice.................
	%76 = bitcast { i32, i32, i32, i32* }* %array.102 to i8*
	%77 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %76, i8* %77, i32 20, i1 false)
	; copy and end slice
	%78 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.102, i32 0, i32 3
	%79 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.102, i32 0, i32 0
	%80 = extractvalue %return.3.0 %64, 0
	%81 = extractvalue %return.3.0 %64, 1
	%82 = bitcast i8* %80 to i32*
	store i32* %82, i32** %78
	; store value
	%83 = load i32*, i32** %78
	%84 = bitcast i32* %83 to i32*
	%85 = add i32 %66, 0
	%86 = getelementptr i32, i32* %84, i32 %85
	store i32 12, i32* %86
	; add len
	%87 = add i32 %66, 1
	store i32 %87, i32* %79
	%88 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.102, i32 0, i32 1
	store i32 %81, i32* %88
	; append end-------------------------
	%89 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.102
	store { i32, i32, i32, i32* } %89, { i32, i32, i32, i32* }* %array.4
	%90 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%91 = load i32, i32* %90
	%92 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.2, i64 0, i64 0), i32 %91)
	; get slice index
	%93 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%94 = load i32*, i32** %93
	%95 = getelementptr i32, i32* %94, i32 0
	%96 = load i32, i32* %95
	%97 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0), i32 %96)
	; get slice index
	%98 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%99 = load i32*, i32** %98
	%100 = getelementptr i32, i32* %99, i32 1
	%101 = load i32, i32* %100
	%102 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0), i32 %101)
	; get slice index
	%103 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%104 = load i32*, i32** %103
	%105 = getelementptr i32, i32* %104, i32 2
	%106 = load i32, i32* %105
	%107 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0), i32 %106)
	ret void
}

define void @sli2() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, i32* }
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 1, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	store i32 1, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 1, i32* %7
	; end init slice.................
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 1, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = bitcast [1 x i32]* @sli2.7 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 4, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; init block
	%14 = alloca i32
	store i32 0, i32* %14
	br label %18

; <label>:15
	; add block
	%16 = load i32, i32* %14
	%17 = add i32 %16, 1
	store i32 %17, i32* %14
	br label %18

; <label>:18
	; cond Block begin
	%19 = load i32, i32* %14
	%20 = icmp slt i32 %19, 30
	; cond Block end
	br i1 %20, label %21, label %63

; <label>:21
	%22 = load i32, i32* %14
	; append start---------------------
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%24 = load i32*, i32** %23
	%25 = bitcast i32* %24 to i8*
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%29 = load i32, i32* %28
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%31 = load i32, i32* %30
	%32 = call %return.3.0 @checkGrow(i8* %25, i32 %27, i32 %29, i32 %31, i32 1)
	%33 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%34 = load i32, i32* %33
	; copy and new slice
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%36 = load i32, i32* %35
	; init slice...............
	%array.21 = alloca { i32, i32, i32, i32* }
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 2
	store i32 4, i32* %37
	%38 = mul i32 %36, 4
	%39 = call i8* @malloc(i32 %38)
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 3
	%41 = bitcast i8* %39 to i32*
	store i32* %41, i32** %40
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 1
	store i32 %36, i32* %42
	%43 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 0
	store i32 %36, i32* %43
	; end init slice.................
	%44 = bitcast { i32, i32, i32, i32* }* %array.21 to i8*
	%45 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %44, i8* %45, i32 20, i1 false)
	; copy and end slice
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 3
	%47 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 0
	%48 = extractvalue %return.3.0 %32, 0
	%49 = extractvalue %return.3.0 %32, 1
	%50 = bitcast i8* %48 to i32*
	store i32* %50, i32** %46
	; store value
	%51 = load i32*, i32** %46
	%52 = bitcast i32* %51 to i32*
	%53 = add i32 %34, 0
	%54 = getelementptr i32, i32* %52, i32 %53
	store i32 %22, i32* %54
	; add len
	%55 = add i32 %34, 1
	store i32 %55, i32* %47
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 1
	store i32 %49, i32* %56
	; append end-------------------------
	%57 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21
	store { i32, i32, i32, i32* } %57, { i32, i32, i32, i32* }* %array.4
	%58 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%59 = load i32, i32* %58
	%60 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%61 = load i32, i32* %60
	%62 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.6, i64 0, i64 0), i32 %59, i32 %61)
	br label %15

; <label>:63
	; empty block
	ret void
}

define void @sli3() {
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
	%12 = bitcast [3 x i32]* @sli3.9 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 12, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; init block
	%14 = alloca i32
	store i32 0, i32* %14
	br label %18

; <label>:15
	; add block
	%16 = load i32, i32* %14
	%17 = add i32 %16, 1
	store i32 %17, i32* %14
	br label %18

; <label>:18
	; cond Block begin
	%19 = load i32, i32* %14
	%20 = icmp slt i32 %19, 30
	; cond Block end
	br i1 %20, label %21, label %63

; <label>:21
	%22 = load i32, i32* %14
	; append start---------------------
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%24 = load i32*, i32** %23
	%25 = bitcast i32* %24 to i8*
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%29 = load i32, i32* %28
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%31 = load i32, i32* %30
	%32 = call %return.3.0 @checkGrow(i8* %25, i32 %27, i32 %29, i32 %31, i32 1)
	%33 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%34 = load i32, i32* %33
	; copy and new slice
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%36 = load i32, i32* %35
	; init slice...............
	%array.21 = alloca { i32, i32, i32, i32* }
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 2
	store i32 4, i32* %37
	%38 = mul i32 %36, 4
	%39 = call i8* @malloc(i32 %38)
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 3
	%41 = bitcast i8* %39 to i32*
	store i32* %41, i32** %40
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 1
	store i32 %36, i32* %42
	%43 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 0
	store i32 %36, i32* %43
	; end init slice.................
	%44 = bitcast { i32, i32, i32, i32* }* %array.21 to i8*
	%45 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %44, i8* %45, i32 20, i1 false)
	; copy and end slice
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 3
	%47 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 0
	%48 = extractvalue %return.3.0 %32, 0
	%49 = extractvalue %return.3.0 %32, 1
	%50 = bitcast i8* %48 to i32*
	store i32* %50, i32** %46
	; store value
	%51 = load i32*, i32** %46
	%52 = bitcast i32* %51 to i32*
	%53 = add i32 %34, 0
	%54 = getelementptr i32, i32* %52, i32 %53
	store i32 %22, i32* %54
	; add len
	%55 = add i32 %34, 1
	store i32 %55, i32* %47
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21, i32 0, i32 1
	store i32 %49, i32* %56
	; append end-------------------------
	%57 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.21
	store { i32, i32, i32, i32* } %57, { i32, i32, i32, i32* }* %array.4
	%58 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%59 = load i32, i32* %58
	%60 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%61 = load i32, i32* %60
	%62 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.7, i64 0, i64 0), i32 %59, i32 %61)
	br label %15

; <label>:63
	; empty block
	; init block
	%64 = alloca i32
	store i32 0, i32* %64
	br label %68

; <label>:65
	; add block
	%66 = load i32, i32* %64
	%67 = add i32 %66, 1
	store i32 %67, i32* %64
	br label %68

; <label>:68
	; cond Block begin
	%69 = load i32, i32* %64
	%70 = icmp slt i32 %69, 33
	; cond Block end
	br i1 %70, label %71, label %78

; <label>:71
	%72 = load i32, i32* %64
	; get slice index
	%73 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%74 = load i32*, i32** %73
	%75 = getelementptr i32, i32* %74, i32 %72
	%76 = load i32, i32* %75
	%77 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.8, i64 0, i64 0), i32 %76)
	br label %65

; <label>:78
	; empty block
	ret void
}

define void @othSli() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, float* }
	%1 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 2
	store i32 8, i32* %1
	%2 = mul i32 3, 8
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to float*
	store float* %5, float** %4
	%6 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 1
	store i32 3, i32* %6
	%7 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 0
	store i32 3, i32* %7
	; end init slice.................
	%8 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 0
	store i32 3, i32* %8
	%9 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 3
	%10 = load float*, float** %9
	%11 = bitcast float* %10 to i8*
	%12 = bitcast [3 x float]* @othSli.12 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 24, i1 false)
	%13 = load { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4
	; append start---------------------
	%14 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 3
	%15 = load float*, float** %14
	%16 = bitcast float* %15 to i8*
	%17 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 0
	%18 = load i32, i32* %17
	%19 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 1
	%20 = load i32, i32* %19
	%21 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 2
	%22 = load i32, i32* %21
	%23 = call %return.3.0 @checkGrow(i8* %16, i32 %18, i32 %20, i32 %22, i32 1)
	%24 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 0
	%25 = load i32, i32* %24
	; copy and new slice
	%26 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 0
	%27 = load i32, i32* %26
	; init slice...............
	%array.42 = alloca { i32, i32, i32, float* }
	%28 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.42, i32 0, i32 2
	store i32 8, i32* %28
	%29 = mul i32 %27, 8
	%30 = call i8* @malloc(i32 %29)
	%31 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.42, i32 0, i32 3
	%32 = bitcast i8* %30 to float*
	store float* %32, float** %31
	%33 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.42, i32 0, i32 1
	store i32 %27, i32* %33
	%34 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.42, i32 0, i32 0
	store i32 %27, i32* %34
	; end init slice.................
	%35 = bitcast { i32, i32, i32, float* }* %array.42 to i8*
	%36 = bitcast { i32, i32, i32, float* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %35, i8* %36, i32 20, i1 false)
	; copy and end slice
	%37 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.42, i32 0, i32 3
	%38 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.42, i32 0, i32 0
	%39 = extractvalue %return.3.0 %23, 0
	%40 = extractvalue %return.3.0 %23, 1
	%41 = bitcast i8* %39 to float*
	store float* %41, float** %37
	; store value
	%42 = load float*, float** %37
	%43 = bitcast float* %42 to float*
	%44 = add i32 %25, 0
	%45 = getelementptr float, float* %43, i32 %44
	store float 0x40156BC280000000, float* %45
	; add len
	%46 = add i32 %25, 1
	store i32 %46, i32* %38
	%47 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.42, i32 0, i32 1
	store i32 %40, i32* %47
	; append end-------------------------
	%48 = load { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.42
	store { i32, i32, i32, float* } %48, { i32, i32, i32, float* }* %array.4
	; get slice index
	%49 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %array.4, i32 0, i32 3
	%50 = load float*, float** %49
	%51 = getelementptr float, float* %50, i32 3
	%52 = load float, float* %51
	%53 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.9, i64 0, i64 0), float %52)
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

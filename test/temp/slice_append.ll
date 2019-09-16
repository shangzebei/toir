%mapStruct = type {}
%string = type { i32, i8* }
%return.5.0 = type { i8*, i32 }

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

define void @init_slice_i32({ i32, i32, i32, i32* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %ptr, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 %len, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define %string* @newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 12)
	%3 = bitcast i8* %2 to %string*
	%4 = alloca %string*
	store %string* %3, %string** %4
	br label %5

; <label>:5
	%6 = load i32, i32* %1
	%7 = icmp eq i32 %6, 0
	br i1 %7, label %8, label %10

; <label>:8
	; block start
	%9 = load %string*, %string** %4
	; end block
	ret %string* %9

; <label>:10
	br label %11

; <label>:11
	%12 = load i32, i32* %1
	%13 = sub i32 %12, 1
	%14 = load %string*, %string** %4
	%15 = getelementptr %string, %string* %14, i32 0, i32 0
	%16 = load i32, i32* %15
	store i32 %13, i32* %15
	%17 = load i32, i32* %1
	%18 = call i8* @malloc(i32 %17)
	%19 = load %string*, %string** %4
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	store i8* %18, i8** %20
	%22 = load %string*, %string** %4
	; end block
	ret %string* %22
}

declare i32 @printf(i8*, ...)

define %return.5.0 @checkGrow(i8* %ptr, i32 %len, i32 %cap, i32 %bytes, i32 %insert) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %len, i32* %1
	%2 = alloca i32
	store i32 %cap, i32* %2
	%3 = alloca i32
	store i32 %bytes, i32* %3
	%4 = alloca i32
	store i32 %insert, i32* %4
	; end block
	br label %5

; <label>:5
	%6 = load i32, i32* %1
	%7 = load i32, i32* %2
	%8 = icmp sge i32 %6, %7
	br i1 %8, label %9, label %31

; <label>:9
	; block start
	%10 = load i32, i32* %1
	%11 = load i32, i32* %4
	%12 = add i32 %10, %11
	%13 = add i32 %12, 4
	%14 = alloca i32
	store i32 %13, i32* %14
	%15 = load i32, i32* %14
	%16 = load i32, i32* %3
	%17 = mul i32 %15, %16
	%18 = call i8* @malloc(i32 %17)
	%19 = alloca i8*
	store i8* %18, i8** %19
	%20 = load i8*, i8** %19
	%21 = load i32, i32* %1
	%22 = load i32, i32* %3
	%23 = mul i32 %21, %22
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %ptr, i32 %23, i1 false)
	%24 = load i32, i32* %1
	store i32 %24, i32* %2
	%25 = load i8*, i8** %19
	%26 = load i32, i32* %14
	%27 = alloca %return.5.0
	%28 = getelementptr %return.5.0, %return.5.0* %27, i32 0, i32 0
	store i8* %25, i8** %28
	%29 = getelementptr %return.5.0, %return.5.0* %27, i32 0, i32 1
	store i32 %26, i32* %29
	%30 = load %return.5.0, %return.5.0* %27
	; end block
	ret %return.5.0 %30

; <label>:31
	; block start
	%32 = load i32, i32* %2
	%33 = alloca %return.5.0
	%34 = getelementptr %return.5.0, %return.5.0* %33, i32 0, i32 0
	store i8* %ptr, i8** %34
	%35 = getelementptr %return.5.0, %return.5.0* %33, i32 0, i32 1
	store i32 %32, i32* %35
	%36 = load %return.5.0, %return.5.0* %33
	; end block
	ret %return.5.0 %36
}

define void @sli1() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %2, i32 1)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 1, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [1 x i32]* @sli1.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 4, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call %string* @newString(i32 8)
	%10 = getelementptr %string, %string* %9, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 8, i1 false)
	%14 = load %string, %string* %9
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = getelementptr %string, %string* %9, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = call i32 (i8*, ...) @printf(i8* %18, i32 %16)
	; append start---------------------
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%21 = load i32*, i32** %20
	%22 = bitcast i32* %21 to i8*
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%24 = load i32, i32* %23
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%26 = load i32, i32* %25
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%28 = load i32, i32* %27
	%29 = call %return.5.0 @checkGrow(i8* %22, i32 %24, i32 %26, i32 %28, i32 1)
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%31 = load i32, i32* %30
	; copy and new slice
	%32 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%33 = load i32, i32* %32
	%34 = call i8* @malloc(i32 20)
	%35 = bitcast i8* %34 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %35, i32 %33)
	%36 = bitcast { i32, i32, i32, i32* }* %35 to i8*
	%37 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %36, i8* %37, i32 20, i1 false)
	; copy and end slice
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %35, i32 0, i32 3
	%39 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %35, i32 0, i32 0
	%40 = extractvalue %return.5.0 %29, 0
	%41 = extractvalue %return.5.0 %29, 1
	%42 = bitcast i8* %40 to i32*
	store i32* %42, i32** %38
	; store value
	%43 = load i32*, i32** %38
	%44 = bitcast i32* %43 to i32*
	%45 = add i32 %31, 0
	%46 = getelementptr i32, i32* %44, i32 %45
	store i32 11, i32* %46
	; add len
	%47 = add i32 %31, 1
	store i32 %47, i32* %39
	%48 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %35, i32 0, i32 1
	store i32 %41, i32* %48
	; append end-------------------------
	%49 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %35
	store { i32, i32, i32, i32* } %49, { i32, i32, i32, i32* }* %2
	%50 = call %string* @newString(i32 8)
	%51 = getelementptr %string, %string* %50, i32 0, i32 1
	%52 = load i8*, i8** %51
	%53 = bitcast i8* %52 to i8*
	%54 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %53, i8* %54, i32 8, i1 false)
	%55 = load %string, %string* %50
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%57 = load i32, i32* %56
	%58 = getelementptr %string, %string* %50, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = call i32 (i8*, ...) @printf(i8* %59, i32 %57)
	; append start---------------------
	%61 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%62 = load i32*, i32** %61
	%63 = bitcast i32* %62 to i8*
	%64 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%65 = load i32, i32* %64
	%66 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%67 = load i32, i32* %66
	%68 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%69 = load i32, i32* %68
	%70 = call %return.5.0 @checkGrow(i8* %63, i32 %65, i32 %67, i32 %69, i32 1)
	%71 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%72 = load i32, i32* %71
	; copy and new slice
	%73 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%74 = load i32, i32* %73
	%75 = call i8* @malloc(i32 20)
	%76 = bitcast i8* %75 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %76, i32 %74)
	%77 = bitcast { i32, i32, i32, i32* }* %76 to i8*
	%78 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %77, i8* %78, i32 20, i1 false)
	; copy and end slice
	%79 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %76, i32 0, i32 3
	%80 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %76, i32 0, i32 0
	%81 = extractvalue %return.5.0 %70, 0
	%82 = extractvalue %return.5.0 %70, 1
	%83 = bitcast i8* %81 to i32*
	store i32* %83, i32** %79
	; store value
	%84 = load i32*, i32** %79
	%85 = bitcast i32* %84 to i32*
	%86 = add i32 %72, 0
	%87 = getelementptr i32, i32* %85, i32 %86
	store i32 12, i32* %87
	; add len
	%88 = add i32 %72, 1
	store i32 %88, i32* %80
	%89 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %76, i32 0, i32 1
	store i32 %82, i32* %89
	; append end-------------------------
	%90 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %76
	store { i32, i32, i32, i32* } %90, { i32, i32, i32, i32* }* %2
	%91 = call %string* @newString(i32 8)
	%92 = getelementptr %string, %string* %91, i32 0, i32 1
	%93 = load i8*, i8** %92
	%94 = bitcast i8* %93 to i8*
	%95 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %94, i8* %95, i32 8, i1 false)
	%96 = load %string, %string* %91
	%97 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%98 = load i32, i32* %97
	%99 = getelementptr %string, %string* %91, i32 0, i32 1
	%100 = load i8*, i8** %99
	%101 = call i32 (i8*, ...) @printf(i8* %100, i32 %98)
	%102 = call %string* @newString(i32 4)
	%103 = getelementptr %string, %string* %102, i32 0, i32 1
	%104 = load i8*, i8** %103
	%105 = bitcast i8* %104 to i8*
	%106 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %105, i8* %106, i32 4, i1 false)
	%107 = load %string, %string* %102
	; get slice index
	%108 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%109 = load i32*, i32** %108
	%110 = getelementptr i32, i32* %109, i32 0
	%111 = load i32, i32* %110
	%112 = getelementptr %string, %string* %102, i32 0, i32 1
	%113 = load i8*, i8** %112
	%114 = call i32 (i8*, ...) @printf(i8* %113, i32 %111)
	%115 = call %string* @newString(i32 4)
	%116 = getelementptr %string, %string* %115, i32 0, i32 1
	%117 = load i8*, i8** %116
	%118 = bitcast i8* %117 to i8*
	%119 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %118, i8* %119, i32 4, i1 false)
	%120 = load %string, %string* %115
	; get slice index
	%121 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%122 = load i32*, i32** %121
	%123 = getelementptr i32, i32* %122, i32 1
	%124 = load i32, i32* %123
	%125 = getelementptr %string, %string* %115, i32 0, i32 1
	%126 = load i8*, i8** %125
	%127 = call i32 (i8*, ...) @printf(i8* %126, i32 %124)
	%128 = call %string* @newString(i32 4)
	%129 = getelementptr %string, %string* %128, i32 0, i32 1
	%130 = load i8*, i8** %129
	%131 = bitcast i8* %130 to i8*
	%132 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %131, i8* %132, i32 4, i1 false)
	%133 = load %string, %string* %128
	; get slice index
	%134 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%135 = load i32*, i32** %134
	%136 = getelementptr i32, i32* %135, i32 2
	%137 = load i32, i32* %136
	%138 = getelementptr %string, %string* %128, i32 0, i32 1
	%139 = load i8*, i8** %138
	%140 = call i32 (i8*, ...) @printf(i8* %139, i32 %137)
	; end block
	ret void
}

define void @sli2() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %2, i32 1)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 1, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [1 x i32]* @sli2.7 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 4, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; init block
	%9 = alloca i32
	store i32 0, i32* %9
	br label %13

; <label>:10
	; add block
	%11 = load i32, i32* %9
	%12 = add i32 %11, 1
	store i32 %12, i32* %9
	br label %13

; <label>:13
	; cond Block begin
	%14 = load i32, i32* %9
	%15 = icmp slt i32 %14, 30
	; cond Block end
	br i1 %15, label %16, label %61

; <label>:16
	; block start
	%17 = load i32, i32* %9
	; append start---------------------
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%19 = load i32*, i32** %18
	%20 = bitcast i32* %19 to i8*
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%22 = load i32, i32* %21
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%24 = load i32, i32* %23
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%26 = load i32, i32* %25
	%27 = call %return.5.0 @checkGrow(i8* %20, i32 %22, i32 %24, i32 %26, i32 1)
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%29 = load i32, i32* %28
	; copy and new slice
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%31 = load i32, i32* %30
	%32 = call i8* @malloc(i32 20)
	%33 = bitcast i8* %32 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %33, i32 %31)
	%34 = bitcast { i32, i32, i32, i32* }* %33 to i8*
	%35 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %34, i8* %35, i32 20, i1 false)
	; copy and end slice
	%36 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33, i32 0, i32 3
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33, i32 0, i32 0
	%38 = extractvalue %return.5.0 %27, 0
	%39 = extractvalue %return.5.0 %27, 1
	%40 = bitcast i8* %38 to i32*
	store i32* %40, i32** %36
	; store value
	%41 = load i32*, i32** %36
	%42 = bitcast i32* %41 to i32*
	%43 = add i32 %29, 0
	%44 = getelementptr i32, i32* %42, i32 %43
	store i32 %17, i32* %44
	; add len
	%45 = add i32 %29, 1
	store i32 %45, i32* %37
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33, i32 0, i32 1
	store i32 %39, i32* %46
	; append end-------------------------
	%47 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33
	store { i32, i32, i32, i32* } %47, { i32, i32, i32, i32* }* %2
	%48 = call %string* @newString(i32 15)
	%49 = getelementptr %string, %string* %48, i32 0, i32 1
	%50 = load i8*, i8** %49
	%51 = bitcast i8* %50 to i8*
	%52 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %51, i8* %52, i32 15, i1 false)
	%53 = load %string, %string* %48
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%55 = load i32, i32* %54
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%57 = load i32, i32* %56
	%58 = getelementptr %string, %string* %48, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = call i32 (i8*, ...) @printf(i8* %59, i32 %55, i32 %57)
	; end block
	br label %10

; <label>:61
	; empty block
	; end block
	ret void
}

define void @sli3() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 3, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [3 x i32]* @sli3.9 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 12, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; init block
	%9 = alloca i32
	store i32 0, i32* %9
	br label %13

; <label>:10
	; add block
	%11 = load i32, i32* %9
	%12 = add i32 %11, 1
	store i32 %12, i32* %9
	br label %13

; <label>:13
	; cond Block begin
	%14 = load i32, i32* %9
	%15 = icmp slt i32 %14, 30
	; cond Block end
	br i1 %15, label %16, label %61

; <label>:16
	; block start
	%17 = load i32, i32* %9
	; append start---------------------
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%19 = load i32*, i32** %18
	%20 = bitcast i32* %19 to i8*
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%22 = load i32, i32* %21
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%24 = load i32, i32* %23
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%26 = load i32, i32* %25
	%27 = call %return.5.0 @checkGrow(i8* %20, i32 %22, i32 %24, i32 %26, i32 1)
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%29 = load i32, i32* %28
	; copy and new slice
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%31 = load i32, i32* %30
	%32 = call i8* @malloc(i32 20)
	%33 = bitcast i8* %32 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %33, i32 %31)
	%34 = bitcast { i32, i32, i32, i32* }* %33 to i8*
	%35 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %34, i8* %35, i32 20, i1 false)
	; copy and end slice
	%36 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33, i32 0, i32 3
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33, i32 0, i32 0
	%38 = extractvalue %return.5.0 %27, 0
	%39 = extractvalue %return.5.0 %27, 1
	%40 = bitcast i8* %38 to i32*
	store i32* %40, i32** %36
	; store value
	%41 = load i32*, i32** %36
	%42 = bitcast i32* %41 to i32*
	%43 = add i32 %29, 0
	%44 = getelementptr i32, i32* %42, i32 %43
	store i32 %17, i32* %44
	; add len
	%45 = add i32 %29, 1
	store i32 %45, i32* %37
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33, i32 0, i32 1
	store i32 %39, i32* %46
	; append end-------------------------
	%47 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33
	store { i32, i32, i32, i32* } %47, { i32, i32, i32, i32* }* %2
	%48 = call %string* @newString(i32 15)
	%49 = getelementptr %string, %string* %48, i32 0, i32 1
	%50 = load i8*, i8** %49
	%51 = bitcast i8* %50 to i8*
	%52 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %51, i8* %52, i32 15, i1 false)
	%53 = load %string, %string* %48
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%55 = load i32, i32* %54
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%57 = load i32, i32* %56
	%58 = getelementptr %string, %string* %48, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = call i32 (i8*, ...) @printf(i8* %59, i32 %55, i32 %57)
	; end block
	br label %10

; <label>:61
	; empty block
	; init block
	%62 = alloca i32
	store i32 0, i32* %62
	br label %66

; <label>:63
	; add block
	%64 = load i32, i32* %62
	%65 = add i32 %64, 1
	store i32 %65, i32* %62
	br label %66

; <label>:66
	; cond Block begin
	%67 = load i32, i32* %62
	%68 = icmp slt i32 %67, 33
	; cond Block end
	br i1 %68, label %69, label %84

; <label>:69
	; block start
	%70 = call %string* @newString(i32 4)
	%71 = getelementptr %string, %string* %70, i32 0, i32 1
	%72 = load i8*, i8** %71
	%73 = bitcast i8* %72 to i8*
	%74 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %73, i8* %74, i32 4, i1 false)
	%75 = load %string, %string* %70
	%76 = load i32, i32* %62
	; get slice index
	%77 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%78 = load i32*, i32** %77
	%79 = getelementptr i32, i32* %78, i32 %76
	%80 = load i32, i32* %79
	%81 = getelementptr %string, %string* %70, i32 0, i32 1
	%82 = load i8*, i8** %81
	%83 = call i32 (i8*, ...) @printf(i8* %82, i32 %80)
	; end block
	br label %63

; <label>:84
	; empty block
	; end block
	ret void
}

define void @init_slice_float({ i32, i32, i32, float* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %ptr, i32 0, i32 2
	store i32 8, i32* %1
	%2 = mul i32 %len, 8
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to float*
	store float* %5, float** %4
	%6 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

define void @othSli() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, float* }*
	call void @init_slice_float({ i32, i32, i32, float* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 0
	store i32 3, i32* %3
	%4 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 3
	%5 = load float*, float** %4
	%6 = bitcast float* %5 to i8*
	%7 = bitcast [3 x float]* @othSli.12 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 24, i1 false)
	%8 = load { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2
	; append start---------------------
	%9 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 3
	%10 = load float*, float** %9
	%11 = bitcast float* %10 to i8*
	%12 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 0
	%13 = load i32, i32* %12
	%14 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 1
	%15 = load i32, i32* %14
	%16 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 2
	%17 = load i32, i32* %16
	%18 = call %return.5.0 @checkGrow(i8* %11, i32 %13, i32 %15, i32 %17, i32 1)
	%19 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 0
	%20 = load i32, i32* %19
	; copy and new slice
	%21 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 0
	%22 = load i32, i32* %21
	%23 = call i8* @malloc(i32 20)
	%24 = bitcast i8* %23 to { i32, i32, i32, float* }*
	call void @init_slice_float({ i32, i32, i32, float* }* %24, i32 %22)
	%25 = bitcast { i32, i32, i32, float* }* %24 to i8*
	%26 = bitcast { i32, i32, i32, float* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %25, i8* %26, i32 20, i1 false)
	; copy and end slice
	%27 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %24, i32 0, i32 3
	%28 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %24, i32 0, i32 0
	%29 = extractvalue %return.5.0 %18, 0
	%30 = extractvalue %return.5.0 %18, 1
	%31 = bitcast i8* %29 to float*
	store float* %31, float** %27
	; store value
	%32 = load float*, float** %27
	%33 = bitcast float* %32 to float*
	%34 = add i32 %20, 0
	%35 = getelementptr float, float* %33, i32 %34
	store float 0x40156BC280000000, float* %35
	; add len
	%36 = add i32 %20, 1
	store i32 %36, i32* %28
	%37 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %24, i32 0, i32 1
	store i32 %30, i32* %37
	; append end-------------------------
	%38 = load { i32, i32, i32, float* }, { i32, i32, i32, float* }* %24
	store { i32, i32, i32, float* } %38, { i32, i32, i32, float* }* %2
	%39 = call %string* @newString(i32 6)
	%40 = getelementptr %string, %string* %39, i32 0, i32 1
	%41 = load i8*, i8** %40
	%42 = bitcast i8* %41 to i8*
	%43 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.9, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %42, i8* %43, i32 6, i1 false)
	%44 = load %string, %string* %39
	; get slice index
	%45 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 3
	%46 = load float*, float** %45
	%47 = getelementptr float, float* %46, i32 3
	%48 = load float, float* %47
	%49 = getelementptr %string, %string* %39, i32 0, i32 1
	%50 = load i8*, i8** %49
	%51 = call i32 (i8*, ...) @printf(i8* %50, float %48)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @sli1()
	call void @sli2()
	call void @sli3()
	call void @othSli()
	; end block
	ret void
}

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
	%9 = call i8* @malloc(i32 20)
	%10 = bitcast i8* %9 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %10, i32 8)
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 0
	store i32 8, i32* %11
	%12 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 8, i1 false)
	%16 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%18 = load i32, i32* %17
	%19 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20, i32 %18)
	; append start---------------------
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%23 = load i32*, i32** %22
	%24 = bitcast i32* %23 to i8*
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%26 = load i32, i32* %25
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%28 = load i32, i32* %27
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%30 = load i32, i32* %29
	%31 = call %return.5.0 @checkGrow(i8* %24, i32 %26, i32 %28, i32 %30, i32 1)
	%32 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%33 = load i32, i32* %32
	; copy and new slice
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%35 = load i32, i32* %34
	%36 = call i8* @malloc(i32 20)
	%37 = bitcast i8* %36 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %37, i32 %35)
	%38 = bitcast { i32, i32, i32, i32* }* %37 to i8*
	%39 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %38, i8* %39, i32 20, i1 false)
	; copy and end slice
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %37, i32 0, i32 3
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %37, i32 0, i32 0
	%42 = extractvalue %return.5.0 %31, 0
	%43 = extractvalue %return.5.0 %31, 1
	%44 = bitcast i8* %42 to i32*
	store i32* %44, i32** %40
	; store value
	%45 = load i32*, i32** %40
	%46 = bitcast i32* %45 to i32*
	%47 = add i32 %33, 0
	%48 = getelementptr i32, i32* %46, i32 %47
	store i32 11, i32* %48
	; add len
	%49 = add i32 %33, 1
	store i32 %49, i32* %41
	%50 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %37, i32 0, i32 1
	store i32 %43, i32* %50
	; append end-------------------------
	%51 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %37
	store { i32, i32, i32, i32* } %51, { i32, i32, i32, i32* }* %2
	%52 = call i8* @malloc(i32 20)
	%53 = bitcast i8* %52 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %53, i32 8)
	%54 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %53, i32 0, i32 0
	store i32 8, i32* %54
	%55 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %53, i32 0, i32 3
	%56 = load i8*, i8** %55
	%57 = bitcast i8* %56 to i8*
	%58 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %57, i8* %58, i32 8, i1 false)
	%59 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %53
	%60 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%61 = load i32, i32* %60
	%62 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %53, i32 0, i32 3
	%63 = load i8*, i8** %62
	%64 = call i32 (i8*, ...) @printf(i8* %63, i32 %61)
	; append start---------------------
	%65 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%66 = load i32*, i32** %65
	%67 = bitcast i32* %66 to i8*
	%68 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%69 = load i32, i32* %68
	%70 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%71 = load i32, i32* %70
	%72 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%73 = load i32, i32* %72
	%74 = call %return.5.0 @checkGrow(i8* %67, i32 %69, i32 %71, i32 %73, i32 1)
	%75 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%76 = load i32, i32* %75
	; copy and new slice
	%77 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%78 = load i32, i32* %77
	%79 = call i8* @malloc(i32 20)
	%80 = bitcast i8* %79 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %80, i32 %78)
	%81 = bitcast { i32, i32, i32, i32* }* %80 to i8*
	%82 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %81, i8* %82, i32 20, i1 false)
	; copy and end slice
	%83 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %80, i32 0, i32 3
	%84 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %80, i32 0, i32 0
	%85 = extractvalue %return.5.0 %74, 0
	%86 = extractvalue %return.5.0 %74, 1
	%87 = bitcast i8* %85 to i32*
	store i32* %87, i32** %83
	; store value
	%88 = load i32*, i32** %83
	%89 = bitcast i32* %88 to i32*
	%90 = add i32 %76, 0
	%91 = getelementptr i32, i32* %89, i32 %90
	store i32 12, i32* %91
	; add len
	%92 = add i32 %76, 1
	store i32 %92, i32* %84
	%93 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %80, i32 0, i32 1
	store i32 %86, i32* %93
	; append end-------------------------
	%94 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %80
	store { i32, i32, i32, i32* } %94, { i32, i32, i32, i32* }* %2
	%95 = call i8* @malloc(i32 20)
	%96 = bitcast i8* %95 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %96, i32 8)
	%97 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %96, i32 0, i32 0
	store i32 8, i32* %97
	%98 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %96, i32 0, i32 3
	%99 = load i8*, i8** %98
	%100 = bitcast i8* %99 to i8*
	%101 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %100, i8* %101, i32 8, i1 false)
	%102 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %96
	%103 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%104 = load i32, i32* %103
	%105 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %96, i32 0, i32 3
	%106 = load i8*, i8** %105
	%107 = call i32 (i8*, ...) @printf(i8* %106, i32 %104)
	%108 = call i8* @malloc(i32 20)
	%109 = bitcast i8* %108 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %109, i32 4)
	%110 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %109, i32 0, i32 0
	store i32 4, i32* %110
	%111 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %109, i32 0, i32 3
	%112 = load i8*, i8** %111
	%113 = bitcast i8* %112 to i8*
	%114 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %113, i8* %114, i32 4, i1 false)
	%115 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %109
	; get slice index
	%116 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%117 = load i32*, i32** %116
	%118 = getelementptr i32, i32* %117, i32 0
	%119 = load i32, i32* %118
	%120 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %109, i32 0, i32 3
	%121 = load i8*, i8** %120
	%122 = call i32 (i8*, ...) @printf(i8* %121, i32 %119)
	%123 = call i8* @malloc(i32 20)
	%124 = bitcast i8* %123 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %124, i32 4)
	%125 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %124, i32 0, i32 0
	store i32 4, i32* %125
	%126 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %124, i32 0, i32 3
	%127 = load i8*, i8** %126
	%128 = bitcast i8* %127 to i8*
	%129 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %128, i8* %129, i32 4, i1 false)
	%130 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %124
	; get slice index
	%131 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%132 = load i32*, i32** %131
	%133 = getelementptr i32, i32* %132, i32 1
	%134 = load i32, i32* %133
	%135 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %124, i32 0, i32 3
	%136 = load i8*, i8** %135
	%137 = call i32 (i8*, ...) @printf(i8* %136, i32 %134)
	%138 = call i8* @malloc(i32 20)
	%139 = bitcast i8* %138 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %139, i32 4)
	%140 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %139, i32 0, i32 0
	store i32 4, i32* %140
	%141 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %139, i32 0, i32 3
	%142 = load i8*, i8** %141
	%143 = bitcast i8* %142 to i8*
	%144 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %143, i8* %144, i32 4, i1 false)
	%145 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %139
	; get slice index
	%146 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%147 = load i32*, i32** %146
	%148 = getelementptr i32, i32* %147, i32 2
	%149 = load i32, i32* %148
	%150 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %139, i32 0, i32 3
	%151 = load i8*, i8** %150
	%152 = call i32 (i8*, ...) @printf(i8* %151, i32 %149)
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
	br i1 %15, label %16, label %63

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
	%48 = call i8* @malloc(i32 20)
	%49 = bitcast i8* %48 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %49, i32 15)
	%50 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %49, i32 0, i32 0
	store i32 15, i32* %50
	%51 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %49, i32 0, i32 3
	%52 = load i8*, i8** %51
	%53 = bitcast i8* %52 to i8*
	%54 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %53, i8* %54, i32 15, i1 false)
	%55 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %49
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%57 = load i32, i32* %56
	%58 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%59 = load i32, i32* %58
	%60 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %49, i32 0, i32 3
	%61 = load i8*, i8** %60
	%62 = call i32 (i8*, ...) @printf(i8* %61, i32 %57, i32 %59)
	; end block
	br label %10

; <label>:63
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
	br i1 %15, label %16, label %63

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
	%48 = call i8* @malloc(i32 20)
	%49 = bitcast i8* %48 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %49, i32 15)
	%50 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %49, i32 0, i32 0
	store i32 15, i32* %50
	%51 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %49, i32 0, i32 3
	%52 = load i8*, i8** %51
	%53 = bitcast i8* %52 to i8*
	%54 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %53, i8* %54, i32 15, i1 false)
	%55 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %49
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%57 = load i32, i32* %56
	%58 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%59 = load i32, i32* %58
	%60 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %49, i32 0, i32 3
	%61 = load i8*, i8** %60
	%62 = call i32 (i8*, ...) @printf(i8* %61, i32 %57, i32 %59)
	; end block
	br label %10

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
	br i1 %70, label %71, label %88

; <label>:71
	; block start
	%72 = call i8* @malloc(i32 20)
	%73 = bitcast i8* %72 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %73, i32 4)
	%74 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %73, i32 0, i32 0
	store i32 4, i32* %74
	%75 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %73, i32 0, i32 3
	%76 = load i8*, i8** %75
	%77 = bitcast i8* %76 to i8*
	%78 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %77, i8* %78, i32 4, i1 false)
	%79 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %73
	%80 = load i32, i32* %64
	; get slice index
	%81 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%82 = load i32*, i32** %81
	%83 = getelementptr i32, i32* %82, i32 %80
	%84 = load i32, i32* %83
	%85 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %73, i32 0, i32 3
	%86 = load i8*, i8** %85
	%87 = call i32 (i8*, ...) @printf(i8* %86, i32 %84)
	; end block
	br label %65

; <label>:88
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
	%39 = call i8* @malloc(i32 20)
	%40 = bitcast i8* %39 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %40, i32 6)
	%41 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %40, i32 0, i32 0
	store i32 6, i32* %41
	%42 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %40, i32 0, i32 3
	%43 = load i8*, i8** %42
	%44 = bitcast i8* %43 to i8*
	%45 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.9, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %44, i8* %45, i32 6, i1 false)
	%46 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %40
	; get slice index
	%47 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 3
	%48 = load float*, float** %47
	%49 = getelementptr float, float* %48, i32 3
	%50 = load float, float* %49
	%51 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %40, i32 0, i32 3
	%52 = load i8*, i8** %51
	%53 = call i32 (i8*, ...) @printf(i8* %52, float %50)
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

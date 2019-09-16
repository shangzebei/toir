%return.5.0 = type { i8*, i32 }

@main.0 = constant [3 x i32] [i32 1, i32 2, i32 8]
@str.0 = constant [30 x i8] c"a = len(%d) cap(%d) %d %d %d\0A\00"
@str.1 = constant [33 x i8] c"a = len(%d) cap(%d) %d %d %d %d\0A\00"
@str.2 = constant [36 x i8] c"a = len(%d) cap(%d) %d %d %d %d %d\0A\00"
@str.3 = constant [39 x i8] c"b = len(%d) cap(%d) %d %d %d %d %d %d\0A\00"
@str.4 = constant [39 x i8] c"a = len(%d) cap(%d) %d %d %d %d %d %d\0A\00"
@str.5 = constant [42 x i8] c"b = len(%d) cap(%d) %d %d %d %d %d %d %d\0A\00"

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

define void @main() {
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
	%7 = bitcast [3 x i32]* @main.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 12, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call i8* @malloc(i32 20)
	%10 = bitcast i8* %9 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %10, i32 30)
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 0
	store i32 30, i32* %11
	%12 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([30 x i8], [30 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 30, i1 false)
	%16 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%18 = load i32, i32* %17
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%20 = load i32, i32* %19
	; get slice index
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%22 = load i32*, i32** %21
	%23 = getelementptr i32, i32* %22, i32 0
	%24 = load i32, i32* %23
	; get slice index
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%26 = load i32*, i32** %25
	%27 = getelementptr i32, i32* %26, i32 1
	%28 = load i32, i32* %27
	; get slice index
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%30 = load i32*, i32** %29
	%31 = getelementptr i32, i32* %30, i32 2
	%32 = load i32, i32* %31
	%33 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%34 = load i8*, i8** %33
	%35 = call i32 (i8*, ...) @printf(i8* %34, i32 %18, i32 %20, i32 %24, i32 %28, i32 %32)
	; append start---------------------
	%36 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%37 = load i32*, i32** %36
	%38 = bitcast i32* %37 to i8*
	%39 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%40 = load i32, i32* %39
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%42 = load i32, i32* %41
	%43 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%44 = load i32, i32* %43
	%45 = call %return.5.0 @checkGrow(i8* %38, i32 %40, i32 %42, i32 %44, i32 1)
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%47 = load i32, i32* %46
	; copy and new slice
	%48 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%49 = load i32, i32* %48
	%50 = call i8* @malloc(i32 20)
	%51 = bitcast i8* %50 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %51, i32 %49)
	%52 = bitcast { i32, i32, i32, i32* }* %51 to i8*
	%53 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %52, i8* %53, i32 20, i1 false)
	; copy and end slice
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %51, i32 0, i32 3
	%55 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %51, i32 0, i32 0
	%56 = extractvalue %return.5.0 %45, 0
	%57 = extractvalue %return.5.0 %45, 1
	%58 = bitcast i8* %56 to i32*
	store i32* %58, i32** %54
	; store value
	%59 = load i32*, i32** %54
	%60 = bitcast i32* %59 to i32*
	%61 = add i32 %47, 0
	%62 = getelementptr i32, i32* %60, i32 %61
	store i32 4, i32* %62
	; add len
	%63 = add i32 %47, 1
	store i32 %63, i32* %55
	%64 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %51, i32 0, i32 1
	store i32 %57, i32* %64
	; append end-------------------------
	%65 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %51
	store { i32, i32, i32, i32* } %65, { i32, i32, i32, i32* }* %2
	%66 = call i8* @malloc(i32 20)
	%67 = bitcast i8* %66 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %67, i32 33)
	%68 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %67, i32 0, i32 0
	store i32 33, i32* %68
	%69 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %67, i32 0, i32 3
	%70 = load i8*, i8** %69
	%71 = bitcast i8* %70 to i8*
	%72 = bitcast i8* getelementptr inbounds ([33 x i8], [33 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %71, i8* %72, i32 33, i1 false)
	%73 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %67
	%74 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%75 = load i32, i32* %74
	%76 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%77 = load i32, i32* %76
	; get slice index
	%78 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%79 = load i32*, i32** %78
	%80 = getelementptr i32, i32* %79, i32 0
	%81 = load i32, i32* %80
	; get slice index
	%82 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%83 = load i32*, i32** %82
	%84 = getelementptr i32, i32* %83, i32 1
	%85 = load i32, i32* %84
	; get slice index
	%86 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%87 = load i32*, i32** %86
	%88 = getelementptr i32, i32* %87, i32 2
	%89 = load i32, i32* %88
	; get slice index
	%90 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%91 = load i32*, i32** %90
	%92 = getelementptr i32, i32* %91, i32 3
	%93 = load i32, i32* %92
	%94 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %67, i32 0, i32 3
	%95 = load i8*, i8** %94
	%96 = call i32 (i8*, ...) @printf(i8* %95, i32 %75, i32 %77, i32 %81, i32 %85, i32 %89, i32 %93)
	; append start---------------------
	%97 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%98 = load i32*, i32** %97
	%99 = bitcast i32* %98 to i8*
	%100 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%101 = load i32, i32* %100
	%102 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%103 = load i32, i32* %102
	%104 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%105 = load i32, i32* %104
	%106 = call %return.5.0 @checkGrow(i8* %99, i32 %101, i32 %103, i32 %105, i32 1)
	%107 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%108 = load i32, i32* %107
	; copy and new slice
	%109 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%110 = load i32, i32* %109
	%111 = call i8* @malloc(i32 20)
	%112 = bitcast i8* %111 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %112, i32 %110)
	%113 = bitcast { i32, i32, i32, i32* }* %112 to i8*
	%114 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %113, i8* %114, i32 20, i1 false)
	; copy and end slice
	%115 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %112, i32 0, i32 3
	%116 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %112, i32 0, i32 0
	%117 = extractvalue %return.5.0 %106, 0
	%118 = extractvalue %return.5.0 %106, 1
	%119 = bitcast i8* %117 to i32*
	store i32* %119, i32** %115
	; store value
	%120 = load i32*, i32** %115
	%121 = bitcast i32* %120 to i32*
	%122 = add i32 %108, 0
	%123 = getelementptr i32, i32* %121, i32 %122
	store i32 5000, i32* %123
	; add len
	%124 = add i32 %108, 1
	store i32 %124, i32* %116
	%125 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %112, i32 0, i32 1
	store i32 %118, i32* %125
	; append end-------------------------
	%126 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %112
	store { i32, i32, i32, i32* } %126, { i32, i32, i32, i32* }* %2
	%127 = call i8* @malloc(i32 20)
	%128 = bitcast i8* %127 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %128, i32 36)
	%129 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %128, i32 0, i32 0
	store i32 36, i32* %129
	%130 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %128, i32 0, i32 3
	%131 = load i8*, i8** %130
	%132 = bitcast i8* %131 to i8*
	%133 = bitcast i8* getelementptr inbounds ([36 x i8], [36 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %132, i8* %133, i32 36, i1 false)
	%134 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %128
	%135 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%136 = load i32, i32* %135
	%137 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%138 = load i32, i32* %137
	; get slice index
	%139 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%140 = load i32*, i32** %139
	%141 = getelementptr i32, i32* %140, i32 0
	%142 = load i32, i32* %141
	; get slice index
	%143 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%144 = load i32*, i32** %143
	%145 = getelementptr i32, i32* %144, i32 1
	%146 = load i32, i32* %145
	; get slice index
	%147 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%148 = load i32*, i32** %147
	%149 = getelementptr i32, i32* %148, i32 2
	%150 = load i32, i32* %149
	; get slice index
	%151 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%152 = load i32*, i32** %151
	%153 = getelementptr i32, i32* %152, i32 3
	%154 = load i32, i32* %153
	; get slice index
	%155 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%156 = load i32*, i32** %155
	%157 = getelementptr i32, i32* %156, i32 4
	%158 = load i32, i32* %157
	%159 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %128, i32 0, i32 3
	%160 = load i8*, i8** %159
	%161 = call i32 (i8*, ...) @printf(i8* %160, i32 %136, i32 %138, i32 %142, i32 %146, i32 %150, i32 %154, i32 %158)
	; append start---------------------
	%162 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%163 = load i32*, i32** %162
	%164 = bitcast i32* %163 to i8*
	%165 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%166 = load i32, i32* %165
	%167 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%168 = load i32, i32* %167
	%169 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%170 = load i32, i32* %169
	%171 = call %return.5.0 @checkGrow(i8* %164, i32 %166, i32 %168, i32 %170, i32 1)
	%172 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%173 = load i32, i32* %172
	; copy and new slice
	%174 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%175 = load i32, i32* %174
	%176 = call i8* @malloc(i32 20)
	%177 = bitcast i8* %176 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %177, i32 %175)
	%178 = bitcast { i32, i32, i32, i32* }* %177 to i8*
	%179 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %178, i8* %179, i32 20, i1 false)
	; copy and end slice
	%180 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%181 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 0
	%182 = extractvalue %return.5.0 %171, 0
	%183 = extractvalue %return.5.0 %171, 1
	%184 = bitcast i8* %182 to i32*
	store i32* %184, i32** %180
	; store value
	%185 = load i32*, i32** %180
	%186 = bitcast i32* %185 to i32*
	%187 = add i32 %173, 0
	%188 = getelementptr i32, i32* %186, i32 %187
	store i32 6000, i32* %188
	; add len
	%189 = add i32 %173, 1
	store i32 %189, i32* %181
	%190 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 1
	store i32 %183, i32* %190
	; append end-------------------------
	%191 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177
	%192 = call i8* @malloc(i32 20)
	%193 = bitcast i8* %192 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %193, i32 39)
	%194 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %193, i32 0, i32 0
	store i32 39, i32* %194
	%195 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %193, i32 0, i32 3
	%196 = load i8*, i8** %195
	%197 = bitcast i8* %196 to i8*
	%198 = bitcast i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %197, i8* %198, i32 39, i1 false)
	%199 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %193
	%200 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 0
	%201 = load i32, i32* %200
	%202 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 1
	%203 = load i32, i32* %202
	; get slice index
	%204 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%205 = load i32*, i32** %204
	%206 = getelementptr i32, i32* %205, i32 0
	%207 = load i32, i32* %206
	; get slice index
	%208 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%209 = load i32*, i32** %208
	%210 = getelementptr i32, i32* %209, i32 1
	%211 = load i32, i32* %210
	; get slice index
	%212 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%213 = load i32*, i32** %212
	%214 = getelementptr i32, i32* %213, i32 2
	%215 = load i32, i32* %214
	; get slice index
	%216 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%217 = load i32*, i32** %216
	%218 = getelementptr i32, i32* %217, i32 3
	%219 = load i32, i32* %218
	; get slice index
	%220 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%221 = load i32*, i32** %220
	%222 = getelementptr i32, i32* %221, i32 4
	%223 = load i32, i32* %222
	; get slice index
	%224 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%225 = load i32*, i32** %224
	%226 = getelementptr i32, i32* %225, i32 5
	%227 = load i32, i32* %226
	%228 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %193, i32 0, i32 3
	%229 = load i8*, i8** %228
	%230 = call i32 (i8*, ...) @printf(i8* %229, i32 %201, i32 %203, i32 %207, i32 %211, i32 %215, i32 %219, i32 %223, i32 %227)
	; append start---------------------
	%231 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%232 = load i32*, i32** %231
	%233 = bitcast i32* %232 to i8*
	%234 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%235 = load i32, i32* %234
	%236 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%237 = load i32, i32* %236
	%238 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%239 = load i32, i32* %238
	%240 = call %return.5.0 @checkGrow(i8* %233, i32 %235, i32 %237, i32 %239, i32 1)
	%241 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%242 = load i32, i32* %241
	; copy and new slice
	%243 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%244 = load i32, i32* %243
	%245 = call i8* @malloc(i32 20)
	%246 = bitcast i8* %245 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %246, i32 %244)
	%247 = bitcast { i32, i32, i32, i32* }* %246 to i8*
	%248 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %247, i8* %248, i32 20, i1 false)
	; copy and end slice
	%249 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %246, i32 0, i32 3
	%250 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %246, i32 0, i32 0
	%251 = extractvalue %return.5.0 %240, 0
	%252 = extractvalue %return.5.0 %240, 1
	%253 = bitcast i8* %251 to i32*
	store i32* %253, i32** %249
	; store value
	%254 = load i32*, i32** %249
	%255 = bitcast i32* %254 to i32*
	%256 = add i32 %242, 0
	%257 = getelementptr i32, i32* %255, i32 %256
	store i32 7000, i32* %257
	; add len
	%258 = add i32 %242, 1
	store i32 %258, i32* %250
	%259 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %246, i32 0, i32 1
	store i32 %252, i32* %259
	; append end-------------------------
	%260 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %246
	store { i32, i32, i32, i32* } %260, { i32, i32, i32, i32* }* %2
	%261 = call i8* @malloc(i32 20)
	%262 = bitcast i8* %261 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %262, i32 39)
	%263 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %262, i32 0, i32 0
	store i32 39, i32* %263
	%264 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %262, i32 0, i32 3
	%265 = load i8*, i8** %264
	%266 = bitcast i8* %265 to i8*
	%267 = bitcast i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %266, i8* %267, i32 39, i1 false)
	%268 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %262
	%269 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%270 = load i32, i32* %269
	%271 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%272 = load i32, i32* %271
	; get slice index
	%273 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%274 = load i32*, i32** %273
	%275 = getelementptr i32, i32* %274, i32 0
	%276 = load i32, i32* %275
	; get slice index
	%277 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%278 = load i32*, i32** %277
	%279 = getelementptr i32, i32* %278, i32 1
	%280 = load i32, i32* %279
	; get slice index
	%281 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%282 = load i32*, i32** %281
	%283 = getelementptr i32, i32* %282, i32 2
	%284 = load i32, i32* %283
	; get slice index
	%285 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%286 = load i32*, i32** %285
	%287 = getelementptr i32, i32* %286, i32 3
	%288 = load i32, i32* %287
	; get slice index
	%289 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%290 = load i32*, i32** %289
	%291 = getelementptr i32, i32* %290, i32 4
	%292 = load i32, i32* %291
	; get slice index
	%293 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%294 = load i32*, i32** %293
	%295 = getelementptr i32, i32* %294, i32 5
	%296 = load i32, i32* %295
	%297 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %262, i32 0, i32 3
	%298 = load i8*, i8** %297
	%299 = call i32 (i8*, ...) @printf(i8* %298, i32 %270, i32 %272, i32 %276, i32 %280, i32 %284, i32 %288, i32 %292, i32 %296)
	; append start---------------------
	%300 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%301 = load i32*, i32** %300
	%302 = bitcast i32* %301 to i8*
	%303 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 0
	%304 = load i32, i32* %303
	%305 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 1
	%306 = load i32, i32* %305
	%307 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 2
	%308 = load i32, i32* %307
	%309 = call %return.5.0 @checkGrow(i8* %302, i32 %304, i32 %306, i32 %308, i32 1)
	%310 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 0
	%311 = load i32, i32* %310
	; copy and new slice
	%312 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 0
	%313 = load i32, i32* %312
	%314 = call i8* @malloc(i32 20)
	%315 = bitcast i8* %314 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %315, i32 %313)
	%316 = bitcast { i32, i32, i32, i32* }* %315 to i8*
	%317 = bitcast { i32, i32, i32, i32* }* %177 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %316, i8* %317, i32 20, i1 false)
	; copy and end slice
	%318 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %315, i32 0, i32 3
	%319 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %315, i32 0, i32 0
	%320 = extractvalue %return.5.0 %309, 0
	%321 = extractvalue %return.5.0 %309, 1
	%322 = bitcast i8* %320 to i32*
	store i32* %322, i32** %318
	; store value
	%323 = load i32*, i32** %318
	%324 = bitcast i32* %323 to i32*
	%325 = add i32 %311, 0
	%326 = getelementptr i32, i32* %324, i32 %325
	store i32 8000, i32* %326
	; add len
	%327 = add i32 %311, 1
	store i32 %327, i32* %319
	%328 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %315, i32 0, i32 1
	store i32 %321, i32* %328
	; append end-------------------------
	%329 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %315
	store { i32, i32, i32, i32* } %329, { i32, i32, i32, i32* }* %177
	%330 = call i8* @malloc(i32 20)
	%331 = bitcast i8* %330 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %331, i32 42)
	%332 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %331, i32 0, i32 0
	store i32 42, i32* %332
	%333 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %331, i32 0, i32 3
	%334 = load i8*, i8** %333
	%335 = bitcast i8* %334 to i8*
	%336 = bitcast i8* getelementptr inbounds ([42 x i8], [42 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %335, i8* %336, i32 42, i1 false)
	%337 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %331
	%338 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 0
	%339 = load i32, i32* %338
	%340 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 1
	%341 = load i32, i32* %340
	; get slice index
	%342 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%343 = load i32*, i32** %342
	%344 = getelementptr i32, i32* %343, i32 0
	%345 = load i32, i32* %344
	; get slice index
	%346 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%347 = load i32*, i32** %346
	%348 = getelementptr i32, i32* %347, i32 1
	%349 = load i32, i32* %348
	; get slice index
	%350 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%351 = load i32*, i32** %350
	%352 = getelementptr i32, i32* %351, i32 2
	%353 = load i32, i32* %352
	; get slice index
	%354 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%355 = load i32*, i32** %354
	%356 = getelementptr i32, i32* %355, i32 3
	%357 = load i32, i32* %356
	; get slice index
	%358 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%359 = load i32*, i32** %358
	%360 = getelementptr i32, i32* %359, i32 4
	%361 = load i32, i32* %360
	; get slice index
	%362 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%363 = load i32*, i32** %362
	%364 = getelementptr i32, i32* %363, i32 5
	%365 = load i32, i32* %364
	; get slice index
	%366 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %177, i32 0, i32 3
	%367 = load i32*, i32** %366
	%368 = getelementptr i32, i32* %367, i32 6
	%369 = load i32, i32* %368
	%370 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %331, i32 0, i32 3
	%371 = load i8*, i8** %370
	%372 = call i32 (i8*, ...) @printf(i8* %371, i32 %339, i32 %341, i32 %345, i32 %349, i32 %353, i32 %357, i32 %361, i32 %365, i32 %369)
	; end block
	ret void
}

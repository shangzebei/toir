%return.4.0 = type { i8*, i32 }

@main.0 = constant [3 x i32] [i32 1, i32 2, i32 8]
@str.0 = constant [30 x i8] c"a = len(%d) cap(%d) %d %d %d\0A\00"
@str.1 = constant [33 x i8] c"a = len(%d) cap(%d) %d %d %d %d\0A\00"
@str.2 = constant [36 x i8] c"a = len(%d) cap(%d) %d %d %d %d %d\0A\00"
@str.3 = constant [39 x i8] c"b = len(%d) cap(%d) %d %d %d %d %d %d\0A\00"
@str.4 = constant [39 x i8] c"a = len(%d) cap(%d) %d %d %d %d %d %d\0A\00"
@str.5 = constant [42 x i8] c"b = len(%d) cap(%d) %d %d %d %d %d %d %d\0A\00"

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
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%11 = load i32, i32* %10
	; get slice index
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%13 = load i32*, i32** %12
	%14 = getelementptr i32, i32* %13, i32 0
	%15 = load i32, i32* %14
	; get slice index
	%16 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%17 = load i32*, i32** %16
	%18 = getelementptr i32, i32* %17, i32 1
	%19 = load i32, i32* %18
	; get slice index
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%21 = load i32*, i32** %20
	%22 = getelementptr i32, i32* %21, i32 2
	%23 = load i32, i32* %22
	%24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([30 x i8], [30 x i8]* @str.0, i64 0, i64 0), i32 %9, i32 %11, i32 %15, i32 %19, i32 %23)
	; append start---------------------
	%25 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%26 = load i32*, i32** %25
	%27 = bitcast i32* %26 to i8*
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%29 = load i32, i32* %28
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%31 = load i32, i32* %30
	%32 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%33 = load i32, i32* %32
	%34 = call %return.4.0 @checkGrow(i8* %27, i32 %29, i32 %31, i32 %33, i32 1)
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%36 = load i32, i32* %35
	; copy and new slice
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%38 = load i32, i32* %37
	%39 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %38)
	%40 = bitcast { i32, i32, i32, i32* }* %39 to i8*
	%41 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %40, i8* %41, i32 20, i1 false)
	; copy and end slice
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %39, i32 0, i32 3
	%43 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %39, i32 0, i32 0
	%44 = extractvalue %return.4.0 %34, 0
	%45 = extractvalue %return.4.0 %34, 1
	%46 = bitcast i8* %44 to i32*
	store i32* %46, i32** %42
	; store value
	%47 = load i32*, i32** %42
	%48 = bitcast i32* %47 to i32*
	%49 = add i32 %36, 0
	%50 = getelementptr i32, i32* %48, i32 %49
	store i32 4, i32* %50
	; add len
	%51 = add i32 %36, 1
	store i32 %51, i32* %43
	%52 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %39, i32 0, i32 1
	store i32 %45, i32* %52
	; append end-------------------------
	%53 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %39
	store { i32, i32, i32, i32* } %53, { i32, i32, i32, i32* }* %1
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%55 = load i32, i32* %54
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%57 = load i32, i32* %56
	; get slice index
	%58 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%59 = load i32*, i32** %58
	%60 = getelementptr i32, i32* %59, i32 0
	%61 = load i32, i32* %60
	; get slice index
	%62 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%63 = load i32*, i32** %62
	%64 = getelementptr i32, i32* %63, i32 1
	%65 = load i32, i32* %64
	; get slice index
	%66 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%67 = load i32*, i32** %66
	%68 = getelementptr i32, i32* %67, i32 2
	%69 = load i32, i32* %68
	; get slice index
	%70 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%71 = load i32*, i32** %70
	%72 = getelementptr i32, i32* %71, i32 3
	%73 = load i32, i32* %72
	%74 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @str.1, i64 0, i64 0), i32 %55, i32 %57, i32 %61, i32 %65, i32 %69, i32 %73)
	; append start---------------------
	%75 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%76 = load i32*, i32** %75
	%77 = bitcast i32* %76 to i8*
	%78 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%79 = load i32, i32* %78
	%80 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%81 = load i32, i32* %80
	%82 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%83 = load i32, i32* %82
	%84 = call %return.4.0 @checkGrow(i8* %77, i32 %79, i32 %81, i32 %83, i32 1)
	%85 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%86 = load i32, i32* %85
	; copy and new slice
	%87 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%88 = load i32, i32* %87
	%89 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %88)
	%90 = bitcast { i32, i32, i32, i32* }* %89 to i8*
	%91 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %90, i8* %91, i32 20, i1 false)
	; copy and end slice
	%92 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %89, i32 0, i32 3
	%93 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %89, i32 0, i32 0
	%94 = extractvalue %return.4.0 %84, 0
	%95 = extractvalue %return.4.0 %84, 1
	%96 = bitcast i8* %94 to i32*
	store i32* %96, i32** %92
	; store value
	%97 = load i32*, i32** %92
	%98 = bitcast i32* %97 to i32*
	%99 = add i32 %86, 0
	%100 = getelementptr i32, i32* %98, i32 %99
	store i32 5000, i32* %100
	; add len
	%101 = add i32 %86, 1
	store i32 %101, i32* %93
	%102 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %89, i32 0, i32 1
	store i32 %95, i32* %102
	; append end-------------------------
	%103 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %89
	store { i32, i32, i32, i32* } %103, { i32, i32, i32, i32* }* %1
	%104 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%105 = load i32, i32* %104
	%106 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%107 = load i32, i32* %106
	; get slice index
	%108 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%109 = load i32*, i32** %108
	%110 = getelementptr i32, i32* %109, i32 0
	%111 = load i32, i32* %110
	; get slice index
	%112 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%113 = load i32*, i32** %112
	%114 = getelementptr i32, i32* %113, i32 1
	%115 = load i32, i32* %114
	; get slice index
	%116 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%117 = load i32*, i32** %116
	%118 = getelementptr i32, i32* %117, i32 2
	%119 = load i32, i32* %118
	; get slice index
	%120 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%121 = load i32*, i32** %120
	%122 = getelementptr i32, i32* %121, i32 3
	%123 = load i32, i32* %122
	; get slice index
	%124 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%125 = load i32*, i32** %124
	%126 = getelementptr i32, i32* %125, i32 4
	%127 = load i32, i32* %126
	%128 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([36 x i8], [36 x i8]* @str.2, i64 0, i64 0), i32 %105, i32 %107, i32 %111, i32 %115, i32 %119, i32 %123, i32 %127)
	; append start---------------------
	%129 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%130 = load i32*, i32** %129
	%131 = bitcast i32* %130 to i8*
	%132 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%133 = load i32, i32* %132
	%134 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%135 = load i32, i32* %134
	%136 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%137 = load i32, i32* %136
	%138 = call %return.4.0 @checkGrow(i8* %131, i32 %133, i32 %135, i32 %137, i32 1)
	%139 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%140 = load i32, i32* %139
	; copy and new slice
	%141 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%142 = load i32, i32* %141
	%143 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %142)
	%144 = bitcast { i32, i32, i32, i32* }* %143 to i8*
	%145 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %144, i8* %145, i32 20, i1 false)
	; copy and end slice
	%146 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%147 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 0
	%148 = extractvalue %return.4.0 %138, 0
	%149 = extractvalue %return.4.0 %138, 1
	%150 = bitcast i8* %148 to i32*
	store i32* %150, i32** %146
	; store value
	%151 = load i32*, i32** %146
	%152 = bitcast i32* %151 to i32*
	%153 = add i32 %140, 0
	%154 = getelementptr i32, i32* %152, i32 %153
	store i32 6000, i32* %154
	; add len
	%155 = add i32 %140, 1
	store i32 %155, i32* %147
	%156 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 1
	store i32 %149, i32* %156
	; append end-------------------------
	%157 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143
	%158 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 0
	%159 = load i32, i32* %158
	%160 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 1
	%161 = load i32, i32* %160
	; get slice index
	%162 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%163 = load i32*, i32** %162
	%164 = getelementptr i32, i32* %163, i32 0
	%165 = load i32, i32* %164
	; get slice index
	%166 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%167 = load i32*, i32** %166
	%168 = getelementptr i32, i32* %167, i32 1
	%169 = load i32, i32* %168
	; get slice index
	%170 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%171 = load i32*, i32** %170
	%172 = getelementptr i32, i32* %171, i32 2
	%173 = load i32, i32* %172
	; get slice index
	%174 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%175 = load i32*, i32** %174
	%176 = getelementptr i32, i32* %175, i32 3
	%177 = load i32, i32* %176
	; get slice index
	%178 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%179 = load i32*, i32** %178
	%180 = getelementptr i32, i32* %179, i32 4
	%181 = load i32, i32* %180
	; get slice index
	%182 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%183 = load i32*, i32** %182
	%184 = getelementptr i32, i32* %183, i32 5
	%185 = load i32, i32* %184
	%186 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.3, i64 0, i64 0), i32 %159, i32 %161, i32 %165, i32 %169, i32 %173, i32 %177, i32 %181, i32 %185)
	; append start---------------------
	%187 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%188 = load i32*, i32** %187
	%189 = bitcast i32* %188 to i8*
	%190 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%191 = load i32, i32* %190
	%192 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%193 = load i32, i32* %192
	%194 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 2
	%195 = load i32, i32* %194
	%196 = call %return.4.0 @checkGrow(i8* %189, i32 %191, i32 %193, i32 %195, i32 1)
	%197 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%198 = load i32, i32* %197
	; copy and new slice
	%199 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%200 = load i32, i32* %199
	%201 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %200)
	%202 = bitcast { i32, i32, i32, i32* }* %201 to i8*
	%203 = bitcast { i32, i32, i32, i32* }* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %202, i8* %203, i32 20, i1 false)
	; copy and end slice
	%204 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %201, i32 0, i32 3
	%205 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %201, i32 0, i32 0
	%206 = extractvalue %return.4.0 %196, 0
	%207 = extractvalue %return.4.0 %196, 1
	%208 = bitcast i8* %206 to i32*
	store i32* %208, i32** %204
	; store value
	%209 = load i32*, i32** %204
	%210 = bitcast i32* %209 to i32*
	%211 = add i32 %198, 0
	%212 = getelementptr i32, i32* %210, i32 %211
	store i32 7000, i32* %212
	; add len
	%213 = add i32 %198, 1
	store i32 %213, i32* %205
	%214 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %201, i32 0, i32 1
	store i32 %207, i32* %214
	; append end-------------------------
	%215 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %201
	store { i32, i32, i32, i32* } %215, { i32, i32, i32, i32* }* %1
	%216 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 0
	%217 = load i32, i32* %216
	%218 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 1
	%219 = load i32, i32* %218
	; get slice index
	%220 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%221 = load i32*, i32** %220
	%222 = getelementptr i32, i32* %221, i32 0
	%223 = load i32, i32* %222
	; get slice index
	%224 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%225 = load i32*, i32** %224
	%226 = getelementptr i32, i32* %225, i32 1
	%227 = load i32, i32* %226
	; get slice index
	%228 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%229 = load i32*, i32** %228
	%230 = getelementptr i32, i32* %229, i32 2
	%231 = load i32, i32* %230
	; get slice index
	%232 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%233 = load i32*, i32** %232
	%234 = getelementptr i32, i32* %233, i32 3
	%235 = load i32, i32* %234
	; get slice index
	%236 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%237 = load i32*, i32** %236
	%238 = getelementptr i32, i32* %237, i32 4
	%239 = load i32, i32* %238
	; get slice index
	%240 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %1, i32 0, i32 3
	%241 = load i32*, i32** %240
	%242 = getelementptr i32, i32* %241, i32 5
	%243 = load i32, i32* %242
	%244 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.4, i64 0, i64 0), i32 %217, i32 %219, i32 %223, i32 %227, i32 %231, i32 %235, i32 %239, i32 %243)
	; append start---------------------
	%245 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%246 = load i32*, i32** %245
	%247 = bitcast i32* %246 to i8*
	%248 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 0
	%249 = load i32, i32* %248
	%250 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 1
	%251 = load i32, i32* %250
	%252 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 2
	%253 = load i32, i32* %252
	%254 = call %return.4.0 @checkGrow(i8* %247, i32 %249, i32 %251, i32 %253, i32 1)
	%255 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 0
	%256 = load i32, i32* %255
	; copy and new slice
	%257 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 0
	%258 = load i32, i32* %257
	%259 = call { i32, i32, i32, i32* }* @init_slice_i32(i32 %258)
	%260 = bitcast { i32, i32, i32, i32* }* %259 to i8*
	%261 = bitcast { i32, i32, i32, i32* }* %143 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %260, i8* %261, i32 20, i1 false)
	; copy and end slice
	%262 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %259, i32 0, i32 3
	%263 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %259, i32 0, i32 0
	%264 = extractvalue %return.4.0 %254, 0
	%265 = extractvalue %return.4.0 %254, 1
	%266 = bitcast i8* %264 to i32*
	store i32* %266, i32** %262
	; store value
	%267 = load i32*, i32** %262
	%268 = bitcast i32* %267 to i32*
	%269 = add i32 %256, 0
	%270 = getelementptr i32, i32* %268, i32 %269
	store i32 8000, i32* %270
	; add len
	%271 = add i32 %256, 1
	store i32 %271, i32* %263
	%272 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %259, i32 0, i32 1
	store i32 %265, i32* %272
	; append end-------------------------
	%273 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %259
	store { i32, i32, i32, i32* } %273, { i32, i32, i32, i32* }* %143
	%274 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 0
	%275 = load i32, i32* %274
	%276 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 1
	%277 = load i32, i32* %276
	; get slice index
	%278 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%279 = load i32*, i32** %278
	%280 = getelementptr i32, i32* %279, i32 0
	%281 = load i32, i32* %280
	; get slice index
	%282 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%283 = load i32*, i32** %282
	%284 = getelementptr i32, i32* %283, i32 1
	%285 = load i32, i32* %284
	; get slice index
	%286 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%287 = load i32*, i32** %286
	%288 = getelementptr i32, i32* %287, i32 2
	%289 = load i32, i32* %288
	; get slice index
	%290 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%291 = load i32*, i32** %290
	%292 = getelementptr i32, i32* %291, i32 3
	%293 = load i32, i32* %292
	; get slice index
	%294 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%295 = load i32*, i32** %294
	%296 = getelementptr i32, i32* %295, i32 4
	%297 = load i32, i32* %296
	; get slice index
	%298 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%299 = load i32*, i32** %298
	%300 = getelementptr i32, i32* %299, i32 5
	%301 = load i32, i32* %300
	; get slice index
	%302 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %143, i32 0, i32 3
	%303 = load i32*, i32** %302
	%304 = getelementptr i32, i32* %303, i32 6
	%305 = load i32, i32* %304
	%306 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @str.5, i64 0, i64 0), i32 %275, i32 %277, i32 %281, i32 %285, i32 %289, i32 %293, i32 %297, i32 %301, i32 %305)
	ret void
}

%return.3.0 = type { i8*, i32 }

@main.0 = constant [3 x i32] [i32 1, i32 2, i32 8]
@str.0 = constant [30 x i8] c"a = len(%d) cap(%d) %d %d %d\0A\00"
@str.1 = constant [33 x i8] c"a = len(%d) cap(%d) %d %d %d %d\0A\00"
@str.2 = constant [36 x i8] c"a = len(%d) cap(%d) %d %d %d %d %d\0A\00"
@str.3 = constant [39 x i8] c"b = len(%d) cap(%d) %d %d %d %d %d %d\0A\00"
@str.4 = constant [39 x i8] c"a = len(%d) cap(%d) %d %d %d %d %d %d\0A\00"
@str.5 = constant [42 x i8] c"b = len(%d) cap(%d) %d %d %d %d %d %d %d\0A\00"

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
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%17 = load i32, i32* %16
	; get slice index
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%19 = load i32*, i32** %18
	%20 = getelementptr i32, i32* %19, i32 0
	%21 = load i32, i32* %20
	; get slice index
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%23 = load i32*, i32** %22
	%24 = getelementptr i32, i32* %23, i32 1
	%25 = load i32, i32* %24
	; get slice index
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%27 = load i32*, i32** %26
	%28 = getelementptr i32, i32* %27, i32 2
	%29 = load i32, i32* %28
	%30 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([30 x i8], [30 x i8]* @str.0, i64 0, i64 0), i32 %15, i32 %17, i32 %21, i32 %25, i32 %29)
	; append start---------------------
	%31 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%32 = load i32*, i32** %31
	%33 = bitcast i32* %32 to i8*
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%35 = load i32, i32* %34
	%36 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%37 = load i32, i32* %36
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%39 = load i32, i32* %38
	%40 = call %return.3.0 @checkGrow(i8* %33, i32 %35, i32 %37, i32 %39, i32 1)
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%42 = load i32, i32* %41
	; copy and new slice
	%43 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%44 = load i32, i32* %43
	; init slice...............
	%array.62 = alloca { i32, i32, i32, i32* }
	%45 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.62, i32 0, i32 2
	store i32 4, i32* %45
	%46 = mul i32 %44, 4
	%47 = call i8* @malloc(i32 %46)
	%48 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.62, i32 0, i32 3
	%49 = bitcast i8* %47 to i32*
	store i32* %49, i32** %48
	%50 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.62, i32 0, i32 1
	store i32 %44, i32* %50
	%51 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.62, i32 0, i32 0
	store i32 %44, i32* %51
	; end init slice.................
	%52 = bitcast { i32, i32, i32, i32* }* %array.62 to i8*
	%53 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %52, i8* %53, i32 20, i1 false)
	; copy and end slice
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.62, i32 0, i32 3
	%55 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.62, i32 0, i32 0
	%56 = extractvalue %return.3.0 %40, 0
	%57 = extractvalue %return.3.0 %40, 1
	%58 = bitcast i8* %56 to i32*
	store i32* %58, i32** %54
	; store value
	%59 = load i32*, i32** %54
	%60 = bitcast i32* %59 to i32*
	%61 = add i32 %42, 0
	%62 = getelementptr i32, i32* %60, i32 %61
	store i32 4, i32* %62
	; add len
	%63 = add i32 %42, 1
	store i32 %63, i32* %55
	%64 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.62, i32 0, i32 1
	store i32 %57, i32* %64
	; append end-------------------------
	%65 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.62
	store { i32, i32, i32, i32* } %65, { i32, i32, i32, i32* }* %array.4
	%66 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%67 = load i32, i32* %66
	%68 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%69 = load i32, i32* %68
	; get slice index
	%70 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%71 = load i32*, i32** %70
	%72 = getelementptr i32, i32* %71, i32 0
	%73 = load i32, i32* %72
	; get slice index
	%74 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%75 = load i32*, i32** %74
	%76 = getelementptr i32, i32* %75, i32 1
	%77 = load i32, i32* %76
	; get slice index
	%78 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%79 = load i32*, i32** %78
	%80 = getelementptr i32, i32* %79, i32 2
	%81 = load i32, i32* %80
	; get slice index
	%82 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%83 = load i32*, i32** %82
	%84 = getelementptr i32, i32* %83, i32 3
	%85 = load i32, i32* %84
	%86 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @str.1, i64 0, i64 0), i32 %67, i32 %69, i32 %73, i32 %77, i32 %81, i32 %85)
	; append start---------------------
	%87 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%88 = load i32*, i32** %87
	%89 = bitcast i32* %88 to i8*
	%90 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%91 = load i32, i32* %90
	%92 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%93 = load i32, i32* %92
	%94 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%95 = load i32, i32* %94
	%96 = call %return.3.0 @checkGrow(i8* %89, i32 %91, i32 %93, i32 %95, i32 1)
	%97 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%98 = load i32, i32* %97
	; copy and new slice
	%99 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%100 = load i32, i32* %99
	; init slice...............
	%array.141 = alloca { i32, i32, i32, i32* }
	%101 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.141, i32 0, i32 2
	store i32 4, i32* %101
	%102 = mul i32 %100, 4
	%103 = call i8* @malloc(i32 %102)
	%104 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.141, i32 0, i32 3
	%105 = bitcast i8* %103 to i32*
	store i32* %105, i32** %104
	%106 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.141, i32 0, i32 1
	store i32 %100, i32* %106
	%107 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.141, i32 0, i32 0
	store i32 %100, i32* %107
	; end init slice.................
	%108 = bitcast { i32, i32, i32, i32* }* %array.141 to i8*
	%109 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %108, i8* %109, i32 20, i1 false)
	; copy and end slice
	%110 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.141, i32 0, i32 3
	%111 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.141, i32 0, i32 0
	%112 = extractvalue %return.3.0 %96, 0
	%113 = extractvalue %return.3.0 %96, 1
	%114 = bitcast i8* %112 to i32*
	store i32* %114, i32** %110
	; store value
	%115 = load i32*, i32** %110
	%116 = bitcast i32* %115 to i32*
	%117 = add i32 %98, 0
	%118 = getelementptr i32, i32* %116, i32 %117
	store i32 5000, i32* %118
	; add len
	%119 = add i32 %98, 1
	store i32 %119, i32* %111
	%120 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.141, i32 0, i32 1
	store i32 %113, i32* %120
	; append end-------------------------
	%121 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.141
	store { i32, i32, i32, i32* } %121, { i32, i32, i32, i32* }* %array.4
	%122 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%123 = load i32, i32* %122
	%124 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%125 = load i32, i32* %124
	; get slice index
	%126 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%127 = load i32*, i32** %126
	%128 = getelementptr i32, i32* %127, i32 0
	%129 = load i32, i32* %128
	; get slice index
	%130 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%131 = load i32*, i32** %130
	%132 = getelementptr i32, i32* %131, i32 1
	%133 = load i32, i32* %132
	; get slice index
	%134 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%135 = load i32*, i32** %134
	%136 = getelementptr i32, i32* %135, i32 2
	%137 = load i32, i32* %136
	; get slice index
	%138 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%139 = load i32*, i32** %138
	%140 = getelementptr i32, i32* %139, i32 3
	%141 = load i32, i32* %140
	; get slice index
	%142 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%143 = load i32*, i32** %142
	%144 = getelementptr i32, i32* %143, i32 4
	%145 = load i32, i32* %144
	%146 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([36 x i8], [36 x i8]* @str.2, i64 0, i64 0), i32 %123, i32 %125, i32 %129, i32 %133, i32 %137, i32 %141, i32 %145)
	; append start---------------------
	%147 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%148 = load i32*, i32** %147
	%149 = bitcast i32* %148 to i8*
	%150 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%151 = load i32, i32* %150
	%152 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%153 = load i32, i32* %152
	%154 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%155 = load i32, i32* %154
	%156 = call %return.3.0 @checkGrow(i8* %149, i32 %151, i32 %153, i32 %155, i32 1)
	%157 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%158 = load i32, i32* %157
	; copy and new slice
	%159 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%160 = load i32, i32* %159
	; init slice...............
	%array.225 = alloca { i32, i32, i32, i32* }
	%161 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 2
	store i32 4, i32* %161
	%162 = mul i32 %160, 4
	%163 = call i8* @malloc(i32 %162)
	%164 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%165 = bitcast i8* %163 to i32*
	store i32* %165, i32** %164
	%166 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 1
	store i32 %160, i32* %166
	%167 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 0
	store i32 %160, i32* %167
	; end init slice.................
	%168 = bitcast { i32, i32, i32, i32* }* %array.225 to i8*
	%169 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %168, i8* %169, i32 20, i1 false)
	; copy and end slice
	%170 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%171 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 0
	%172 = extractvalue %return.3.0 %156, 0
	%173 = extractvalue %return.3.0 %156, 1
	%174 = bitcast i8* %172 to i32*
	store i32* %174, i32** %170
	; store value
	%175 = load i32*, i32** %170
	%176 = bitcast i32* %175 to i32*
	%177 = add i32 %158, 0
	%178 = getelementptr i32, i32* %176, i32 %177
	store i32 6000, i32* %178
	; add len
	%179 = add i32 %158, 1
	store i32 %179, i32* %171
	%180 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 1
	store i32 %173, i32* %180
	; append end-------------------------
	%181 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225
	%182 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 0
	%183 = load i32, i32* %182
	%184 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 1
	%185 = load i32, i32* %184
	; get slice index
	%186 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%187 = load i32*, i32** %186
	%188 = getelementptr i32, i32* %187, i32 0
	%189 = load i32, i32* %188
	; get slice index
	%190 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%191 = load i32*, i32** %190
	%192 = getelementptr i32, i32* %191, i32 1
	%193 = load i32, i32* %192
	; get slice index
	%194 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%195 = load i32*, i32** %194
	%196 = getelementptr i32, i32* %195, i32 2
	%197 = load i32, i32* %196
	; get slice index
	%198 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%199 = load i32*, i32** %198
	%200 = getelementptr i32, i32* %199, i32 3
	%201 = load i32, i32* %200
	; get slice index
	%202 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%203 = load i32*, i32** %202
	%204 = getelementptr i32, i32* %203, i32 4
	%205 = load i32, i32* %204
	; get slice index
	%206 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%207 = load i32*, i32** %206
	%208 = getelementptr i32, i32* %207, i32 5
	%209 = load i32, i32* %208
	%210 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.3, i64 0, i64 0), i32 %183, i32 %185, i32 %189, i32 %193, i32 %197, i32 %201, i32 %205, i32 %209)
	; append start---------------------
	%211 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%212 = load i32*, i32** %211
	%213 = bitcast i32* %212 to i8*
	%214 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%215 = load i32, i32* %214
	%216 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%217 = load i32, i32* %216
	%218 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%219 = load i32, i32* %218
	%220 = call %return.3.0 @checkGrow(i8* %213, i32 %215, i32 %217, i32 %219, i32 1)
	%221 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%222 = load i32, i32* %221
	; copy and new slice
	%223 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%224 = load i32, i32* %223
	; init slice...............
	%array.313 = alloca { i32, i32, i32, i32* }
	%225 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.313, i32 0, i32 2
	store i32 4, i32* %225
	%226 = mul i32 %224, 4
	%227 = call i8* @malloc(i32 %226)
	%228 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.313, i32 0, i32 3
	%229 = bitcast i8* %227 to i32*
	store i32* %229, i32** %228
	%230 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.313, i32 0, i32 1
	store i32 %224, i32* %230
	%231 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.313, i32 0, i32 0
	store i32 %224, i32* %231
	; end init slice.................
	%232 = bitcast { i32, i32, i32, i32* }* %array.313 to i8*
	%233 = bitcast { i32, i32, i32, i32* }* %array.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %232, i8* %233, i32 20, i1 false)
	; copy and end slice
	%234 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.313, i32 0, i32 3
	%235 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.313, i32 0, i32 0
	%236 = extractvalue %return.3.0 %220, 0
	%237 = extractvalue %return.3.0 %220, 1
	%238 = bitcast i8* %236 to i32*
	store i32* %238, i32** %234
	; store value
	%239 = load i32*, i32** %234
	%240 = bitcast i32* %239 to i32*
	%241 = add i32 %222, 0
	%242 = getelementptr i32, i32* %240, i32 %241
	store i32 7000, i32* %242
	; add len
	%243 = add i32 %222, 1
	store i32 %243, i32* %235
	%244 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.313, i32 0, i32 1
	store i32 %237, i32* %244
	; append end-------------------------
	%245 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.313
	store { i32, i32, i32, i32* } %245, { i32, i32, i32, i32* }* %array.4
	%246 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%247 = load i32, i32* %246
	%248 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	%249 = load i32, i32* %248
	; get slice index
	%250 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%251 = load i32*, i32** %250
	%252 = getelementptr i32, i32* %251, i32 0
	%253 = load i32, i32* %252
	; get slice index
	%254 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%255 = load i32*, i32** %254
	%256 = getelementptr i32, i32* %255, i32 1
	%257 = load i32, i32* %256
	; get slice index
	%258 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%259 = load i32*, i32** %258
	%260 = getelementptr i32, i32* %259, i32 2
	%261 = load i32, i32* %260
	; get slice index
	%262 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%263 = load i32*, i32** %262
	%264 = getelementptr i32, i32* %263, i32 3
	%265 = load i32, i32* %264
	; get slice index
	%266 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%267 = load i32*, i32** %266
	%268 = getelementptr i32, i32* %267, i32 4
	%269 = load i32, i32* %268
	; get slice index
	%270 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%271 = load i32*, i32** %270
	%272 = getelementptr i32, i32* %271, i32 5
	%273 = load i32, i32* %272
	%274 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.4, i64 0, i64 0), i32 %247, i32 %249, i32 %253, i32 %257, i32 %261, i32 %265, i32 %269, i32 %273)
	; append start---------------------
	%275 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%276 = load i32*, i32** %275
	%277 = bitcast i32* %276 to i8*
	%278 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 0
	%279 = load i32, i32* %278
	%280 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 1
	%281 = load i32, i32* %280
	%282 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 2
	%283 = load i32, i32* %282
	%284 = call %return.3.0 @checkGrow(i8* %277, i32 %279, i32 %281, i32 %283, i32 1)
	%285 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 0
	%286 = load i32, i32* %285
	; copy and new slice
	%287 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 0
	%288 = load i32, i32* %287
	; init slice...............
	%array.402 = alloca { i32, i32, i32, i32* }
	%289 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.402, i32 0, i32 2
	store i32 4, i32* %289
	%290 = mul i32 %288, 4
	%291 = call i8* @malloc(i32 %290)
	%292 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.402, i32 0, i32 3
	%293 = bitcast i8* %291 to i32*
	store i32* %293, i32** %292
	%294 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.402, i32 0, i32 1
	store i32 %288, i32* %294
	%295 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.402, i32 0, i32 0
	store i32 %288, i32* %295
	; end init slice.................
	%296 = bitcast { i32, i32, i32, i32* }* %array.402 to i8*
	%297 = bitcast { i32, i32, i32, i32* }* %array.225 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %296, i8* %297, i32 20, i1 false)
	; copy and end slice
	%298 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.402, i32 0, i32 3
	%299 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.402, i32 0, i32 0
	%300 = extractvalue %return.3.0 %284, 0
	%301 = extractvalue %return.3.0 %284, 1
	%302 = bitcast i8* %300 to i32*
	store i32* %302, i32** %298
	; store value
	%303 = load i32*, i32** %298
	%304 = bitcast i32* %303 to i32*
	%305 = add i32 %286, 0
	%306 = getelementptr i32, i32* %304, i32 %305
	store i32 8000, i32* %306
	; add len
	%307 = add i32 %286, 1
	store i32 %307, i32* %299
	%308 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.402, i32 0, i32 1
	store i32 %301, i32* %308
	; append end-------------------------
	%309 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.402
	store { i32, i32, i32, i32* } %309, { i32, i32, i32, i32* }* %array.225
	%310 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 0
	%311 = load i32, i32* %310
	%312 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 1
	%313 = load i32, i32* %312
	; get slice index
	%314 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%315 = load i32*, i32** %314
	%316 = getelementptr i32, i32* %315, i32 0
	%317 = load i32, i32* %316
	; get slice index
	%318 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%319 = load i32*, i32** %318
	%320 = getelementptr i32, i32* %319, i32 1
	%321 = load i32, i32* %320
	; get slice index
	%322 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%323 = load i32*, i32** %322
	%324 = getelementptr i32, i32* %323, i32 2
	%325 = load i32, i32* %324
	; get slice index
	%326 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%327 = load i32*, i32** %326
	%328 = getelementptr i32, i32* %327, i32 3
	%329 = load i32, i32* %328
	; get slice index
	%330 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%331 = load i32*, i32** %330
	%332 = getelementptr i32, i32* %331, i32 4
	%333 = load i32, i32* %332
	; get slice index
	%334 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%335 = load i32*, i32** %334
	%336 = getelementptr i32, i32* %335, i32 5
	%337 = load i32, i32* %336
	; get slice index
	%338 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.225, i32 0, i32 3
	%339 = load i32*, i32** %338
	%340 = getelementptr i32, i32* %339, i32 6
	%341 = load i32, i32* %340
	%342 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([42 x i8], [42 x i8]* @str.5, i64 0, i64 0), i32 %311, i32 %313, i32 %317, i32 %321, i32 %325, i32 %329, i32 %333, i32 %337, i32 %341)
	ret void
}

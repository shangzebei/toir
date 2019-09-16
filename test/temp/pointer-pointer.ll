@str.0 = constant [7 x i8] c"i: %d\0A\00"
@str.1 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.2 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.3 = constant [14 x i8] c"***iptr3: %d\0A\00"
@str.4 = constant [7 x i8] c"i: %d\0A\00"
@str.5 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.6 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.7 = constant [14 x i8] c"***iptr3: %d\0A\00"
@str.8 = constant [7 x i8] c"i: %d\0A\00"
@str.9 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.10 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.11 = constant [14 x i8] c"***iptr3: %d\0A\00"
@str.12 = constant [7 x i8] c"i: %d\0A\00"
@str.13 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.14 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.15 = constant [14 x i8] c"***iptr3: %d\0A\00"
@str.16 = constant [7 x i8] c"i: %d\0A\00"
@str.17 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.18 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.19 = constant [14 x i8] c"***iptr3: %d\0A\00"

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

define void @main() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 100, i32* %1
	%2 = alloca i32*
	store i32* %1, i32** %2
	%3 = alloca i32**
	store i32** %2, i32*** %3
	%4 = alloca i32***
	store i32*** %3, i32**** %4
	%5 = call i8* @malloc(i32 20)
	%6 = bitcast i8* %5 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %6, i32 7)
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 0
	store i32 7, i32* %7
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 3
	%9 = load i8*, i8** %8
	%10 = bitcast i8* %9 to i8*
	%11 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %11, i32 7, i1 false)
	%12 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6
	%13 = load i32, i32* %1
	%14 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 3
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15, i32 %13)
	%17 = call i8* @malloc(i32 20)
	%18 = bitcast i8* %17 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %18, i32 12)
	%19 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 0
	store i32 12, i32* %19
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 3
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 12, i1 false)
	%24 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18
	%25 = load i32*, i32** %2
	%26 = load i32, i32* %25
	%27 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 3
	%28 = load i8*, i8** %27
	%29 = call i32 (i8*, ...) @printf(i8* %28, i32 %26)
	%30 = call i8* @malloc(i32 20)
	%31 = bitcast i8* %30 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %31, i32 13)
	%32 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %31, i32 0, i32 0
	store i32 13, i32* %32
	%33 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %31, i32 0, i32 3
	%34 = load i8*, i8** %33
	%35 = bitcast i8* %34 to i8*
	%36 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %35, i8* %36, i32 13, i1 false)
	%37 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %31
	%38 = load i32**, i32*** %3
	%39 = load i32*, i32** %38
	%40 = load i32, i32* %39
	%41 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %31, i32 0, i32 3
	%42 = load i8*, i8** %41
	%43 = call i32 (i8*, ...) @printf(i8* %42, i32 %40)
	%44 = call i8* @malloc(i32 20)
	%45 = bitcast i8* %44 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %45, i32 14)
	%46 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %45, i32 0, i32 0
	store i32 14, i32* %46
	%47 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %45, i32 0, i32 3
	%48 = load i8*, i8** %47
	%49 = bitcast i8* %48 to i8*
	%50 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %49, i8* %50, i32 14, i1 false)
	%51 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %45
	%52 = load i32***, i32**** %4
	%53 = load i32**, i32*** %52
	%54 = load i32*, i32** %53
	%55 = load i32, i32* %54
	%56 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %45, i32 0, i32 3
	%57 = load i8*, i8** %56
	%58 = call i32 (i8*, ...) @printf(i8* %57, i32 %55)
	store i32 200, i32* %1
	%59 = call i8* @malloc(i32 20)
	%60 = bitcast i8* %59 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %60, i32 7)
	%61 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %60, i32 0, i32 0
	store i32 7, i32* %61
	%62 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %60, i32 0, i32 3
	%63 = load i8*, i8** %62
	%64 = bitcast i8* %63 to i8*
	%65 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %64, i8* %65, i32 7, i1 false)
	%66 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %60
	%67 = load i32, i32* %1
	%68 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %60, i32 0, i32 3
	%69 = load i8*, i8** %68
	%70 = call i32 (i8*, ...) @printf(i8* %69, i32 %67)
	%71 = call i8* @malloc(i32 20)
	%72 = bitcast i8* %71 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %72, i32 12)
	%73 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %72, i32 0, i32 0
	store i32 12, i32* %73
	%74 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %72, i32 0, i32 3
	%75 = load i8*, i8** %74
	%76 = bitcast i8* %75 to i8*
	%77 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %76, i8* %77, i32 12, i1 false)
	%78 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %72
	%79 = load i32*, i32** %2
	%80 = load i32, i32* %79
	%81 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %72, i32 0, i32 3
	%82 = load i8*, i8** %81
	%83 = call i32 (i8*, ...) @printf(i8* %82, i32 %80)
	%84 = call i8* @malloc(i32 20)
	%85 = bitcast i8* %84 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %85, i32 13)
	%86 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %85, i32 0, i32 0
	store i32 13, i32* %86
	%87 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %85, i32 0, i32 3
	%88 = load i8*, i8** %87
	%89 = bitcast i8* %88 to i8*
	%90 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %89, i8* %90, i32 13, i1 false)
	%91 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %85
	%92 = load i32**, i32*** %3
	%93 = load i32*, i32** %92
	%94 = load i32, i32* %93
	%95 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %85, i32 0, i32 3
	%96 = load i8*, i8** %95
	%97 = call i32 (i8*, ...) @printf(i8* %96, i32 %94)
	%98 = call i8* @malloc(i32 20)
	%99 = bitcast i8* %98 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %99, i32 14)
	%100 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %99, i32 0, i32 0
	store i32 14, i32* %100
	%101 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %99, i32 0, i32 3
	%102 = load i8*, i8** %101
	%103 = bitcast i8* %102 to i8*
	%104 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %103, i8* %104, i32 14, i1 false)
	%105 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %99
	%106 = load i32***, i32**** %4
	%107 = load i32**, i32*** %106
	%108 = load i32*, i32** %107
	%109 = load i32, i32* %108
	%110 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %99, i32 0, i32 3
	%111 = load i8*, i8** %110
	%112 = call i32 (i8*, ...) @printf(i8* %111, i32 %109)
	%113 = load i32*, i32** %2
	%114 = load i32, i32* %113
	store i32 300, i32* %113
	%115 = call i8* @malloc(i32 20)
	%116 = bitcast i8* %115 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %116, i32 7)
	%117 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %116, i32 0, i32 0
	store i32 7, i32* %117
	%118 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %116, i32 0, i32 3
	%119 = load i8*, i8** %118
	%120 = bitcast i8* %119 to i8*
	%121 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %120, i8* %121, i32 7, i1 false)
	%122 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %116
	%123 = load i32, i32* %1
	%124 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %116, i32 0, i32 3
	%125 = load i8*, i8** %124
	%126 = call i32 (i8*, ...) @printf(i8* %125, i32 %123)
	%127 = call i8* @malloc(i32 20)
	%128 = bitcast i8* %127 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %128, i32 12)
	%129 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %128, i32 0, i32 0
	store i32 12, i32* %129
	%130 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %128, i32 0, i32 3
	%131 = load i8*, i8** %130
	%132 = bitcast i8* %131 to i8*
	%133 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.9, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %132, i8* %133, i32 12, i1 false)
	%134 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %128
	%135 = load i32*, i32** %2
	%136 = load i32, i32* %135
	%137 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %128, i32 0, i32 3
	%138 = load i8*, i8** %137
	%139 = call i32 (i8*, ...) @printf(i8* %138, i32 %136)
	%140 = call i8* @malloc(i32 20)
	%141 = bitcast i8* %140 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %141, i32 13)
	%142 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %141, i32 0, i32 0
	store i32 13, i32* %142
	%143 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %141, i32 0, i32 3
	%144 = load i8*, i8** %143
	%145 = bitcast i8* %144 to i8*
	%146 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.10, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %145, i8* %146, i32 13, i1 false)
	%147 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %141
	%148 = load i32**, i32*** %3
	%149 = load i32*, i32** %148
	%150 = load i32, i32* %149
	%151 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %141, i32 0, i32 3
	%152 = load i8*, i8** %151
	%153 = call i32 (i8*, ...) @printf(i8* %152, i32 %150)
	%154 = call i8* @malloc(i32 20)
	%155 = bitcast i8* %154 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %155, i32 14)
	%156 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %155, i32 0, i32 0
	store i32 14, i32* %156
	%157 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %155, i32 0, i32 3
	%158 = load i8*, i8** %157
	%159 = bitcast i8* %158 to i8*
	%160 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.11, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %159, i8* %160, i32 14, i1 false)
	%161 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %155
	%162 = load i32***, i32**** %4
	%163 = load i32**, i32*** %162
	%164 = load i32*, i32** %163
	%165 = load i32, i32* %164
	%166 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %155, i32 0, i32 3
	%167 = load i8*, i8** %166
	%168 = call i32 (i8*, ...) @printf(i8* %167, i32 %165)
	%169 = load i32**, i32*** %3
	%170 = load i32*, i32** %169
	%171 = load i32, i32* %170
	store i32 400, i32* %170
	%172 = call i8* @malloc(i32 20)
	%173 = bitcast i8* %172 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %173, i32 7)
	%174 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %173, i32 0, i32 0
	store i32 7, i32* %174
	%175 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %173, i32 0, i32 3
	%176 = load i8*, i8** %175
	%177 = bitcast i8* %176 to i8*
	%178 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.12, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %177, i8* %178, i32 7, i1 false)
	%179 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %173
	%180 = load i32, i32* %1
	%181 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %173, i32 0, i32 3
	%182 = load i8*, i8** %181
	%183 = call i32 (i8*, ...) @printf(i8* %182, i32 %180)
	%184 = call i8* @malloc(i32 20)
	%185 = bitcast i8* %184 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %185, i32 12)
	%186 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %185, i32 0, i32 0
	store i32 12, i32* %186
	%187 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %185, i32 0, i32 3
	%188 = load i8*, i8** %187
	%189 = bitcast i8* %188 to i8*
	%190 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.13, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %189, i8* %190, i32 12, i1 false)
	%191 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %185
	%192 = load i32*, i32** %2
	%193 = load i32, i32* %192
	%194 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %185, i32 0, i32 3
	%195 = load i8*, i8** %194
	%196 = call i32 (i8*, ...) @printf(i8* %195, i32 %193)
	%197 = call i8* @malloc(i32 20)
	%198 = bitcast i8* %197 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %198, i32 13)
	%199 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %198, i32 0, i32 0
	store i32 13, i32* %199
	%200 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %198, i32 0, i32 3
	%201 = load i8*, i8** %200
	%202 = bitcast i8* %201 to i8*
	%203 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.14, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %202, i8* %203, i32 13, i1 false)
	%204 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %198
	%205 = load i32**, i32*** %3
	%206 = load i32*, i32** %205
	%207 = load i32, i32* %206
	%208 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %198, i32 0, i32 3
	%209 = load i8*, i8** %208
	%210 = call i32 (i8*, ...) @printf(i8* %209, i32 %207)
	%211 = call i8* @malloc(i32 20)
	%212 = bitcast i8* %211 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %212, i32 14)
	%213 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %212, i32 0, i32 0
	store i32 14, i32* %213
	%214 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %212, i32 0, i32 3
	%215 = load i8*, i8** %214
	%216 = bitcast i8* %215 to i8*
	%217 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.15, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %216, i8* %217, i32 14, i1 false)
	%218 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %212
	%219 = load i32***, i32**** %4
	%220 = load i32**, i32*** %219
	%221 = load i32*, i32** %220
	%222 = load i32, i32* %221
	%223 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %212, i32 0, i32 3
	%224 = load i8*, i8** %223
	%225 = call i32 (i8*, ...) @printf(i8* %224, i32 %222)
	%226 = load i32***, i32**** %4
	%227 = load i32**, i32*** %226
	%228 = load i32*, i32** %227
	%229 = load i32, i32* %228
	store i32 500, i32* %228
	%230 = call i8* @malloc(i32 20)
	%231 = bitcast i8* %230 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %231, i32 7)
	%232 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %231, i32 0, i32 0
	store i32 7, i32* %232
	%233 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %231, i32 0, i32 3
	%234 = load i8*, i8** %233
	%235 = bitcast i8* %234 to i8*
	%236 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.16, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %235, i8* %236, i32 7, i1 false)
	%237 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %231
	%238 = load i32, i32* %1
	%239 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %231, i32 0, i32 3
	%240 = load i8*, i8** %239
	%241 = call i32 (i8*, ...) @printf(i8* %240, i32 %238)
	%242 = call i8* @malloc(i32 20)
	%243 = bitcast i8* %242 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %243, i32 12)
	%244 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %243, i32 0, i32 0
	store i32 12, i32* %244
	%245 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %243, i32 0, i32 3
	%246 = load i8*, i8** %245
	%247 = bitcast i8* %246 to i8*
	%248 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.17, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %247, i8* %248, i32 12, i1 false)
	%249 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %243
	%250 = load i32*, i32** %2
	%251 = load i32, i32* %250
	%252 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %243, i32 0, i32 3
	%253 = load i8*, i8** %252
	%254 = call i32 (i8*, ...) @printf(i8* %253, i32 %251)
	%255 = call i8* @malloc(i32 20)
	%256 = bitcast i8* %255 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %256, i32 13)
	%257 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %256, i32 0, i32 0
	store i32 13, i32* %257
	%258 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %256, i32 0, i32 3
	%259 = load i8*, i8** %258
	%260 = bitcast i8* %259 to i8*
	%261 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.18, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %260, i8* %261, i32 13, i1 false)
	%262 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %256
	%263 = load i32**, i32*** %3
	%264 = load i32*, i32** %263
	%265 = load i32, i32* %264
	%266 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %256, i32 0, i32 3
	%267 = load i8*, i8** %266
	%268 = call i32 (i8*, ...) @printf(i8* %267, i32 %265)
	%269 = call i8* @malloc(i32 20)
	%270 = bitcast i8* %269 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %270, i32 14)
	%271 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %270, i32 0, i32 0
	store i32 14, i32* %271
	%272 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %270, i32 0, i32 3
	%273 = load i8*, i8** %272
	%274 = bitcast i8* %273 to i8*
	%275 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.19, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %274, i8* %275, i32 14, i1 false)
	%276 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %270
	%277 = load i32***, i32**** %4
	%278 = load i32**, i32*** %277
	%279 = load i32*, i32** %278
	%280 = load i32, i32* %279
	%281 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %270, i32 0, i32 3
	%282 = load i8*, i8** %281
	%283 = call i32 (i8*, ...) @printf(i8* %282, i32 %280)
	; end block
	ret void
}

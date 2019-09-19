%mapStruct = type {}
%string = type { i32, i8* }

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

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 20)
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
	; IF NEW BLOCK
	%12 = load %string*, %string** %4
	%13 = getelementptr %string, %string* %12, i32 0, i32 0
	%14 = load i32, i32* %13
	%15 = load i32, i32* %1
	store i32 %15, i32* %13
	%16 = load i32, i32* %1
	%17 = add i32 %16, 1
	%18 = call i8* @malloc(i32 %17)
	%19 = load %string*, %string** %4
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	store i8* %18, i8** %20
	%22 = load %string*, %string** %4
	; end block
	ret %string* %22
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
	%5 = call %string* @runtime.newString(i32 6)
	%6 = getelementptr %string, %string* %5, i32 0, i32 1
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	%10 = getelementptr %string, %string* %5, i32 0, i32 0
	%11 = load i32, i32* %10
	%12 = add i32 %11, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 %12, i1 false)
	%13 = load %string, %string* %5
	%14 = load i32, i32* %1
	%15 = getelementptr %string, %string* %5, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = call i32 (i8*, ...) @printf(i8* %16, i32 %14)
	%18 = call %string* @runtime.newString(i32 11)
	%19 = getelementptr %string, %string* %18, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = bitcast i8* %20 to i8*
	%22 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.1, i64 0, i64 0) to i8*
	%23 = getelementptr %string, %string* %18, i32 0, i32 0
	%24 = load i32, i32* %23
	%25 = add i32 %24, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %21, i8* %22, i32 %25, i1 false)
	%26 = load %string, %string* %18
	%27 = load i32*, i32** %2
	%28 = load i32, i32* %27
	%29 = getelementptr %string, %string* %18, i32 0, i32 1
	%30 = load i8*, i8** %29
	%31 = call i32 (i8*, ...) @printf(i8* %30, i32 %28)
	%32 = call %string* @runtime.newString(i32 12)
	%33 = getelementptr %string, %string* %32, i32 0, i32 1
	%34 = load i8*, i8** %33
	%35 = bitcast i8* %34 to i8*
	%36 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.2, i64 0, i64 0) to i8*
	%37 = getelementptr %string, %string* %32, i32 0, i32 0
	%38 = load i32, i32* %37
	%39 = add i32 %38, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %35, i8* %36, i32 %39, i1 false)
	%40 = load %string, %string* %32
	%41 = load i32**, i32*** %3
	%42 = load i32*, i32** %41
	%43 = load i32, i32* %42
	%44 = getelementptr %string, %string* %32, i32 0, i32 1
	%45 = load i8*, i8** %44
	%46 = call i32 (i8*, ...) @printf(i8* %45, i32 %43)
	%47 = call %string* @runtime.newString(i32 13)
	%48 = getelementptr %string, %string* %47, i32 0, i32 1
	%49 = load i8*, i8** %48
	%50 = bitcast i8* %49 to i8*
	%51 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.3, i64 0, i64 0) to i8*
	%52 = getelementptr %string, %string* %47, i32 0, i32 0
	%53 = load i32, i32* %52
	%54 = add i32 %53, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %50, i8* %51, i32 %54, i1 false)
	%55 = load %string, %string* %47
	%56 = load i32***, i32**** %4
	%57 = load i32**, i32*** %56
	%58 = load i32*, i32** %57
	%59 = load i32, i32* %58
	%60 = getelementptr %string, %string* %47, i32 0, i32 1
	%61 = load i8*, i8** %60
	%62 = call i32 (i8*, ...) @printf(i8* %61, i32 %59)
	store i32 200, i32* %1
	%63 = call %string* @runtime.newString(i32 6)
	%64 = getelementptr %string, %string* %63, i32 0, i32 1
	%65 = load i8*, i8** %64
	%66 = bitcast i8* %65 to i8*
	%67 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.4, i64 0, i64 0) to i8*
	%68 = getelementptr %string, %string* %63, i32 0, i32 0
	%69 = load i32, i32* %68
	%70 = add i32 %69, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %66, i8* %67, i32 %70, i1 false)
	%71 = load %string, %string* %63
	%72 = load i32, i32* %1
	%73 = getelementptr %string, %string* %63, i32 0, i32 1
	%74 = load i8*, i8** %73
	%75 = call i32 (i8*, ...) @printf(i8* %74, i32 %72)
	%76 = call %string* @runtime.newString(i32 11)
	%77 = getelementptr %string, %string* %76, i32 0, i32 1
	%78 = load i8*, i8** %77
	%79 = bitcast i8* %78 to i8*
	%80 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.5, i64 0, i64 0) to i8*
	%81 = getelementptr %string, %string* %76, i32 0, i32 0
	%82 = load i32, i32* %81
	%83 = add i32 %82, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %79, i8* %80, i32 %83, i1 false)
	%84 = load %string, %string* %76
	%85 = load i32*, i32** %2
	%86 = load i32, i32* %85
	%87 = getelementptr %string, %string* %76, i32 0, i32 1
	%88 = load i8*, i8** %87
	%89 = call i32 (i8*, ...) @printf(i8* %88, i32 %86)
	%90 = call %string* @runtime.newString(i32 12)
	%91 = getelementptr %string, %string* %90, i32 0, i32 1
	%92 = load i8*, i8** %91
	%93 = bitcast i8* %92 to i8*
	%94 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.6, i64 0, i64 0) to i8*
	%95 = getelementptr %string, %string* %90, i32 0, i32 0
	%96 = load i32, i32* %95
	%97 = add i32 %96, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %93, i8* %94, i32 %97, i1 false)
	%98 = load %string, %string* %90
	%99 = load i32**, i32*** %3
	%100 = load i32*, i32** %99
	%101 = load i32, i32* %100
	%102 = getelementptr %string, %string* %90, i32 0, i32 1
	%103 = load i8*, i8** %102
	%104 = call i32 (i8*, ...) @printf(i8* %103, i32 %101)
	%105 = call %string* @runtime.newString(i32 13)
	%106 = getelementptr %string, %string* %105, i32 0, i32 1
	%107 = load i8*, i8** %106
	%108 = bitcast i8* %107 to i8*
	%109 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.7, i64 0, i64 0) to i8*
	%110 = getelementptr %string, %string* %105, i32 0, i32 0
	%111 = load i32, i32* %110
	%112 = add i32 %111, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %108, i8* %109, i32 %112, i1 false)
	%113 = load %string, %string* %105
	%114 = load i32***, i32**** %4
	%115 = load i32**, i32*** %114
	%116 = load i32*, i32** %115
	%117 = load i32, i32* %116
	%118 = getelementptr %string, %string* %105, i32 0, i32 1
	%119 = load i8*, i8** %118
	%120 = call i32 (i8*, ...) @printf(i8* %119, i32 %117)
	%121 = load i32*, i32** %2
	%122 = load i32, i32* %121
	store i32 300, i32* %121
	%123 = call %string* @runtime.newString(i32 6)
	%124 = getelementptr %string, %string* %123, i32 0, i32 1
	%125 = load i8*, i8** %124
	%126 = bitcast i8* %125 to i8*
	%127 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.8, i64 0, i64 0) to i8*
	%128 = getelementptr %string, %string* %123, i32 0, i32 0
	%129 = load i32, i32* %128
	%130 = add i32 %129, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %126, i8* %127, i32 %130, i1 false)
	%131 = load %string, %string* %123
	%132 = load i32, i32* %1
	%133 = getelementptr %string, %string* %123, i32 0, i32 1
	%134 = load i8*, i8** %133
	%135 = call i32 (i8*, ...) @printf(i8* %134, i32 %132)
	%136 = call %string* @runtime.newString(i32 11)
	%137 = getelementptr %string, %string* %136, i32 0, i32 1
	%138 = load i8*, i8** %137
	%139 = bitcast i8* %138 to i8*
	%140 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.9, i64 0, i64 0) to i8*
	%141 = getelementptr %string, %string* %136, i32 0, i32 0
	%142 = load i32, i32* %141
	%143 = add i32 %142, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %139, i8* %140, i32 %143, i1 false)
	%144 = load %string, %string* %136
	%145 = load i32*, i32** %2
	%146 = load i32, i32* %145
	%147 = getelementptr %string, %string* %136, i32 0, i32 1
	%148 = load i8*, i8** %147
	%149 = call i32 (i8*, ...) @printf(i8* %148, i32 %146)
	%150 = call %string* @runtime.newString(i32 12)
	%151 = getelementptr %string, %string* %150, i32 0, i32 1
	%152 = load i8*, i8** %151
	%153 = bitcast i8* %152 to i8*
	%154 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.10, i64 0, i64 0) to i8*
	%155 = getelementptr %string, %string* %150, i32 0, i32 0
	%156 = load i32, i32* %155
	%157 = add i32 %156, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %153, i8* %154, i32 %157, i1 false)
	%158 = load %string, %string* %150
	%159 = load i32**, i32*** %3
	%160 = load i32*, i32** %159
	%161 = load i32, i32* %160
	%162 = getelementptr %string, %string* %150, i32 0, i32 1
	%163 = load i8*, i8** %162
	%164 = call i32 (i8*, ...) @printf(i8* %163, i32 %161)
	%165 = call %string* @runtime.newString(i32 13)
	%166 = getelementptr %string, %string* %165, i32 0, i32 1
	%167 = load i8*, i8** %166
	%168 = bitcast i8* %167 to i8*
	%169 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.11, i64 0, i64 0) to i8*
	%170 = getelementptr %string, %string* %165, i32 0, i32 0
	%171 = load i32, i32* %170
	%172 = add i32 %171, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %168, i8* %169, i32 %172, i1 false)
	%173 = load %string, %string* %165
	%174 = load i32***, i32**** %4
	%175 = load i32**, i32*** %174
	%176 = load i32*, i32** %175
	%177 = load i32, i32* %176
	%178 = getelementptr %string, %string* %165, i32 0, i32 1
	%179 = load i8*, i8** %178
	%180 = call i32 (i8*, ...) @printf(i8* %179, i32 %177)
	%181 = load i32**, i32*** %3
	%182 = load i32*, i32** %181
	%183 = load i32, i32* %182
	store i32 400, i32* %182
	%184 = call %string* @runtime.newString(i32 6)
	%185 = getelementptr %string, %string* %184, i32 0, i32 1
	%186 = load i8*, i8** %185
	%187 = bitcast i8* %186 to i8*
	%188 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.12, i64 0, i64 0) to i8*
	%189 = getelementptr %string, %string* %184, i32 0, i32 0
	%190 = load i32, i32* %189
	%191 = add i32 %190, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %187, i8* %188, i32 %191, i1 false)
	%192 = load %string, %string* %184
	%193 = load i32, i32* %1
	%194 = getelementptr %string, %string* %184, i32 0, i32 1
	%195 = load i8*, i8** %194
	%196 = call i32 (i8*, ...) @printf(i8* %195, i32 %193)
	%197 = call %string* @runtime.newString(i32 11)
	%198 = getelementptr %string, %string* %197, i32 0, i32 1
	%199 = load i8*, i8** %198
	%200 = bitcast i8* %199 to i8*
	%201 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.13, i64 0, i64 0) to i8*
	%202 = getelementptr %string, %string* %197, i32 0, i32 0
	%203 = load i32, i32* %202
	%204 = add i32 %203, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %200, i8* %201, i32 %204, i1 false)
	%205 = load %string, %string* %197
	%206 = load i32*, i32** %2
	%207 = load i32, i32* %206
	%208 = getelementptr %string, %string* %197, i32 0, i32 1
	%209 = load i8*, i8** %208
	%210 = call i32 (i8*, ...) @printf(i8* %209, i32 %207)
	%211 = call %string* @runtime.newString(i32 12)
	%212 = getelementptr %string, %string* %211, i32 0, i32 1
	%213 = load i8*, i8** %212
	%214 = bitcast i8* %213 to i8*
	%215 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.14, i64 0, i64 0) to i8*
	%216 = getelementptr %string, %string* %211, i32 0, i32 0
	%217 = load i32, i32* %216
	%218 = add i32 %217, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %214, i8* %215, i32 %218, i1 false)
	%219 = load %string, %string* %211
	%220 = load i32**, i32*** %3
	%221 = load i32*, i32** %220
	%222 = load i32, i32* %221
	%223 = getelementptr %string, %string* %211, i32 0, i32 1
	%224 = load i8*, i8** %223
	%225 = call i32 (i8*, ...) @printf(i8* %224, i32 %222)
	%226 = call %string* @runtime.newString(i32 13)
	%227 = getelementptr %string, %string* %226, i32 0, i32 1
	%228 = load i8*, i8** %227
	%229 = bitcast i8* %228 to i8*
	%230 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.15, i64 0, i64 0) to i8*
	%231 = getelementptr %string, %string* %226, i32 0, i32 0
	%232 = load i32, i32* %231
	%233 = add i32 %232, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %229, i8* %230, i32 %233, i1 false)
	%234 = load %string, %string* %226
	%235 = load i32***, i32**** %4
	%236 = load i32**, i32*** %235
	%237 = load i32*, i32** %236
	%238 = load i32, i32* %237
	%239 = getelementptr %string, %string* %226, i32 0, i32 1
	%240 = load i8*, i8** %239
	%241 = call i32 (i8*, ...) @printf(i8* %240, i32 %238)
	%242 = load i32***, i32**** %4
	%243 = load i32**, i32*** %242
	%244 = load i32*, i32** %243
	%245 = load i32, i32* %244
	store i32 500, i32* %244
	%246 = call %string* @runtime.newString(i32 6)
	%247 = getelementptr %string, %string* %246, i32 0, i32 1
	%248 = load i8*, i8** %247
	%249 = bitcast i8* %248 to i8*
	%250 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.16, i64 0, i64 0) to i8*
	%251 = getelementptr %string, %string* %246, i32 0, i32 0
	%252 = load i32, i32* %251
	%253 = add i32 %252, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %249, i8* %250, i32 %253, i1 false)
	%254 = load %string, %string* %246
	%255 = load i32, i32* %1
	%256 = getelementptr %string, %string* %246, i32 0, i32 1
	%257 = load i8*, i8** %256
	%258 = call i32 (i8*, ...) @printf(i8* %257, i32 %255)
	%259 = call %string* @runtime.newString(i32 11)
	%260 = getelementptr %string, %string* %259, i32 0, i32 1
	%261 = load i8*, i8** %260
	%262 = bitcast i8* %261 to i8*
	%263 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.17, i64 0, i64 0) to i8*
	%264 = getelementptr %string, %string* %259, i32 0, i32 0
	%265 = load i32, i32* %264
	%266 = add i32 %265, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %262, i8* %263, i32 %266, i1 false)
	%267 = load %string, %string* %259
	%268 = load i32*, i32** %2
	%269 = load i32, i32* %268
	%270 = getelementptr %string, %string* %259, i32 0, i32 1
	%271 = load i8*, i8** %270
	%272 = call i32 (i8*, ...) @printf(i8* %271, i32 %269)
	%273 = call %string* @runtime.newString(i32 12)
	%274 = getelementptr %string, %string* %273, i32 0, i32 1
	%275 = load i8*, i8** %274
	%276 = bitcast i8* %275 to i8*
	%277 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.18, i64 0, i64 0) to i8*
	%278 = getelementptr %string, %string* %273, i32 0, i32 0
	%279 = load i32, i32* %278
	%280 = add i32 %279, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %276, i8* %277, i32 %280, i1 false)
	%281 = load %string, %string* %273
	%282 = load i32**, i32*** %3
	%283 = load i32*, i32** %282
	%284 = load i32, i32* %283
	%285 = getelementptr %string, %string* %273, i32 0, i32 1
	%286 = load i8*, i8** %285
	%287 = call i32 (i8*, ...) @printf(i8* %286, i32 %284)
	%288 = call %string* @runtime.newString(i32 13)
	%289 = getelementptr %string, %string* %288, i32 0, i32 1
	%290 = load i8*, i8** %289
	%291 = bitcast i8* %290 to i8*
	%292 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.19, i64 0, i64 0) to i8*
	%293 = getelementptr %string, %string* %288, i32 0, i32 0
	%294 = load i32, i32* %293
	%295 = add i32 %294, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %291, i8* %292, i32 %295, i1 false)
	%296 = load %string, %string* %288
	%297 = load i32***, i32**** %4
	%298 = load i32**, i32*** %297
	%299 = load i32*, i32** %298
	%300 = load i32, i32* %299
	%301 = getelementptr %string, %string* %288, i32 0, i32 1
	%302 = load i8*, i8** %301
	%303 = call i32 (i8*, ...) @printf(i8* %302, i32 %300)
	; end block
	ret void
}

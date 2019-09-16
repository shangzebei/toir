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
	%5 = call %string* @newString(i32 7)
	%6 = getelementptr %string, %string* %5, i32 0, i32 1
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 7, i1 false)
	%10 = load %string, %string* %5
	%11 = load i32, i32* %1
	%12 = getelementptr %string, %string* %5, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13, i32 %11)
	%15 = call %string* @newString(i32 12)
	%16 = getelementptr %string, %string* %15, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to i8*
	%19 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 12, i1 false)
	%20 = load %string, %string* %15
	%21 = load i32*, i32** %2
	%22 = load i32, i32* %21
	%23 = getelementptr %string, %string* %15, i32 0, i32 1
	%24 = load i8*, i8** %23
	%25 = call i32 (i8*, ...) @printf(i8* %24, i32 %22)
	%26 = call %string* @newString(i32 13)
	%27 = getelementptr %string, %string* %26, i32 0, i32 1
	%28 = load i8*, i8** %27
	%29 = bitcast i8* %28 to i8*
	%30 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %29, i8* %30, i32 13, i1 false)
	%31 = load %string, %string* %26
	%32 = load i32**, i32*** %3
	%33 = load i32*, i32** %32
	%34 = load i32, i32* %33
	%35 = getelementptr %string, %string* %26, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = call i32 (i8*, ...) @printf(i8* %36, i32 %34)
	%38 = call %string* @newString(i32 14)
	%39 = getelementptr %string, %string* %38, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 14, i1 false)
	%43 = load %string, %string* %38
	%44 = load i32***, i32**** %4
	%45 = load i32**, i32*** %44
	%46 = load i32*, i32** %45
	%47 = load i32, i32* %46
	%48 = getelementptr %string, %string* %38, i32 0, i32 1
	%49 = load i8*, i8** %48
	%50 = call i32 (i8*, ...) @printf(i8* %49, i32 %47)
	store i32 200, i32* %1
	%51 = call %string* @newString(i32 7)
	%52 = getelementptr %string, %string* %51, i32 0, i32 1
	%53 = load i8*, i8** %52
	%54 = bitcast i8* %53 to i8*
	%55 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %54, i8* %55, i32 7, i1 false)
	%56 = load %string, %string* %51
	%57 = load i32, i32* %1
	%58 = getelementptr %string, %string* %51, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = call i32 (i8*, ...) @printf(i8* %59, i32 %57)
	%61 = call %string* @newString(i32 12)
	%62 = getelementptr %string, %string* %61, i32 0, i32 1
	%63 = load i8*, i8** %62
	%64 = bitcast i8* %63 to i8*
	%65 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %64, i8* %65, i32 12, i1 false)
	%66 = load %string, %string* %61
	%67 = load i32*, i32** %2
	%68 = load i32, i32* %67
	%69 = getelementptr %string, %string* %61, i32 0, i32 1
	%70 = load i8*, i8** %69
	%71 = call i32 (i8*, ...) @printf(i8* %70, i32 %68)
	%72 = call %string* @newString(i32 13)
	%73 = getelementptr %string, %string* %72, i32 0, i32 1
	%74 = load i8*, i8** %73
	%75 = bitcast i8* %74 to i8*
	%76 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %75, i8* %76, i32 13, i1 false)
	%77 = load %string, %string* %72
	%78 = load i32**, i32*** %3
	%79 = load i32*, i32** %78
	%80 = load i32, i32* %79
	%81 = getelementptr %string, %string* %72, i32 0, i32 1
	%82 = load i8*, i8** %81
	%83 = call i32 (i8*, ...) @printf(i8* %82, i32 %80)
	%84 = call %string* @newString(i32 14)
	%85 = getelementptr %string, %string* %84, i32 0, i32 1
	%86 = load i8*, i8** %85
	%87 = bitcast i8* %86 to i8*
	%88 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %87, i8* %88, i32 14, i1 false)
	%89 = load %string, %string* %84
	%90 = load i32***, i32**** %4
	%91 = load i32**, i32*** %90
	%92 = load i32*, i32** %91
	%93 = load i32, i32* %92
	%94 = getelementptr %string, %string* %84, i32 0, i32 1
	%95 = load i8*, i8** %94
	%96 = call i32 (i8*, ...) @printf(i8* %95, i32 %93)
	%97 = load i32*, i32** %2
	%98 = load i32, i32* %97
	store i32 300, i32* %97
	%99 = call %string* @newString(i32 7)
	%100 = getelementptr %string, %string* %99, i32 0, i32 1
	%101 = load i8*, i8** %100
	%102 = bitcast i8* %101 to i8*
	%103 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %102, i8* %103, i32 7, i1 false)
	%104 = load %string, %string* %99
	%105 = load i32, i32* %1
	%106 = getelementptr %string, %string* %99, i32 0, i32 1
	%107 = load i8*, i8** %106
	%108 = call i32 (i8*, ...) @printf(i8* %107, i32 %105)
	%109 = call %string* @newString(i32 12)
	%110 = getelementptr %string, %string* %109, i32 0, i32 1
	%111 = load i8*, i8** %110
	%112 = bitcast i8* %111 to i8*
	%113 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.9, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %112, i8* %113, i32 12, i1 false)
	%114 = load %string, %string* %109
	%115 = load i32*, i32** %2
	%116 = load i32, i32* %115
	%117 = getelementptr %string, %string* %109, i32 0, i32 1
	%118 = load i8*, i8** %117
	%119 = call i32 (i8*, ...) @printf(i8* %118, i32 %116)
	%120 = call %string* @newString(i32 13)
	%121 = getelementptr %string, %string* %120, i32 0, i32 1
	%122 = load i8*, i8** %121
	%123 = bitcast i8* %122 to i8*
	%124 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.10, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %123, i8* %124, i32 13, i1 false)
	%125 = load %string, %string* %120
	%126 = load i32**, i32*** %3
	%127 = load i32*, i32** %126
	%128 = load i32, i32* %127
	%129 = getelementptr %string, %string* %120, i32 0, i32 1
	%130 = load i8*, i8** %129
	%131 = call i32 (i8*, ...) @printf(i8* %130, i32 %128)
	%132 = call %string* @newString(i32 14)
	%133 = getelementptr %string, %string* %132, i32 0, i32 1
	%134 = load i8*, i8** %133
	%135 = bitcast i8* %134 to i8*
	%136 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.11, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %135, i8* %136, i32 14, i1 false)
	%137 = load %string, %string* %132
	%138 = load i32***, i32**** %4
	%139 = load i32**, i32*** %138
	%140 = load i32*, i32** %139
	%141 = load i32, i32* %140
	%142 = getelementptr %string, %string* %132, i32 0, i32 1
	%143 = load i8*, i8** %142
	%144 = call i32 (i8*, ...) @printf(i8* %143, i32 %141)
	%145 = load i32**, i32*** %3
	%146 = load i32*, i32** %145
	%147 = load i32, i32* %146
	store i32 400, i32* %146
	%148 = call %string* @newString(i32 7)
	%149 = getelementptr %string, %string* %148, i32 0, i32 1
	%150 = load i8*, i8** %149
	%151 = bitcast i8* %150 to i8*
	%152 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.12, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %151, i8* %152, i32 7, i1 false)
	%153 = load %string, %string* %148
	%154 = load i32, i32* %1
	%155 = getelementptr %string, %string* %148, i32 0, i32 1
	%156 = load i8*, i8** %155
	%157 = call i32 (i8*, ...) @printf(i8* %156, i32 %154)
	%158 = call %string* @newString(i32 12)
	%159 = getelementptr %string, %string* %158, i32 0, i32 1
	%160 = load i8*, i8** %159
	%161 = bitcast i8* %160 to i8*
	%162 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.13, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %161, i8* %162, i32 12, i1 false)
	%163 = load %string, %string* %158
	%164 = load i32*, i32** %2
	%165 = load i32, i32* %164
	%166 = getelementptr %string, %string* %158, i32 0, i32 1
	%167 = load i8*, i8** %166
	%168 = call i32 (i8*, ...) @printf(i8* %167, i32 %165)
	%169 = call %string* @newString(i32 13)
	%170 = getelementptr %string, %string* %169, i32 0, i32 1
	%171 = load i8*, i8** %170
	%172 = bitcast i8* %171 to i8*
	%173 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.14, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %172, i8* %173, i32 13, i1 false)
	%174 = load %string, %string* %169
	%175 = load i32**, i32*** %3
	%176 = load i32*, i32** %175
	%177 = load i32, i32* %176
	%178 = getelementptr %string, %string* %169, i32 0, i32 1
	%179 = load i8*, i8** %178
	%180 = call i32 (i8*, ...) @printf(i8* %179, i32 %177)
	%181 = call %string* @newString(i32 14)
	%182 = getelementptr %string, %string* %181, i32 0, i32 1
	%183 = load i8*, i8** %182
	%184 = bitcast i8* %183 to i8*
	%185 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.15, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %184, i8* %185, i32 14, i1 false)
	%186 = load %string, %string* %181
	%187 = load i32***, i32**** %4
	%188 = load i32**, i32*** %187
	%189 = load i32*, i32** %188
	%190 = load i32, i32* %189
	%191 = getelementptr %string, %string* %181, i32 0, i32 1
	%192 = load i8*, i8** %191
	%193 = call i32 (i8*, ...) @printf(i8* %192, i32 %190)
	%194 = load i32***, i32**** %4
	%195 = load i32**, i32*** %194
	%196 = load i32*, i32** %195
	%197 = load i32, i32* %196
	store i32 500, i32* %196
	%198 = call %string* @newString(i32 7)
	%199 = getelementptr %string, %string* %198, i32 0, i32 1
	%200 = load i8*, i8** %199
	%201 = bitcast i8* %200 to i8*
	%202 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.16, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %201, i8* %202, i32 7, i1 false)
	%203 = load %string, %string* %198
	%204 = load i32, i32* %1
	%205 = getelementptr %string, %string* %198, i32 0, i32 1
	%206 = load i8*, i8** %205
	%207 = call i32 (i8*, ...) @printf(i8* %206, i32 %204)
	%208 = call %string* @newString(i32 12)
	%209 = getelementptr %string, %string* %208, i32 0, i32 1
	%210 = load i8*, i8** %209
	%211 = bitcast i8* %210 to i8*
	%212 = bitcast i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.17, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %211, i8* %212, i32 12, i1 false)
	%213 = load %string, %string* %208
	%214 = load i32*, i32** %2
	%215 = load i32, i32* %214
	%216 = getelementptr %string, %string* %208, i32 0, i32 1
	%217 = load i8*, i8** %216
	%218 = call i32 (i8*, ...) @printf(i8* %217, i32 %215)
	%219 = call %string* @newString(i32 13)
	%220 = getelementptr %string, %string* %219, i32 0, i32 1
	%221 = load i8*, i8** %220
	%222 = bitcast i8* %221 to i8*
	%223 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.18, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %222, i8* %223, i32 13, i1 false)
	%224 = load %string, %string* %219
	%225 = load i32**, i32*** %3
	%226 = load i32*, i32** %225
	%227 = load i32, i32* %226
	%228 = getelementptr %string, %string* %219, i32 0, i32 1
	%229 = load i8*, i8** %228
	%230 = call i32 (i8*, ...) @printf(i8* %229, i32 %227)
	%231 = call %string* @newString(i32 14)
	%232 = getelementptr %string, %string* %231, i32 0, i32 1
	%233 = load i8*, i8** %232
	%234 = bitcast i8* %233 to i8*
	%235 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.19, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %234, i8* %235, i32 14, i1 false)
	%236 = load %string, %string* %231
	%237 = load i32***, i32**** %4
	%238 = load i32**, i32*** %237
	%239 = load i32*, i32** %238
	%240 = load i32, i32* %239
	%241 = getelementptr %string, %string* %231, i32 0, i32 1
	%242 = load i8*, i8** %241
	%243 = call i32 (i8*, ...) @printf(i8* %242, i32 %240)
	; end block
	ret void
}

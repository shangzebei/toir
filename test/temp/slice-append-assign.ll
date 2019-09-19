%mapStruct = type {}
%string = type { i32, i8* }
%return.5.0 = type { i8*, i32 }

@main.main.0 = constant [3 x i32] [i32 1, i32 2, i32 8]
@str.0 = constant [30 x i8] c"a = len(%d) cap(%d) %d %d %d\0A\00"
@str.1 = constant [33 x i8] c"a = len(%d) cap(%d) %d %d %d %d\0A\00"
@str.2 = constant [36 x i8] c"a = len(%d) cap(%d) %d %d %d %d %d\0A\00"
@str.3 = constant [39 x i8] c"b = len(%d) cap(%d) %d %d %d %d %d %d\0A\00"
@str.4 = constant [39 x i8] c"a = len(%d) cap(%d) %d %d %d %d %d %d\0A\00"
@str.5 = constant [42 x i8] c"b = len(%d) cap(%d) %d %d %d %d %d %d %d\0A\00"

declare i8* @malloc(i32)

define void @slice.init.aTMy({ i32, i32, i32, i32* }* %ptr, i32 %len) {
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

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 16)
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

declare i32 @printf(i8*, ...)

define %return.5.0 @runtime.checkGrow(i8* %ptr, i32 %len, i32 %cap, i32 %bytes, i32 %insert) {
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
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 3, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [3 x i32]* @main.main.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 12, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call %string* @runtime.newString(i32 29)
	%10 = getelementptr %string, %string* %9, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* getelementptr inbounds ([30 x i8], [30 x i8]* @str.0, i64 0, i64 0) to i8*
	%14 = getelementptr %string, %string* %9, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = add i32 %15, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 %16, i1 false)
	%17 = load %string, %string* %9
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%19 = load i32, i32* %18
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%21 = load i32, i32* %20
	; get slice index
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%23 = load i32*, i32** %22
	%24 = getelementptr i32, i32* %23, i32 0
	%25 = load i32, i32* %24
	; get slice index
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%27 = load i32*, i32** %26
	%28 = getelementptr i32, i32* %27, i32 1
	%29 = load i32, i32* %28
	; get slice index
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%31 = load i32*, i32** %30
	%32 = getelementptr i32, i32* %31, i32 2
	%33 = load i32, i32* %32
	%34 = getelementptr %string, %string* %9, i32 0, i32 1
	%35 = load i8*, i8** %34
	%36 = call i32 (i8*, ...) @printf(i8* %35, i32 %19, i32 %21, i32 %25, i32 %29, i32 %33)
	; append start---------------------
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%38 = load i32*, i32** %37
	%39 = bitcast i32* %38 to i8*
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%41 = load i32, i32* %40
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%43 = load i32, i32* %42
	%44 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%45 = load i32, i32* %44
	%46 = call %return.5.0 @runtime.checkGrow(i8* %39, i32 %41, i32 %43, i32 %45, i32 1)
	%47 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%48 = load i32, i32* %47
	; copy and new slice
	%49 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%50 = load i32, i32* %49
	%51 = call i8* @malloc(i32 24)
	%52 = bitcast i8* %51 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %52, i32 %50)
	%53 = bitcast { i32, i32, i32, i32* }* %52 to i8*
	%54 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %53, i8* %54, i32 24, i1 false)
	; copy and end slice
	%55 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %52, i32 0, i32 3
	%56 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %52, i32 0, i32 0
	%57 = extractvalue %return.5.0 %46, 0
	%58 = extractvalue %return.5.0 %46, 1
	%59 = bitcast i8* %57 to i32*
	store i32* %59, i32** %55
	; store value
	%60 = load i32*, i32** %55
	%61 = bitcast i32* %60 to i32*
	%62 = add i32 %48, 0
	%63 = getelementptr i32, i32* %61, i32 %62
	store i32 4, i32* %63
	; add len
	%64 = add i32 %48, 1
	store i32 %64, i32* %56
	%65 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %52, i32 0, i32 1
	store i32 %58, i32* %65
	; append end-------------------------
	%66 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %52
	store { i32, i32, i32, i32* } %66, { i32, i32, i32, i32* }* %2
	%67 = call %string* @runtime.newString(i32 32)
	%68 = getelementptr %string, %string* %67, i32 0, i32 1
	%69 = load i8*, i8** %68
	%70 = bitcast i8* %69 to i8*
	%71 = bitcast i8* getelementptr inbounds ([33 x i8], [33 x i8]* @str.1, i64 0, i64 0) to i8*
	%72 = getelementptr %string, %string* %67, i32 0, i32 0
	%73 = load i32, i32* %72
	%74 = add i32 %73, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %70, i8* %71, i32 %74, i1 false)
	%75 = load %string, %string* %67
	%76 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%77 = load i32, i32* %76
	%78 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%79 = load i32, i32* %78
	; get slice index
	%80 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%81 = load i32*, i32** %80
	%82 = getelementptr i32, i32* %81, i32 0
	%83 = load i32, i32* %82
	; get slice index
	%84 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%85 = load i32*, i32** %84
	%86 = getelementptr i32, i32* %85, i32 1
	%87 = load i32, i32* %86
	; get slice index
	%88 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%89 = load i32*, i32** %88
	%90 = getelementptr i32, i32* %89, i32 2
	%91 = load i32, i32* %90
	; get slice index
	%92 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%93 = load i32*, i32** %92
	%94 = getelementptr i32, i32* %93, i32 3
	%95 = load i32, i32* %94
	%96 = getelementptr %string, %string* %67, i32 0, i32 1
	%97 = load i8*, i8** %96
	%98 = call i32 (i8*, ...) @printf(i8* %97, i32 %77, i32 %79, i32 %83, i32 %87, i32 %91, i32 %95)
	; append start---------------------
	%99 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%100 = load i32*, i32** %99
	%101 = bitcast i32* %100 to i8*
	%102 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%103 = load i32, i32* %102
	%104 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%105 = load i32, i32* %104
	%106 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%107 = load i32, i32* %106
	%108 = call %return.5.0 @runtime.checkGrow(i8* %101, i32 %103, i32 %105, i32 %107, i32 1)
	%109 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%110 = load i32, i32* %109
	; copy and new slice
	%111 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%112 = load i32, i32* %111
	%113 = call i8* @malloc(i32 24)
	%114 = bitcast i8* %113 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %114, i32 %112)
	%115 = bitcast { i32, i32, i32, i32* }* %114 to i8*
	%116 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %115, i8* %116, i32 24, i1 false)
	; copy and end slice
	%117 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %114, i32 0, i32 3
	%118 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %114, i32 0, i32 0
	%119 = extractvalue %return.5.0 %108, 0
	%120 = extractvalue %return.5.0 %108, 1
	%121 = bitcast i8* %119 to i32*
	store i32* %121, i32** %117
	; store value
	%122 = load i32*, i32** %117
	%123 = bitcast i32* %122 to i32*
	%124 = add i32 %110, 0
	%125 = getelementptr i32, i32* %123, i32 %124
	store i32 5000, i32* %125
	; add len
	%126 = add i32 %110, 1
	store i32 %126, i32* %118
	%127 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %114, i32 0, i32 1
	store i32 %120, i32* %127
	; append end-------------------------
	%128 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %114
	store { i32, i32, i32, i32* } %128, { i32, i32, i32, i32* }* %2
	%129 = call %string* @runtime.newString(i32 35)
	%130 = getelementptr %string, %string* %129, i32 0, i32 1
	%131 = load i8*, i8** %130
	%132 = bitcast i8* %131 to i8*
	%133 = bitcast i8* getelementptr inbounds ([36 x i8], [36 x i8]* @str.2, i64 0, i64 0) to i8*
	%134 = getelementptr %string, %string* %129, i32 0, i32 0
	%135 = load i32, i32* %134
	%136 = add i32 %135, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %132, i8* %133, i32 %136, i1 false)
	%137 = load %string, %string* %129
	%138 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%139 = load i32, i32* %138
	%140 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%141 = load i32, i32* %140
	; get slice index
	%142 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%143 = load i32*, i32** %142
	%144 = getelementptr i32, i32* %143, i32 0
	%145 = load i32, i32* %144
	; get slice index
	%146 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%147 = load i32*, i32** %146
	%148 = getelementptr i32, i32* %147, i32 1
	%149 = load i32, i32* %148
	; get slice index
	%150 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%151 = load i32*, i32** %150
	%152 = getelementptr i32, i32* %151, i32 2
	%153 = load i32, i32* %152
	; get slice index
	%154 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%155 = load i32*, i32** %154
	%156 = getelementptr i32, i32* %155, i32 3
	%157 = load i32, i32* %156
	; get slice index
	%158 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%159 = load i32*, i32** %158
	%160 = getelementptr i32, i32* %159, i32 4
	%161 = load i32, i32* %160
	%162 = getelementptr %string, %string* %129, i32 0, i32 1
	%163 = load i8*, i8** %162
	%164 = call i32 (i8*, ...) @printf(i8* %163, i32 %139, i32 %141, i32 %145, i32 %149, i32 %153, i32 %157, i32 %161)
	; append start---------------------
	%165 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%166 = load i32*, i32** %165
	%167 = bitcast i32* %166 to i8*
	%168 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%169 = load i32, i32* %168
	%170 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%171 = load i32, i32* %170
	%172 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%173 = load i32, i32* %172
	%174 = call %return.5.0 @runtime.checkGrow(i8* %167, i32 %169, i32 %171, i32 %173, i32 1)
	%175 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%176 = load i32, i32* %175
	; copy and new slice
	%177 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%178 = load i32, i32* %177
	%179 = call i8* @malloc(i32 24)
	%180 = bitcast i8* %179 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %180, i32 %178)
	%181 = bitcast { i32, i32, i32, i32* }* %180 to i8*
	%182 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %181, i8* %182, i32 24, i1 false)
	; copy and end slice
	%183 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%184 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 0
	%185 = extractvalue %return.5.0 %174, 0
	%186 = extractvalue %return.5.0 %174, 1
	%187 = bitcast i8* %185 to i32*
	store i32* %187, i32** %183
	; store value
	%188 = load i32*, i32** %183
	%189 = bitcast i32* %188 to i32*
	%190 = add i32 %176, 0
	%191 = getelementptr i32, i32* %189, i32 %190
	store i32 6000, i32* %191
	; add len
	%192 = add i32 %176, 1
	store i32 %192, i32* %184
	%193 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 1
	store i32 %186, i32* %193
	; append end-------------------------
	%194 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180
	%195 = call %string* @runtime.newString(i32 38)
	%196 = getelementptr %string, %string* %195, i32 0, i32 1
	%197 = load i8*, i8** %196
	%198 = bitcast i8* %197 to i8*
	%199 = bitcast i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.3, i64 0, i64 0) to i8*
	%200 = getelementptr %string, %string* %195, i32 0, i32 0
	%201 = load i32, i32* %200
	%202 = add i32 %201, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %198, i8* %199, i32 %202, i1 false)
	%203 = load %string, %string* %195
	%204 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 0
	%205 = load i32, i32* %204
	%206 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 1
	%207 = load i32, i32* %206
	; get slice index
	%208 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%209 = load i32*, i32** %208
	%210 = getelementptr i32, i32* %209, i32 0
	%211 = load i32, i32* %210
	; get slice index
	%212 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%213 = load i32*, i32** %212
	%214 = getelementptr i32, i32* %213, i32 1
	%215 = load i32, i32* %214
	; get slice index
	%216 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%217 = load i32*, i32** %216
	%218 = getelementptr i32, i32* %217, i32 2
	%219 = load i32, i32* %218
	; get slice index
	%220 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%221 = load i32*, i32** %220
	%222 = getelementptr i32, i32* %221, i32 3
	%223 = load i32, i32* %222
	; get slice index
	%224 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%225 = load i32*, i32** %224
	%226 = getelementptr i32, i32* %225, i32 4
	%227 = load i32, i32* %226
	; get slice index
	%228 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%229 = load i32*, i32** %228
	%230 = getelementptr i32, i32* %229, i32 5
	%231 = load i32, i32* %230
	%232 = getelementptr %string, %string* %195, i32 0, i32 1
	%233 = load i8*, i8** %232
	%234 = call i32 (i8*, ...) @printf(i8* %233, i32 %205, i32 %207, i32 %211, i32 %215, i32 %219, i32 %223, i32 %227, i32 %231)
	; append start---------------------
	%235 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%236 = load i32*, i32** %235
	%237 = bitcast i32* %236 to i8*
	%238 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%239 = load i32, i32* %238
	%240 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%241 = load i32, i32* %240
	%242 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%243 = load i32, i32* %242
	%244 = call %return.5.0 @runtime.checkGrow(i8* %237, i32 %239, i32 %241, i32 %243, i32 1)
	%245 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%246 = load i32, i32* %245
	; copy and new slice
	%247 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%248 = load i32, i32* %247
	%249 = call i8* @malloc(i32 24)
	%250 = bitcast i8* %249 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %250, i32 %248)
	%251 = bitcast { i32, i32, i32, i32* }* %250 to i8*
	%252 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %251, i8* %252, i32 24, i1 false)
	; copy and end slice
	%253 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %250, i32 0, i32 3
	%254 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %250, i32 0, i32 0
	%255 = extractvalue %return.5.0 %244, 0
	%256 = extractvalue %return.5.0 %244, 1
	%257 = bitcast i8* %255 to i32*
	store i32* %257, i32** %253
	; store value
	%258 = load i32*, i32** %253
	%259 = bitcast i32* %258 to i32*
	%260 = add i32 %246, 0
	%261 = getelementptr i32, i32* %259, i32 %260
	store i32 7000, i32* %261
	; add len
	%262 = add i32 %246, 1
	store i32 %262, i32* %254
	%263 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %250, i32 0, i32 1
	store i32 %256, i32* %263
	; append end-------------------------
	%264 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %250
	store { i32, i32, i32, i32* } %264, { i32, i32, i32, i32* }* %2
	%265 = call %string* @runtime.newString(i32 38)
	%266 = getelementptr %string, %string* %265, i32 0, i32 1
	%267 = load i8*, i8** %266
	%268 = bitcast i8* %267 to i8*
	%269 = bitcast i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.4, i64 0, i64 0) to i8*
	%270 = getelementptr %string, %string* %265, i32 0, i32 0
	%271 = load i32, i32* %270
	%272 = add i32 %271, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %268, i8* %269, i32 %272, i1 false)
	%273 = load %string, %string* %265
	%274 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%275 = load i32, i32* %274
	%276 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%277 = load i32, i32* %276
	; get slice index
	%278 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%279 = load i32*, i32** %278
	%280 = getelementptr i32, i32* %279, i32 0
	%281 = load i32, i32* %280
	; get slice index
	%282 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%283 = load i32*, i32** %282
	%284 = getelementptr i32, i32* %283, i32 1
	%285 = load i32, i32* %284
	; get slice index
	%286 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%287 = load i32*, i32** %286
	%288 = getelementptr i32, i32* %287, i32 2
	%289 = load i32, i32* %288
	; get slice index
	%290 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%291 = load i32*, i32** %290
	%292 = getelementptr i32, i32* %291, i32 3
	%293 = load i32, i32* %292
	; get slice index
	%294 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%295 = load i32*, i32** %294
	%296 = getelementptr i32, i32* %295, i32 4
	%297 = load i32, i32* %296
	; get slice index
	%298 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%299 = load i32*, i32** %298
	%300 = getelementptr i32, i32* %299, i32 5
	%301 = load i32, i32* %300
	%302 = getelementptr %string, %string* %265, i32 0, i32 1
	%303 = load i8*, i8** %302
	%304 = call i32 (i8*, ...) @printf(i8* %303, i32 %275, i32 %277, i32 %281, i32 %285, i32 %289, i32 %293, i32 %297, i32 %301)
	; append start---------------------
	%305 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%306 = load i32*, i32** %305
	%307 = bitcast i32* %306 to i8*
	%308 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 0
	%309 = load i32, i32* %308
	%310 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 1
	%311 = load i32, i32* %310
	%312 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 2
	%313 = load i32, i32* %312
	%314 = call %return.5.0 @runtime.checkGrow(i8* %307, i32 %309, i32 %311, i32 %313, i32 1)
	%315 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 0
	%316 = load i32, i32* %315
	; copy and new slice
	%317 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 0
	%318 = load i32, i32* %317
	%319 = call i8* @malloc(i32 24)
	%320 = bitcast i8* %319 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %320, i32 %318)
	%321 = bitcast { i32, i32, i32, i32* }* %320 to i8*
	%322 = bitcast { i32, i32, i32, i32* }* %180 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %321, i8* %322, i32 24, i1 false)
	; copy and end slice
	%323 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %320, i32 0, i32 3
	%324 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %320, i32 0, i32 0
	%325 = extractvalue %return.5.0 %314, 0
	%326 = extractvalue %return.5.0 %314, 1
	%327 = bitcast i8* %325 to i32*
	store i32* %327, i32** %323
	; store value
	%328 = load i32*, i32** %323
	%329 = bitcast i32* %328 to i32*
	%330 = add i32 %316, 0
	%331 = getelementptr i32, i32* %329, i32 %330
	store i32 8000, i32* %331
	; add len
	%332 = add i32 %316, 1
	store i32 %332, i32* %324
	%333 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %320, i32 0, i32 1
	store i32 %326, i32* %333
	; append end-------------------------
	%334 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %320
	store { i32, i32, i32, i32* } %334, { i32, i32, i32, i32* }* %180
	%335 = call %string* @runtime.newString(i32 41)
	%336 = getelementptr %string, %string* %335, i32 0, i32 1
	%337 = load i8*, i8** %336
	%338 = bitcast i8* %337 to i8*
	%339 = bitcast i8* getelementptr inbounds ([42 x i8], [42 x i8]* @str.5, i64 0, i64 0) to i8*
	%340 = getelementptr %string, %string* %335, i32 0, i32 0
	%341 = load i32, i32* %340
	%342 = add i32 %341, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %338, i8* %339, i32 %342, i1 false)
	%343 = load %string, %string* %335
	%344 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 0
	%345 = load i32, i32* %344
	%346 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 1
	%347 = load i32, i32* %346
	; get slice index
	%348 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%349 = load i32*, i32** %348
	%350 = getelementptr i32, i32* %349, i32 0
	%351 = load i32, i32* %350
	; get slice index
	%352 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%353 = load i32*, i32** %352
	%354 = getelementptr i32, i32* %353, i32 1
	%355 = load i32, i32* %354
	; get slice index
	%356 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%357 = load i32*, i32** %356
	%358 = getelementptr i32, i32* %357, i32 2
	%359 = load i32, i32* %358
	; get slice index
	%360 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%361 = load i32*, i32** %360
	%362 = getelementptr i32, i32* %361, i32 3
	%363 = load i32, i32* %362
	; get slice index
	%364 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%365 = load i32*, i32** %364
	%366 = getelementptr i32, i32* %365, i32 4
	%367 = load i32, i32* %366
	; get slice index
	%368 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%369 = load i32*, i32** %368
	%370 = getelementptr i32, i32* %369, i32 5
	%371 = load i32, i32* %370
	; get slice index
	%372 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %180, i32 0, i32 3
	%373 = load i32*, i32** %372
	%374 = getelementptr i32, i32* %373, i32 6
	%375 = load i32, i32* %374
	%376 = getelementptr %string, %string* %335, i32 0, i32 1
	%377 = load i8*, i8** %376
	%378 = call i32 (i8*, ...) @printf(i8* %377, i32 %345, i32 %347, i32 %351, i32 %355, i32 %359, i32 %363, i32 %367, i32 %371, i32 %375)
	; end block
	ret void
}

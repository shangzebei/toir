%mapStruct = type {}
%string = type { i32, i8* }
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
	%9 = call %string* @newString(i32 30)
	%10 = getelementptr %string, %string* %9, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* getelementptr inbounds ([30 x i8], [30 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 30, i1 false)
	%14 = load %string, %string* %9
	%15 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%16 = load i32, i32* %15
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%18 = load i32, i32* %17
	; get slice index
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%20 = load i32*, i32** %19
	%21 = getelementptr i32, i32* %20, i32 0
	%22 = load i32, i32* %21
	; get slice index
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%24 = load i32*, i32** %23
	%25 = getelementptr i32, i32* %24, i32 1
	%26 = load i32, i32* %25
	; get slice index
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%28 = load i32*, i32** %27
	%29 = getelementptr i32, i32* %28, i32 2
	%30 = load i32, i32* %29
	%31 = getelementptr %string, %string* %9, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = call i32 (i8*, ...) @printf(i8* %32, i32 %16, i32 %18, i32 %22, i32 %26, i32 %30)
	; append start---------------------
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%35 = load i32*, i32** %34
	%36 = bitcast i32* %35 to i8*
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%38 = load i32, i32* %37
	%39 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%40 = load i32, i32* %39
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%42 = load i32, i32* %41
	%43 = call %return.5.0 @checkGrow(i8* %36, i32 %38, i32 %40, i32 %42, i32 1)
	%44 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%45 = load i32, i32* %44
	; copy and new slice
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%47 = load i32, i32* %46
	%48 = call i8* @malloc(i32 20)
	%49 = bitcast i8* %48 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %49, i32 %47)
	%50 = bitcast { i32, i32, i32, i32* }* %49 to i8*
	%51 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %50, i8* %51, i32 20, i1 false)
	; copy and end slice
	%52 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %49, i32 0, i32 3
	%53 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %49, i32 0, i32 0
	%54 = extractvalue %return.5.0 %43, 0
	%55 = extractvalue %return.5.0 %43, 1
	%56 = bitcast i8* %54 to i32*
	store i32* %56, i32** %52
	; store value
	%57 = load i32*, i32** %52
	%58 = bitcast i32* %57 to i32*
	%59 = add i32 %45, 0
	%60 = getelementptr i32, i32* %58, i32 %59
	store i32 4, i32* %60
	; add len
	%61 = add i32 %45, 1
	store i32 %61, i32* %53
	%62 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %49, i32 0, i32 1
	store i32 %55, i32* %62
	; append end-------------------------
	%63 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %49
	store { i32, i32, i32, i32* } %63, { i32, i32, i32, i32* }* %2
	%64 = call %string* @newString(i32 33)
	%65 = getelementptr %string, %string* %64, i32 0, i32 1
	%66 = load i8*, i8** %65
	%67 = bitcast i8* %66 to i8*
	%68 = bitcast i8* getelementptr inbounds ([33 x i8], [33 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %67, i8* %68, i32 33, i1 false)
	%69 = load %string, %string* %64
	%70 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%71 = load i32, i32* %70
	%72 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%73 = load i32, i32* %72
	; get slice index
	%74 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%75 = load i32*, i32** %74
	%76 = getelementptr i32, i32* %75, i32 0
	%77 = load i32, i32* %76
	; get slice index
	%78 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%79 = load i32*, i32** %78
	%80 = getelementptr i32, i32* %79, i32 1
	%81 = load i32, i32* %80
	; get slice index
	%82 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%83 = load i32*, i32** %82
	%84 = getelementptr i32, i32* %83, i32 2
	%85 = load i32, i32* %84
	; get slice index
	%86 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%87 = load i32*, i32** %86
	%88 = getelementptr i32, i32* %87, i32 3
	%89 = load i32, i32* %88
	%90 = getelementptr %string, %string* %64, i32 0, i32 1
	%91 = load i8*, i8** %90
	%92 = call i32 (i8*, ...) @printf(i8* %91, i32 %71, i32 %73, i32 %77, i32 %81, i32 %85, i32 %89)
	; append start---------------------
	%93 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%94 = load i32*, i32** %93
	%95 = bitcast i32* %94 to i8*
	%96 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%97 = load i32, i32* %96
	%98 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%99 = load i32, i32* %98
	%100 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%101 = load i32, i32* %100
	%102 = call %return.5.0 @checkGrow(i8* %95, i32 %97, i32 %99, i32 %101, i32 1)
	%103 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%104 = load i32, i32* %103
	; copy and new slice
	%105 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%106 = load i32, i32* %105
	%107 = call i8* @malloc(i32 20)
	%108 = bitcast i8* %107 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %108, i32 %106)
	%109 = bitcast { i32, i32, i32, i32* }* %108 to i8*
	%110 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %109, i8* %110, i32 20, i1 false)
	; copy and end slice
	%111 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %108, i32 0, i32 3
	%112 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %108, i32 0, i32 0
	%113 = extractvalue %return.5.0 %102, 0
	%114 = extractvalue %return.5.0 %102, 1
	%115 = bitcast i8* %113 to i32*
	store i32* %115, i32** %111
	; store value
	%116 = load i32*, i32** %111
	%117 = bitcast i32* %116 to i32*
	%118 = add i32 %104, 0
	%119 = getelementptr i32, i32* %117, i32 %118
	store i32 5000, i32* %119
	; add len
	%120 = add i32 %104, 1
	store i32 %120, i32* %112
	%121 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %108, i32 0, i32 1
	store i32 %114, i32* %121
	; append end-------------------------
	%122 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %108
	store { i32, i32, i32, i32* } %122, { i32, i32, i32, i32* }* %2
	%123 = call %string* @newString(i32 36)
	%124 = getelementptr %string, %string* %123, i32 0, i32 1
	%125 = load i8*, i8** %124
	%126 = bitcast i8* %125 to i8*
	%127 = bitcast i8* getelementptr inbounds ([36 x i8], [36 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %126, i8* %127, i32 36, i1 false)
	%128 = load %string, %string* %123
	%129 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%130 = load i32, i32* %129
	%131 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%132 = load i32, i32* %131
	; get slice index
	%133 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%134 = load i32*, i32** %133
	%135 = getelementptr i32, i32* %134, i32 0
	%136 = load i32, i32* %135
	; get slice index
	%137 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%138 = load i32*, i32** %137
	%139 = getelementptr i32, i32* %138, i32 1
	%140 = load i32, i32* %139
	; get slice index
	%141 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%142 = load i32*, i32** %141
	%143 = getelementptr i32, i32* %142, i32 2
	%144 = load i32, i32* %143
	; get slice index
	%145 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%146 = load i32*, i32** %145
	%147 = getelementptr i32, i32* %146, i32 3
	%148 = load i32, i32* %147
	; get slice index
	%149 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%150 = load i32*, i32** %149
	%151 = getelementptr i32, i32* %150, i32 4
	%152 = load i32, i32* %151
	%153 = getelementptr %string, %string* %123, i32 0, i32 1
	%154 = load i8*, i8** %153
	%155 = call i32 (i8*, ...) @printf(i8* %154, i32 %130, i32 %132, i32 %136, i32 %140, i32 %144, i32 %148, i32 %152)
	; append start---------------------
	%156 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%157 = load i32*, i32** %156
	%158 = bitcast i32* %157 to i8*
	%159 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%160 = load i32, i32* %159
	%161 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%162 = load i32, i32* %161
	%163 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%164 = load i32, i32* %163
	%165 = call %return.5.0 @checkGrow(i8* %158, i32 %160, i32 %162, i32 %164, i32 1)
	%166 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%167 = load i32, i32* %166
	; copy and new slice
	%168 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%169 = load i32, i32* %168
	%170 = call i8* @malloc(i32 20)
	%171 = bitcast i8* %170 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %171, i32 %169)
	%172 = bitcast { i32, i32, i32, i32* }* %171 to i8*
	%173 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %172, i8* %173, i32 20, i1 false)
	; copy and end slice
	%174 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%175 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 0
	%176 = extractvalue %return.5.0 %165, 0
	%177 = extractvalue %return.5.0 %165, 1
	%178 = bitcast i8* %176 to i32*
	store i32* %178, i32** %174
	; store value
	%179 = load i32*, i32** %174
	%180 = bitcast i32* %179 to i32*
	%181 = add i32 %167, 0
	%182 = getelementptr i32, i32* %180, i32 %181
	store i32 6000, i32* %182
	; add len
	%183 = add i32 %167, 1
	store i32 %183, i32* %175
	%184 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 1
	store i32 %177, i32* %184
	; append end-------------------------
	%185 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171
	%186 = call %string* @newString(i32 39)
	%187 = getelementptr %string, %string* %186, i32 0, i32 1
	%188 = load i8*, i8** %187
	%189 = bitcast i8* %188 to i8*
	%190 = bitcast i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %189, i8* %190, i32 39, i1 false)
	%191 = load %string, %string* %186
	%192 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 0
	%193 = load i32, i32* %192
	%194 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 1
	%195 = load i32, i32* %194
	; get slice index
	%196 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%197 = load i32*, i32** %196
	%198 = getelementptr i32, i32* %197, i32 0
	%199 = load i32, i32* %198
	; get slice index
	%200 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%201 = load i32*, i32** %200
	%202 = getelementptr i32, i32* %201, i32 1
	%203 = load i32, i32* %202
	; get slice index
	%204 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%205 = load i32*, i32** %204
	%206 = getelementptr i32, i32* %205, i32 2
	%207 = load i32, i32* %206
	; get slice index
	%208 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%209 = load i32*, i32** %208
	%210 = getelementptr i32, i32* %209, i32 3
	%211 = load i32, i32* %210
	; get slice index
	%212 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%213 = load i32*, i32** %212
	%214 = getelementptr i32, i32* %213, i32 4
	%215 = load i32, i32* %214
	; get slice index
	%216 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%217 = load i32*, i32** %216
	%218 = getelementptr i32, i32* %217, i32 5
	%219 = load i32, i32* %218
	%220 = getelementptr %string, %string* %186, i32 0, i32 1
	%221 = load i8*, i8** %220
	%222 = call i32 (i8*, ...) @printf(i8* %221, i32 %193, i32 %195, i32 %199, i32 %203, i32 %207, i32 %211, i32 %215, i32 %219)
	; append start---------------------
	%223 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%224 = load i32*, i32** %223
	%225 = bitcast i32* %224 to i8*
	%226 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%227 = load i32, i32* %226
	%228 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%229 = load i32, i32* %228
	%230 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%231 = load i32, i32* %230
	%232 = call %return.5.0 @checkGrow(i8* %225, i32 %227, i32 %229, i32 %231, i32 1)
	%233 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%234 = load i32, i32* %233
	; copy and new slice
	%235 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%236 = load i32, i32* %235
	%237 = call i8* @malloc(i32 20)
	%238 = bitcast i8* %237 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %238, i32 %236)
	%239 = bitcast { i32, i32, i32, i32* }* %238 to i8*
	%240 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %239, i8* %240, i32 20, i1 false)
	; copy and end slice
	%241 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %238, i32 0, i32 3
	%242 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %238, i32 0, i32 0
	%243 = extractvalue %return.5.0 %232, 0
	%244 = extractvalue %return.5.0 %232, 1
	%245 = bitcast i8* %243 to i32*
	store i32* %245, i32** %241
	; store value
	%246 = load i32*, i32** %241
	%247 = bitcast i32* %246 to i32*
	%248 = add i32 %234, 0
	%249 = getelementptr i32, i32* %247, i32 %248
	store i32 7000, i32* %249
	; add len
	%250 = add i32 %234, 1
	store i32 %250, i32* %242
	%251 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %238, i32 0, i32 1
	store i32 %244, i32* %251
	; append end-------------------------
	%252 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %238
	store { i32, i32, i32, i32* } %252, { i32, i32, i32, i32* }* %2
	%253 = call %string* @newString(i32 39)
	%254 = getelementptr %string, %string* %253, i32 0, i32 1
	%255 = load i8*, i8** %254
	%256 = bitcast i8* %255 to i8*
	%257 = bitcast i8* getelementptr inbounds ([39 x i8], [39 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %256, i8* %257, i32 39, i1 false)
	%258 = load %string, %string* %253
	%259 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%260 = load i32, i32* %259
	%261 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%262 = load i32, i32* %261
	; get slice index
	%263 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%264 = load i32*, i32** %263
	%265 = getelementptr i32, i32* %264, i32 0
	%266 = load i32, i32* %265
	; get slice index
	%267 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%268 = load i32*, i32** %267
	%269 = getelementptr i32, i32* %268, i32 1
	%270 = load i32, i32* %269
	; get slice index
	%271 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%272 = load i32*, i32** %271
	%273 = getelementptr i32, i32* %272, i32 2
	%274 = load i32, i32* %273
	; get slice index
	%275 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%276 = load i32*, i32** %275
	%277 = getelementptr i32, i32* %276, i32 3
	%278 = load i32, i32* %277
	; get slice index
	%279 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%280 = load i32*, i32** %279
	%281 = getelementptr i32, i32* %280, i32 4
	%282 = load i32, i32* %281
	; get slice index
	%283 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%284 = load i32*, i32** %283
	%285 = getelementptr i32, i32* %284, i32 5
	%286 = load i32, i32* %285
	%287 = getelementptr %string, %string* %253, i32 0, i32 1
	%288 = load i8*, i8** %287
	%289 = call i32 (i8*, ...) @printf(i8* %288, i32 %260, i32 %262, i32 %266, i32 %270, i32 %274, i32 %278, i32 %282, i32 %286)
	; append start---------------------
	%290 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%291 = load i32*, i32** %290
	%292 = bitcast i32* %291 to i8*
	%293 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 0
	%294 = load i32, i32* %293
	%295 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 1
	%296 = load i32, i32* %295
	%297 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 2
	%298 = load i32, i32* %297
	%299 = call %return.5.0 @checkGrow(i8* %292, i32 %294, i32 %296, i32 %298, i32 1)
	%300 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 0
	%301 = load i32, i32* %300
	; copy and new slice
	%302 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 0
	%303 = load i32, i32* %302
	%304 = call i8* @malloc(i32 20)
	%305 = bitcast i8* %304 to { i32, i32, i32, i32* }*
	call void @init_slice_i32({ i32, i32, i32, i32* }* %305, i32 %303)
	%306 = bitcast { i32, i32, i32, i32* }* %305 to i8*
	%307 = bitcast { i32, i32, i32, i32* }* %171 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %306, i8* %307, i32 20, i1 false)
	; copy and end slice
	%308 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %305, i32 0, i32 3
	%309 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %305, i32 0, i32 0
	%310 = extractvalue %return.5.0 %299, 0
	%311 = extractvalue %return.5.0 %299, 1
	%312 = bitcast i8* %310 to i32*
	store i32* %312, i32** %308
	; store value
	%313 = load i32*, i32** %308
	%314 = bitcast i32* %313 to i32*
	%315 = add i32 %301, 0
	%316 = getelementptr i32, i32* %314, i32 %315
	store i32 8000, i32* %316
	; add len
	%317 = add i32 %301, 1
	store i32 %317, i32* %309
	%318 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %305, i32 0, i32 1
	store i32 %311, i32* %318
	; append end-------------------------
	%319 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %305
	store { i32, i32, i32, i32* } %319, { i32, i32, i32, i32* }* %171
	%320 = call %string* @newString(i32 42)
	%321 = getelementptr %string, %string* %320, i32 0, i32 1
	%322 = load i8*, i8** %321
	%323 = bitcast i8* %322 to i8*
	%324 = bitcast i8* getelementptr inbounds ([42 x i8], [42 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %323, i8* %324, i32 42, i1 false)
	%325 = load %string, %string* %320
	%326 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 0
	%327 = load i32, i32* %326
	%328 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 1
	%329 = load i32, i32* %328
	; get slice index
	%330 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%331 = load i32*, i32** %330
	%332 = getelementptr i32, i32* %331, i32 0
	%333 = load i32, i32* %332
	; get slice index
	%334 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%335 = load i32*, i32** %334
	%336 = getelementptr i32, i32* %335, i32 1
	%337 = load i32, i32* %336
	; get slice index
	%338 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%339 = load i32*, i32** %338
	%340 = getelementptr i32, i32* %339, i32 2
	%341 = load i32, i32* %340
	; get slice index
	%342 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%343 = load i32*, i32** %342
	%344 = getelementptr i32, i32* %343, i32 3
	%345 = load i32, i32* %344
	; get slice index
	%346 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%347 = load i32*, i32** %346
	%348 = getelementptr i32, i32* %347, i32 4
	%349 = load i32, i32* %348
	; get slice index
	%350 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%351 = load i32*, i32** %350
	%352 = getelementptr i32, i32* %351, i32 5
	%353 = load i32, i32* %352
	; get slice index
	%354 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %171, i32 0, i32 3
	%355 = load i32*, i32** %354
	%356 = getelementptr i32, i32* %355, i32 6
	%357 = load i32, i32* %356
	%358 = getelementptr %string, %string* %320, i32 0, i32 1
	%359 = load i8*, i8** %358
	%360 = call i32 (i8*, ...) @printf(i8* %359, i32 %327, i32 %329, i32 %333, i32 %337, i32 %341, i32 %345, i32 %349, i32 %353, i32 %357)
	; end block
	ret void
}

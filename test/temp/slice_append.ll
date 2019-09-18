%mapStruct = type {}
%string = type { i32, i8* }
%return.5.0 = type { i8*, i32 }

@main.test.sli1.0 = constant [1 x i32] [i32 100]
@str.0 = constant [8 x i8] c"len-%d\0A\00"
@str.1 = constant [8 x i8] c"len-%d\0A\00"
@str.2 = constant [8 x i8] c"len-%d\0A\00"
@str.3 = constant [4 x i8] c"%d\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [4 x i8] c"%d\0A\00"
@main.test.sli2.7 = constant [1 x i32] [i32 100]
@str.6 = constant [15 x i8] c"len-%d cap-%d\0A\00"
@main.test.sli3.9 = constant [3 x i32] [i32 1, i32 2, i32 3]
@str.7 = constant [15 x i8] c"len-%d cap-%d\0A\00"
@str.8 = constant [4 x i8] c"%d\0A\00"
@main.test.othSli.12 = constant [3 x float] [float 1.0, float 2.0, float 3.0]
@str.9 = constant [6 x i8] c"%.2g\0A\00"

declare i8* @malloc(i32)

define void @slice.init.i32({ i32, i32, i32, i32* }* %ptr, i32 %len) {
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

define void @test.sli1() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %2, i32 1)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 1, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [1 x i32]* @main.test.sli1.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 4, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call %string* @runtime.newString(i32 7)
	%10 = getelementptr %string, %string* %9, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.0, i64 0, i64 0) to i8*
	%14 = getelementptr %string, %string* %9, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = add i32 %15, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 %16, i1 false)
	%17 = load %string, %string* %9
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%19 = load i32, i32* %18
	%20 = getelementptr %string, %string* %9, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = call i32 (i8*, ...) @printf(i8* %21, i32 %19)
	; append start---------------------
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%24 = load i32*, i32** %23
	%25 = bitcast i32* %24 to i8*
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%29 = load i32, i32* %28
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%31 = load i32, i32* %30
	%32 = call %return.5.0 @runtime.checkGrow(i8* %25, i32 %27, i32 %29, i32 %31, i32 1)
	%33 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%34 = load i32, i32* %33
	; copy and new slice
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%36 = load i32, i32* %35
	%37 = call i8* @malloc(i32 20)
	%38 = bitcast i8* %37 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %38, i32 %36)
	%39 = bitcast { i32, i32, i32, i32* }* %38 to i8*
	%40 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %39, i8* %40, i32 20, i1 false)
	; copy and end slice
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %38, i32 0, i32 3
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %38, i32 0, i32 0
	%43 = extractvalue %return.5.0 %32, 0
	%44 = extractvalue %return.5.0 %32, 1
	%45 = bitcast i8* %43 to i32*
	store i32* %45, i32** %41
	; store value
	%46 = load i32*, i32** %41
	%47 = bitcast i32* %46 to i32*
	%48 = add i32 %34, 0
	%49 = getelementptr i32, i32* %47, i32 %48
	store i32 11, i32* %49
	; add len
	%50 = add i32 %34, 1
	store i32 %50, i32* %42
	%51 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %38, i32 0, i32 1
	store i32 %44, i32* %51
	; append end-------------------------
	%52 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %38
	store { i32, i32, i32, i32* } %52, { i32, i32, i32, i32* }* %2
	%53 = call %string* @runtime.newString(i32 7)
	%54 = getelementptr %string, %string* %53, i32 0, i32 1
	%55 = load i8*, i8** %54
	%56 = bitcast i8* %55 to i8*
	%57 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.1, i64 0, i64 0) to i8*
	%58 = getelementptr %string, %string* %53, i32 0, i32 0
	%59 = load i32, i32* %58
	%60 = add i32 %59, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %56, i8* %57, i32 %60, i1 false)
	%61 = load %string, %string* %53
	%62 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%63 = load i32, i32* %62
	%64 = getelementptr %string, %string* %53, i32 0, i32 1
	%65 = load i8*, i8** %64
	%66 = call i32 (i8*, ...) @printf(i8* %65, i32 %63)
	; append start---------------------
	%67 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%68 = load i32*, i32** %67
	%69 = bitcast i32* %68 to i8*
	%70 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%71 = load i32, i32* %70
	%72 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%73 = load i32, i32* %72
	%74 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%75 = load i32, i32* %74
	%76 = call %return.5.0 @runtime.checkGrow(i8* %69, i32 %71, i32 %73, i32 %75, i32 1)
	%77 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%78 = load i32, i32* %77
	; copy and new slice
	%79 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%80 = load i32, i32* %79
	%81 = call i8* @malloc(i32 20)
	%82 = bitcast i8* %81 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %82, i32 %80)
	%83 = bitcast { i32, i32, i32, i32* }* %82 to i8*
	%84 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %83, i8* %84, i32 20, i1 false)
	; copy and end slice
	%85 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %82, i32 0, i32 3
	%86 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %82, i32 0, i32 0
	%87 = extractvalue %return.5.0 %76, 0
	%88 = extractvalue %return.5.0 %76, 1
	%89 = bitcast i8* %87 to i32*
	store i32* %89, i32** %85
	; store value
	%90 = load i32*, i32** %85
	%91 = bitcast i32* %90 to i32*
	%92 = add i32 %78, 0
	%93 = getelementptr i32, i32* %91, i32 %92
	store i32 12, i32* %93
	; add len
	%94 = add i32 %78, 1
	store i32 %94, i32* %86
	%95 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %82, i32 0, i32 1
	store i32 %88, i32* %95
	; append end-------------------------
	%96 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %82
	store { i32, i32, i32, i32* } %96, { i32, i32, i32, i32* }* %2
	%97 = call %string* @runtime.newString(i32 7)
	%98 = getelementptr %string, %string* %97, i32 0, i32 1
	%99 = load i8*, i8** %98
	%100 = bitcast i8* %99 to i8*
	%101 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.2, i64 0, i64 0) to i8*
	%102 = getelementptr %string, %string* %97, i32 0, i32 0
	%103 = load i32, i32* %102
	%104 = add i32 %103, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %100, i8* %101, i32 %104, i1 false)
	%105 = load %string, %string* %97
	%106 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%107 = load i32, i32* %106
	%108 = getelementptr %string, %string* %97, i32 0, i32 1
	%109 = load i8*, i8** %108
	%110 = call i32 (i8*, ...) @printf(i8* %109, i32 %107)
	%111 = call %string* @runtime.newString(i32 3)
	%112 = getelementptr %string, %string* %111, i32 0, i32 1
	%113 = load i8*, i8** %112
	%114 = bitcast i8* %113 to i8*
	%115 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	%116 = getelementptr %string, %string* %111, i32 0, i32 0
	%117 = load i32, i32* %116
	%118 = add i32 %117, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %114, i8* %115, i32 %118, i1 false)
	%119 = load %string, %string* %111
	; get slice index
	%120 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%121 = load i32*, i32** %120
	%122 = getelementptr i32, i32* %121, i32 0
	%123 = load i32, i32* %122
	%124 = getelementptr %string, %string* %111, i32 0, i32 1
	%125 = load i8*, i8** %124
	%126 = call i32 (i8*, ...) @printf(i8* %125, i32 %123)
	%127 = call %string* @runtime.newString(i32 3)
	%128 = getelementptr %string, %string* %127, i32 0, i32 1
	%129 = load i8*, i8** %128
	%130 = bitcast i8* %129 to i8*
	%131 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	%132 = getelementptr %string, %string* %127, i32 0, i32 0
	%133 = load i32, i32* %132
	%134 = add i32 %133, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %130, i8* %131, i32 %134, i1 false)
	%135 = load %string, %string* %127
	; get slice index
	%136 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%137 = load i32*, i32** %136
	%138 = getelementptr i32, i32* %137, i32 1
	%139 = load i32, i32* %138
	%140 = getelementptr %string, %string* %127, i32 0, i32 1
	%141 = load i8*, i8** %140
	%142 = call i32 (i8*, ...) @printf(i8* %141, i32 %139)
	%143 = call %string* @runtime.newString(i32 3)
	%144 = getelementptr %string, %string* %143, i32 0, i32 1
	%145 = load i8*, i8** %144
	%146 = bitcast i8* %145 to i8*
	%147 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	%148 = getelementptr %string, %string* %143, i32 0, i32 0
	%149 = load i32, i32* %148
	%150 = add i32 %149, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %146, i8* %147, i32 %150, i1 false)
	%151 = load %string, %string* %143
	; get slice index
	%152 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%153 = load i32*, i32** %152
	%154 = getelementptr i32, i32* %153, i32 2
	%155 = load i32, i32* %154
	%156 = getelementptr %string, %string* %143, i32 0, i32 1
	%157 = load i8*, i8** %156
	%158 = call i32 (i8*, ...) @printf(i8* %157, i32 %155)
	; end block
	ret void
}

define void @test.sli2() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %2, i32 1)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 1, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [1 x i32]* @main.test.sli2.7 to i8*
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
	br i1 %15, label %16, label %64

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
	%27 = call %return.5.0 @runtime.checkGrow(i8* %20, i32 %22, i32 %24, i32 %26, i32 1)
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%29 = load i32, i32* %28
	; copy and new slice
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%31 = load i32, i32* %30
	%32 = call i8* @malloc(i32 20)
	%33 = bitcast i8* %32 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %33, i32 %31)
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
	%48 = call %string* @runtime.newString(i32 14)
	%49 = getelementptr %string, %string* %48, i32 0, i32 1
	%50 = load i8*, i8** %49
	%51 = bitcast i8* %50 to i8*
	%52 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.6, i64 0, i64 0) to i8*
	%53 = getelementptr %string, %string* %48, i32 0, i32 0
	%54 = load i32, i32* %53
	%55 = add i32 %54, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %51, i8* %52, i32 %55, i1 false)
	%56 = load %string, %string* %48
	%57 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%58 = load i32, i32* %57
	%59 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%60 = load i32, i32* %59
	%61 = getelementptr %string, %string* %48, i32 0, i32 1
	%62 = load i8*, i8** %61
	%63 = call i32 (i8*, ...) @printf(i8* %62, i32 %58, i32 %60)
	; end block
	br label %10

; <label>:64
	; empty block
	; end block
	ret void
}

define void @test.sli3() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 3, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [3 x i32]* @main.test.sli3.9 to i8*
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
	br i1 %15, label %16, label %64

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
	%27 = call %return.5.0 @runtime.checkGrow(i8* %20, i32 %22, i32 %24, i32 %26, i32 1)
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%29 = load i32, i32* %28
	; copy and new slice
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%31 = load i32, i32* %30
	%32 = call i8* @malloc(i32 20)
	%33 = bitcast i8* %32 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %33, i32 %31)
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
	%48 = call %string* @runtime.newString(i32 14)
	%49 = getelementptr %string, %string* %48, i32 0, i32 1
	%50 = load i8*, i8** %49
	%51 = bitcast i8* %50 to i8*
	%52 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.7, i64 0, i64 0) to i8*
	%53 = getelementptr %string, %string* %48, i32 0, i32 0
	%54 = load i32, i32* %53
	%55 = add i32 %54, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %51, i8* %52, i32 %55, i1 false)
	%56 = load %string, %string* %48
	%57 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%58 = load i32, i32* %57
	%59 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%60 = load i32, i32* %59
	%61 = getelementptr %string, %string* %48, i32 0, i32 1
	%62 = load i8*, i8** %61
	%63 = call i32 (i8*, ...) @printf(i8* %62, i32 %58, i32 %60)
	; end block
	br label %10

; <label>:64
	; empty block
	; init block
	%65 = alloca i32
	store i32 0, i32* %65
	br label %69

; <label>:66
	; add block
	%67 = load i32, i32* %65
	%68 = add i32 %67, 1
	store i32 %68, i32* %65
	br label %69

; <label>:69
	; cond Block begin
	%70 = load i32, i32* %65
	%71 = icmp slt i32 %70, 33
	; cond Block end
	br i1 %71, label %72, label %90

; <label>:72
	; block start
	%73 = call %string* @runtime.newString(i32 3)
	%74 = getelementptr %string, %string* %73, i32 0, i32 1
	%75 = load i8*, i8** %74
	%76 = bitcast i8* %75 to i8*
	%77 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.8, i64 0, i64 0) to i8*
	%78 = getelementptr %string, %string* %73, i32 0, i32 0
	%79 = load i32, i32* %78
	%80 = add i32 %79, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %76, i8* %77, i32 %80, i1 false)
	%81 = load %string, %string* %73
	%82 = load i32, i32* %65
	; get slice index
	%83 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%84 = load i32*, i32** %83
	%85 = getelementptr i32, i32* %84, i32 %82
	%86 = load i32, i32* %85
	%87 = getelementptr %string, %string* %73, i32 0, i32 1
	%88 = load i8*, i8** %87
	%89 = call i32 (i8*, ...) @printf(i8* %88, i32 %86)
	; end block
	br label %66

; <label>:90
	; empty block
	; end block
	ret void
}

define void @slice.init.float({ i32, i32, i32, float* }* %ptr, i32 %len) {
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

define void @test.othSli() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, float* }*
	call void @slice.init.float({ i32, i32, i32, float* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 0
	store i32 3, i32* %3
	%4 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 3
	%5 = load float*, float** %4
	%6 = bitcast float* %5 to i8*
	%7 = bitcast [3 x float]* @main.test.othSli.12 to i8*
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
	%18 = call %return.5.0 @runtime.checkGrow(i8* %11, i32 %13, i32 %15, i32 %17, i32 1)
	%19 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 0
	%20 = load i32, i32* %19
	; copy and new slice
	%21 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 0
	%22 = load i32, i32* %21
	%23 = call i8* @malloc(i32 20)
	%24 = bitcast i8* %23 to { i32, i32, i32, float* }*
	call void @slice.init.float({ i32, i32, i32, float* }* %24, i32 %22)
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
	%39 = call %string* @runtime.newString(i32 5)
	%40 = getelementptr %string, %string* %39, i32 0, i32 1
	%41 = load i8*, i8** %40
	%42 = bitcast i8* %41 to i8*
	%43 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.9, i64 0, i64 0) to i8*
	%44 = getelementptr %string, %string* %39, i32 0, i32 0
	%45 = load i32, i32* %44
	%46 = add i32 %45, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %42, i8* %43, i32 %46, i1 false)
	%47 = load %string, %string* %39
	; get slice index
	%48 = getelementptr { i32, i32, i32, float* }, { i32, i32, i32, float* }* %2, i32 0, i32 3
	%49 = load float*, float** %48
	%50 = getelementptr float, float* %49, i32 3
	%51 = load float, float* %50
	%52 = getelementptr %string, %string* %39, i32 0, i32 1
	%53 = load i8*, i8** %52
	%54 = call i32 (i8*, ...) @printf(i8* %53, float %51)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.sli1()
	call void @test.sli2()
	call void @test.sli3()
	call void @test.othSli()
	; end block
	ret void
}

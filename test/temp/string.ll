%string = type { i32, i8* }
%mapStruct = type {}

@str.0 = constant [11 x i8] c"shangzebei\00"
@str.1 = constant [4 x i8] c"%d\0A\00"
@str.2 = constant [6 x i8] c"hello\00"
@str.3 = constant [4 x i8] c"%d\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [11 x i8] c"shangzebei\00"
@str.6 = constant [4 x i8] c"%d \00"
@str.7 = constant [11 x i8] c"shangzebei\00"
@str.8 = constant [4 x i8] c"%s\0A\00"
@str.9 = constant [4 x i8] c"%d\0A\00"
@str.10 = constant [4 x i8] c"%c\0A\00"
@str.11 = constant [8 x i8] c"%d==%c\0A\00"
@str.12 = constant [4 x i8] c"%s\0A\00"

declare i8* @malloc(i32)

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

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define i32 @runtime.getStringLen(%string* %s) {
; <label>:0
	; block start
	%1 = getelementptr %string, %string* %s, i32 0, i32 0
	%2 = load i32, i32* %1
	; end block
	ret i32 %2
}

declare i32 @printf(i8*, ...)

define %string* @runtime.stringJoin(%string* %a, %string* %b) {
; <label>:0
	; block start
	%1 = getelementptr %string, %string* %a, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = getelementptr %string, %string* %b, i32 0, i32 0
	%4 = load i32, i32* %3
	%5 = add i32 %2, %4
	%6 = add i32 %5, 1
	%7 = call %string* @runtime.newString(i32 %6)
	%8 = alloca %string*
	store %string* %7, %string** %8
	%9 = load %string*, %string** %8
	%10 = getelementptr %string, %string* %9, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = getelementptr %string, %string* %a, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = getelementptr %string, %string* %a, i32 0, i32 0
	%15 = load i32, i32* %14
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %13, i32 %15, i1 false)
	%16 = load %string*, %string** %8
	%17 = getelementptr %string, %string* %16, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = getelementptr %string, %string* %a, i32 0, i32 0
	%20 = load i32, i32* %19
	%21 = mul i32 1, %20
	%22 = getelementptr i8, i8* %18, i32 %21
	%23 = getelementptr %string, %string* %b, i32 0, i32 1
	%24 = load i8*, i8** %23
	%25 = getelementptr %string, %string* %b, i32 0, i32 0
	%26 = load i32, i32* %25
	%27 = add i32 %26, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %24, i32 %27, i1 false)
	%28 = load %string*, %string** %8
	; end block
	ret %string* %28
}

define void @test.stringJoin() {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 10)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.0, i64 0, i64 0) to i8*
	%6 = getelementptr %string, %string* %1, i32 0, i32 0
	%7 = load i32, i32* %6
	%8 = add i32 %7, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 %8, i1 false)
	%9 = load %string, %string* %1
	%10 = call %string* @runtime.newString(i32 0)
	store %string %9, %string* %10
	%11 = call %string* @runtime.newString(i32 3)
	%12 = getelementptr %string, %string* %11, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	%16 = getelementptr %string, %string* %11, i32 0, i32 0
	%17 = load i32, i32* %16
	%18 = add i32 %17, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 %18, i1 false)
	%19 = load %string, %string* %11
	%20 = call i32 @runtime.getStringLen(%string* %10)
	%21 = getelementptr %string, %string* %11, i32 0, i32 1
	%22 = load i8*, i8** %21
	%23 = call i32 (i8*, ...) @printf(i8* %22, i32 %20)
	%24 = call %string* @runtime.newString(i32 5)
	%25 = getelementptr %string, %string* %24, i32 0, i32 1
	%26 = load i8*, i8** %25
	%27 = bitcast i8* %26 to i8*
	%28 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.2, i64 0, i64 0) to i8*
	%29 = getelementptr %string, %string* %24, i32 0, i32 0
	%30 = load i32, i32* %29
	%31 = add i32 %30, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %27, i8* %28, i32 %31, i1 false)
	%32 = load %string, %string* %24
	%33 = call %string* @runtime.newString(i32 0)
	store %string %32, %string* %33
	%34 = call %string* @runtime.newString(i32 3)
	%35 = getelementptr %string, %string* %34, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = bitcast i8* %36 to i8*
	%38 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	%39 = getelementptr %string, %string* %34, i32 0, i32 0
	%40 = load i32, i32* %39
	%41 = add i32 %40, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %37, i8* %38, i32 %41, i1 false)
	%42 = load %string, %string* %34
	%43 = call i32 @runtime.getStringLen(%string* %33)
	%44 = getelementptr %string, %string* %34, i32 0, i32 1
	%45 = load i8*, i8** %44
	%46 = call i32 (i8*, ...) @printf(i8* %45, i32 %43)
	%47 = call %string* @runtime.stringJoin(%string* %10, %string* %33)
	%48 = load %string, %string* %47
	%49 = call %string* @runtime.newString(i32 0)
	store %string %48, %string* %49
	%50 = call %string* @runtime.newString(i32 3)
	%51 = getelementptr %string, %string* %50, i32 0, i32 1
	%52 = load i8*, i8** %51
	%53 = bitcast i8* %52 to i8*
	%54 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	%55 = getelementptr %string, %string* %50, i32 0, i32 0
	%56 = load i32, i32* %55
	%57 = add i32 %56, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %53, i8* %54, i32 %57, i1 false)
	%58 = load %string, %string* %50
	%59 = call i32 @runtime.getStringLen(%string* %49)
	%60 = getelementptr %string, %string* %50, i32 0, i32 1
	%61 = load i8*, i8** %60
	%62 = call i32 (i8*, ...) @printf(i8* %61, i32 %59)
	%63 = getelementptr %string, %string* %49, i32 0, i32 1
	%64 = load i8*, i8** %63
	%65 = call i32 (i8*, ...) @printf(i8* %64)
	; end block
	ret void
}

define void @slice.init.i8({ i32, i32, i32, i8* }* %ptr, i32 %len) {
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

define { i32, i32, i32, i8* }* @runtime.stringToBytes(%string* %a) {
; <label>:0
	; block start
	%1 = getelementptr %string, %string* %a, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @slice.init.i8({ i32, i32, i32, i8* }* %4, i32 %2)
	%5 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	%6 = extractvalue { i32, i32, i32, i8* } %5, 3
	%7 = getelementptr %string, %string* %a, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = getelementptr %string, %string* %a, i32 0, i32 0
	%10 = load i32, i32* %9
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %8, i32 %10, i1 false)
	; end block
	ret { i32, i32, i32, i8* }* %4
}

define void @test.string2bytes() {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 10)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.5, i64 0, i64 0) to i8*
	%6 = getelementptr %string, %string* %1, i32 0, i32 0
	%7 = load i32, i32* %6
	%8 = add i32 %7, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 %8, i1 false)
	%9 = load %string, %string* %1
	%10 = call { i32, i32, i32, i8* }* @runtime.stringToBytes(%string* %1)
	; [range start]
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = alloca i8
	; [range end]
	; init block
	%14 = alloca i32
	store i32 0, i32* %14
	br label %18

; <label>:15
	; add block
	%16 = load i32, i32* %14
	%17 = add i32 %16, 1
	store i32 %17, i32* %14
	br label %18

; <label>:18
	; cond Block begin
	%19 = load i32, i32* %14
	%20 = icmp slt i32 %19, %12
	; cond Block end
	br i1 %20, label %21, label %40

; <label>:21
	; block start
	%22 = load i32, i32* %14
	; get slice index
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%24 = load i8*, i8** %23
	%25 = getelementptr i8, i8* %24, i32 %22
	%26 = load i8, i8* %25
	store i8 %26, i8* %13
	%27 = call %string* @runtime.newString(i32 3)
	%28 = getelementptr %string, %string* %27, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.6, i64 0, i64 0) to i8*
	%32 = getelementptr %string, %string* %27, i32 0, i32 0
	%33 = load i32, i32* %32
	%34 = add i32 %33, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 %34, i1 false)
	%35 = load %string, %string* %27
	%36 = load i8, i8* %13
	%37 = getelementptr %string, %string* %27, i32 0, i32 1
	%38 = load i8*, i8** %37
	%39 = call i32 (i8*, ...) @printf(i8* %38, i8 %36)
	; end block
	br label %15

; <label>:40
	; empty block
	; end block
	ret void
}

define i8* @runtime.rangePtr(i8* %ptr, i32 %low, i32 %high, i32 %bytes) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %low, i32* %1
	%2 = alloca i32
	store i32 %high, i32* %2
	%3 = alloca i32
	store i32 %bytes, i32* %3
	%4 = load i32, i32* %2
	%5 = load i32, i32* %1
	%6 = sub i32 %4, %5
	%7 = alloca i32
	store i32 %6, i32* %7
	%8 = load i32, i32* %7
	%9 = load i32, i32* %3
	%10 = mul i32 %8, %9
	%11 = alloca i32
	store i32 %10, i32* %11
	%12 = load i32, i32* %11
	%13 = call i8* @malloc(i32 %12)
	%14 = alloca i8*
	store i8* %13, i8** %14
	%15 = load i8*, i8** %14
	%16 = load i32, i32* %3
	%17 = load i32, i32* %1
	%18 = mul i32 %16, %17
	%19 = getelementptr i8, i8* %ptr, i32 %18
	%20 = load i32, i32* %11
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %15, i8* %19, i32 %20, i1 false)
	%21 = load i8*, i8** %14
	; end block
	ret i8* %21
}

define void @test.stringBase() {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 10)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.7, i64 0, i64 0) to i8*
	%6 = getelementptr %string, %string* %1, i32 0, i32 0
	%7 = load i32, i32* %6
	%8 = add i32 %7, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 %8, i1 false)
	%9 = load %string, %string* %1
	%10 = call %string* @runtime.newString(i32 0)
	store %string %9, %string* %10
	%11 = call %string* @runtime.newString(i32 3)
	%12 = getelementptr %string, %string* %11, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.8, i64 0, i64 0) to i8*
	%16 = getelementptr %string, %string* %11, i32 0, i32 0
	%17 = load i32, i32* %16
	%18 = add i32 %17, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 %18, i1 false)
	%19 = load %string, %string* %11
	%20 = getelementptr %string, %string* %11, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = getelementptr %string, %string* %10, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = call i32 (i8*, ...) @printf(i8* %21, i8* %23)
	%25 = call %string* @runtime.newString(i32 3)
	%26 = getelementptr %string, %string* %25, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = bitcast i8* %27 to i8*
	%29 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.9, i64 0, i64 0) to i8*
	%30 = getelementptr %string, %string* %25, i32 0, i32 0
	%31 = load i32, i32* %30
	%32 = add i32 %31, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %28, i8* %29, i32 %32, i1 false)
	%33 = load %string, %string* %25
	%34 = call i32 @runtime.getStringLen(%string* %10)
	%35 = getelementptr %string, %string* %25, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = call i32 (i8*, ...) @printf(i8* %36, i32 %34)
	%38 = call %string* @runtime.newString(i32 3)
	%39 = getelementptr %string, %string* %38, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.10, i64 0, i64 0) to i8*
	%43 = getelementptr %string, %string* %38, i32 0, i32 0
	%44 = load i32, i32* %43
	%45 = add i32 %44, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 %45, i1 false)
	%46 = load %string, %string* %38
	; get slice index
	%47 = getelementptr %string, %string* %10, i32 0, i32 1
	%48 = load i8*, i8** %47
	%49 = getelementptr i8, i8* %48, i32 1
	%50 = load i8, i8* %49
	%51 = getelementptr %string, %string* %38, i32 0, i32 1
	%52 = load i8*, i8** %51
	%53 = call i32 (i8*, ...) @printf(i8* %52, i8 %50)
	; [range start]
	%54 = getelementptr %string, %string* %10, i32 0, i32 0
	%55 = load i32, i32* %54
	%56 = alloca i32
	%57 = alloca i8
	; [range end]
	; init block
	%58 = alloca i32
	store i32 0, i32* %58
	br label %62

; <label>:59
	; add block
	%60 = load i32, i32* %58
	%61 = add i32 %60, 1
	store i32 %61, i32* %58
	br label %62

; <label>:62
	; cond Block begin
	%63 = load i32, i32* %58
	%64 = icmp slt i32 %63, %55
	; cond Block end
	br i1 %64, label %65, label %86

; <label>:65
	; block start
	%66 = load i32, i32* %58
	store i32 %66, i32* %56
	%67 = load i32, i32* %58
	; get slice index
	%68 = getelementptr %string, %string* %10, i32 0, i32 1
	%69 = load i8*, i8** %68
	%70 = getelementptr i8, i8* %69, i32 %67
	%71 = load i8, i8* %70
	store i8 %71, i8* %57
	%72 = call %string* @runtime.newString(i32 7)
	%73 = getelementptr %string, %string* %72, i32 0, i32 1
	%74 = load i8*, i8** %73
	%75 = bitcast i8* %74 to i8*
	%76 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.11, i64 0, i64 0) to i8*
	%77 = getelementptr %string, %string* %72, i32 0, i32 0
	%78 = load i32, i32* %77
	%79 = add i32 %78, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %75, i8* %76, i32 %79, i1 false)
	%80 = load %string, %string* %72
	%81 = load i32, i32* %56
	%82 = load i8, i8* %57
	%83 = getelementptr %string, %string* %72, i32 0, i32 1
	%84 = load i8*, i8** %83
	%85 = call i32 (i8*, ...) @printf(i8* %84, i32 %81, i8 %82)
	; end block
	br label %59

; <label>:86
	; empty block
	%87 = call %string* @runtime.newString(i32 3)
	%88 = getelementptr %string, %string* %87, i32 0, i32 1
	%89 = load i8*, i8** %88
	%90 = bitcast i8* %89 to i8*
	%91 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.12, i64 0, i64 0) to i8*
	%92 = getelementptr %string, %string* %87, i32 0, i32 0
	%93 = load i32, i32* %92
	%94 = add i32 %93, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %90, i8* %91, i32 %94, i1 false)
	%95 = load %string, %string* %87
	; start string range[]
	%96 = getelementptr %string, %string* %10, i32 0, i32 1
	%97 = load i8*, i8** %96
	%98 = bitcast i8* %97 to i8*
	%99 = call i8* @runtime.rangePtr(i8* %98, i32 3, i32 5, i32 1)
	%100 = sub i32 5, 3
	%101 = call %string* @runtime.newString(i32 %100)
	%102 = getelementptr %string, %string* %101, i32 0, i32 1
	%103 = bitcast i8* %99 to i8*
	store i8* %103, i8** %102
	; end string range[]
	%104 = load %string, %string* %101
	%105 = getelementptr %string, %string* %87, i32 0, i32 1
	%106 = load i8*, i8** %105
	%107 = getelementptr %string, %string* %101, i32 0, i32 1
	%108 = load i8*, i8** %107
	%109 = call i32 (i8*, ...) @printf(i8* %106, i8* %108)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.stringBase()
	call void @test.stringJoin()
	call void @test.string2bytes()
	; end block
	ret void
}

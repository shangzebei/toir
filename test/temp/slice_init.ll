%mapStruct = type {}
%string = type { i32, i8* }

@main.test.ini1.0 = constant [4 x i32] [i32 1, i32 2, i32 3, i32 4]
@main.test.ini1.1 = constant [4 x i1] [i1 true, i1 false, i1 false, i1 true]
@main.test.ini1.2 = constant [4 x i32] [i32 1, i32 2, i32 3, i32 4]
@str.0 = constant [5 x i8] c"aaaa\00"
@str.1 = constant [6 x i8] c"bbbbb\00"
@str.2 = constant [6 x i8] c"ccccc\00"
@str.3 = constant [6 x i8] c"ddddd\00"
@str.4 = constant [9 x i8] c"asdfasdf\00"
@str.5 = constant [10 x i8] c"bbbbbbbbb\00"
@str.6 = constant [11 x i8] c"cccccccccc\00"
@str.7 = constant [10 x i8] c"endendend\00"
@str.8 = constant [24 x i8] c"index%d --[%s]--len %d\0A\00"

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

define void @slice.init.aTE({ i32, i32, i32, i1* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %ptr, i32 0, i32 2
	store i32 0, i32* %1
	%2 = mul i32 %len, 0
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to i1*
	store i1* %5, i1** %4
	%6 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

define void @slice.init.c3RyaW5n({ i32, i32, i32, %string* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %ptr, i32 0, i32 2
	store i32 16, i32* %1
	%2 = mul i32 %len, 16
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to %string*
	store %string* %5, %string** %4
	%6 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

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

define void @test.ini1() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %2, i32 4)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 4, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [4 x i32]* @main.test.ini1.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 16, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%9 = call i8* @malloc(i32 24)
	%10 = bitcast i8* %9 to { i32, i32, i32, i1* }*
	call void @slice.init.aTE({ i32, i32, i32, i1* }* %10, i32 4)
	%11 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %10, i32 0, i32 0
	store i32 4, i32* %11
	%12 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %10, i32 0, i32 3
	%13 = load i1*, i1** %12
	%14 = bitcast i1* %13 to i8*
	%15 = bitcast [4 x i1]* @main.test.ini1.1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 0, i1 false)
	%16 = load { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %10
	%17 = call i8* @malloc(i32 24)
	%18 = bitcast i8* %17 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %18, i32 4)
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 0
	store i32 4, i32* %19
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18, i32 0, i32 3
	%21 = load i32*, i32** %20
	%22 = bitcast i32* %21 to i8*
	%23 = bitcast [4 x i32]* @main.test.ini1.2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 16, i1 false)
	%24 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %18
	%25 = call i8* @malloc(i32 24)
	%26 = bitcast i8* %25 to { i32, i32, i32, %string* }*
	call void @slice.init.c3RyaW5n({ i32, i32, i32, %string* }* %26, i32 4)
	%27 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %26, i32 0, i32 3
	%28 = load %string*, %string** %27
	; init slice 0
	%29 = getelementptr %string, %string* %28, i32 0
	%30 = call %string* @runtime.newString(i32 4)
	%31 = getelementptr %string, %string* %30, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to i8*
	%34 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.0, i64 0, i64 0) to i8*
	%35 = getelementptr %string, %string* %30, i32 0, i32 0
	%36 = load i32, i32* %35
	%37 = add i32 %36, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %33, i8* %34, i32 %37, i1 false)
	%38 = load %string, %string* %30
	store %string %38, %string* %29
	; init slice 1
	%39 = getelementptr %string, %string* %28, i32 1
	%40 = call %string* @runtime.newString(i32 5)
	%41 = getelementptr %string, %string* %40, i32 0, i32 1
	%42 = load i8*, i8** %41
	%43 = bitcast i8* %42 to i8*
	%44 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0) to i8*
	%45 = getelementptr %string, %string* %40, i32 0, i32 0
	%46 = load i32, i32* %45
	%47 = add i32 %46, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %43, i8* %44, i32 %47, i1 false)
	%48 = load %string, %string* %40
	store %string %48, %string* %39
	; init slice 2
	%49 = getelementptr %string, %string* %28, i32 2
	%50 = call %string* @runtime.newString(i32 5)
	%51 = getelementptr %string, %string* %50, i32 0, i32 1
	%52 = load i8*, i8** %51
	%53 = bitcast i8* %52 to i8*
	%54 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.2, i64 0, i64 0) to i8*
	%55 = getelementptr %string, %string* %50, i32 0, i32 0
	%56 = load i32, i32* %55
	%57 = add i32 %56, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %53, i8* %54, i32 %57, i1 false)
	%58 = load %string, %string* %50
	store %string %58, %string* %49
	; init slice 3
	%59 = getelementptr %string, %string* %28, i32 3
	%60 = call %string* @runtime.newString(i32 5)
	%61 = getelementptr %string, %string* %60, i32 0, i32 1
	%62 = load i8*, i8** %61
	%63 = bitcast i8* %62 to i8*
	%64 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.3, i64 0, i64 0) to i8*
	%65 = getelementptr %string, %string* %60, i32 0, i32 0
	%66 = load i32, i32* %65
	%67 = add i32 %66, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %63, i8* %64, i32 %67, i1 false)
	%68 = load %string, %string* %60
	store %string %68, %string* %59
	; end init slice
	; end block
	ret void
}

define i32 @runtime.getStringLen(%string* %s) {
; <label>:0
	; block start
	%1 = getelementptr %string, %string* %s, i32 0, i32 0
	%2 = load i32, i32* %1
	; end block
	ret i32 %2
}

declare i32 @printf(i8*, ...)

define void @test.ini2() {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 8)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([9 x i8], [9 x i8]* @str.4, i64 0, i64 0) to i8*
	%6 = getelementptr %string, %string* %1, i32 0, i32 0
	%7 = load i32, i32* %6
	%8 = add i32 %7, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 %8, i1 false)
	%9 = load %string, %string* %1
	%10 = call %string* @runtime.newString(i32 0)
	store %string %9, %string* %10
	%11 = call %string* @runtime.newString(i32 9)
	%12 = getelementptr %string, %string* %11, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.5, i64 0, i64 0) to i8*
	%16 = getelementptr %string, %string* %11, i32 0, i32 0
	%17 = load i32, i32* %16
	%18 = add i32 %17, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 %18, i1 false)
	%19 = load %string, %string* %11
	%20 = call %string* @runtime.newString(i32 0)
	store %string %19, %string* %20
	%21 = call %string* @runtime.newString(i32 10)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.6, i64 0, i64 0) to i8*
	%26 = getelementptr %string, %string* %21, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = add i32 %27, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 %28, i1 false)
	%29 = load %string, %string* %21
	%30 = call %string* @runtime.newString(i32 0)
	store %string %29, %string* %30
	%31 = call i8* @malloc(i32 24)
	%32 = bitcast i8* %31 to { i32, i32, i32, %string* }*
	call void @slice.init.c3RyaW5n({ i32, i32, i32, %string* }* %32, i32 4)
	%33 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %32, i32 0, i32 3
	%34 = load %string*, %string** %33
	; init slice 0
	%35 = getelementptr %string, %string* %34, i32 0
	%36 = load %string, %string* %10
	store %string %36, %string* %35
	; init slice 1
	%37 = getelementptr %string, %string* %34, i32 1
	%38 = load %string, %string* %20
	store %string %38, %string* %37
	; init slice 2
	%39 = getelementptr %string, %string* %34, i32 2
	%40 = load %string, %string* %30
	store %string %40, %string* %39
	; init slice 3
	%41 = getelementptr %string, %string* %34, i32 3
	%42 = call %string* @runtime.newString(i32 9)
	%43 = getelementptr %string, %string* %42, i32 0, i32 1
	%44 = load i8*, i8** %43
	%45 = bitcast i8* %44 to i8*
	%46 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.7, i64 0, i64 0) to i8*
	%47 = getelementptr %string, %string* %42, i32 0, i32 0
	%48 = load i32, i32* %47
	%49 = add i32 %48, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %45, i8* %46, i32 %49, i1 false)
	%50 = load %string, %string* %42
	store %string %50, %string* %41
	; end init slice
	; [range start]
	%51 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %32, i32 0, i32 0
	%52 = load i32, i32* %51
	%53 = alloca i32
	%54 = alloca %string
	; [range end]
	; init block
	%55 = alloca i32
	store i32 0, i32* %55
	br label %59

; <label>:56
	; add block
	%57 = load i32, i32* %55
	%58 = add i32 %57, 1
	store i32 %58, i32* %55
	br label %59

; <label>:59
	; cond Block begin
	%60 = load i32, i32* %55
	%61 = icmp slt i32 %60, %52
	; cond Block end
	br i1 %61, label %62, label %87

; <label>:62
	; block start
	%63 = load i32, i32* %55
	store i32 %63, i32* %53
	%64 = load i32, i32* %55
	; get slice index
	%65 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %32, i32 0, i32 3
	%66 = load %string*, %string** %65
	%67 = getelementptr %string, %string* %66, i32 %64
	%68 = load %string, %string* %67
	store %string %68, %string* %54
	%69 = call %string* @runtime.newString(i32 23)
	%70 = getelementptr %string, %string* %69, i32 0, i32 1
	%71 = load i8*, i8** %70
	%72 = bitcast i8* %71 to i8*
	%73 = bitcast i8* getelementptr inbounds ([24 x i8], [24 x i8]* @str.8, i64 0, i64 0) to i8*
	%74 = getelementptr %string, %string* %69, i32 0, i32 0
	%75 = load i32, i32* %74
	%76 = add i32 %75, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %72, i8* %73, i32 %76, i1 false)
	%77 = load %string, %string* %69
	%78 = load i32, i32* %53
	%79 = load %string, %string* %54
	%80 = load %string, %string* %54
	%81 = call i32 @runtime.getStringLen(%string* %54)
	%82 = getelementptr %string, %string* %69, i32 0, i32 1
	%83 = load i8*, i8** %82
	%84 = getelementptr %string, %string* %54, i32 0, i32 1
	%85 = load i8*, i8** %84
	%86 = call i32 (i8*, ...) @printf(i8* %83, i32 %78, i8* %85, i32 %81)
	; end block
	br label %56

; <label>:87
	; empty block
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.ini2()
	; end block
	ret void
}

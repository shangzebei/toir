%mapStruct = type {}
%string = type { i32, i8* }

@main.test.arr1.0 = constant [4 x i32] [i32 3, i32 0, i32 8, i32 4]
@main.test.arr1.1 = constant [4 x i32] [i32 2, i32 4, i32 5, i32 7]
@main.str.0 = constant [4 x i8] c"%d \00"
@main.str.1 = constant [2 x i8] c"\0A\00"
@main.test.arr2.4 = constant [4 x i32] [i32 3, i32 0, i32 8, i32 4]
@main.test.arr2.5 = constant [4 x i32] [i32 2, i32 4, i32 5, i32 7]
@main.test.arr2.6 = constant [4 x i32] [i32 9, i32 2, i32 6, i32 3]
@main.test.arr2.7 = constant [4 x i32] [i32 0, i32 3, i32 1, i32 0]
@main.str.2 = constant [4 x i8] c"%d\0A\00"
@main.test.arr3.9 = constant [4 x i32] [i32 1, i32 2, i32 3, i32 4]
@main.test.arr3.10 = constant [4 x i32] [i32 5, i32 6, i32 7, i32 8]
@main.test.arr3.11 = constant [4 x i32] [i32 9, i32 10, i32 11, i32 12]
@main.test.arr3.12 = constant [4 x i32] [i32 13, i32 14, i32 15, i32 16]
@main.test.arr3.13 = constant [4 x i32] [i32 17, i32 18, i32 19, i32 20]
@main.test.arr3.14 = constant [4 x i32] [i32 21, i32 22, i32 23, i32 24]
@main.str.3 = constant [4 x i8] c"%d\0A\00"
@main.str.4 = constant [6 x i8] c"aaaaa\00"
@main.str.5 = constant [6 x i8] c"aaaaa\00"
@main.str.6 = constant [7 x i8] c"bbbbbb\00"
@main.str.7 = constant [6 x i8] c"vvvvv\00"
@main.str.8 = constant [6 x i8] c"fffff\00"
@main.str.9 = constant [6 x i8] c"fffff\00"
@main.str.10 = constant [7 x i8] c"rrrrrr\00"
@main.str.11 = constant [6 x i8] c"ggggg\00"
@main.str.12 = constant [4 x i8] c"%s \00"
@main.str.13 = constant [2 x i8] c"\0A\00"

declare i8* @malloc(i32)

define void @slice.init.eyBpMzIsIGkzMiwgaTMyLCBpMzIqIH0({ i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 0, i32 2
	store i32 24, i32* %1
	%2 = mul i32 %len, 24
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* }* %5, { i32, i32, i32, i32* }** %4
	%6 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

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

define void @test.arr1() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	call void @slice.init.eyBpMzIsIGkzMiwgaTMyLCBpMzIqIH0({ i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 2)
	%3 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 3
	%4 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %3
	; init slice 0
	%5 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 0
	%6 = call i8* @malloc(i32 24)
	%7 = bitcast i8* %6 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %7, i32 4)
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %7, i32 0, i32 0
	store i32 4, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %7, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = bitcast [4 x i32]* @main.test.arr1.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 16, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %7
	store { i32, i32, i32, i32* } %13, { i32, i32, i32, i32* }* %5
	; init slice 1
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 1
	%15 = call i8* @malloc(i32 24)
	%16 = bitcast i8* %15 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %16, i32 4)
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 0
	store i32 4, i32* %17
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 3
	%19 = load i32*, i32** %18
	%20 = bitcast i32* %19 to i8*
	%21 = bitcast [4 x i32]* @main.test.arr1.1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 16, i1 false)
	%22 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16
	store { i32, i32, i32, i32* } %22, { i32, i32, i32, i32* }* %14
	; end init slice
	; [range start]
	%23 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 0
	%24 = load i32, i32* %23
	%25 = alloca { i32, i32, i32, i32* }
	; [range end]
	; init block
	%26 = alloca i32
	store i32 0, i32* %26
	br label %30

; <label>:27
	; add block
	%28 = load i32, i32* %26
	%29 = add i32 %28, 1
	store i32 %29, i32* %26
	br label %30

; <label>:30
	; cond Block begin
	%31 = load i32, i32* %26
	%32 = icmp slt i32 %31, %24
	; cond Block end
	br i1 %32, label %33, label %82

; <label>:33
	; block start
	%34 = load i32, i32* %26
	; get slice index
	%35 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 3
	%36 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %35
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %36, i32 %34
	%38 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %37
	store { i32, i32, i32, i32* } %38, { i32, i32, i32, i32* }* %25
	; [range start]
	%39 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25
	%40 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 0
	%41 = load i32, i32* %40
	%42 = alloca i32
	; [range end]
	; init block
	%43 = alloca i32
	store i32 0, i32* %43
	br label %47

; <label>:44
	; add block
	%45 = load i32, i32* %43
	%46 = add i32 %45, 1
	store i32 %46, i32* %43
	br label %47

; <label>:47
	; cond Block begin
	%48 = load i32, i32* %43
	%49 = icmp slt i32 %48, %41
	; cond Block end
	br i1 %49, label %50, label %69

; <label>:50
	; block start
	%51 = load i32, i32* %43
	; get slice index
	%52 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 3
	%53 = load i32*, i32** %52
	%54 = getelementptr i32, i32* %53, i32 %51
	%55 = load i32, i32* %54
	store i32 %55, i32* %42
	%56 = call %string* @runtime.newString(i32 3)
	%57 = getelementptr %string, %string* %56, i32 0, i32 1
	%58 = load i8*, i8** %57
	%59 = bitcast i8* %58 to i8*
	%60 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @main.str.0, i64 0, i64 0) to i8*
	%61 = getelementptr %string, %string* %56, i32 0, i32 0
	%62 = load i32, i32* %61
	%63 = add i32 %62, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %59, i8* %60, i32 %63, i1 false)
	%64 = load %string, %string* %56
	%65 = load i32, i32* %42
	%66 = getelementptr %string, %string* %56, i32 0, i32 1
	%67 = load i8*, i8** %66
	%68 = call i32 (i8*, ...) @printf(i8* %67, i32 %65)
	; end block
	br label %44

; <label>:69
	; empty block
	%70 = call %string* @runtime.newString(i32 1)
	%71 = getelementptr %string, %string* %70, i32 0, i32 1
	%72 = load i8*, i8** %71
	%73 = bitcast i8* %72 to i8*
	%74 = bitcast i8* getelementptr inbounds ([2 x i8], [2 x i8]* @main.str.1, i64 0, i64 0) to i8*
	%75 = getelementptr %string, %string* %70, i32 0, i32 0
	%76 = load i32, i32* %75
	%77 = add i32 %76, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %73, i8* %74, i32 %77, i1 false)
	%78 = load %string, %string* %70
	%79 = getelementptr %string, %string* %70, i32 0, i32 1
	%80 = load i8*, i8** %79
	%81 = call i32 (i8*, ...) @printf(i8* %80)
	; end block
	br label %27

; <label>:82
	; empty block
	; end block
	ret void
}

define void @test.arr2() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	call void @slice.init.eyBpMzIsIGkzMiwgaTMyLCBpMzIqIH0({ i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 4)
	%3 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 3
	%4 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %3
	; init slice 0
	%5 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 0
	%6 = call i8* @malloc(i32 24)
	%7 = bitcast i8* %6 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %7, i32 4)
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %7, i32 0, i32 0
	store i32 4, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %7, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = bitcast [4 x i32]* @main.test.arr2.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 16, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %7
	store { i32, i32, i32, i32* } %13, { i32, i32, i32, i32* }* %5
	; init slice 1
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 1
	%15 = call i8* @malloc(i32 24)
	%16 = bitcast i8* %15 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %16, i32 4)
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 0
	store i32 4, i32* %17
	%18 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16, i32 0, i32 3
	%19 = load i32*, i32** %18
	%20 = bitcast i32* %19 to i8*
	%21 = bitcast [4 x i32]* @main.test.arr2.5 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 16, i1 false)
	%22 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %16
	store { i32, i32, i32, i32* } %22, { i32, i32, i32, i32* }* %14
	; init slice 2
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 2
	%24 = call i8* @malloc(i32 24)
	%25 = bitcast i8* %24 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %25, i32 4)
	%26 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 0
	store i32 4, i32* %26
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 3
	%28 = load i32*, i32** %27
	%29 = bitcast i32* %28 to i8*
	%30 = bitcast [4 x i32]* @main.test.arr2.6 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %29, i8* %30, i32 16, i1 false)
	%31 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25
	store { i32, i32, i32, i32* } %31, { i32, i32, i32, i32* }* %23
	; init slice 3
	%32 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %4, i32 3
	%33 = call i8* @malloc(i32 24)
	%34 = bitcast i8* %33 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %34, i32 4)
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %34, i32 0, i32 0
	store i32 4, i32* %35
	%36 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %34, i32 0, i32 3
	%37 = load i32*, i32** %36
	%38 = bitcast i32* %37 to i8*
	%39 = bitcast [4 x i32]* @main.test.arr2.7 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %38, i8* %39, i32 16, i1 false)
	%40 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %34
	store { i32, i32, i32, i32* } %40, { i32, i32, i32, i32* }* %32
	; end init slice
	%41 = call %string* @runtime.newString(i32 3)
	%42 = getelementptr %string, %string* %41, i32 0, i32 1
	%43 = load i8*, i8** %42
	%44 = bitcast i8* %43 to i8*
	%45 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @main.str.2, i64 0, i64 0) to i8*
	%46 = getelementptr %string, %string* %41, i32 0, i32 0
	%47 = load i32, i32* %46
	%48 = add i32 %47, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %44, i8* %45, i32 %48, i1 false)
	%49 = load %string, %string* %41
	; get slice index
	%50 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %2, i32 0, i32 3
	%51 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %50
	%52 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %51, i32 2
	%53 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %52
	; get slice index
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %52, i32 0, i32 3
	%55 = load i32*, i32** %54
	%56 = getelementptr i32, i32* %55, i32 2
	%57 = load i32, i32* %56
	%58 = getelementptr %string, %string* %41, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = call i32 (i8*, ...) @printf(i8* %59, i32 %57)
	; end block
	ret void
}

define void @slice.init.eyBpMzIsIGkzMiwgaTMyLCB7IGkzMiwgaTMyLCBpMzIsIGkzMiogfSogfQ({ i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }, { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }* %ptr, i32 0, i32 2
	store i32 24, i32* %1
	%2 = mul i32 %len, 24
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }, { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	store { i32, i32, i32, { i32, i32, i32, i32* }* }* %5, { i32, i32, i32, { i32, i32, i32, i32* }* }** %4
	%6 = getelementptr { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }, { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }, { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

define void @test.arr3() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }*
	call void @slice.init.eyBpMzIsIGkzMiwgaTMyLCB7IGkzMiwgaTMyLCBpMzIsIGkzMiogfSogfQ({ i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }, { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }* %2, i32 0, i32 3
	%4 = load { i32, i32, i32, { i32, i32, i32, i32* }* }*, { i32, i32, i32, { i32, i32, i32, i32* }* }** %3
	; init slice 0
	%5 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %4, i32 0
	%6 = call i8* @malloc(i32 24)
	%7 = bitcast i8* %6 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	call void @slice.init.eyBpMzIsIGkzMiwgaTMyLCBpMzIqIH0({ i32, i32, i32, { i32, i32, i32, i32* }* }* %7, i32 2)
	%8 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %7, i32 0, i32 3
	%9 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %8
	; init slice 0
	%10 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %9, i32 0
	%11 = call i8* @malloc(i32 24)
	%12 = bitcast i8* %11 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %12, i32 4)
	%13 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %12, i32 0, i32 0
	store i32 4, i32* %13
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %12, i32 0, i32 3
	%15 = load i32*, i32** %14
	%16 = bitcast i32* %15 to i8*
	%17 = bitcast [4 x i32]* @main.test.arr3.9 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %16, i8* %17, i32 16, i1 false)
	%18 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %12
	store { i32, i32, i32, i32* } %18, { i32, i32, i32, i32* }* %10
	; init slice 1
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %9, i32 1
	%20 = call i8* @malloc(i32 24)
	%21 = bitcast i8* %20 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %21, i32 4)
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %21, i32 0, i32 0
	store i32 4, i32* %22
	%23 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %21, i32 0, i32 3
	%24 = load i32*, i32** %23
	%25 = bitcast i32* %24 to i8*
	%26 = bitcast [4 x i32]* @main.test.arr3.10 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %25, i8* %26, i32 16, i1 false)
	%27 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %21
	store { i32, i32, i32, i32* } %27, { i32, i32, i32, i32* }* %19
	; end init slice
	%28 = load { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %7
	store { i32, i32, i32, { i32, i32, i32, i32* }* } %28, { i32, i32, i32, { i32, i32, i32, i32* }* }* %5
	; init slice 1
	%29 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %4, i32 1
	%30 = call i8* @malloc(i32 24)
	%31 = bitcast i8* %30 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	call void @slice.init.eyBpMzIsIGkzMiwgaTMyLCBpMzIqIH0({ i32, i32, i32, { i32, i32, i32, i32* }* }* %31, i32 2)
	%32 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %31, i32 0, i32 3
	%33 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %32
	; init slice 0
	%34 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33, i32 0
	%35 = call i8* @malloc(i32 24)
	%36 = bitcast i8* %35 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %36, i32 4)
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %36, i32 0, i32 0
	store i32 4, i32* %37
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %36, i32 0, i32 3
	%39 = load i32*, i32** %38
	%40 = bitcast i32* %39 to i8*
	%41 = bitcast [4 x i32]* @main.test.arr3.11 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %40, i8* %41, i32 16, i1 false)
	%42 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %36
	store { i32, i32, i32, i32* } %42, { i32, i32, i32, i32* }* %34
	; init slice 1
	%43 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %33, i32 1
	%44 = call i8* @malloc(i32 24)
	%45 = bitcast i8* %44 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %45, i32 4)
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %45, i32 0, i32 0
	store i32 4, i32* %46
	%47 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %45, i32 0, i32 3
	%48 = load i32*, i32** %47
	%49 = bitcast i32* %48 to i8*
	%50 = bitcast [4 x i32]* @main.test.arr3.12 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %49, i8* %50, i32 16, i1 false)
	%51 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %45
	store { i32, i32, i32, i32* } %51, { i32, i32, i32, i32* }* %43
	; end init slice
	%52 = load { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %31
	store { i32, i32, i32, { i32, i32, i32, i32* }* } %52, { i32, i32, i32, { i32, i32, i32, i32* }* }* %29
	; init slice 2
	%53 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %4, i32 2
	%54 = call i8* @malloc(i32 24)
	%55 = bitcast i8* %54 to { i32, i32, i32, { i32, i32, i32, i32* }* }*
	call void @slice.init.eyBpMzIsIGkzMiwgaTMyLCBpMzIqIH0({ i32, i32, i32, { i32, i32, i32, i32* }* }* %55, i32 2)
	%56 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %55, i32 0, i32 3
	%57 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %56
	; init slice 0
	%58 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %57, i32 0
	%59 = call i8* @malloc(i32 24)
	%60 = bitcast i8* %59 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %60, i32 4)
	%61 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %60, i32 0, i32 0
	store i32 4, i32* %61
	%62 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %60, i32 0, i32 3
	%63 = load i32*, i32** %62
	%64 = bitcast i32* %63 to i8*
	%65 = bitcast [4 x i32]* @main.test.arr3.13 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %64, i8* %65, i32 16, i1 false)
	%66 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %60
	store { i32, i32, i32, i32* } %66, { i32, i32, i32, i32* }* %58
	; init slice 1
	%67 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %57, i32 1
	%68 = call i8* @malloc(i32 24)
	%69 = bitcast i8* %68 to { i32, i32, i32, i32* }*
	call void @slice.init.aTMy({ i32, i32, i32, i32* }* %69, i32 4)
	%70 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %69, i32 0, i32 0
	store i32 4, i32* %70
	%71 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %69, i32 0, i32 3
	%72 = load i32*, i32** %71
	%73 = bitcast i32* %72 to i8*
	%74 = bitcast [4 x i32]* @main.test.arr3.14 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %73, i8* %74, i32 16, i1 false)
	%75 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %69
	store { i32, i32, i32, i32* } %75, { i32, i32, i32, i32* }* %67
	; end init slice
	%76 = load { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %55
	store { i32, i32, i32, { i32, i32, i32, i32* }* } %76, { i32, i32, i32, { i32, i32, i32, i32* }* }* %53
	; end init slice
	%77 = call %string* @runtime.newString(i32 3)
	%78 = getelementptr %string, %string* %77, i32 0, i32 1
	%79 = load i8*, i8** %78
	%80 = bitcast i8* %79 to i8*
	%81 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @main.str.3, i64 0, i64 0) to i8*
	%82 = getelementptr %string, %string* %77, i32 0, i32 0
	%83 = load i32, i32* %82
	%84 = add i32 %83, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %80, i8* %81, i32 %84, i1 false)
	%85 = load %string, %string* %77
	; get slice index
	%86 = getelementptr { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }, { i32, i32, i32, { i32, i32, i32, { i32, i32, i32, i32* }* }* }* %2, i32 0, i32 3
	%87 = load { i32, i32, i32, { i32, i32, i32, i32* }* }*, { i32, i32, i32, { i32, i32, i32, i32* }* }** %86
	%88 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %87, i32 1
	%89 = load { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %88
	; get slice index
	%90 = getelementptr { i32, i32, i32, { i32, i32, i32, i32* }* }, { i32, i32, i32, { i32, i32, i32, i32* }* }* %88, i32 0, i32 3
	%91 = load { i32, i32, i32, i32* }*, { i32, i32, i32, i32* }** %90
	%92 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %91, i32 1
	%93 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %92
	; get slice index
	%94 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %92, i32 0, i32 3
	%95 = load i32*, i32** %94
	%96 = getelementptr i32, i32* %95, i32 1
	%97 = load i32, i32* %96
	%98 = getelementptr %string, %string* %77, i32 0, i32 1
	%99 = load i8*, i8** %98
	%100 = call i32 (i8*, ...) @printf(i8* %99, i32 %97)
	; end block
	ret void
}

define void @slice.init.eyBpMzIsIGkzMiwgaTMyLCBzdHJpbmcqIH0({ i32, i32, i32, { i32, i32, i32, %string* }* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, { i32, i32, i32, %string* }* }, { i32, i32, i32, { i32, i32, i32, %string* }* }* %ptr, i32 0, i32 2
	store i32 24, i32* %1
	%2 = mul i32 %len, 24
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, { i32, i32, i32, %string* }* }, { i32, i32, i32, { i32, i32, i32, %string* }* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to { i32, i32, i32, %string* }*
	store { i32, i32, i32, %string* }* %5, { i32, i32, i32, %string* }** %4
	%6 = getelementptr { i32, i32, i32, { i32, i32, i32, %string* }* }, { i32, i32, i32, { i32, i32, i32, %string* }* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, { i32, i32, i32, %string* }* }, { i32, i32, i32, { i32, i32, i32, %string* }* }* %ptr, i32 0, i32 0
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

define void @test.arr4() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, { i32, i32, i32, %string* }* }*
	call void @slice.init.eyBpMzIsIGkzMiwgaTMyLCBzdHJpbmcqIH0({ i32, i32, i32, { i32, i32, i32, %string* }* }* %2, i32 2)
	%3 = getelementptr { i32, i32, i32, { i32, i32, i32, %string* }* }, { i32, i32, i32, { i32, i32, i32, %string* }* }* %2, i32 0, i32 3
	%4 = load { i32, i32, i32, %string* }*, { i32, i32, i32, %string* }** %3
	; init slice 0
	%5 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %4, i32 0
	%6 = call %string* @runtime.newString(i32 5)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @main.str.4, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = call i8* @malloc(i32 24)
	%16 = bitcast i8* %15 to { i32, i32, i32, %string* }*
	call void @slice.init.c3RyaW5n({ i32, i32, i32, %string* }* %16, i32 3)
	%17 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %16, i32 0, i32 3
	%18 = load %string*, %string** %17
	; init slice 0
	%19 = getelementptr %string, %string* %18, i32 0
	%20 = call %string* @runtime.newString(i32 5)
	%21 = getelementptr %string, %string* %20, i32 0, i32 1
	%22 = load i8*, i8** %21
	%23 = bitcast i8* %22 to i8*
	%24 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @main.str.5, i64 0, i64 0) to i8*
	%25 = getelementptr %string, %string* %20, i32 0, i32 0
	%26 = load i32, i32* %25
	%27 = add i32 %26, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %23, i8* %24, i32 %27, i1 false)
	%28 = load %string, %string* %20
	store %string %28, %string* %19
	; init slice 1
	%29 = getelementptr %string, %string* %18, i32 1
	%30 = call %string* @runtime.newString(i32 6)
	%31 = getelementptr %string, %string* %30, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to i8*
	%34 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.6, i64 0, i64 0) to i8*
	%35 = getelementptr %string, %string* %30, i32 0, i32 0
	%36 = load i32, i32* %35
	%37 = add i32 %36, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %33, i8* %34, i32 %37, i1 false)
	%38 = load %string, %string* %30
	store %string %38, %string* %29
	; init slice 2
	%39 = getelementptr %string, %string* %18, i32 2
	%40 = call %string* @runtime.newString(i32 5)
	%41 = getelementptr %string, %string* %40, i32 0, i32 1
	%42 = load i8*, i8** %41
	%43 = bitcast i8* %42 to i8*
	%44 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @main.str.7, i64 0, i64 0) to i8*
	%45 = getelementptr %string, %string* %40, i32 0, i32 0
	%46 = load i32, i32* %45
	%47 = add i32 %46, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %43, i8* %44, i32 %47, i1 false)
	%48 = load %string, %string* %40
	store %string %48, %string* %39
	; end init slice
	%49 = load { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %16
	store { i32, i32, i32, %string* } %49, { i32, i32, i32, %string* }* %5
	; init slice 1
	%50 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %4, i32 1
	%51 = call %string* @runtime.newString(i32 5)
	%52 = getelementptr %string, %string* %51, i32 0, i32 1
	%53 = load i8*, i8** %52
	%54 = bitcast i8* %53 to i8*
	%55 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @main.str.8, i64 0, i64 0) to i8*
	%56 = getelementptr %string, %string* %51, i32 0, i32 0
	%57 = load i32, i32* %56
	%58 = add i32 %57, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %54, i8* %55, i32 %58, i1 false)
	%59 = load %string, %string* %51
	%60 = call i8* @malloc(i32 24)
	%61 = bitcast i8* %60 to { i32, i32, i32, %string* }*
	call void @slice.init.c3RyaW5n({ i32, i32, i32, %string* }* %61, i32 3)
	%62 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %61, i32 0, i32 3
	%63 = load %string*, %string** %62
	; init slice 0
	%64 = getelementptr %string, %string* %63, i32 0
	%65 = call %string* @runtime.newString(i32 5)
	%66 = getelementptr %string, %string* %65, i32 0, i32 1
	%67 = load i8*, i8** %66
	%68 = bitcast i8* %67 to i8*
	%69 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @main.str.9, i64 0, i64 0) to i8*
	%70 = getelementptr %string, %string* %65, i32 0, i32 0
	%71 = load i32, i32* %70
	%72 = add i32 %71, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %68, i8* %69, i32 %72, i1 false)
	%73 = load %string, %string* %65
	store %string %73, %string* %64
	; init slice 1
	%74 = getelementptr %string, %string* %63, i32 1
	%75 = call %string* @runtime.newString(i32 6)
	%76 = getelementptr %string, %string* %75, i32 0, i32 1
	%77 = load i8*, i8** %76
	%78 = bitcast i8* %77 to i8*
	%79 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.10, i64 0, i64 0) to i8*
	%80 = getelementptr %string, %string* %75, i32 0, i32 0
	%81 = load i32, i32* %80
	%82 = add i32 %81, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %78, i8* %79, i32 %82, i1 false)
	%83 = load %string, %string* %75
	store %string %83, %string* %74
	; init slice 2
	%84 = getelementptr %string, %string* %63, i32 2
	%85 = call %string* @runtime.newString(i32 5)
	%86 = getelementptr %string, %string* %85, i32 0, i32 1
	%87 = load i8*, i8** %86
	%88 = bitcast i8* %87 to i8*
	%89 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @main.str.11, i64 0, i64 0) to i8*
	%90 = getelementptr %string, %string* %85, i32 0, i32 0
	%91 = load i32, i32* %90
	%92 = add i32 %91, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %88, i8* %89, i32 %92, i1 false)
	%93 = load %string, %string* %85
	store %string %93, %string* %84
	; end init slice
	%94 = load { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %61
	store { i32, i32, i32, %string* } %94, { i32, i32, i32, %string* }* %50
	; end init slice
	; [range start]
	%95 = getelementptr { i32, i32, i32, { i32, i32, i32, %string* }* }, { i32, i32, i32, { i32, i32, i32, %string* }* }* %2, i32 0, i32 0
	%96 = load i32, i32* %95
	%97 = alloca { i32, i32, i32, %string* }
	; [range end]
	; init block
	%98 = alloca i32
	store i32 0, i32* %98
	br label %102

; <label>:99
	; add block
	%100 = load i32, i32* %98
	%101 = add i32 %100, 1
	store i32 %101, i32* %98
	br label %102

; <label>:102
	; cond Block begin
	%103 = load i32, i32* %98
	%104 = icmp slt i32 %103, %96
	; cond Block end
	br i1 %104, label %105, label %156

; <label>:105
	; block start
	%106 = load i32, i32* %98
	; get slice index
	%107 = getelementptr { i32, i32, i32, { i32, i32, i32, %string* }* }, { i32, i32, i32, { i32, i32, i32, %string* }* }* %2, i32 0, i32 3
	%108 = load { i32, i32, i32, %string* }*, { i32, i32, i32, %string* }** %107
	%109 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %108, i32 %106
	%110 = load { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %109
	store { i32, i32, i32, %string* } %110, { i32, i32, i32, %string* }* %97
	; [range start]
	%111 = load { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %97
	%112 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %97, i32 0, i32 0
	%113 = load i32, i32* %112
	%114 = alloca %string
	; [range end]
	; init block
	%115 = alloca i32
	store i32 0, i32* %115
	br label %119

; <label>:116
	; add block
	%117 = load i32, i32* %115
	%118 = add i32 %117, 1
	store i32 %118, i32* %115
	br label %119

; <label>:119
	; cond Block begin
	%120 = load i32, i32* %115
	%121 = icmp slt i32 %120, %113
	; cond Block end
	br i1 %121, label %122, label %143

; <label>:122
	; block start
	%123 = load i32, i32* %115
	; get slice index
	%124 = getelementptr { i32, i32, i32, %string* }, { i32, i32, i32, %string* }* %97, i32 0, i32 3
	%125 = load %string*, %string** %124
	%126 = getelementptr %string, %string* %125, i32 %123
	%127 = load %string, %string* %126
	store %string %127, %string* %114
	%128 = call %string* @runtime.newString(i32 3)
	%129 = getelementptr %string, %string* %128, i32 0, i32 1
	%130 = load i8*, i8** %129
	%131 = bitcast i8* %130 to i8*
	%132 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @main.str.12, i64 0, i64 0) to i8*
	%133 = getelementptr %string, %string* %128, i32 0, i32 0
	%134 = load i32, i32* %133
	%135 = add i32 %134, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %131, i8* %132, i32 %135, i1 false)
	%136 = load %string, %string* %128
	%137 = load %string, %string* %114
	%138 = getelementptr %string, %string* %128, i32 0, i32 1
	%139 = load i8*, i8** %138
	%140 = getelementptr %string, %string* %114, i32 0, i32 1
	%141 = load i8*, i8** %140
	%142 = call i32 (i8*, ...) @printf(i8* %139, i8* %141)
	; end block
	br label %116

; <label>:143
	; empty block
	%144 = call %string* @runtime.newString(i32 1)
	%145 = getelementptr %string, %string* %144, i32 0, i32 1
	%146 = load i8*, i8** %145
	%147 = bitcast i8* %146 to i8*
	%148 = bitcast i8* getelementptr inbounds ([2 x i8], [2 x i8]* @main.str.13, i64 0, i64 0) to i8*
	%149 = getelementptr %string, %string* %144, i32 0, i32 0
	%150 = load i32, i32* %149
	%151 = add i32 %150, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %147, i8* %148, i32 %151, i1 false)
	%152 = load %string, %string* %144
	%153 = getelementptr %string, %string* %144, i32 0, i32 1
	%154 = load i8*, i8** %153
	%155 = call i32 (i8*, ...) @printf(i8* %154)
	; end block
	br label %99

; <label>:156
	; empty block
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.arr1()
	call void @test.arr2()
	call void @test.arr3()
	call void @test.arr4()
	; end block
	ret void
}

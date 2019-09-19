%mapStruct = type {}
%string = type { i32, i8* }

@main.test.arr1.0 = constant [4 x i32] [i32 3, i32 0, i32 8, i32 4]
@main.test.arr1.1 = constant [4 x i32] [i32 2, i32 4, i32 5, i32 7]
@str.0 = constant [4 x i8] c"%d \00"
@str.1 = constant [2 x i8] c"\0A\00"
@main.test.arr2.4 = constant [4 x i32] [i32 3, i32 0, i32 8, i32 4]
@main.test.arr2.5 = constant [4 x i32] [i32 2, i32 4, i32 5, i32 7]
@main.test.arr2.6 = constant [4 x i32] [i32 9, i32 2, i32 6, i32 3]
@main.test.arr2.7 = constant [4 x i32] [i32 0, i32 3, i32 1, i32 0]
@str.2 = constant [4 x i8] c"%d\0A\00"

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
	br i1 %32, label %33, label %83

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
	%40 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25
	%41 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 0
	%42 = load i32, i32* %41
	%43 = alloca i32
	; [range end]
	; init block
	%44 = alloca i32
	store i32 0, i32* %44
	br label %48

; <label>:45
	; add block
	%46 = load i32, i32* %44
	%47 = add i32 %46, 1
	store i32 %47, i32* %44
	br label %48

; <label>:48
	; cond Block begin
	%49 = load i32, i32* %44
	%50 = icmp slt i32 %49, %42
	; cond Block end
	br i1 %50, label %51, label %70

; <label>:51
	; block start
	%52 = load i32, i32* %44
	; get slice index
	%53 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %25, i32 0, i32 3
	%54 = load i32*, i32** %53
	%55 = getelementptr i32, i32* %54, i32 %52
	%56 = load i32, i32* %55
	store i32 %56, i32* %43
	%57 = call %string* @runtime.newString(i32 3)
	%58 = getelementptr %string, %string* %57, i32 0, i32 1
	%59 = load i8*, i8** %58
	%60 = bitcast i8* %59 to i8*
	%61 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	%62 = getelementptr %string, %string* %57, i32 0, i32 0
	%63 = load i32, i32* %62
	%64 = add i32 %63, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %60, i8* %61, i32 %64, i1 false)
	%65 = load %string, %string* %57
	%66 = load i32, i32* %43
	%67 = getelementptr %string, %string* %57, i32 0, i32 1
	%68 = load i8*, i8** %67
	%69 = call i32 (i8*, ...) @printf(i8* %68, i32 %66)
	; end block
	br label %45

; <label>:70
	; empty block
	%71 = call %string* @runtime.newString(i32 1)
	%72 = getelementptr %string, %string* %71, i32 0, i32 1
	%73 = load i8*, i8** %72
	%74 = bitcast i8* %73 to i8*
	%75 = bitcast i8* getelementptr inbounds ([2 x i8], [2 x i8]* @str.1, i64 0, i64 0) to i8*
	%76 = getelementptr %string, %string* %71, i32 0, i32 0
	%77 = load i32, i32* %76
	%78 = add i32 %77, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %74, i8* %75, i32 %78, i1 false)
	%79 = load %string, %string* %71
	%80 = getelementptr %string, %string* %71, i32 0, i32 1
	%81 = load i8*, i8** %80
	%82 = call i32 (i8*, ...) @printf(i8* %81)
	; end block
	br label %27

; <label>:83
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
	%45 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
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

define void @main() {
; <label>:0
	; block start
	call void @test.arr1()
	call void @test.arr2()
	; end block
	ret void
}

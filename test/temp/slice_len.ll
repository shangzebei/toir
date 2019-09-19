%mapStruct = type {}
%string = type { i32, i8* }
%return.3.0 = type { i8*, i32 }

@main.main.0 = constant [3 x i32] [i32 1, i32 2, i32 3]
@str.0 = constant [4 x i8] c"%d\0A\00"

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

define %return.3.0 @runtime.checkGrow(i8* %ptr, i32 %len, i32 %cap, i32 %bytes, i32 %insert) {
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
	%27 = alloca %return.3.0
	%28 = getelementptr %return.3.0, %return.3.0* %27, i32 0, i32 0
	store i8* %25, i8** %28
	%29 = getelementptr %return.3.0, %return.3.0* %27, i32 0, i32 1
	store i32 %26, i32* %29
	%30 = load %return.3.0, %return.3.0* %27
	; end block
	ret %return.3.0 %30

; <label>:31
	; block start
	%32 = load i32, i32* %2
	%33 = alloca %return.3.0
	%34 = getelementptr %return.3.0, %return.3.0* %33, i32 0, i32 0
	store i8* %ptr, i8** %34
	%35 = getelementptr %return.3.0, %return.3.0* %33, i32 0, i32 1
	store i32 %32, i32* %35
	%36 = load %return.3.0, %return.3.0* %33
	; end block
	ret %return.3.0 %36
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

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 24)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %2, i32 3)
	%3 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	store i32 3, i32* %3
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%5 = load i32*, i32** %4
	%6 = bitcast i32* %5 to i8*
	%7 = bitcast [3 x i32]* @main.main.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 12, i1 false)
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	; append start---------------------
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%13 = load i32, i32* %12
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%15 = load i32, i32* %14
	%16 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 2
	%17 = load i32, i32* %16
	%18 = call %return.3.0 @runtime.checkGrow(i8* %11, i32 %13, i32 %15, i32 %17, i32 1)
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%20 = load i32, i32* %19
	; copy and new slice
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%22 = load i32, i32* %21
	%23 = call i8* @malloc(i32 24)
	%24 = bitcast i8* %23 to { i32, i32, i32, i32* }*
	call void @slice.init.i32({ i32, i32, i32, i32* }* %24, i32 %22)
	%25 = bitcast { i32, i32, i32, i32* }* %24 to i8*
	%26 = bitcast { i32, i32, i32, i32* }* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %25, i8* %26, i32 24, i1 false)
	; copy and end slice
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %24, i32 0, i32 3
	%28 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %24, i32 0, i32 0
	%29 = extractvalue %return.3.0 %18, 0
	%30 = extractvalue %return.3.0 %18, 1
	%31 = bitcast i8* %29 to i32*
	store i32* %31, i32** %27
	; store value
	%32 = load i32*, i32** %27
	%33 = bitcast i32* %32 to i32*
	%34 = add i32 %20, 0
	%35 = getelementptr i32, i32* %33, i32 %34
	store i32 8, i32* %35
	; add len
	%36 = add i32 %20, 1
	store i32 %36, i32* %28
	%37 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %24, i32 0, i32 1
	store i32 %30, i32* %37
	; append end-------------------------
	%38 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %24
	store { i32, i32, i32, i32* } %38, { i32, i32, i32, i32* }* %2
	%39 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%40 = load i32, i32* %39
	%41 = alloca i32
	store i32 %40, i32* %41
	%42 = call %string* @runtime.newString(i32 3)
	%43 = getelementptr %string, %string* %42, i32 0, i32 1
	%44 = load i8*, i8** %43
	%45 = bitcast i8* %44 to i8*
	%46 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	%47 = getelementptr %string, %string* %42, i32 0, i32 0
	%48 = load i32, i32* %47
	%49 = add i32 %48, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %45, i8* %46, i32 %49, i1 false)
	%50 = load %string, %string* %42
	%51 = load i32, i32* %41
	%52 = getelementptr %string, %string* %42, i32 0, i32 1
	%53 = load i8*, i8** %52
	%54 = call i32 (i8*, ...) @printf(i8* %53, i32 %51)
	; end block
	ret void
}

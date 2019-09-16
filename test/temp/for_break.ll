@str.0 = constant [7 x i8] c"break\0A\00"
@str.1 = constant [4 x i8] c"no\0A\00"
@str.2 = constant [18 x i8] c"bbbbbbbbbbbbbbbb\0A\00"
@str.3 = constant [7 x i8] c"break\0A\00"
@str.4 = constant [4 x i8] c"no\0A\00"
@str.5 = constant [19 x i8] c"bbbbbbbbbbbbbbbbb\0A\00"

declare i8* @malloc(i32)

define void @init_slice_i8({ i32, i32, i32, i8* }* %ptr, i32 %len) {
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

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @for2break() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 10
	; cond Block end
	br i1 %7, label %8, label %57

; <label>:8
	; block start
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
	%15 = icmp slt i32 %14, 10
	; cond Block end
	br i1 %15, label %16, label %45

; <label>:16
	; block start
	br label %17

; <label>:17
	%18 = load i32, i32* %9
	%19 = icmp sgt i32 %18, 5
	br i1 %19, label %20, label %32

; <label>:20
	; block start
	%21 = call i8* @malloc(i32 20)
	%22 = bitcast i8* %21 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %22, i32 7)
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 0
	store i32 7, i32* %23
	%24 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to i8*
	%27 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 7, i1 false)
	%28 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22
	%29 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%30 = load i8*, i8** %29
	%31 = call i32 (i8*, ...) @printf(i8* %30)
	; end block
	br label %45

; <label>:32
	; block start
	%33 = call i8* @malloc(i32 20)
	%34 = bitcast i8* %33 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %34, i32 4)
	%35 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %34, i32 0, i32 0
	store i32 4, i32* %35
	%36 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %34, i32 0, i32 3
	%37 = load i8*, i8** %36
	%38 = bitcast i8* %37 to i8*
	%39 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %38, i8* %39, i32 4, i1 false)
	%40 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %34
	%41 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %34, i32 0, i32 3
	%42 = load i8*, i8** %41
	%43 = call i32 (i8*, ...) @printf(i8* %42)
	; end block
	br label %44

; <label>:44
	; end block
	br label %10

; <label>:45
	; empty block
	%46 = call i8* @malloc(i32 20)
	%47 = bitcast i8* %46 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %47, i32 18)
	%48 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %47, i32 0, i32 0
	store i32 18, i32* %48
	%49 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %47, i32 0, i32 3
	%50 = load i8*, i8** %49
	%51 = bitcast i8* %50 to i8*
	%52 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %51, i8* %52, i32 18, i1 false)
	%53 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %47
	%54 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %47, i32 0, i32 3
	%55 = load i8*, i8** %54
	%56 = call i32 (i8*, ...) @printf(i8* %55)
	; end block
	br label %2

; <label>:57
	; empty block
	; end block
	ret void
}

define void @for1break() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 10
	; cond Block end
	br i1 %7, label %8, label %37

; <label>:8
	; block start
	br label %9

; <label>:9
	%10 = load i32, i32* %1
	%11 = icmp sgt i32 %10, 5
	br i1 %11, label %12, label %24

; <label>:12
	; block start
	%13 = call i8* @malloc(i32 20)
	%14 = bitcast i8* %13 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %14, i32 7)
	%15 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %14, i32 0, i32 0
	store i32 7, i32* %15
	%16 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %14, i32 0, i32 3
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to i8*
	%19 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 7, i1 false)
	%20 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %14
	%21 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %14, i32 0, i32 3
	%22 = load i8*, i8** %21
	%23 = call i32 (i8*, ...) @printf(i8* %22)
	; end block
	br label %37

; <label>:24
	; block start
	%25 = call i8* @malloc(i32 20)
	%26 = bitcast i8* %25 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %26, i32 4)
	%27 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 0
	store i32 4, i32* %27
	%28 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 3
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 4, i1 false)
	%32 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26
	%33 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 3
	%34 = load i8*, i8** %33
	%35 = call i32 (i8*, ...) @printf(i8* %34)
	; end block
	br label %36

; <label>:36
	; end block
	br label %2

; <label>:37
	; empty block
	%38 = call i8* @malloc(i32 20)
	%39 = bitcast i8* %38 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %39, i32 19)
	%40 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %39, i32 0, i32 0
	store i32 19, i32* %40
	%41 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %39, i32 0, i32 3
	%42 = load i8*, i8** %41
	%43 = bitcast i8* %42 to i8*
	%44 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %43, i8* %44, i32 19, i1 false)
	%45 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %39
	%46 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %39, i32 0, i32 3
	%47 = load i8*, i8** %46
	%48 = call i32 (i8*, ...) @printf(i8* %47)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @for2break()
	; end block
	ret void
}

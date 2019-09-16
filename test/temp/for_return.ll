@str.0 = constant [7 x i8] c"begin\0A\00"
@str.1 = constant [17 x i8] c"asdfasdfsdf--%d\0A\00"
@str.2 = constant [5 x i8] c">5 \0A\00"
@str.3 = constant [13 x i8] c"aaaaaaaaaaa\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"

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

define i32 @forr() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %2, i32 7)
	%3 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 0
	store i32 7, i32* %3
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 7, i1 false)
	%8 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = call i32 (i8*, ...) @printf(i8* %10)
	; init block
	%12 = alloca i32
	store i32 0, i32* %12
	br label %16

; <label>:13
	; add block
	%14 = load i32, i32* %12
	%15 = add i32 %14, 1
	store i32 %15, i32* %12
	br label %16

; <label>:16
	; cond Block begin
	%17 = load i32, i32* %12
	%18 = icmp sle i32 %17, 11
	; cond Block end
	br i1 %18, label %19, label %49

; <label>:19
	; block start
	%20 = call i8* @malloc(i32 20)
	%21 = bitcast i8* %20 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %21, i32 17)
	%22 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %21, i32 0, i32 0
	store i32 17, i32* %22
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %21, i32 0, i32 3
	%24 = load i8*, i8** %23
	%25 = bitcast i8* %24 to i8*
	%26 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %25, i8* %26, i32 17, i1 false)
	%27 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %21
	%28 = load i32, i32* %12
	%29 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %21, i32 0, i32 3
	%30 = load i8*, i8** %29
	%31 = call i32 (i8*, ...) @printf(i8* %30, i32 %28)
	br label %32

; <label>:32
	%33 = load i32, i32* %12
	%34 = icmp sgt i32 %33, 5
	br i1 %34, label %35, label %47

; <label>:35
	; block start
	%36 = call i8* @malloc(i32 20)
	%37 = bitcast i8* %36 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %37, i32 5)
	%38 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 0
	store i32 5, i32* %38
	%39 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 3
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 5, i1 false)
	%43 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37
	%44 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 3
	%45 = load i8*, i8** %44
	%46 = call i32 (i8*, ...) @printf(i8* %45)
	; end block
	br label %48

; <label>:47
	br label %48

; <label>:48
	; end block
	br label %13

; <label>:49
	; empty block
	; end block
	ret i32 0
}

define i32 @ifrr() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 9, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 5
	br i1 %4, label %5, label %17

; <label>:5
	; block start
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 13)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 13, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 13, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15)
	; end block
	ret i32 1

; <label>:17
	br label %18

; <label>:18
	; end block
	ret i32 0
}

define void @main() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %2, i32 4)
	%3 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 0
	store i32 4, i32* %3
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 4, i1 false)
	%8 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2
	%9 = call i32 @forr()
	%10 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%11 = load i8*, i8** %10
	%12 = call i32 (i8*, ...) @printf(i8* %11, i32 %9)
	%13 = call i32 @ifrr()
	%14 = call i32 @forr()
	; end block
	ret void
}

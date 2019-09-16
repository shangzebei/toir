@str.0 = constant [17 x i8] c"asdfasdfsdf--%d\0A\00"
@str.1 = constant [5 x i8] c">5 \0A\00"

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

define void @main() {
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
	%7 = icmp sle i32 %6, 11
	; cond Block end
	br i1 %7, label %8, label %38

; <label>:8
	; block start
	%9 = call i8* @malloc(i32 20)
	%10 = bitcast i8* %9 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %10, i32 17)
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 0
	store i32 17, i32* %11
	%12 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 17, i1 false)
	%16 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10
	%17 = load i32, i32* %1
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %10, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19, i32 %17)
	br label %21

; <label>:21
	%22 = load i32, i32* %1
	%23 = icmp sgt i32 %22, 5
	br i1 %23, label %24, label %36

; <label>:24
	; block start
	%25 = call i8* @malloc(i32 20)
	%26 = bitcast i8* %25 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %26, i32 5)
	%27 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 0
	store i32 5, i32* %27
	%28 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 3
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 5, i1 false)
	%32 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26
	%33 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %26, i32 0, i32 3
	%34 = load i8*, i8** %33
	%35 = call i32 (i8*, ...) @printf(i8* %34)
	; end block
	br label %37

; <label>:36
	br label %37

; <label>:37
	; end block
	br label %2

; <label>:38
	; empty block
	; end block
	ret void
}

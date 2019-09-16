@str.0 = constant [11 x i8] c"shangzebei\00"
@str.1 = constant [4 x i8] c"%d \00"

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

define void @stringRange() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %2, i32 0)
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %4, i32 11)
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 0
	store i32 11, i32* %5
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 11, i1 false)
	%10 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	store { i32, i32, i32, i8* } %10, { i32, i32, i32, i8* }* %2
	; [range start]
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 0
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
	br i1 %20, label %21, label %39

; <label>:21
	; block start
	%22 = load i32, i32* %14
	; get slice index
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%24 = load i8*, i8** %23
	%25 = getelementptr i8, i8* %24, i32 %22
	%26 = load i8, i8* %25
	store i8 %26, i8* %13
	%27 = call i8* @malloc(i32 20)
	%28 = bitcast i8* %27 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %28, i32 4)
	%29 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 0
	store i32 4, i32* %29
	%30 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 3
	%31 = load i8*, i8** %30
	%32 = bitcast i8* %31 to i8*
	%33 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %32, i8* %33, i32 4, i1 false)
	%34 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28
	%35 = load i8, i8* %13
	%36 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 3
	%37 = load i8*, i8** %36
	%38 = call i32 (i8*, ...) @printf(i8* %37, i8 %35)
	; end block
	br label %15

; <label>:39
	; empty block
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @stringRange()
	; end block
	ret void
}

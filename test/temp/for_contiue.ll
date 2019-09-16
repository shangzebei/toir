@str.0 = constant [15 x i8] c"okkkkkkkkkkkk\0A\00"
@str.1 = constant [19 x i8] c"bbbbbbbbbbbbbbbbb\0A\00"

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

define void @for1con() {
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
	br i1 %7, label %8, label %26

; <label>:8
	; block start
	br label %9

; <label>:9
	%10 = load i32, i32* %1
	%11 = icmp sgt i32 %10, 5
	br i1 %11, label %12, label %13

; <label>:12
	; block start
	; end block
	br label %2

; <label>:13
	br label %14

; <label>:14
	%15 = call i8* @malloc(i32 20)
	%16 = bitcast i8* %15 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %16, i32 15)
	%17 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 0
	store i32 15, i32* %17
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 15, i1 false)
	%22 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 3
	%24 = load i8*, i8** %23
	%25 = call i32 (i8*, ...) @printf(i8* %24)
	; end block
	br label %2

; <label>:26
	; empty block
	%27 = call i8* @malloc(i32 20)
	%28 = bitcast i8* %27 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %28, i32 19)
	%29 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 0
	store i32 19, i32* %29
	%30 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 3
	%31 = load i8*, i8** %30
	%32 = bitcast i8* %31 to i8*
	%33 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %32, i8* %33, i32 19, i1 false)
	%34 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28
	%35 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %28, i32 0, i32 3
	%36 = load i8*, i8** %35
	%37 = call i32 (i8*, ...) @printf(i8* %36)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @for1con()
	; end block
	ret void
}

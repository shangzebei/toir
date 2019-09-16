@str.0 = constant [16 x i8] c"aaaaaaaaaaaaaa\0A\00"
@str.1 = constant [17 x i8] c"bbbbbbbbbbbbbbb\0A\00"
@str.2 = constant [16 x i8] c"aaaaaaaaaaaaaa\0A\00"
@str.3 = constant [17 x i8] c"bbbbbbbbbbbbbbb\0A\00"
@str.4 = constant [13 x i8] c"asdfasfdsaf\0A\00"

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

define i32 @ifr2() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	; end block
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %17

; <label>:5
	; block start
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 16)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 16, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 16, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15)
	; end block
	ret i32 0

; <label>:17
	; block start
	%18 = call i8* @malloc(i32 20)
	%19 = bitcast i8* %18 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %19, i32 17)
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 0
	store i32 17, i32* %20
	%21 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 3
	%22 = load i8*, i8** %21
	%23 = bitcast i8* %22 to i8*
	%24 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %23, i8* %24, i32 17, i1 false)
	%25 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19
	%26 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 3
	%27 = load i8*, i8** %26
	%28 = call i32 (i8*, ...) @printf(i8* %27)
	; end block
	ret i32 1
}

define i32 @ifr1() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %17

; <label>:5
	; block start
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 16)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 16, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 16, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %15)
	; end block
	br label %29

; <label>:17
	; block start
	%18 = call i8* @malloc(i32 20)
	%19 = bitcast i8* %18 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %19, i32 17)
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 0
	store i32 17, i32* %20
	%21 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 3
	%22 = load i8*, i8** %21
	%23 = bitcast i8* %22 to i8*
	%24 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %23, i8* %24, i32 17, i1 false)
	%25 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19
	%26 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %19, i32 0, i32 3
	%27 = load i8*, i8** %26
	%28 = call i32 (i8*, ...) @printf(i8* %27)
	; end block
	ret i32 1

; <label>:29
	; end block
	ret i32 0
}

define void @ifr3() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %6

; <label>:5
	; block start
	; end block
	ret void

; <label>:6
	br label %7

; <label>:7
	%8 = call i8* @malloc(i32 20)
	%9 = bitcast i8* %8 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %9, i32 13)
	%10 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %9, i32 0, i32 0
	store i32 13, i32* %10
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %9, i32 0, i32 3
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 13, i1 false)
	%15 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %9
	%16 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %9, i32 0, i32 3
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	%1 = call i32 @ifr1()
	%2 = call i32 @ifr2()
	call void @ifr3()
	; end block
	ret void
}

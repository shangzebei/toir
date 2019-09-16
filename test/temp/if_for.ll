@str.0 = constant [6 x i8] c"hello\00"

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
	%1 = alloca i32
	store i32 100, i32* %1
	br label %2

; <label>:2
	%3 = load i32, i32* %1
	%4 = icmp sgt i32 %3, 50
	br i1 %4, label %5, label %23

; <label>:5
	; block start
	br label %6

; <label>:6
	%7 = load i32, i32* %1
	%8 = icmp sgt i32 %7, 60
	br i1 %8, label %9, label %21

; <label>:9
	; block start
	%10 = call i8* @malloc(i32 20)
	%11 = bitcast i8* %10 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %11, i32 6)
	%12 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 0
	store i32 6, i32* %12
	%13 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%14 = load i8*, i8** %13
	%15 = bitcast i8* %14 to i8*
	%16 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %15, i8* %16, i32 6, i1 false)
	%17 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %11, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19)
	; end block
	br label %22

; <label>:21
	br label %22

; <label>:22
	; end block
	ret void

; <label>:23
	br label %24

; <label>:24
	; end block
	ret void
}

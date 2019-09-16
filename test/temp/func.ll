@str.0 = constant [4 x i8] c"%d\0A\00"

define i32 @add(i32 %a, i32 %b) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca i32
	store i32 %b, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = add i32 %3, %4
	; end block
	ret i32 %5
}

define i32 @sul(i32 %a, i32 %b) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca i32
	store i32 %b, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = sub i32 %3, %4
	; end block
	ret i32 %5
}

define i32 @call() {
; <label>:0
	; block start
	%1 = call i32 @add(i32 5, i32 6)
	; end block
	ret i32 %1
}

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
	%1 = add i32 1, 1
	%2 = sub i32 %1, 1
	%3 = call i32 @call()
	%4 = call i32 @sul(i32 %3, i32 1)
	%5 = call i32 @add(i32 %2, i32 %4)
	%6 = alloca i32
	store i32 %5, i32* %6
	%7 = call i8* @malloc(i32 20)
	%8 = bitcast i8* %7 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %8, i32 4)
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %8, i32 0, i32 0
	store i32 4, i32* %9
	%10 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %8, i32 0, i32 3
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 4, i1 false)
	%14 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %8
	%15 = load i32, i32* %6
	%16 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %8, i32 0, i32 3
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17, i32 %15)
	; end block
	ret void
}

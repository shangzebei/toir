@tt = global i32 0
@str.0 = constant [10 x i8] c"%d-%d=%d\0A\00"

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

define void @varBool1() {
; <label>:0
	; block start
	%1 = alloca i1
	store i1 true, i1* %1
	; end block
	ret void
}

define void @varBool2() {
; <label>:0
	; block start
	%1 = alloca i1
	store i1 true, i1* %1
	; end block
	ret void
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
	%1 = alloca i32
	store i32 4, i32* %1
	%2 = call i8* @malloc(i32 20)
	%3 = bitcast i8* %2 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %3, i32 10)
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 0
	store i32 10, i32* %4
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 10, i1 false)
	%9 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3
	%10 = load i32, i32* %1
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12, i32 %10, i32 3, i32* @tt)
	; end block
	ret void
}

%return.0.0 = type { i32, i32 }

@str.0 = constant [8 x i8] c"%d--%d\0A\00"

define i32 @k() {
; <label>:0
	; block start
	; end block
	ret i32 85
}

define %return.0.0 @mul2(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = call i32 @k()
	%3 = alloca %return.0.0
	%4 = getelementptr %return.0.0, %return.0.0* %3, i32 0, i32 0
	store i32 %2, i32* %4
	%5 = getelementptr %return.0.0, %return.0.0* %3, i32 0, i32 1
	store i32 5, i32* %5
	%6 = load %return.0.0, %return.0.0* %3
	; end block
	ret %return.0.0 %6
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
	%1 = call %return.0.0 @mul2(i32 1)
	%2 = extractvalue %return.0.0 %1, 0
	%3 = extractvalue %return.0.0 %1, 1
	%4 = alloca i32
	store i32 %2, i32* %4
	%5 = alloca i32
	store i32 %3, i32* %5
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 8)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 8, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 8, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = load i32, i32* %4
	%15 = load i32, i32* %5
	%16 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17, i32 %14, i32 %15)
	; end block
	ret void
}

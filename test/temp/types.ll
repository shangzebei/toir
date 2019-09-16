@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [4 x i8] c"%d\0A\00"
@str.2 = constant [4 x i8] c"%f\0A\00"

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

define void @t(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = call i8* @malloc(i32 20)
	%3 = bitcast i8* %2 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %3, i32 4)
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 0
	store i32 4, i32* %4
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 4, i1 false)
	%9 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3
	%10 = load i32, i32* %1
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12, i32 %10)
	; end block
	ret void
}

define void @tt(i64 %a) {
; <label>:0
	; block start
	%1 = alloca i64
	store i64 %a, i64* %1
	%2 = call i8* @malloc(i32 20)
	%3 = bitcast i8* %2 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %3, i32 4)
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 0
	store i32 4, i32* %4
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 4, i1 false)
	%9 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3
	%10 = load i64, i64* %1
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12, i64 %10)
	; end block
	ret void
}

define void @ff(float %float322) {
; <label>:0
	; block start
	%1 = alloca float
	store float %float322, float* %1
	%2 = call i8* @malloc(i32 20)
	%3 = bitcast i8* %2 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %3, i32 4)
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 0
	store i32 4, i32* %4
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 4, i1 false)
	%9 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3
	%10 = load float, float* %1
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12, float %10)
	; end block
	ret void
}

define void @b() {
; <label>:0
	; block start
	%1 = alloca i1
	store i1 true, i1* %1
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	%1 = trunc i32 23 to i8
	%2 = alloca i8
	store i8 %1, i8* %2
	%3 = trunc i32 234 to i16
	%4 = alloca i16
	store i16 %3, i16* %4
	%5 = alloca i32
	store i32 235, i32* %5
	%6 = sext i32 2356 to i64
	%7 = alloca i64
	store i64 %6, i64* %7
	%8 = alloca float
	store float 0x4028AC0840000000, float* %8
	%9 = alloca float
	store float 0x4028AC0840000000, float* %9
	%10 = alloca i32
	store i32 1236, i32* %10
	%11 = load i32, i32* %10
	%12 = trunc i32 %11 to i8
	%13 = sext i8 %12 to i32
	call void @t(i32 %13)
	%14 = load i32, i32* %10
	%15 = sext i32 %14 to i64
	call void @tt(i64 %15)
	%16 = load i32, i32* %10
	%17 = sitofp i32 %16 to float
	call void @ff(float %17)
	%18 = load float, float* %8
	%19 = fptosi float %18 to i32
	call void @t(i32 %19)
	; end block
	ret void
}

%mapStruct = type {}
%string = type { i32, i8* }

@main.str.0 = constant [4 x i8] c"%d\0A\00"
@main.str.1 = constant [4 x i8] c"%d\0A\00"
@main.str.2 = constant [4 x i8] c"%f\0A\00"

declare i8* @malloc(i32)

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 16)
	%3 = bitcast i8* %2 to %string*
	%4 = alloca %string*
	store %string* %3, %string** %4
	br label %5

; <label>:5
	%6 = load i32, i32* %1
	%7 = icmp eq i32 %6, 0
	br i1 %7, label %8, label %10

; <label>:8
	; block start
	%9 = load %string*, %string** %4
	; end block
	ret %string* %9

; <label>:10
	br label %11

; <label>:11
	; IF NEW BLOCK
	%12 = load %string*, %string** %4
	%13 = getelementptr %string, %string* %12, i32 0, i32 0
	%14 = load i32, i32* %13
	%15 = load i32, i32* %1
	store i32 %15, i32* %13
	%16 = load i32, i32* %1
	%17 = add i32 %16, 1
	%18 = call i8* @malloc(i32 %17)
	%19 = load %string*, %string** %4
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	store i8* %18, i8** %20
	%22 = load %string*, %string** %4
	; end block
	ret %string* %22
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @test.t(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = call %string* @runtime.newString(i32 3)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @main.str.0, i64 0, i64 0) to i8*
	%7 = getelementptr %string, %string* %2, i32 0, i32 0
	%8 = load i32, i32* %7
	%9 = add i32 %8, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 %9, i1 false)
	%10 = load %string, %string* %2
	%11 = load i32, i32* %1
	%12 = getelementptr %string, %string* %2, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13, i32 %11)
	; end block
	ret void
}

define void @test.tt(i64 %a) {
; <label>:0
	; block start
	%1 = alloca i64
	store i64 %a, i64* %1
	%2 = call %string* @runtime.newString(i32 3)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @main.str.1, i64 0, i64 0) to i8*
	%7 = getelementptr %string, %string* %2, i32 0, i32 0
	%8 = load i32, i32* %7
	%9 = add i32 %8, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 %9, i1 false)
	%10 = load %string, %string* %2
	%11 = load i64, i64* %1
	%12 = getelementptr %string, %string* %2, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13, i64 %11)
	; end block
	ret void
}

define void @test.ff(float %float322) {
; <label>:0
	; block start
	%1 = alloca float
	store float %float322, float* %1
	%2 = call %string* @runtime.newString(i32 3)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @main.str.2, i64 0, i64 0) to i8*
	%7 = getelementptr %string, %string* %2, i32 0, i32 0
	%8 = load i32, i32* %7
	%9 = add i32 %8, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 %9, i1 false)
	%10 = load %string, %string* %2
	%11 = load float, float* %1
	%12 = getelementptr %string, %string* %2, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = call i32 (i8*, ...) @printf(i8* %13, float %11)
	; end block
	ret void
}

define void @test.b() {
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
	call void @test.t(i32 %13)
	%14 = load i32, i32* %10
	%15 = sext i32 %14 to i64
	call void @test.tt(i64 %15)
	%16 = load i32, i32* %10
	%17 = sitofp i32 %16 to float
	call void @test.ff(float %17)
	%18 = load float, float* %8
	%19 = fptosi float %18 to i32
	call void @test.t(i32 %19)
	; end block
	ret void
}

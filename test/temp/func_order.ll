%One = type {}
%Two = type {}

@str.0 = constant [10 x i8] c"aaaaaaaa\0A\00"

define void @a2() {
; <label>:0
	; block start
	call void @a1()
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

define void @a1() {
; <label>:0
	; block start
	call void @a2()
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %2, i32 10)
	%3 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 0
	store i32 10, i32* %3
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 10, i1 false)
	%8 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = call i32 (i8*, ...) @printf(i8* %10)
	; end block
	ret void
}

define void @main.One.Kkkk(%One* %t) {
; <label>:0
	; block start
	; end block
	ret void
}

define void @main.Two.two1(%Two* %t) {
; <label>:0
	; block start
	call void @main.Two.two(%Two* %t)
	; end block
	ret void
}

define void @main.Two.two(%Two* %t) {
; <label>:0
	; block start
	call void @main.Two.two1(%Two* %t)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	; end block
	ret void
}

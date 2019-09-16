%Hello = type { { i32, i32, i32, i8* }, i32 }

@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [6 x i8] c"shang\00"
@str.2 = constant [4 x i8] c"%s\0A\00"

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

define void @main.Hello.Show(%Hello %h) {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %Hello*
	store %Hello %h, %Hello* %2
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %4, i32 4)
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 0
	store i32 4, i32* %5
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 4, i1 false)
	%10 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	%11 = getelementptr %Hello, %Hello* %2, i32 0, i32 1
	%12 = load i32, i32* %11
	%13 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%14 = load i8*, i8** %13
	%15 = call i32 (i8*, ...) @printf(i8* %14, i32 %12)
	; end block
	ret void
}

define void @init.Hello.18501568619439(%Hello*) {
; <label>:1
	%2 = getelementptr %Hello, %Hello* %0, i32 0, i32 0
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %4, i32 6)
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 0
	store i32 6, i32* %5
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 6, i1 false)
	%10 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	store { i32, i32, i32, i8* } %10, { i32, i32, i32, i8* }* %2
	%11 = getelementptr %Hello, %Hello* %0, i32 0, i32 1
	store i32 12, i32* %11
	ret void
}

define void @main() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %Hello*
	call void @init.Hello.18501568619439(%Hello* %2)
	%3 = load %Hello, %Hello* %2
	%4 = call i8* @malloc(i32 12)
	%5 = bitcast i8* %4 to %Hello*
	store %Hello %3, %Hello* %5
	%6 = load %Hello, %Hello* %5
	call void @main.Hello.Show(%Hello %6)
	%7 = call i8* @malloc(i32 20)
	%8 = bitcast i8* %7 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %8, i32 4)
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %8, i32 0, i32 0
	store i32 4, i32* %9
	%10 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %8, i32 0, i32 3
	%11 = load i8*, i8** %10
	%12 = bitcast i8* %11 to i8*
	%13 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %12, i8* %13, i32 4, i1 false)
	%14 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %8
	%15 = getelementptr %Hello, %Hello* %5, i32 0, i32 0
	%16 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15
	%17 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %8, i32 0, i32 3
	%18 = load i8*, i8** %17
	%19 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %15, i32 0, i32 3
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %18, i8* %20)
	; end block
	ret void
}

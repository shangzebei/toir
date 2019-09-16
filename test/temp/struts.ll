%Person = type { { i32, i32, i32, i8* }, { i32, i32, i32, i8* }, i32 }

@str.0 = constant [4 x i8] c"man\00"
@str.1 = constant [10 x i8] c"%s-%s-%d\0A\00"
@str.2 = constant [4 x i8] c"man\00"
@str.3 = constant [4 x i8] c"%s\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [18 x i8] c"tttttttttttttttt\0A\00"

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

define void @init.Person.71561568619439(%Person*) {
; <label>:1
	%2 = getelementptr %Person, %Person* %0, i32 0, i32 1
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
	store { i32, i32, i32, i8* } %10, { i32, i32, i32, i8* }* %2
	%11 = getelementptr %Person, %Person* %0, i32 0, i32 2
	store i32 12, i32* %11
	ret void
}

declare i32 @printf(i8*, ...)

define void @initS() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to %Person*
	call void @init.Person.71561568619439(%Person* %2)
	%3 = load %Person, %Person* %2
	%4 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%5 = load i32, i32* %4
	store i32 45, i32* %4
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 10)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 10, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 10, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = getelementptr %Person, %Person* %2, i32 0, i32 0
	%15 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %14
	%16 = getelementptr %Person, %Person* %2, i32 0, i32 1
	%17 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16
	%18 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%19 = load i32, i32* %18
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%21 = load i8*, i8** %20
	%22 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %14, i32 0, i32 3
	%23 = load i8*, i8** %22
	%24 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 3
	%25 = load i8*, i8** %24
	%26 = call i32 (i8*, ...) @printf(i8* %21, i8* %23, i8* %25, i32 %19)
	; end block
	ret void
}

define void @init.Person.30431568619439(%Person*) {
; <label>:1
	%2 = getelementptr %Person, %Person* %0, i32 0, i32 1
	%3 = call i8* @malloc(i32 20)
	%4 = bitcast i8* %3 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %4, i32 4)
	%5 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 0
	store i32 4, i32* %5
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4, i32 0, i32 3
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 4, i1 false)
	%10 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %4
	store { i32, i32, i32, i8* } %10, { i32, i32, i32, i8* }* %2
	%11 = getelementptr %Person, %Person* %0, i32 0, i32 2
	store i32 12, i32* %11
	ret void
}

define void @show(i32 %a) {
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
	%8 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 4, i1 false)
	%9 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3
	%10 = load i32, i32* %1
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %3, i32 0, i32 3
	%12 = load i8*, i8** %11
	%13 = call i32 (i8*, ...) @printf(i8* %12, i32 %10)
	; end block
	ret void
}

define void @main.Person.Show(%Person* %p) {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %2, i32 18)
	%3 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 0
	store i32 18, i32* %3
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 18, i1 false)
	%8 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = call i32 (i8*, ...) @printf(i8* %10)
	; end block
	ret void
}

define void @sFunc() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to %Person*
	call void @init.Person.30431568619439(%Person* %2)
	%3 = load %Person, %Person* %2
	%4 = call i8* @malloc(i32 20)
	%5 = bitcast i8* %4 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %5, i32 4)
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5, i32 0, i32 0
	store i32 4, i32* %6
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5, i32 0, i32 3
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 4, i1 false)
	%11 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5
	%12 = getelementptr %Person, %Person* %2, i32 0, i32 0
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %12
	%14 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %5, i32 0, i32 3
	%15 = load i8*, i8** %14
	%16 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %12, i32 0, i32 3
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %15, i8* %17)
	%19 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%20 = load i32, i32* %19
	call void @show(i32 %20)
	call void @main.Person.Show(%Person* %2)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @initS()
	call void @sFunc()
	; end block
	ret void
}

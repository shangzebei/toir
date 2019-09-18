%mapStruct = type {}
%string = type { i32, i8* }
%Person = type { %string, %string, i32 }

@str.0 = constant [4 x i8] c"man\00"
@str.1 = constant [10 x i8] c"%s-%s-%d\0A\00"
@str.2 = constant [4 x i8] c"man\00"
@str.3 = constant [4 x i8] c"%s\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [18 x i8] c"tttttttttttttttt\0A\00"

declare i8* @malloc(i32)

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 12)
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

define void @init.Person.71561568773736(%Person*) {
; <label>:1
	%2 = getelementptr %Person, %Person* %0, i32 0, i32 1
	%3 = call %string* @runtime.newString(i32 3)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	%8 = getelementptr %string, %string* %3, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = add i32 %9, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 %10, i1 false)
	%11 = load %string, %string* %3
	store %string %11, %string* %2
	%12 = getelementptr %Person, %Person* %0, i32 0, i32 2
	store i32 12, i32* %12
	ret void
}

declare i32 @printf(i8*, ...)

define void @test.initS() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to %Person*
	call void @init.Person.71561568773736(%Person* %2)
	%3 = load %Person, %Person* %2
	%4 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%5 = load i32, i32* %4
	store i32 45, i32* %4
	%6 = call %string* @runtime.newString(i32 9)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = getelementptr %Person, %Person* %2, i32 0, i32 0
	%16 = load %string, %string* %15
	%17 = getelementptr %Person, %Person* %2, i32 0, i32 1
	%18 = load %string, %string* %17
	%19 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%20 = load i32, i32* %19
	%21 = getelementptr %string, %string* %6, i32 0, i32 1
	%22 = load i8*, i8** %21
	%23 = getelementptr %string, %string* %15, i32 0, i32 1
	%24 = load i8*, i8** %23
	%25 = getelementptr %string, %string* %17, i32 0, i32 1
	%26 = load i8*, i8** %25
	%27 = call i32 (i8*, ...) @printf(i8* %22, i8* %24, i8* %26, i32 %20)
	; end block
	ret void
}

define void @init.Person.30431568773736(%Person*) {
; <label>:1
	%2 = getelementptr %Person, %Person* %0, i32 0, i32 1
	%3 = call %string* @runtime.newString(i32 3)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	%8 = getelementptr %string, %string* %3, i32 0, i32 0
	%9 = load i32, i32* %8
	%10 = add i32 %9, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 %10, i1 false)
	%11 = load %string, %string* %3
	store %string %11, %string* %2
	%12 = getelementptr %Person, %Person* %0, i32 0, i32 2
	store i32 12, i32* %12
	ret void
}

define void @show(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = call %string* @runtime.newString(i32 3)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
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

define void @main.Person.Show(%Person* %p) {
; <label>:0
	; block start
	%1 = call %string* @runtime.newString(i32 17)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.5, i64 0, i64 0) to i8*
	%6 = getelementptr %string, %string* %1, i32 0, i32 0
	%7 = load i32, i32* %6
	%8 = add i32 %7, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 %8, i1 false)
	%9 = load %string, %string* %1
	%10 = getelementptr %string, %string* %1, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = call i32 (i8*, ...) @printf(i8* %11)
	; end block
	ret void
}

define void @test.sFunc() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to %Person*
	call void @init.Person.30431568773736(%Person* %2)
	%3 = load %Person, %Person* %2
	%4 = call %string* @runtime.newString(i32 3)
	%5 = getelementptr %string, %string* %4, i32 0, i32 1
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	%9 = getelementptr %string, %string* %4, i32 0, i32 0
	%10 = load i32, i32* %9
	%11 = add i32 %10, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 %11, i1 false)
	%12 = load %string, %string* %4
	%13 = getelementptr %Person, %Person* %2, i32 0, i32 0
	%14 = load %string, %string* %13
	%15 = getelementptr %string, %string* %4, i32 0, i32 1
	%16 = load i8*, i8** %15
	%17 = getelementptr %string, %string* %13, i32 0, i32 1
	%18 = load i8*, i8** %17
	%19 = call i32 (i8*, ...) @printf(i8* %16, i8* %18)
	%20 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%21 = load i32, i32* %20
	call void @show(i32 %21)
	call void @main.Person.Show(%Person* %2)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.initS()
	call void @test.sFunc()
	; end block
	ret void
}

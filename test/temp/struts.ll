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

define %string* @newString(i32 %size) {
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
	%12 = load i32, i32* %1
	%13 = sub i32 %12, 1
	%14 = load %string*, %string** %4
	%15 = getelementptr %string, %string* %14, i32 0, i32 0
	%16 = load i32, i32* %15
	store i32 %13, i32* %15
	%17 = load i32, i32* %1
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

define void @init.Person.71561568630589(%Person*) {
; <label>:1
	%2 = getelementptr %Person, %Person* %0, i32 0, i32 1
	%3 = call %string* @newString(i32 4)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 4, i1 false)
	%8 = load %string, %string* %3
	store %string %8, %string* %2
	%9 = getelementptr %Person, %Person* %0, i32 0, i32 2
	store i32 12, i32* %9
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
	call void @init.Person.71561568630589(%Person* %2)
	%3 = load %Person, %Person* %2
	%4 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%5 = load i32, i32* %4
	store i32 45, i32* %4
	%6 = call %string* @newString(i32 10)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 10, i1 false)
	%11 = load %string, %string* %6
	%12 = getelementptr %Person, %Person* %2, i32 0, i32 0
	%13 = load %string, %string* %12
	%14 = getelementptr %Person, %Person* %2, i32 0, i32 1
	%15 = load %string, %string* %14
	%16 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%17 = load i32, i32* %16
	%18 = getelementptr %string, %string* %6, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = getelementptr %string, %string* %12, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = getelementptr %string, %string* %14, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = call i32 (i8*, ...) @printf(i8* %19, i8* %21, i8* %23, i32 %17)
	; end block
	ret void
}

define void @init.Person.30431568630589(%Person*) {
; <label>:1
	%2 = getelementptr %Person, %Person* %0, i32 0, i32 1
	%3 = call %string* @newString(i32 4)
	%4 = getelementptr %string, %string* %3, i32 0, i32 1
	%5 = load i8*, i8** %4
	%6 = bitcast i8* %5 to i8*
	%7 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 4, i1 false)
	%8 = load %string, %string* %3
	store %string %8, %string* %2
	%9 = getelementptr %Person, %Person* %0, i32 0, i32 2
	store i32 12, i32* %9
	ret void
}

define void @show(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = call %string* @newString(i32 4)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* %6, i32 4, i1 false)
	%7 = load %string, %string* %2
	%8 = load i32, i32* %1
	%9 = getelementptr %string, %string* %2, i32 0, i32 1
	%10 = load i8*, i8** %9
	%11 = call i32 (i8*, ...) @printf(i8* %10, i32 %8)
	; end block
	ret void
}

define void @main.Person.Show(%Person* %p) {
; <label>:0
	; block start
	%1 = call %string* @newString(i32 18)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 18, i1 false)
	%6 = load %string, %string* %1
	%7 = getelementptr %string, %string* %1, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = call i32 (i8*, ...) @printf(i8* %8)
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
	call void @init.Person.30431568630589(%Person* %2)
	%3 = load %Person, %Person* %2
	%4 = call %string* @newString(i32 4)
	%5 = getelementptr %string, %string* %4, i32 0, i32 1
	%6 = load i8*, i8** %5
	%7 = bitcast i8* %6 to i8*
	%8 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 4, i1 false)
	%9 = load %string, %string* %4
	%10 = getelementptr %Person, %Person* %2, i32 0, i32 0
	%11 = load %string, %string* %10
	%12 = getelementptr %string, %string* %4, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = getelementptr %string, %string* %10, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = call i32 (i8*, ...) @printf(i8* %13, i8* %15)
	%17 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%18 = load i32, i32* %17
	call void @show(i32 %18)
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

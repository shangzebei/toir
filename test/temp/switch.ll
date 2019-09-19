%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [4 x i8] c"ok\0A\00"

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

define void @show(i32 %a) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = call %string* @runtime.newString(i32 3)
	%3 = getelementptr %string, %string* %2, i32 0, i32 1
	%4 = load i8*, i8** %3
	%5 = bitcast i8* %4 to i8*
	%6 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
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

define void @test.sw1() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 60, i32* %1
	%2 = mul i32 1000, -1
	call void @show(i32 %2)
	%3 = alloca i1
	store i1 false, i1* %3
	br label %4

; <label>:4
	; block start
	br label %5

; <label>:5
	%6 = load i32, i32* %1
	%7 = icmp eq i32 %6, 70
	br i1 %7, label %8, label %9

; <label>:8
	; block start
	store i1 true, i1* %3
	call void @show(i32 1)
	; end block
	br label %10

; <label>:9
	br label %10

; <label>:10
	; IF NEW BLOCK
	br label %11

; <label>:11
	%12 = load i32, i32* %1
	%13 = icmp eq i32 %12, 60
	br i1 %13, label %14, label %15

; <label>:14
	; block start
	store i1 true, i1* %3
	call void @show(i32 2)
	; end block
	br label %16

; <label>:15
	br label %16

; <label>:16
	; IF NEW BLOCK
	br label %17

; <label>:17
	%18 = load i32, i32* %1
	%19 = icmp eq i32 %18, 81
	br i1 %19, label %20, label %21

; <label>:20
	; block start
	store i1 true, i1* %3
	call void @show(i32 3)
	; end block
	br label %22

; <label>:21
	br label %22

; <label>:22
	; IF NEW BLOCK
	; default Case
	br label %23

; <label>:23
	%24 = load i1, i1* %3
	%25 = icmp eq i1 %24, false
	br i1 %25, label %26, label %27

; <label>:26
	; block start
	call void @show(i32 200)
	; end block
	br label %28

; <label>:27
	br label %28

; <label>:28
	; IF NEW BLOCK
	; end block
	br label %29

; <label>:29
	; SWITCH NEW
	call void @show(i32 1000)
	; end block
	ret void
}

define void @test.sw2() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 80, i32* %1
	%2 = mul i32 1000, -1
	call void @show(i32 %2)
	%3 = alloca i1
	store i1 false, i1* %3
	br label %4

; <label>:4
	; block start
	br label %5

; <label>:5
	%6 = load i32, i32* %1
	%7 = icmp eq i32 %6, 70
	br i1 %7, label %8, label %9

; <label>:8
	; block start
	store i1 true, i1* %3
	call void @show(i32 1)
	; end block
	br label %10

; <label>:9
	br label %10

; <label>:10
	; IF NEW BLOCK
	br label %11

; <label>:11
	%12 = load i32, i32* %1
	%13 = icmp eq i32 %12, 60
	br i1 %13, label %14, label %15

; <label>:14
	; block start
	store i1 true, i1* %3
	call void @show(i32 2)
	; end block
	br label %16

; <label>:15
	br label %16

; <label>:16
	; IF NEW BLOCK
	br label %17

; <label>:17
	%18 = load i32, i32* %1
	%19 = icmp eq i32 %18, 81
	br i1 %19, label %20, label %21

; <label>:20
	; block start
	store i1 true, i1* %3
	call void @show(i32 3)
	; end block
	br label %22

; <label>:21
	br label %22

; <label>:22
	; IF NEW BLOCK
	; default Case
	br label %23

; <label>:23
	%24 = load i1, i1* %3
	%25 = icmp eq i1 %24, false
	br i1 %25, label %26, label %27

; <label>:26
	; block start
	call void @show(i32 200)
	; end block
	br label %28

; <label>:27
	br label %28

; <label>:28
	; IF NEW BLOCK
	; end block
	br label %29

; <label>:29
	; SWITCH NEW
	call void @show(i32 1000)
	; end block
	ret void
}

define void @test.sw3() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 80, i32* %1
	%2 = mul i32 1000, -1
	call void @show(i32 %2)
	%3 = alloca i1
	store i1 false, i1* %3
	br label %4

; <label>:4
	; block start
	br label %5

; <label>:5
	%6 = load i32, i32* %1
	%7 = icmp eq i32 %6, 70
	br i1 %7, label %8, label %9

; <label>:8
	; block start
	store i1 true, i1* %3
	call void @show(i32 1)
	; end block
	br label %10

; <label>:9
	br label %10

; <label>:10
	; IF NEW BLOCK
	br label %11

; <label>:11
	%12 = load i32, i32* %1
	%13 = icmp eq i32 %12, 60
	br i1 %13, label %14, label %15

; <label>:14
	; block start
	store i1 true, i1* %3
	call void @show(i32 2)
	; end block
	br label %16

; <label>:15
	br label %16

; <label>:16
	; IF NEW BLOCK
	br label %17

; <label>:17
	%18 = load i32, i32* %1
	%19 = icmp eq i32 %18, 80
	br i1 %19, label %20, label %21

; <label>:20
	; block start
	store i1 true, i1* %3
	call void @show(i32 3)
	; end block
	br label %22

; <label>:21
	br label %22

; <label>:22
	; IF NEW BLOCK
	; default Case
	br label %23

; <label>:23
	%24 = load i1, i1* %3
	%25 = icmp eq i1 %24, false
	br i1 %25, label %26, label %27

; <label>:26
	; block start
	call void @show(i32 200)
	; end block
	br label %28

; <label>:27
	br label %28

; <label>:28
	; IF NEW BLOCK
	; end block
	br label %29

; <label>:29
	; SWITCH NEW
	call void @show(i32 1000)
	; end block
	ret void
}

define i32 @co() {
; <label>:0
	; block start
	; end block
	ret i32 3
}

define void @test.sw() {
; <label>:0
	; block start
	%1 = alloca i1
	store i1 false, i1* %1
	br label %2

; <label>:2
	; block start
	br label %3

; <label>:3
	%4 = call i32 @co()
	%5 = icmp eq i32 %4, 3
	br i1 %5, label %6, label %19

; <label>:6
	; block start
	store i1 true, i1* %1
	%7 = call %string* @runtime.newString(i32 3)
	%8 = getelementptr %string, %string* %7, i32 0, i32 1
	%9 = load i8*, i8** %8
	%10 = bitcast i8* %9 to i8*
	%11 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	%12 = getelementptr %string, %string* %7, i32 0, i32 0
	%13 = load i32, i32* %12
	%14 = add i32 %13, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %11, i32 %14, i1 false)
	%15 = load %string, %string* %7
	%16 = getelementptr %string, %string* %7, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17)
	; end block
	br label %20

; <label>:19
	br label %20

; <label>:20
	; IF NEW BLOCK
	; end block
	br label %21

; <label>:21
	; SWITCH NEW
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.sw()
	call void @test.sw1()
	call void @test.sw2()
	call void @test.sw3()
	; end block
	ret void
}

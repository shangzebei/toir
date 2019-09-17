%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [7 x i8] c"break\0A\00"
@str.1 = constant [4 x i8] c"no\0A\00"
@str.2 = constant [18 x i8] c"bbbbbbbbbbbbbbbb\0A\00"
@str.3 = constant [7 x i8] c"break\0A\00"
@str.4 = constant [4 x i8] c"no\0A\00"
@str.5 = constant [19 x i8] c"bbbbbbbbbbbbbbbbb\0A\00"

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

define void @test.for2break() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 10
	; cond Block end
	br i1 %7, label %8, label %60

; <label>:8
	; block start
	; init block
	%9 = alloca i32
	store i32 0, i32* %9
	br label %13

; <label>:10
	; add block
	%11 = load i32, i32* %9
	%12 = add i32 %11, 1
	store i32 %12, i32* %9
	br label %13

; <label>:13
	; cond Block begin
	%14 = load i32, i32* %9
	%15 = icmp slt i32 %14, 10
	; cond Block end
	br i1 %15, label %16, label %47

; <label>:16
	; block start
	br label %17

; <label>:17
	%18 = load i32, i32* %9
	%19 = icmp sgt i32 %18, 5
	br i1 %19, label %20, label %33

; <label>:20
	; block start
	%21 = call %string* @runtime.newString(i32 6)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	%26 = getelementptr %string, %string* %21, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = add i32 %27, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 %28, i1 false)
	%29 = load %string, %string* %21
	%30 = getelementptr %string, %string* %21, i32 0, i32 1
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %31)
	; end block
	br label %47

; <label>:33
	; block start
	%34 = call %string* @runtime.newString(i32 3)
	%35 = getelementptr %string, %string* %34, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = bitcast i8* %36 to i8*
	%38 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	%39 = getelementptr %string, %string* %34, i32 0, i32 0
	%40 = load i32, i32* %39
	%41 = add i32 %40, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %37, i8* %38, i32 %41, i1 false)
	%42 = load %string, %string* %34
	%43 = getelementptr %string, %string* %34, i32 0, i32 1
	%44 = load i8*, i8** %43
	%45 = call i32 (i8*, ...) @printf(i8* %44)
	; end block
	br label %46

; <label>:46
	; end block
	br label %10

; <label>:47
	; empty block
	%48 = call %string* @runtime.newString(i32 17)
	%49 = getelementptr %string, %string* %48, i32 0, i32 1
	%50 = load i8*, i8** %49
	%51 = bitcast i8* %50 to i8*
	%52 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.2, i64 0, i64 0) to i8*
	%53 = getelementptr %string, %string* %48, i32 0, i32 0
	%54 = load i32, i32* %53
	%55 = add i32 %54, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %51, i8* %52, i32 %55, i1 false)
	%56 = load %string, %string* %48
	%57 = getelementptr %string, %string* %48, i32 0, i32 1
	%58 = load i8*, i8** %57
	%59 = call i32 (i8*, ...) @printf(i8* %58)
	; end block
	br label %2

; <label>:60
	; empty block
	; end block
	ret void
}

define void @test.for1break() {
; <label>:0
	; block start
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 10
	; cond Block end
	br i1 %7, label %8, label %39

; <label>:8
	; block start
	br label %9

; <label>:9
	%10 = load i32, i32* %1
	%11 = icmp sgt i32 %10, 5
	br i1 %11, label %12, label %25

; <label>:12
	; block start
	%13 = call %string* @runtime.newString(i32 6)
	%14 = getelementptr %string, %string* %13, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = bitcast i8* %15 to i8*
	%17 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.3, i64 0, i64 0) to i8*
	%18 = getelementptr %string, %string* %13, i32 0, i32 0
	%19 = load i32, i32* %18
	%20 = add i32 %19, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %16, i8* %17, i32 %20, i1 false)
	%21 = load %string, %string* %13
	%22 = getelementptr %string, %string* %13, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = call i32 (i8*, ...) @printf(i8* %23)
	; end block
	br label %39

; <label>:25
	; block start
	%26 = call %string* @runtime.newString(i32 3)
	%27 = getelementptr %string, %string* %26, i32 0, i32 1
	%28 = load i8*, i8** %27
	%29 = bitcast i8* %28 to i8*
	%30 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	%31 = getelementptr %string, %string* %26, i32 0, i32 0
	%32 = load i32, i32* %31
	%33 = add i32 %32, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %29, i8* %30, i32 %33, i1 false)
	%34 = load %string, %string* %26
	%35 = getelementptr %string, %string* %26, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = call i32 (i8*, ...) @printf(i8* %36)
	; end block
	br label %38

; <label>:38
	; end block
	br label %2

; <label>:39
	; empty block
	%40 = call %string* @runtime.newString(i32 18)
	%41 = getelementptr %string, %string* %40, i32 0, i32 1
	%42 = load i8*, i8** %41
	%43 = bitcast i8* %42 to i8*
	%44 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.5, i64 0, i64 0) to i8*
	%45 = getelementptr %string, %string* %40, i32 0, i32 0
	%46 = load i32, i32* %45
	%47 = add i32 %46, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %43, i8* %44, i32 %47, i1 false)
	%48 = load %string, %string* %40
	%49 = getelementptr %string, %string* %40, i32 0, i32 1
	%50 = load i8*, i8** %49
	%51 = call i32 (i8*, ...) @printf(i8* %50)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.for2break()
	; end block
	ret void
}

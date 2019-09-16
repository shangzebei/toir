%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [7 x i8] c"break\0A\00"
@str.1 = constant [4 x i8] c"no\0A\00"
@str.2 = constant [18 x i8] c"bbbbbbbbbbbbbbbb\0A\00"
@str.3 = constant [7 x i8] c"break\0A\00"
@str.4 = constant [4 x i8] c"no\0A\00"
@str.5 = constant [19 x i8] c"bbbbbbbbbbbbbbbbb\0A\00"

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

declare i32 @printf(i8*, ...)

define void @for2break() {
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
	br i1 %7, label %8, label %51

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
	br i1 %15, label %16, label %41

; <label>:16
	; block start
	br label %17

; <label>:17
	%18 = load i32, i32* %9
	%19 = icmp sgt i32 %18, 5
	br i1 %19, label %20, label %30

; <label>:20
	; block start
	%21 = call %string* @newString(i32 7)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 7, i1 false)
	%26 = load %string, %string* %21
	%27 = getelementptr %string, %string* %21, i32 0, i32 1
	%28 = load i8*, i8** %27
	%29 = call i32 (i8*, ...) @printf(i8* %28)
	; end block
	br label %41

; <label>:30
	; block start
	%31 = call %string* @newString(i32 4)
	%32 = getelementptr %string, %string* %31, i32 0, i32 1
	%33 = load i8*, i8** %32
	%34 = bitcast i8* %33 to i8*
	%35 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %34, i8* %35, i32 4, i1 false)
	%36 = load %string, %string* %31
	%37 = getelementptr %string, %string* %31, i32 0, i32 1
	%38 = load i8*, i8** %37
	%39 = call i32 (i8*, ...) @printf(i8* %38)
	; end block
	br label %40

; <label>:40
	; end block
	br label %10

; <label>:41
	; empty block
	%42 = call %string* @newString(i32 18)
	%43 = getelementptr %string, %string* %42, i32 0, i32 1
	%44 = load i8*, i8** %43
	%45 = bitcast i8* %44 to i8*
	%46 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %45, i8* %46, i32 18, i1 false)
	%47 = load %string, %string* %42
	%48 = getelementptr %string, %string* %42, i32 0, i32 1
	%49 = load i8*, i8** %48
	%50 = call i32 (i8*, ...) @printf(i8* %49)
	; end block
	br label %2

; <label>:51
	; empty block
	; end block
	ret void
}

define void @for1break() {
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
	br i1 %7, label %8, label %33

; <label>:8
	; block start
	br label %9

; <label>:9
	%10 = load i32, i32* %1
	%11 = icmp sgt i32 %10, 5
	br i1 %11, label %12, label %22

; <label>:12
	; block start
	%13 = call %string* @newString(i32 7)
	%14 = getelementptr %string, %string* %13, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = bitcast i8* %15 to i8*
	%17 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %16, i8* %17, i32 7, i1 false)
	%18 = load %string, %string* %13
	%19 = getelementptr %string, %string* %13, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20)
	; end block
	br label %33

; <label>:22
	; block start
	%23 = call %string* @newString(i32 4)
	%24 = getelementptr %string, %string* %23, i32 0, i32 1
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to i8*
	%27 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 4, i1 false)
	%28 = load %string, %string* %23
	%29 = getelementptr %string, %string* %23, i32 0, i32 1
	%30 = load i8*, i8** %29
	%31 = call i32 (i8*, ...) @printf(i8* %30)
	; end block
	br label %32

; <label>:32
	; end block
	br label %2

; <label>:33
	; empty block
	%34 = call %string* @newString(i32 19)
	%35 = getelementptr %string, %string* %34, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = bitcast i8* %36 to i8*
	%38 = bitcast i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %37, i8* %38, i32 19, i1 false)
	%39 = load %string, %string* %34
	%40 = getelementptr %string, %string* %34, i32 0, i32 1
	%41 = load i8*, i8** %40
	%42 = call i32 (i8*, ...) @printf(i8* %41)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @for2break()
	; end block
	ret void
}

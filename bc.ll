%slice = type { i32, i32, i32, i8* }

@main.0 = constant [5 x i32] [i32 1, i32 22, i32 33, i32 44, i32 5]
@str.0 = constant [20 x i8] c"checkGrow bytes %d\0A\00"
@str.1 = constant [4 x i8] c"%d\0A\00"

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

declare i8* @malloc(i32)

define i8* @checkGrow(%slice* %s) {
; <label>:0
	%1 = getelementptr %slice, %slice* %s, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = getelementptr %slice, %slice* %s, i32 0, i32 1
	%4 = load i32, i32* %3
	%5 = icmp sge i32 %2, %4
	br i1 %5, label %6, label %32

; <label>:6
	%7 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%8 = load i32, i32* %7
	%9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @str.0, i64 0, i64 0), i32 %8)
	%10 = getelementptr %slice, %slice* %s, i32 0, i32 0
	%11 = load i32, i32* %10
	%12 = add i32 %11, 4
	%13 = alloca i32
	store i32 %12, i32* %13
	%14 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%15 = load i32, i32* %14
	%16 = load i32, i32* %13
	%17 = mul i32 %16, %15
	%18 = call i8* @malloc(i32 %17)
	%19 = alloca i8*
	store i8* %18, i8** %19
	%20 = load i8*, i8** %19
	%21 = getelementptr %slice, %slice* %s, i32 0, i32 3
	%22 = load i8*, i8** %21
	%23 = getelementptr %slice, %slice* %s, i32 0, i32 0
	%24 = load i32, i32* %23
	%25 = getelementptr %slice, %slice* %s, i32 0, i32 2
	%26 = load i32, i32* %25
	%27 = mul i32 %24, %26
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %22, i32 %27, i1 false)
	%28 = getelementptr %slice, %slice* %s, i32 0, i32 1
	%29 = load i32, i32* %28
	%30 = load i32, i32* %13
	store i32 %30, i32* %28
	%31 = load i8*, i8** %19
	ret i8* %31

; <label>:32
	%33 = getelementptr %slice, %slice* %s, i32 0, i32 3
	%34 = load i8*, i8** %33
	ret i8* %34
}

define %slice* @copyNewSlice(%slice* %src) {
; <label>:0
	%array.1 = alloca %slice
	%1 = getelementptr %slice, %slice* %src, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = getelementptr %slice, %slice* %src, i32 0, i32 2
	%4 = load i32, i32* %3
	%5 = mul i32 %2, %4
	%6 = alloca i32
	store i32 %5, i32* %6
	%7 = load i32, i32* %6
	%8 = call i8* @malloc(i32 %7)
	%9 = alloca i8*
	store i8* %8, i8** %9
	%10 = load i8*, i8** %9
	%11 = getelementptr %slice, %slice* %src, i32 0, i32 3
	%12 = load i8*, i8** %11
	%13 = load i32, i32* %6
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %12, i32 %13, i1 false)
	%14 = getelementptr %slice, %slice* %src, i32 0, i32 2
	%15 = load i32, i32* %14
	%16 = getelementptr %slice, %slice* %array.1, i32 0, i32 2
	%17 = load i32, i32* %16
	store i32 %15, i32* %16
	%18 = getelementptr %slice, %slice* %src, i32 0, i32 0
	%19 = load i32, i32* %18
	%20 = getelementptr %slice, %slice* %array.1, i32 0, i32 0
	%21 = load i32, i32* %20
	store i32 %19, i32* %20
	%22 = getelementptr %slice, %slice* %src, i32 0, i32 1
	%23 = load i32, i32* %22
	%24 = getelementptr %slice, %slice* %array.1, i32 0, i32 1
	%25 = load i32, i32* %24
	store i32 %23, i32* %24
	%26 = getelementptr %slice, %slice* %array.1, i32 0, i32 3
	%27 = load i8*, i8** %26
	%28 = load i8*, i8** %9
	store i8* %28, i8** %26
	ret %slice* %array.1
}

define void @main() {
; <label>:0
	%array.1 = alloca %slice
	%1 = getelementptr %slice, %slice* %array.1, i32 0, i32 2
	store i32 4, i32* %1
	%2 = alloca [5 x i32]
	%3 = bitcast [5 x i32]* %2 to i8*
	%4 = getelementptr %slice, %slice* %array.1, i32 0, i32 3
	store i8* %3, i8** %4
	%5 = getelementptr %slice, %slice* %array.1, i32 0, i32 0
	store i32 5, i32* %5
	%6 = getelementptr %slice, %slice* %array.1, i32 0, i32 1
	store i32 5, i32* %6
	%7 = getelementptr %slice, %slice* %array.1, i32 0, i32 3
	%8 = load i8*, i8** %7
	%9 = bitcast [5 x i32]* @main.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 20, i1 false)
	%10 = load %slice, %slice* %array.1
	; append start---------------------
	%11 = call i8* @checkGrow(%slice* %array.1)
	%12 = getelementptr %slice, %slice* %array.1, i32 0, i32 0
	%13 = load i32, i32* %12
	%14 = call %slice* @copyNewSlice(%slice* %array.1)
	%15 = alloca %slice*
	store %slice* %14, %slice** %15
	%16 = load %slice*, %slice** %15
	%17 = getelementptr %slice, %slice* %16, i32 0, i32 3
	%18 = getelementptr %slice, %slice* %16, i32 0, i32 0
	store i8* %11, i8** %17
	; append value
	%19 = load i8*, i8** %17
	%20 = bitcast i8* %19 to i32*
	%21 = getelementptr i32, i32* %20, i32 %13
	store i32 89, i32* %21
	; store len value
	%22 = add i32 %13, 1
	store i32 %22, i32* %18
	; append end-------------------------
	%23 = load %slice, %slice* %16
	%24 = alloca i32
	store i32 0, i32* %24
	br label %28

; <label>:25
	%26 = load i32, i32* %24
	%27 = add i32 %26, 1
	store i32 %27, i32* %24
	br label %36

; <label>:28
	%29 = load i32, i32* %24
	%30 = getelementptr %slice, %slice* %16, i32 0, i32 3
	%31 = load i8*, i8** %30
	%32 = bitcast i8* %31 to i32*
	%33 = getelementptr i32, i32* %32, i32 %29
	%34 = load i32, i32* %33
	%35 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0), i32 %34)
	br label %25

; <label>:36
	%37 = extractvalue %slice %23, 0
	%38 = load i32, i32* %24
	%39 = icmp slt i32 %38, %37
	br i1 %39, label %28, label %40

; <label>:40
	ret void
}

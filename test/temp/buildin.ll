%Per = type { i8* }

@copyt.0 = constant [3 x i32] [i32 1, i32 2, i32 3]
@copyt.1 = constant [6 x i32] [i32 4, i32 5, i32 6, i32 7, i32 8, i32 9]
@str.0 = constant [19 x i8] c"%d-%d-%d-%d-%d-%d\0A\00"
@str.1 = constant [6 x i8] c"see@ \00"
@str.2 = constant [19 x i8] c"%s len=%d cap=%d \0A\00"
@str.3 = constant [4 x i8] c"%d\0A\00"
@str.4 = constant [12 x i8] c"asdfasdfasd\00"
@str.5 = constant [4 x i8] c"%s\0A\00"

declare i8* @malloc(i32)

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @copyt() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, i32* }
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 3, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	store i32 3, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 3, i32* %7
	; end init slice.................
	%8 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 3, i32* %8
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = bitcast i32* %10 to i8*
	%12 = bitcast [3 x i32]* @copyt.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 12, i1 false)
	%13 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	; init slice...............
	%array.26 = alloca { i32, i32, i32, i32* }
	%14 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 2
	store i32 4, i32* %14
	%15 = mul i32 6, 4
	%16 = call i8* @malloc(i32 %15)
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%18 = bitcast i8* %16 to i32*
	store i32* %18, i32** %17
	%19 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 1
	store i32 6, i32* %19
	%20 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 0
	store i32 6, i32* %20
	; end init slice.................
	%21 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 0
	store i32 6, i32* %21
	%22 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%23 = load i32*, i32** %22
	%24 = bitcast i32* %23 to i8*
	%25 = bitcast [6 x i32]* @copyt.1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 24, i1 false)
	%26 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26
	; copy ptr..........start
	%27 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	%28 = load i32, i32* %27
	%29 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%30 = load i32*, i32** %29
	%31 = bitcast i32* %30 to i8*
	%32 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%33 = load i32*, i32** %32
	%34 = bitcast i32* %33 to i8*
	%35 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	%36 = load i32, i32* %35
	%37 = mul i32 %28, %36
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %31, i8* %34, i32 %37, i1 false)
	; copy ptr..........end
	; get slice index
	%38 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%39 = load i32*, i32** %38
	%40 = getelementptr i32, i32* %39, i32 0
	%41 = load i32, i32* %40
	; get slice index
	%42 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%43 = load i32*, i32** %42
	%44 = getelementptr i32, i32* %43, i32 1
	%45 = load i32, i32* %44
	; get slice index
	%46 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%47 = load i32*, i32** %46
	%48 = getelementptr i32, i32* %47, i32 2
	%49 = load i32, i32* %48
	; get slice index
	%50 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%51 = load i32*, i32** %50
	%52 = getelementptr i32, i32* %51, i32 3
	%53 = load i32, i32* %52
	; get slice index
	%54 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%55 = load i32*, i32** %54
	%56 = getelementptr i32, i32* %55, i32 4
	%57 = load i32, i32* %56
	; get slice index
	%58 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.26, i32 0, i32 3
	%59 = load i32*, i32** %58
	%60 = getelementptr i32, i32* %59, i32 5
	%61 = load i32, i32* %60
	%62 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.0, i64 0, i64 0), i32 %41, i32 %45, i32 %49, i32 %53, i32 %57, i32 %61)
	ret void
}

define void @printSlice(i8* %s, { i32, i32, i32, i32* } %x) {
; <label>:0
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i32* }*
	store { i32, i32, i32, i32* } %x, { i32, i32, i32, i32* }* %2
	%3 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 0
	%5 = load i32, i32* %4
	%6 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %2, i32 0, i32 1
	%8 = load i32, i32* %7
	%9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.2, i64 0, i64 0), i8* %s, i32 %5, i32 %8)
	ret void
}

define void @make1() {
; <label>:0
	; init slice...............
	%array.4 = alloca { i32, i32, i32, i32* }
	%1 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 2
	store i32 4, i32* %1
	%2 = mul i32 3, 4
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%5 = bitcast i8* %3 to i32*
	store i32* %5, i32** %4
	%6 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 1
	store i32 3, i32* %6
	%7 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 0
	store i32 3, i32* %7
	; end init slice.................
	%8 = load { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4
	call void @printSlice(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0), { i32, i32, i32, i32* } %8)
	; get slice index
	%9 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%10 = load i32*, i32** %9
	%11 = getelementptr i32, i32* %10, i32 0
	%12 = load i32, i32* %11
	store i32 90, i32* %11
	; get slice index
	%13 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%14 = load i32*, i32** %13
	%15 = getelementptr i32, i32* %14, i32 1
	%16 = load i32, i32* %15
	store i32 50, i32* %15
	; get slice index
	%17 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%18 = load i32*, i32** %17
	%19 = getelementptr i32, i32* %18, i32 2
	%20 = load i32, i32* %19
	store i32 70, i32* %19
	; init block
	%21 = alloca i32
	store i32 0, i32* %21
	br label %25

; <label>:22
	; add block
	%23 = load i32, i32* %21
	%24 = add i32 %23, 1
	store i32 %24, i32* %21
	br label %25

; <label>:25
	; cond Block begin
	%26 = load i32, i32* %21
	%27 = icmp slt i32 %26, 3
	; cond Block end
	br i1 %27, label %28, label %35

; <label>:28
	%29 = load i32, i32* %21
	; get slice index
	%30 = getelementptr { i32, i32, i32, i32* }, { i32, i32, i32, i32* }* %array.4, i32 0, i32 3
	%31 = load i32*, i32** %30
	%32 = getelementptr i32, i32* %31, i32 %29
	%33 = load i32, i32* %32
	%34 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0), i32 %33)
	br label %22

; <label>:35
	; empty block
	ret void
}

define void @newF() {
; <label>:0
	%1 = call i8* @malloc(i32 8)
	%2 = bitcast i8* %1 to %Per*
	%3 = alloca %Per*
	store %Per* %2, %Per** %3
	%4 = load %Per*, %Per** %3
	%5 = getelementptr %Per, %Per* %4, i32 0, i32 0
	%6 = load i8*, i8** %5
	store i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.4, i64 0, i64 0), i8** %5
	%7 = load %Per*, %Per** %3
	%8 = getelementptr %Per, %Per* %7, i32 0, i32 0
	%9 = load i8*, i8** %8
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0), i8* %9)
	ret void
}

define void @main() {
; <label>:0
	call void @copyt()
	call void @newF()
	call void @make1()
	ret void
}

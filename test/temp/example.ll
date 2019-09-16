%mapStruct = type {}
%string = type { i32, i8* }

@str.0 = constant [11 x i8] c"shangzebei\00"
@str.1 = constant [4 x i8] c"%s\0A\00"
@str.2 = constant [4 x i8] c"%d\0A\00"
@str.3 = constant [4 x i8] c"%c\0A\00"
@str.4 = constant [8 x i8] c"%d==%c\0A\00"
@str.5 = constant [4 x i8] c"%s\0A\00"

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

define i32 @getStringLen(%string* %s) {
; <label>:0
	; block start
	%1 = getelementptr %string, %string* %s, i32 0, i32 0
	%2 = load i32, i32* %1
	; end block
	ret i32 %2
}

define i8* @rangeSlice(i8* %ptr, i32 %low, i32 %high, i32 %bytes) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %low, i32* %1
	%2 = alloca i32
	store i32 %high, i32* %2
	%3 = alloca i32
	store i32 %bytes, i32* %3
	%4 = load i32, i32* %2
	%5 = load i32, i32* %1
	%6 = sub i32 %4, %5
	%7 = alloca i32
	store i32 %6, i32* %7
	%8 = load i32, i32* %7
	%9 = load i32, i32* %3
	%10 = mul i32 %8, %9
	%11 = alloca i32
	store i32 %10, i32* %11
	%12 = load i32, i32* %11
	%13 = call i8* @malloc(i32 %12)
	%14 = alloca i8*
	store i8* %13, i8** %14
	%15 = load i8*, i8** %14
	%16 = load i32, i32* %3
	%17 = load i32, i32* %1
	%18 = mul i32 %16, %17
	%19 = getelementptr i8, i8* %ptr, i32 %18
	%20 = load i32, i32* %11
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %15, i8* %19, i32 %20, i1 false)
	%21 = load i8*, i8** %14
	; end block
	ret i8* %21
}

define void @main() {
; <label>:0
	; block start
	%1 = call %string* @newString(i32 11)
	%2 = getelementptr %string, %string* %1, i32 0, i32 1
	%3 = load i8*, i8** %2
	%4 = bitcast i8* %3 to i8*
	%5 = bitcast i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %4, i8* %5, i32 11, i1 false)
	%6 = load %string, %string* %1
	%7 = call %string* @newString(i32 0)
	store %string %6, %string* %7
	%8 = call %string* @newString(i32 4)
	%9 = getelementptr %string, %string* %8, i32 0, i32 1
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 4, i1 false)
	%13 = load %string, %string* %8
	%14 = getelementptr %string, %string* %8, i32 0, i32 1
	%15 = load i8*, i8** %14
	%16 = getelementptr %string, %string* %7, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %15, i8* %17)
	%19 = call %string* @newString(i32 4)
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 4, i1 false)
	%24 = load %string, %string* %19
	%25 = call i32 @getStringLen(%string* %7)
	%26 = getelementptr %string, %string* %19, i32 0, i32 1
	%27 = load i8*, i8** %26
	%28 = call i32 (i8*, ...) @printf(i8* %27, i32 %25)
	%29 = call %string* @newString(i32 4)
	%30 = getelementptr %string, %string* %29, i32 0, i32 1
	%31 = load i8*, i8** %30
	%32 = bitcast i8* %31 to i8*
	%33 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %32, i8* %33, i32 4, i1 false)
	%34 = load %string, %string* %29
	; get slice index
	%35 = getelementptr %string, %string* %7, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = getelementptr i8, i8* %36, i32 1
	%38 = load i8, i8* %37
	%39 = getelementptr %string, %string* %29, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = call i32 (i8*, ...) @printf(i8* %40, i8 %38)
	; [range start]
	%42 = getelementptr %string, %string* %7, i32 0, i32 0
	%43 = load i32, i32* %42
	%44 = alloca i32
	%45 = alloca i8
	; [range end]
	; init block
	%46 = alloca i32
	store i32 0, i32* %46
	br label %50

; <label>:47
	; add block
	%48 = load i32, i32* %46
	%49 = add i32 %48, 1
	store i32 %49, i32* %46
	br label %50

; <label>:50
	; cond Block begin
	%51 = load i32, i32* %46
	%52 = icmp slt i32 %51, %43
	; cond Block end
	br i1 %52, label %53, label %71

; <label>:53
	; block start
	%54 = load i32, i32* %46
	store i32 %54, i32* %44
	%55 = load i32, i32* %46
	; get slice index
	%56 = getelementptr %string, %string* %7, i32 0, i32 1
	%57 = load i8*, i8** %56
	%58 = getelementptr i8, i8* %57, i32 %55
	%59 = load i8, i8* %58
	store i8 %59, i8* %45
	%60 = call %string* @newString(i32 8)
	%61 = getelementptr %string, %string* %60, i32 0, i32 1
	%62 = load i8*, i8** %61
	%63 = bitcast i8* %62 to i8*
	%64 = bitcast i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %63, i8* %64, i32 8, i1 false)
	%65 = load %string, %string* %60
	%66 = load i32, i32* %44
	%67 = load i8, i8* %45
	%68 = getelementptr %string, %string* %60, i32 0, i32 1
	%69 = load i8*, i8** %68
	%70 = call i32 (i8*, ...) @printf(i8* %69, i32 %66, i8 %67)
	; end block
	br label %47

; <label>:71
	; empty block
	%72 = call %string* @newString(i32 4)
	%73 = getelementptr %string, %string* %72, i32 0, i32 1
	%74 = load i8*, i8** %73
	%75 = bitcast i8* %74 to i8*
	%76 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %75, i8* %76, i32 4, i1 false)
	%77 = load %string, %string* %72
	; start string range[]
	%78 = getelementptr %string, %string* %7, i32 0, i32 1
	%79 = load i8*, i8** %78
	%80 = bitcast i8* %79 to i8*
	%81 = call i8* @rangeSlice(i8* %80, i32 3, i32 5, i32 1)
	%82 = sub i32 5, 3
	%83 = call %string* @newString(i32 %82)
	%84 = getelementptr %string, %string* %83, i32 0, i32 1
	%85 = bitcast i8* %81 to i8*
	store i8* %85, i8** %84
	; end string range[]
	%86 = load %string, %string* %83
	%87 = getelementptr %string, %string* %72, i32 0, i32 1
	%88 = load i8*, i8** %87
	%89 = getelementptr %string, %string* %83, i32 0, i32 1
	%90 = load i8*, i8** %89
	%91 = call i32 (i8*, ...) @printf(i8* %88, i8* %90)
	; end block
	ret void
}

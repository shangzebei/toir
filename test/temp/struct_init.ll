%mapStruct = type {}
%string = type { i32, i8* }
%ListNode = type { i32, %KK* }
%KK = type { i32, i32, i32 }
%AA = type { i32, %AA* }
%B = type { %AA*, %B* }
%Bar = type { i64 }
%Foo = type { i64, %Bar* }
%struct.8 = type { i32, i32, i32 }
%struct.9 = type { %AA }

@str.0 = constant [7 x i8] c"22-%d\0A\00"
@str.1 = constant [7 x i8] c"11-%d\0A\00"
@str.2 = constant [7 x i8] c"19-%d\0A\00"
@KK.3 = constant %KK { i32 11, i32 22, i32 99 }
@str.3 = constant [7 x i8] c"99-%d\0A\00"
@str.4 = constant [7 x i8] c"22-%d\0A\00"
@str.5 = constant [7 x i8] c"11-%d\0A\00"
@str.6 = constant [7 x i8] c"11-%d\0A\00"
@Bar.8 = constant %Bar { i64 400 }
@Bar.9 = constant %Bar { i64 200 }
@str.7 = constant [17 x i8] c"foo.bar.num: %d\0A\00"
@str.8 = constant [13 x i8] c"foo.num: %d\0A\00"
@str.9 = constant [17 x i8] c"foo.bar.num: %d\0A\00"
@str.10 = constant [13 x i8] c"foo.num: %d\0A\00"
@str.11 = constant [18 x i8] c"foo2.bar.num: %d\0A\00"
@str.12 = constant [14 x i8] c"foo2.num: %d\0A\00"
@str.13 = constant [18 x i8] c"foo2.bar.num: %d\0A\00"
@str.14 = constant [14 x i8] c"foo2.num: %d\0A\00"

declare i8* @malloc(i32)

define void @init.KK.29841568630589(%struct.8*, %KK*) {
; <label>:2
	%3 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 0
	%4 = load i32, i32* %3
	%5 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 2
	%8 = load i32, i32* %7
	%9 = getelementptr %KK, %KK* %1, i32 0, i32 0
	store i32 19, i32* %9
	%10 = getelementptr %KK, %KK* %1, i32 0, i32 1
	store i32 %6, i32* %10
	%11 = getelementptr %KK, %KK* %1, i32 0, i32 2
	store i32 %8, i32* %11
	ret void
}

define void @init.ListNode.60411568630589(%struct.8*, %ListNode*) {
; <label>:2
	%3 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 0
	%4 = load i32, i32* %3
	%5 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 2
	%8 = load i32, i32* %7
	%9 = getelementptr %ListNode, %ListNode* %1, i32 0, i32 0
	store i32 %4, i32* %9
	%10 = getelementptr %ListNode, %ListNode* %1, i32 0, i32 1
	; init param
	; end param
	%11 = call i8* @malloc(i32 12)
	%12 = bitcast i8* %11 to %KK*
	call void @init.KK.29841568630589(%struct.8* %0, %KK* %12)
	%13 = load %KK, %KK* %12
	store %KK* %12, %KK** %10
	ret void
}

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

define void @init1() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	%2 = alloca i32
	store i32 11, i32* %2
	%3 = alloca i32
	store i32 22, i32* %3
	; init param
	%4 = load i32, i32* %1
	%5 = load i32, i32* %2
	%6 = load i32, i32* %3
	%7 = call i8* @malloc(i32 12)
	%8 = bitcast i8* %7 to %struct.8*
	%9 = getelementptr %struct.8, %struct.8* %8, i32 0, i32 0
	store i32 %4, i32* %9
	%10 = getelementptr %struct.8, %struct.8* %8, i32 0, i32 1
	store i32 %5, i32* %10
	%11 = getelementptr %struct.8, %struct.8* %8, i32 0, i32 2
	store i32 %6, i32* %11
	; end param
	%12 = call i8* @malloc(i32 12)
	%13 = bitcast i8* %12 to %ListNode*
	call void @init.ListNode.60411568630589(%struct.8* %8, %ListNode* %13)
	%14 = load %ListNode, %ListNode* %13
	%15 = call i8* @malloc(i32 12)
	%16 = bitcast i8* %15 to %ListNode*
	store %ListNode %14, %ListNode* %16
	%17 = call %string* @newString(i32 7)
	%18 = getelementptr %string, %string* %17, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 7, i1 false)
	%22 = load %string, %string* %17
	%23 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%24 = load %KK*, %KK** %23
	%25 = getelementptr %KK, %KK* %24, i32 0, i32 2
	%26 = load i32, i32* %25
	%27 = getelementptr %string, %string* %17, i32 0, i32 1
	%28 = load i8*, i8** %27
	%29 = call i32 (i8*, ...) @printf(i8* %28, i32 %26)
	%30 = call %string* @newString(i32 7)
	%31 = getelementptr %string, %string* %30, i32 0, i32 1
	%32 = load i8*, i8** %31
	%33 = bitcast i8* %32 to i8*
	%34 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %33, i8* %34, i32 7, i1 false)
	%35 = load %string, %string* %30
	%36 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%37 = load %KK*, %KK** %36
	%38 = getelementptr %KK, %KK* %37, i32 0, i32 1
	%39 = load i32, i32* %38
	%40 = getelementptr %string, %string* %30, i32 0, i32 1
	%41 = load i8*, i8** %40
	%42 = call i32 (i8*, ...) @printf(i8* %41, i32 %39)
	%43 = call %string* @newString(i32 7)
	%44 = getelementptr %string, %string* %43, i32 0, i32 1
	%45 = load i8*, i8** %44
	%46 = bitcast i8* %45 to i8*
	%47 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %46, i8* %47, i32 7, i1 false)
	%48 = load %string, %string* %43
	%49 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%50 = load %KK*, %KK** %49
	%51 = getelementptr %KK, %KK* %50, i32 0, i32 0
	%52 = load i32, i32* %51
	%53 = getelementptr %string, %string* %43, i32 0, i32 1
	%54 = load i8*, i8** %53
	%55 = call i32 (i8*, ...) @printf(i8* %54, i32 %52)
	; end block
	ret void
}

define void @init.ListNode.15761568630589(%ListNode*) {
; <label>:1
	%2 = getelementptr %ListNode, %ListNode* %0, i32 0, i32 0
	store i32 111, i32* %2
	%3 = getelementptr %ListNode, %ListNode* %0, i32 0, i32 1
	%4 = call i8* @malloc(i32 12)
	%5 = bitcast i8* %4 to %KK*
	%6 = bitcast %KK* %5 to i8*
	%7 = bitcast %KK* @KK.3 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 12, i1 false)
	%8 = load %KK, %KK* %5
	store %KK* %5, %KK** %3
	ret void
}

define void @init2() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %ListNode*
	call void @init.ListNode.15761568630589(%ListNode* %2)
	%3 = load %ListNode, %ListNode* %2
	%4 = call i8* @malloc(i32 12)
	%5 = bitcast i8* %4 to %ListNode*
	store %ListNode %3, %ListNode* %5
	%6 = call %string* @newString(i32 7)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 7, i1 false)
	%11 = load %string, %string* %6
	%12 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%13 = load %KK*, %KK** %12
	%14 = getelementptr %KK, %KK* %13, i32 0, i32 2
	%15 = load i32, i32* %14
	%16 = getelementptr %string, %string* %6, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17, i32 %15)
	%19 = call %string* @newString(i32 7)
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 7, i1 false)
	%24 = load %string, %string* %19
	%25 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%26 = load %KK*, %KK** %25
	%27 = getelementptr %KK, %KK* %26, i32 0, i32 1
	%28 = load i32, i32* %27
	%29 = getelementptr %string, %string* %19, i32 0, i32 1
	%30 = load i8*, i8** %29
	%31 = call i32 (i8*, ...) @printf(i8* %30, i32 %28)
	%32 = call %string* @newString(i32 7)
	%33 = getelementptr %string, %string* %32, i32 0, i32 1
	%34 = load i8*, i8** %33
	%35 = bitcast i8* %34 to i8*
	%36 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %35, i8* %36, i32 7, i1 false)
	%37 = load %string, %string* %32
	%38 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%39 = load %KK*, %KK** %38
	%40 = getelementptr %KK, %KK* %39, i32 0, i32 0
	%41 = load i32, i32* %40
	%42 = getelementptr %string, %string* %32, i32 0, i32 1
	%43 = load i8*, i8** %42
	%44 = call i32 (i8*, ...) @printf(i8* %43, i32 %41)
	; end block
	ret void
}

define void @init.AA.56881568630589(%AA*) {
; <label>:1
	%2 = getelementptr %AA, %AA* %0, i32 0, i32 0
	store i32 11, i32* %2
	%3 = getelementptr %AA, %AA* %0, i32 0, i32 1
	store %AA* null, %AA** %3
	ret void
}

define void @init.B.77781568630589(%struct.9*, %B*) {
; <label>:2
	%3 = getelementptr %struct.9, %struct.9* %0, i32 0, i32 0
	%4 = load %AA, %AA* %3
	%5 = getelementptr %B, %B* %1, i32 0, i32 0
	store %AA* %3, %AA** %5
	%6 = getelementptr %B, %B* %1, i32 0, i32 1
	store %B* null, %B** %6
	ret void
}

define void @init3() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %AA*
	call void @init.AA.56881568630589(%AA* %2)
	%3 = load %AA, %AA* %2
	%4 = call i8* @malloc(i32 12)
	%5 = bitcast i8* %4 to %AA*
	store %AA %3, %AA* %5
	; init param
	%6 = load %AA, %AA* %5
	%7 = call i8* @malloc(i32 8)
	%8 = bitcast i8* %7 to %struct.9*
	%9 = getelementptr %struct.9, %struct.9* %8, i32 0, i32 0
	store %AA %6, %AA* %9
	; end param
	%10 = call i8* @malloc(i32 16)
	%11 = bitcast i8* %10 to %B*
	call void @init.B.77781568630589(%struct.9* %8, %B* %11)
	%12 = load %B, %B* %11
	%13 = call i8* @malloc(i32 16)
	%14 = bitcast i8* %13 to %B*
	store %B %12, %B* %14
	%15 = call %string* @newString(i32 7)
	%16 = getelementptr %string, %string* %15, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to i8*
	%19 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 7, i1 false)
	%20 = load %string, %string* %15
	%21 = getelementptr %B, %B* %14, i32 0, i32 0
	%22 = load %AA*, %AA** %21
	%23 = getelementptr %AA, %AA* %22, i32 0, i32 0
	%24 = load i32, i32* %23
	%25 = getelementptr %string, %string* %15, i32 0, i32 1
	%26 = load i8*, i8** %25
	%27 = call i32 (i8*, ...) @printf(i8* %26, i32 %24)
	; end block
	ret void
}

define void @init.Foo.05181568630589(%Foo*) {
; <label>:1
	%2 = getelementptr %Foo, %Foo* %0, i32 0, i32 0
	%3 = sext i32 300 to i64
	store i64 %3, i64* %2
	%4 = getelementptr %Foo, %Foo* %0, i32 0, i32 1
	%5 = call i8* @malloc(i32 8)
	%6 = bitcast i8* %5 to %Bar*
	%7 = bitcast %Bar* %6 to i8*
	%8 = bitcast %Bar* @Bar.8 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 8, i1 false)
	%9 = load %Bar, %Bar* %6
	store %Bar* %6, %Bar** %4
	ret void
}

define %Foo* @GetFooPtr() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %Foo*
	call void @init.Foo.05181568630589(%Foo* %2)
	%3 = load %Foo, %Foo* %2
	%4 = call i8* @malloc(i32 16)
	%5 = bitcast i8* %4 to %Foo*
	store %Foo %3, %Foo* %5
	%6 = load %Foo, %Foo* %5
	; end block
	ret %Foo* %5
}

define void @init.Foo.71961568630589(%Foo*) {
; <label>:1
	%2 = getelementptr %Foo, %Foo* %0, i32 0, i32 0
	%3 = sext i32 100 to i64
	store i64 %3, i64* %2
	%4 = getelementptr %Foo, %Foo* %0, i32 0, i32 1
	%5 = call i8* @malloc(i32 8)
	%6 = bitcast i8* %5 to %Bar*
	%7 = bitcast %Bar* %6 to i8*
	%8 = bitcast %Bar* @Bar.9 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %7, i8* %8, i32 8, i1 false)
	%9 = load %Bar, %Bar* %6
	store %Bar* %6, %Bar** %4
	ret void
}

define void @inin4() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %Foo*
	call void @init.Foo.71961568630589(%Foo* %2)
	%3 = load %Foo, %Foo* %2
	%4 = alloca %Foo*
	store %Foo* %2, %Foo** %4
	%5 = call %string* @newString(i32 17)
	%6 = getelementptr %string, %string* %5, i32 0, i32 1
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 17, i1 false)
	%10 = load %string, %string* %5
	%11 = load %Foo*, %Foo** %4
	%12 = getelementptr %Foo, %Foo* %11, i32 0, i32 1
	%13 = load %Bar*, %Bar** %12
	%14 = getelementptr %Bar, %Bar* %13, i32 0, i32 0
	%15 = load i64, i64* %14
	%16 = getelementptr %string, %string* %5, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = call i32 (i8*, ...) @printf(i8* %17, i64 %15)
	%19 = call %string* @newString(i32 13)
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 13, i1 false)
	%24 = load %string, %string* %19
	%25 = load %Foo*, %Foo** %4
	%26 = getelementptr %Foo, %Foo* %25, i32 0, i32 0
	%27 = load i64, i64* %26
	%28 = getelementptr %string, %string* %19, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %29, i64 %27)
	%31 = call %string* @newString(i32 17)
	%32 = getelementptr %string, %string* %31, i32 0, i32 1
	%33 = load i8*, i8** %32
	%34 = bitcast i8* %33 to i8*
	%35 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.9, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %34, i8* %35, i32 17, i1 false)
	%36 = load %string, %string* %31
	%37 = load %Foo*, %Foo** %4
	%38 = getelementptr %Foo, %Foo* %37, i32 0, i32 1
	%39 = load %Bar*, %Bar** %38
	%40 = getelementptr %Bar, %Bar* %39, i32 0, i32 0
	%41 = load i64, i64* %40
	%42 = getelementptr %string, %string* %31, i32 0, i32 1
	%43 = load i8*, i8** %42
	%44 = call i32 (i8*, ...) @printf(i8* %43, i64 %41)
	%45 = call %string* @newString(i32 13)
	%46 = getelementptr %string, %string* %45, i32 0, i32 1
	%47 = load i8*, i8** %46
	%48 = bitcast i8* %47 to i8*
	%49 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.10, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %48, i8* %49, i32 13, i1 false)
	%50 = load %string, %string* %45
	%51 = load %Foo*, %Foo** %4
	%52 = getelementptr %Foo, %Foo* %51, i32 0, i32 0
	%53 = load i64, i64* %52
	%54 = getelementptr %string, %string* %45, i32 0, i32 1
	%55 = load i8*, i8** %54
	%56 = call i32 (i8*, ...) @printf(i8* %55, i64 %53)
	%57 = call %Foo* @GetFooPtr()
	%58 = alloca %Foo*
	store %Foo* %57, %Foo** %58
	%59 = call %string* @newString(i32 18)
	%60 = getelementptr %string, %string* %59, i32 0, i32 1
	%61 = load i8*, i8** %60
	%62 = bitcast i8* %61 to i8*
	%63 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.11, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %62, i8* %63, i32 18, i1 false)
	%64 = load %string, %string* %59
	%65 = load %Foo*, %Foo** %58
	%66 = getelementptr %Foo, %Foo* %65, i32 0, i32 1
	%67 = load %Bar*, %Bar** %66
	%68 = getelementptr %Bar, %Bar* %67, i32 0, i32 0
	%69 = load i64, i64* %68
	%70 = getelementptr %string, %string* %59, i32 0, i32 1
	%71 = load i8*, i8** %70
	%72 = call i32 (i8*, ...) @printf(i8* %71, i64 %69)
	%73 = call %string* @newString(i32 14)
	%74 = getelementptr %string, %string* %73, i32 0, i32 1
	%75 = load i8*, i8** %74
	%76 = bitcast i8* %75 to i8*
	%77 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.12, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %76, i8* %77, i32 14, i1 false)
	%78 = load %string, %string* %73
	%79 = load %Foo*, %Foo** %58
	%80 = getelementptr %Foo, %Foo* %79, i32 0, i32 0
	%81 = load i64, i64* %80
	%82 = getelementptr %string, %string* %73, i32 0, i32 1
	%83 = load i8*, i8** %82
	%84 = call i32 (i8*, ...) @printf(i8* %83, i64 %81)
	%85 = call %string* @newString(i32 18)
	%86 = getelementptr %string, %string* %85, i32 0, i32 1
	%87 = load i8*, i8** %86
	%88 = bitcast i8* %87 to i8*
	%89 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.13, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %88, i8* %89, i32 18, i1 false)
	%90 = load %string, %string* %85
	%91 = load %Foo*, %Foo** %58
	%92 = getelementptr %Foo, %Foo* %91, i32 0, i32 1
	%93 = load %Bar*, %Bar** %92
	%94 = getelementptr %Bar, %Bar* %93, i32 0, i32 0
	%95 = load i64, i64* %94
	%96 = getelementptr %string, %string* %85, i32 0, i32 1
	%97 = load i8*, i8** %96
	%98 = call i32 (i8*, ...) @printf(i8* %97, i64 %95)
	%99 = call %string* @newString(i32 14)
	%100 = getelementptr %string, %string* %99, i32 0, i32 1
	%101 = load i8*, i8** %100
	%102 = bitcast i8* %101 to i8*
	%103 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.14, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %102, i8* %103, i32 14, i1 false)
	%104 = load %string, %string* %99
	%105 = load %Foo*, %Foo** %58
	%106 = getelementptr %Foo, %Foo* %105, i32 0, i32 0
	%107 = load i64, i64* %106
	%108 = getelementptr %string, %string* %99, i32 0, i32 1
	%109 = load i8*, i8** %108
	%110 = call i32 (i8*, ...) @printf(i8* %109, i64 %107)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @init1()
	call void @init2()
	call void @init3()
	call void @inin4()
	; end block
	ret void
}

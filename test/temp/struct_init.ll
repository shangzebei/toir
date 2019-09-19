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

@main.str.0 = constant [7 x i8] c"22-%d\0A\00"
@main.str.1 = constant [7 x i8] c"11-%d\0A\00"
@main.str.2 = constant [7 x i8] c"19-%d\0A\00"
@KK.3 = constant %KK { i32 11, i32 22, i32 99 }
@main.str.3 = constant [7 x i8] c"99-%d\0A\00"
@main.str.4 = constant [7 x i8] c"22-%d\0A\00"
@main.str.5 = constant [7 x i8] c"11-%d\0A\00"
@main.str.6 = constant [7 x i8] c"11-%d\0A\00"
@Bar.8 = constant %Bar { i64 400 }
@Bar.9 = constant %Bar { i64 200 }
@main.str.7 = constant [17 x i8] c"foo.bar.num: %d\0A\00"
@main.str.8 = constant [13 x i8] c"foo.num: %d\0A\00"
@main.str.9 = constant [17 x i8] c"foo.bar.num: %d\0A\00"
@main.str.10 = constant [13 x i8] c"foo.num: %d\0A\00"
@main.str.11 = constant [18 x i8] c"foo2.bar.num: %d\0A\00"
@main.str.12 = constant [14 x i8] c"foo2.num: %d\0A\00"
@main.str.13 = constant [18 x i8] c"foo2.bar.num: %d\0A\00"
@main.str.14 = constant [14 x i8] c"foo2.num: %d\0A\00"

declare i8* @malloc(i32)

define void @init.KK.29841568887016(%struct.8*, %KK*) {
; <label>:2
	; <inject var
	%3 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 2
	%4 = load i32, i32* %3
	%5 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 0
	%6 = load i32, i32* %5
	%7 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 1
	%8 = load i32, i32* %7
	; inject var>
	%9 = getelementptr %KK, %KK* %1, i32 0, i32 0
	store i32 19, i32* %9
	%10 = getelementptr %KK, %KK* %1, i32 0, i32 1
	store i32 %8, i32* %10
	%11 = getelementptr %KK, %KK* %1, i32 0, i32 2
	store i32 %4, i32* %11
	; <init string>
	ret void
}

define void @init.ListNode.60411568887016(%struct.8*, %ListNode*) {
; <label>:2
	; <inject var
	%3 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 0
	%4 = load i32, i32* %3
	%5 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr %struct.8, %struct.8* %0, i32 0, i32 2
	%8 = load i32, i32* %7
	; inject var>
	%9 = getelementptr %ListNode, %ListNode* %1, i32 0, i32 0
	store i32 %4, i32* %9
	%10 = getelementptr %ListNode, %ListNode* %1, i32 0, i32 1
	; init param
	; end param
	%11 = call i8* @malloc(i32 12)
	%12 = bitcast i8* %11 to %KK*
	call void @init.KK.29841568887016(%struct.8* %0, %KK* %12)
	%13 = load %KK, %KK* %12
	store %KK* %12, %KK** %10
	; <init string>
	ret void
}

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

define void @test.init1() {
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
	%12 = call i8* @malloc(i32 16)
	%13 = bitcast i8* %12 to %ListNode*
	call void @init.ListNode.60411568887016(%struct.8* %8, %ListNode* %13)
	%14 = load %ListNode, %ListNode* %13
	%15 = call i8* @malloc(i32 16)
	%16 = bitcast i8* %15 to %ListNode*
	store %ListNode %14, %ListNode* %16
	%17 = call %string* @runtime.newString(i32 6)
	%18 = getelementptr %string, %string* %17, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.0, i64 0, i64 0) to i8*
	%22 = getelementptr %string, %string* %17, i32 0, i32 0
	%23 = load i32, i32* %22
	%24 = add i32 %23, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 %24, i1 false)
	%25 = load %string, %string* %17
	%26 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%27 = load %KK*, %KK** %26
	%28 = getelementptr %KK, %KK* %27, i32 0, i32 2
	%29 = load i32, i32* %28
	%30 = getelementptr %string, %string* %17, i32 0, i32 1
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %31, i32 %29)
	%33 = call %string* @runtime.newString(i32 6)
	%34 = getelementptr %string, %string* %33, i32 0, i32 1
	%35 = load i8*, i8** %34
	%36 = bitcast i8* %35 to i8*
	%37 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.1, i64 0, i64 0) to i8*
	%38 = getelementptr %string, %string* %33, i32 0, i32 0
	%39 = load i32, i32* %38
	%40 = add i32 %39, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %36, i8* %37, i32 %40, i1 false)
	%41 = load %string, %string* %33
	%42 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%43 = load %KK*, %KK** %42
	%44 = getelementptr %KK, %KK* %43, i32 0, i32 1
	%45 = load i32, i32* %44
	%46 = getelementptr %string, %string* %33, i32 0, i32 1
	%47 = load i8*, i8** %46
	%48 = call i32 (i8*, ...) @printf(i8* %47, i32 %45)
	%49 = call %string* @runtime.newString(i32 6)
	%50 = getelementptr %string, %string* %49, i32 0, i32 1
	%51 = load i8*, i8** %50
	%52 = bitcast i8* %51 to i8*
	%53 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.2, i64 0, i64 0) to i8*
	%54 = getelementptr %string, %string* %49, i32 0, i32 0
	%55 = load i32, i32* %54
	%56 = add i32 %55, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %52, i8* %53, i32 %56, i1 false)
	%57 = load %string, %string* %49
	%58 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%59 = load %KK*, %KK** %58
	%60 = getelementptr %KK, %KK* %59, i32 0, i32 0
	%61 = load i32, i32* %60
	%62 = getelementptr %string, %string* %49, i32 0, i32 1
	%63 = load i8*, i8** %62
	%64 = call i32 (i8*, ...) @printf(i8* %63, i32 %61)
	; end block
	ret void
}

define void @init.ListNode.15761568887016(%ListNode*) {
; <label>:1
	; <inject var
	; inject var>
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
	; <init string>
	ret void
}

define void @test.init2() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %ListNode*
	call void @init.ListNode.15761568887016(%ListNode* %2)
	%3 = load %ListNode, %ListNode* %2
	%4 = call i8* @malloc(i32 16)
	%5 = bitcast i8* %4 to %ListNode*
	store %ListNode %3, %ListNode* %5
	%6 = call %string* @runtime.newString(i32 6)
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	%8 = load i8*, i8** %7
	%9 = bitcast i8* %8 to i8*
	%10 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.3, i64 0, i64 0) to i8*
	%11 = getelementptr %string, %string* %6, i32 0, i32 0
	%12 = load i32, i32* %11
	%13 = add i32 %12, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %9, i8* %10, i32 %13, i1 false)
	%14 = load %string, %string* %6
	%15 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%16 = load %KK*, %KK** %15
	%17 = getelementptr %KK, %KK* %16, i32 0, i32 2
	%18 = load i32, i32* %17
	%19 = getelementptr %string, %string* %6, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20, i32 %18)
	%22 = call %string* @runtime.newString(i32 6)
	%23 = getelementptr %string, %string* %22, i32 0, i32 1
	%24 = load i8*, i8** %23
	%25 = bitcast i8* %24 to i8*
	%26 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.4, i64 0, i64 0) to i8*
	%27 = getelementptr %string, %string* %22, i32 0, i32 0
	%28 = load i32, i32* %27
	%29 = add i32 %28, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %25, i8* %26, i32 %29, i1 false)
	%30 = load %string, %string* %22
	%31 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%32 = load %KK*, %KK** %31
	%33 = getelementptr %KK, %KK* %32, i32 0, i32 1
	%34 = load i32, i32* %33
	%35 = getelementptr %string, %string* %22, i32 0, i32 1
	%36 = load i8*, i8** %35
	%37 = call i32 (i8*, ...) @printf(i8* %36, i32 %34)
	%38 = call %string* @runtime.newString(i32 6)
	%39 = getelementptr %string, %string* %38, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.5, i64 0, i64 0) to i8*
	%43 = getelementptr %string, %string* %38, i32 0, i32 0
	%44 = load i32, i32* %43
	%45 = add i32 %44, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 %45, i1 false)
	%46 = load %string, %string* %38
	%47 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%48 = load %KK*, %KK** %47
	%49 = getelementptr %KK, %KK* %48, i32 0, i32 0
	%50 = load i32, i32* %49
	%51 = getelementptr %string, %string* %38, i32 0, i32 1
	%52 = load i8*, i8** %51
	%53 = call i32 (i8*, ...) @printf(i8* %52, i32 %50)
	; end block
	ret void
}

define void @init.AA.56881568887016(%AA*) {
; <label>:1
	; <inject var
	; inject var>
	%2 = getelementptr %AA, %AA* %0, i32 0, i32 0
	store i32 11, i32* %2
	%3 = getelementptr %AA, %AA* %0, i32 0, i32 1
	store %AA* null, %AA** %3
	; <init string>
	ret void
}

define void @init.B.77781568887016(%struct.9*, %B*) {
; <label>:2
	; <inject var
	%3 = getelementptr %struct.9, %struct.9* %0, i32 0, i32 0
	%4 = load %AA, %AA* %3
	; inject var>
	%5 = getelementptr %B, %B* %1, i32 0, i32 0
	store %AA* %3, %AA** %5
	%6 = getelementptr %B, %B* %1, i32 0, i32 1
	store %B* null, %B** %6
	; <init string>
	ret void
}

define void @test.init3() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %AA*
	call void @init.AA.56881568887016(%AA* %2)
	%3 = load %AA, %AA* %2
	%4 = call i8* @malloc(i32 16)
	%5 = bitcast i8* %4 to %AA*
	store %AA %3, %AA* %5
	; init param
	%6 = load %AA, %AA* %5
	%7 = call i8* @malloc(i32 16)
	%8 = bitcast i8* %7 to %struct.9*
	%9 = getelementptr %struct.9, %struct.9* %8, i32 0, i32 0
	store %AA %6, %AA* %9
	; end param
	%10 = call i8* @malloc(i32 16)
	%11 = bitcast i8* %10 to %B*
	call void @init.B.77781568887016(%struct.9* %8, %B* %11)
	%12 = load %B, %B* %11
	%13 = call i8* @malloc(i32 16)
	%14 = bitcast i8* %13 to %B*
	store %B %12, %B* %14
	%15 = call %string* @runtime.newString(i32 6)
	%16 = getelementptr %string, %string* %15, i32 0, i32 1
	%17 = load i8*, i8** %16
	%18 = bitcast i8* %17 to i8*
	%19 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @main.str.6, i64 0, i64 0) to i8*
	%20 = getelementptr %string, %string* %15, i32 0, i32 0
	%21 = load i32, i32* %20
	%22 = add i32 %21, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %18, i8* %19, i32 %22, i1 false)
	%23 = load %string, %string* %15
	%24 = getelementptr %B, %B* %14, i32 0, i32 0
	%25 = load %AA*, %AA** %24
	%26 = getelementptr %AA, %AA* %25, i32 0, i32 0
	%27 = load i32, i32* %26
	%28 = getelementptr %string, %string* %15, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = call i32 (i8*, ...) @printf(i8* %29, i32 %27)
	; end block
	ret void
}

define void @init.Foo.05181568887016(%Foo*) {
; <label>:1
	; <inject var
	; inject var>
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
	; <init string>
	ret void
}

define %Foo* @test.GetFooPtr() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %Foo*
	call void @init.Foo.05181568887016(%Foo* %2)
	%3 = load %Foo, %Foo* %2
	%4 = call i8* @malloc(i32 16)
	%5 = bitcast i8* %4 to %Foo*
	store %Foo %3, %Foo* %5
	%6 = load %Foo, %Foo* %5
	; end block
	ret %Foo* %5
}

define void @init.Foo.71961568887016(%Foo*) {
; <label>:1
	; <inject var
	; inject var>
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
	; <init string>
	ret void
}

define void @test.inin4() {
; <label>:0
	; block start
	; init param
	; end param
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %Foo*
	call void @init.Foo.71961568887016(%Foo* %2)
	%3 = load %Foo, %Foo* %2
	%4 = alloca %Foo*
	store %Foo* %2, %Foo** %4
	%5 = call %string* @runtime.newString(i32 16)
	%6 = getelementptr %string, %string* %5, i32 0, i32 1
	%7 = load i8*, i8** %6
	%8 = bitcast i8* %7 to i8*
	%9 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @main.str.7, i64 0, i64 0) to i8*
	%10 = getelementptr %string, %string* %5, i32 0, i32 0
	%11 = load i32, i32* %10
	%12 = add i32 %11, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 %12, i1 false)
	%13 = load %string, %string* %5
	%14 = load %Foo*, %Foo** %4
	%15 = getelementptr %Foo, %Foo* %14, i32 0, i32 1
	%16 = load %Bar*, %Bar** %15
	%17 = getelementptr %Bar, %Bar* %16, i32 0, i32 0
	%18 = load i64, i64* %17
	%19 = getelementptr %string, %string* %5, i32 0, i32 1
	%20 = load i8*, i8** %19
	%21 = call i32 (i8*, ...) @printf(i8* %20, i64 %18)
	%22 = call %string* @runtime.newString(i32 12)
	%23 = getelementptr %string, %string* %22, i32 0, i32 1
	%24 = load i8*, i8** %23
	%25 = bitcast i8* %24 to i8*
	%26 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @main.str.8, i64 0, i64 0) to i8*
	%27 = getelementptr %string, %string* %22, i32 0, i32 0
	%28 = load i32, i32* %27
	%29 = add i32 %28, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %25, i8* %26, i32 %29, i1 false)
	%30 = load %string, %string* %22
	%31 = load %Foo*, %Foo** %4
	%32 = getelementptr %Foo, %Foo* %31, i32 0, i32 0
	%33 = load i64, i64* %32
	%34 = getelementptr %string, %string* %22, i32 0, i32 1
	%35 = load i8*, i8** %34
	%36 = call i32 (i8*, ...) @printf(i8* %35, i64 %33)
	%37 = call %string* @runtime.newString(i32 16)
	%38 = getelementptr %string, %string* %37, i32 0, i32 1
	%39 = load i8*, i8** %38
	%40 = bitcast i8* %39 to i8*
	%41 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @main.str.9, i64 0, i64 0) to i8*
	%42 = getelementptr %string, %string* %37, i32 0, i32 0
	%43 = load i32, i32* %42
	%44 = add i32 %43, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %40, i8* %41, i32 %44, i1 false)
	%45 = load %string, %string* %37
	%46 = load %Foo*, %Foo** %4
	%47 = getelementptr %Foo, %Foo* %46, i32 0, i32 1
	%48 = load %Bar*, %Bar** %47
	%49 = getelementptr %Bar, %Bar* %48, i32 0, i32 0
	%50 = load i64, i64* %49
	%51 = getelementptr %string, %string* %37, i32 0, i32 1
	%52 = load i8*, i8** %51
	%53 = call i32 (i8*, ...) @printf(i8* %52, i64 %50)
	%54 = call %string* @runtime.newString(i32 12)
	%55 = getelementptr %string, %string* %54, i32 0, i32 1
	%56 = load i8*, i8** %55
	%57 = bitcast i8* %56 to i8*
	%58 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @main.str.10, i64 0, i64 0) to i8*
	%59 = getelementptr %string, %string* %54, i32 0, i32 0
	%60 = load i32, i32* %59
	%61 = add i32 %60, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %57, i8* %58, i32 %61, i1 false)
	%62 = load %string, %string* %54
	%63 = load %Foo*, %Foo** %4
	%64 = getelementptr %Foo, %Foo* %63, i32 0, i32 0
	%65 = load i64, i64* %64
	%66 = getelementptr %string, %string* %54, i32 0, i32 1
	%67 = load i8*, i8** %66
	%68 = call i32 (i8*, ...) @printf(i8* %67, i64 %65)
	%69 = call %Foo* @test.GetFooPtr()
	%70 = alloca %Foo*
	store %Foo* %69, %Foo** %70
	%71 = call %string* @runtime.newString(i32 17)
	%72 = getelementptr %string, %string* %71, i32 0, i32 1
	%73 = load i8*, i8** %72
	%74 = bitcast i8* %73 to i8*
	%75 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @main.str.11, i64 0, i64 0) to i8*
	%76 = getelementptr %string, %string* %71, i32 0, i32 0
	%77 = load i32, i32* %76
	%78 = add i32 %77, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %74, i8* %75, i32 %78, i1 false)
	%79 = load %string, %string* %71
	%80 = load %Foo*, %Foo** %70
	%81 = getelementptr %Foo, %Foo* %80, i32 0, i32 1
	%82 = load %Bar*, %Bar** %81
	%83 = getelementptr %Bar, %Bar* %82, i32 0, i32 0
	%84 = load i64, i64* %83
	%85 = getelementptr %string, %string* %71, i32 0, i32 1
	%86 = load i8*, i8** %85
	%87 = call i32 (i8*, ...) @printf(i8* %86, i64 %84)
	%88 = call %string* @runtime.newString(i32 13)
	%89 = getelementptr %string, %string* %88, i32 0, i32 1
	%90 = load i8*, i8** %89
	%91 = bitcast i8* %90 to i8*
	%92 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @main.str.12, i64 0, i64 0) to i8*
	%93 = getelementptr %string, %string* %88, i32 0, i32 0
	%94 = load i32, i32* %93
	%95 = add i32 %94, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %91, i8* %92, i32 %95, i1 false)
	%96 = load %string, %string* %88
	%97 = load %Foo*, %Foo** %70
	%98 = getelementptr %Foo, %Foo* %97, i32 0, i32 0
	%99 = load i64, i64* %98
	%100 = getelementptr %string, %string* %88, i32 0, i32 1
	%101 = load i8*, i8** %100
	%102 = call i32 (i8*, ...) @printf(i8* %101, i64 %99)
	%103 = call %string* @runtime.newString(i32 17)
	%104 = getelementptr %string, %string* %103, i32 0, i32 1
	%105 = load i8*, i8** %104
	%106 = bitcast i8* %105 to i8*
	%107 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @main.str.13, i64 0, i64 0) to i8*
	%108 = getelementptr %string, %string* %103, i32 0, i32 0
	%109 = load i32, i32* %108
	%110 = add i32 %109, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %106, i8* %107, i32 %110, i1 false)
	%111 = load %string, %string* %103
	%112 = load %Foo*, %Foo** %70
	%113 = getelementptr %Foo, %Foo* %112, i32 0, i32 1
	%114 = load %Bar*, %Bar** %113
	%115 = getelementptr %Bar, %Bar* %114, i32 0, i32 0
	%116 = load i64, i64* %115
	%117 = getelementptr %string, %string* %103, i32 0, i32 1
	%118 = load i8*, i8** %117
	%119 = call i32 (i8*, ...) @printf(i8* %118, i64 %116)
	%120 = call %string* @runtime.newString(i32 13)
	%121 = getelementptr %string, %string* %120, i32 0, i32 1
	%122 = load i8*, i8** %121
	%123 = bitcast i8* %122 to i8*
	%124 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @main.str.14, i64 0, i64 0) to i8*
	%125 = getelementptr %string, %string* %120, i32 0, i32 0
	%126 = load i32, i32* %125
	%127 = add i32 %126, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %123, i8* %124, i32 %127, i1 false)
	%128 = load %string, %string* %120
	%129 = load %Foo*, %Foo** %70
	%130 = getelementptr %Foo, %Foo* %129, i32 0, i32 0
	%131 = load i64, i64* %130
	%132 = getelementptr %string, %string* %120, i32 0, i32 1
	%133 = load i8*, i8** %132
	%134 = call i32 (i8*, ...) @printf(i8* %133, i64 %131)
	; end block
	ret void
}

define void @main() {
; <label>:0
	; block start
	call void @test.init1()
	call void @test.init2()
	call void @test.init3()
	call void @test.inin4()
	; end block
	ret void
}

%ListNode = type { i32, %KK* }
%KK = type { i32, i32, i32 }
%AA = type { i32, %AA* }
%B = type { %AA*, %B* }
%Bar = type { i64 }
%Foo = type { i64, %Bar* }
%struct.6 = type { i32, i32, i32 }
%struct.7 = type { %AA }

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

define void @init.KK.29841568619439(%struct.6*, %KK*) {
; <label>:2
	%3 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 2
	%4 = load i32, i32* %3
	%5 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 0
	%6 = load i32, i32* %5
	%7 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 1
	%8 = load i32, i32* %7
	%9 = getelementptr %KK, %KK* %1, i32 0, i32 0
	store i32 19, i32* %9
	%10 = getelementptr %KK, %KK* %1, i32 0, i32 1
	store i32 %8, i32* %10
	%11 = getelementptr %KK, %KK* %1, i32 0, i32 2
	store i32 %4, i32* %11
	ret void
}

define void @init.ListNode.60411568619439(%struct.6*, %ListNode*) {
; <label>:2
	%3 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 2
	%4 = load i32, i32* %3
	%5 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 0
	%6 = load i32, i32* %5
	%7 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 1
	%8 = load i32, i32* %7
	%9 = getelementptr %ListNode, %ListNode* %1, i32 0, i32 0
	store i32 %6, i32* %9
	%10 = getelementptr %ListNode, %ListNode* %1, i32 0, i32 1
	; init param
	; end param
	%11 = call i8* @malloc(i32 12)
	%12 = bitcast i8* %11 to %KK*
	call void @init.KK.29841568619439(%struct.6* %0, %KK* %12)
	%13 = load %KK, %KK* %12
	store %KK* %12, %KK** %10
	ret void
}

define void @init_slice_i8({ i32, i32, i32, i8* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 2
	store i32 1, i32* %1
	%2 = mul i32 %len, 1
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to i8*
	store i8* %5, i8** %4
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
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
	%8 = bitcast i8* %7 to %struct.6*
	%9 = getelementptr %struct.6, %struct.6* %8, i32 0, i32 0
	store i32 %4, i32* %9
	%10 = getelementptr %struct.6, %struct.6* %8, i32 0, i32 1
	store i32 %5, i32* %10
	%11 = getelementptr %struct.6, %struct.6* %8, i32 0, i32 2
	store i32 %6, i32* %11
	; end param
	%12 = call i8* @malloc(i32 12)
	%13 = bitcast i8* %12 to %ListNode*
	call void @init.ListNode.60411568619439(%struct.6* %8, %ListNode* %13)
	%14 = load %ListNode, %ListNode* %13
	%15 = call i8* @malloc(i32 12)
	%16 = bitcast i8* %15 to %ListNode*
	store %ListNode %14, %ListNode* %16
	%17 = call i8* @malloc(i32 20)
	%18 = bitcast i8* %17 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %18, i32 7)
	%19 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 0
	store i32 7, i32* %19
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 3
	%21 = load i8*, i8** %20
	%22 = bitcast i8* %21 to i8*
	%23 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %22, i8* %23, i32 7, i1 false)
	%24 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18
	%25 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%26 = load %KK*, %KK** %25
	%27 = getelementptr %KK, %KK* %26, i32 0, i32 2
	%28 = load i32, i32* %27
	%29 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %18, i32 0, i32 3
	%30 = load i8*, i8** %29
	%31 = call i32 (i8*, ...) @printf(i8* %30, i32 %28)
	%32 = call i8* @malloc(i32 20)
	%33 = bitcast i8* %32 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %33, i32 7)
	%34 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %33, i32 0, i32 0
	store i32 7, i32* %34
	%35 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %33, i32 0, i32 3
	%36 = load i8*, i8** %35
	%37 = bitcast i8* %36 to i8*
	%38 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %37, i8* %38, i32 7, i1 false)
	%39 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %33
	%40 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%41 = load %KK*, %KK** %40
	%42 = getelementptr %KK, %KK* %41, i32 0, i32 1
	%43 = load i32, i32* %42
	%44 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %33, i32 0, i32 3
	%45 = load i8*, i8** %44
	%46 = call i32 (i8*, ...) @printf(i8* %45, i32 %43)
	%47 = call i8* @malloc(i32 20)
	%48 = bitcast i8* %47 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %48, i32 7)
	%49 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %48, i32 0, i32 0
	store i32 7, i32* %49
	%50 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %48, i32 0, i32 3
	%51 = load i8*, i8** %50
	%52 = bitcast i8* %51 to i8*
	%53 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.2, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %52, i8* %53, i32 7, i1 false)
	%54 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %48
	%55 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%56 = load %KK*, %KK** %55
	%57 = getelementptr %KK, %KK* %56, i32 0, i32 0
	%58 = load i32, i32* %57
	%59 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %48, i32 0, i32 3
	%60 = load i8*, i8** %59
	%61 = call i32 (i8*, ...) @printf(i8* %60, i32 %58)
	; end block
	ret void
}

define void @init.ListNode.15761568619439(%ListNode*) {
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
	call void @init.ListNode.15761568619439(%ListNode* %2)
	%3 = load %ListNode, %ListNode* %2
	%4 = call i8* @malloc(i32 12)
	%5 = bitcast i8* %4 to %ListNode*
	store %ListNode %3, %ListNode* %5
	%6 = call i8* @malloc(i32 20)
	%7 = bitcast i8* %6 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %7, i32 7)
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 0
	store i32 7, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.3, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 7, i1 false)
	%13 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7
	%14 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%15 = load %KK*, %KK** %14
	%16 = getelementptr %KK, %KK* %15, i32 0, i32 2
	%17 = load i32, i32* %16
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %7, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19, i32 %17)
	%21 = call i8* @malloc(i32 20)
	%22 = bitcast i8* %21 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %22, i32 7)
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 0
	store i32 7, i32* %23
	%24 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to i8*
	%27 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.4, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 7, i1 false)
	%28 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22
	%29 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%30 = load %KK*, %KK** %29
	%31 = getelementptr %KK, %KK* %30, i32 0, i32 1
	%32 = load i32, i32* %31
	%33 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%34 = load i8*, i8** %33
	%35 = call i32 (i8*, ...) @printf(i8* %34, i32 %32)
	%36 = call i8* @malloc(i32 20)
	%37 = bitcast i8* %36 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %37, i32 7)
	%38 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 0
	store i32 7, i32* %38
	%39 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 3
	%40 = load i8*, i8** %39
	%41 = bitcast i8* %40 to i8*
	%42 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.5, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* %42, i32 7, i1 false)
	%43 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37
	%44 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%45 = load %KK*, %KK** %44
	%46 = getelementptr %KK, %KK* %45, i32 0, i32 0
	%47 = load i32, i32* %46
	%48 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %37, i32 0, i32 3
	%49 = load i8*, i8** %48
	%50 = call i32 (i8*, ...) @printf(i8* %49, i32 %47)
	; end block
	ret void
}

define void @init.AA.56881568619439(%AA*) {
; <label>:1
	%2 = getelementptr %AA, %AA* %0, i32 0, i32 0
	store i32 11, i32* %2
	%3 = getelementptr %AA, %AA* %0, i32 0, i32 1
	store %AA* null, %AA** %3
	ret void
}

define void @init.B.77781568619439(%struct.7*, %B*) {
; <label>:2
	%3 = getelementptr %struct.7, %struct.7* %0, i32 0, i32 0
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
	call void @init.AA.56881568619439(%AA* %2)
	%3 = load %AA, %AA* %2
	%4 = call i8* @malloc(i32 12)
	%5 = bitcast i8* %4 to %AA*
	store %AA %3, %AA* %5
	; init param
	%6 = load %AA, %AA* %5
	%7 = call i8* @malloc(i32 8)
	%8 = bitcast i8* %7 to %struct.7*
	%9 = getelementptr %struct.7, %struct.7* %8, i32 0, i32 0
	store %AA %6, %AA* %9
	; end param
	%10 = call i8* @malloc(i32 16)
	%11 = bitcast i8* %10 to %B*
	call void @init.B.77781568619439(%struct.7* %8, %B* %11)
	%12 = load %B, %B* %11
	%13 = call i8* @malloc(i32 16)
	%14 = bitcast i8* %13 to %B*
	store %B %12, %B* %14
	%15 = call i8* @malloc(i32 20)
	%16 = bitcast i8* %15 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %16, i32 7)
	%17 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 0
	store i32 7, i32* %17
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = bitcast i8* %19 to i8*
	%21 = bitcast i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.6, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %20, i8* %21, i32 7, i1 false)
	%22 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16
	%23 = getelementptr %B, %B* %14, i32 0, i32 0
	%24 = load %AA*, %AA** %23
	%25 = getelementptr %AA, %AA* %24, i32 0, i32 0
	%26 = load i32, i32* %25
	%27 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %16, i32 0, i32 3
	%28 = load i8*, i8** %27
	%29 = call i32 (i8*, ...) @printf(i8* %28, i32 %26)
	; end block
	ret void
}

define void @init.Foo.05181568619439(%Foo*) {
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
	call void @init.Foo.05181568619439(%Foo* %2)
	%3 = load %Foo, %Foo* %2
	%4 = call i8* @malloc(i32 16)
	%5 = bitcast i8* %4 to %Foo*
	store %Foo %3, %Foo* %5
	%6 = load %Foo, %Foo* %5
	; end block
	ret %Foo* %5
}

define void @init.Foo.71961568619439(%Foo*) {
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
	call void @init.Foo.71961568619439(%Foo* %2)
	%3 = load %Foo, %Foo* %2
	%4 = alloca %Foo*
	store %Foo* %2, %Foo** %4
	%5 = call i8* @malloc(i32 20)
	%6 = bitcast i8* %5 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %6, i32 17)
	%7 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 0
	store i32 17, i32* %7
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 3
	%9 = load i8*, i8** %8
	%10 = bitcast i8* %9 to i8*
	%11 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.7, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %11, i32 17, i1 false)
	%12 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6
	%13 = load %Foo*, %Foo** %4
	%14 = getelementptr %Foo, %Foo* %13, i32 0, i32 1
	%15 = load %Bar*, %Bar** %14
	%16 = getelementptr %Bar, %Bar* %15, i32 0, i32 0
	%17 = load i64, i64* %16
	%18 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %6, i32 0, i32 3
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19, i64 %17)
	%21 = call i8* @malloc(i32 20)
	%22 = bitcast i8* %21 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %22, i32 13)
	%23 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 0
	store i32 13, i32* %23
	%24 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%25 = load i8*, i8** %24
	%26 = bitcast i8* %25 to i8*
	%27 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.8, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %26, i8* %27, i32 13, i1 false)
	%28 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22
	%29 = load %Foo*, %Foo** %4
	%30 = getelementptr %Foo, %Foo* %29, i32 0, i32 0
	%31 = load i64, i64* %30
	%32 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %22, i32 0, i32 3
	%33 = load i8*, i8** %32
	%34 = call i32 (i8*, ...) @printf(i8* %33, i64 %31)
	%35 = call i8* @malloc(i32 20)
	%36 = bitcast i8* %35 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %36, i32 17)
	%37 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %36, i32 0, i32 0
	store i32 17, i32* %37
	%38 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %36, i32 0, i32 3
	%39 = load i8*, i8** %38
	%40 = bitcast i8* %39 to i8*
	%41 = bitcast i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.9, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %40, i8* %41, i32 17, i1 false)
	%42 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %36
	%43 = load %Foo*, %Foo** %4
	%44 = getelementptr %Foo, %Foo* %43, i32 0, i32 1
	%45 = load %Bar*, %Bar** %44
	%46 = getelementptr %Bar, %Bar* %45, i32 0, i32 0
	%47 = load i64, i64* %46
	%48 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %36, i32 0, i32 3
	%49 = load i8*, i8** %48
	%50 = call i32 (i8*, ...) @printf(i8* %49, i64 %47)
	%51 = call i8* @malloc(i32 20)
	%52 = bitcast i8* %51 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %52, i32 13)
	%53 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %52, i32 0, i32 0
	store i32 13, i32* %53
	%54 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %52, i32 0, i32 3
	%55 = load i8*, i8** %54
	%56 = bitcast i8* %55 to i8*
	%57 = bitcast i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.10, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %56, i8* %57, i32 13, i1 false)
	%58 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %52
	%59 = load %Foo*, %Foo** %4
	%60 = getelementptr %Foo, %Foo* %59, i32 0, i32 0
	%61 = load i64, i64* %60
	%62 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %52, i32 0, i32 3
	%63 = load i8*, i8** %62
	%64 = call i32 (i8*, ...) @printf(i8* %63, i64 %61)
	%65 = call %Foo* @GetFooPtr()
	%66 = alloca %Foo*
	store %Foo* %65, %Foo** %66
	%67 = call i8* @malloc(i32 20)
	%68 = bitcast i8* %67 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %68, i32 18)
	%69 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %68, i32 0, i32 0
	store i32 18, i32* %69
	%70 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %68, i32 0, i32 3
	%71 = load i8*, i8** %70
	%72 = bitcast i8* %71 to i8*
	%73 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.11, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %72, i8* %73, i32 18, i1 false)
	%74 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %68
	%75 = load %Foo*, %Foo** %66
	%76 = getelementptr %Foo, %Foo* %75, i32 0, i32 1
	%77 = load %Bar*, %Bar** %76
	%78 = getelementptr %Bar, %Bar* %77, i32 0, i32 0
	%79 = load i64, i64* %78
	%80 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %68, i32 0, i32 3
	%81 = load i8*, i8** %80
	%82 = call i32 (i8*, ...) @printf(i8* %81, i64 %79)
	%83 = call i8* @malloc(i32 20)
	%84 = bitcast i8* %83 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %84, i32 14)
	%85 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %84, i32 0, i32 0
	store i32 14, i32* %85
	%86 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %84, i32 0, i32 3
	%87 = load i8*, i8** %86
	%88 = bitcast i8* %87 to i8*
	%89 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.12, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %88, i8* %89, i32 14, i1 false)
	%90 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %84
	%91 = load %Foo*, %Foo** %66
	%92 = getelementptr %Foo, %Foo* %91, i32 0, i32 0
	%93 = load i64, i64* %92
	%94 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %84, i32 0, i32 3
	%95 = load i8*, i8** %94
	%96 = call i32 (i8*, ...) @printf(i8* %95, i64 %93)
	%97 = call i8* @malloc(i32 20)
	%98 = bitcast i8* %97 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %98, i32 18)
	%99 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %98, i32 0, i32 0
	store i32 18, i32* %99
	%100 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %98, i32 0, i32 3
	%101 = load i8*, i8** %100
	%102 = bitcast i8* %101 to i8*
	%103 = bitcast i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.13, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %102, i8* %103, i32 18, i1 false)
	%104 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %98
	%105 = load %Foo*, %Foo** %66
	%106 = getelementptr %Foo, %Foo* %105, i32 0, i32 1
	%107 = load %Bar*, %Bar** %106
	%108 = getelementptr %Bar, %Bar* %107, i32 0, i32 0
	%109 = load i64, i64* %108
	%110 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %98, i32 0, i32 3
	%111 = load i8*, i8** %110
	%112 = call i32 (i8*, ...) @printf(i8* %111, i64 %109)
	%113 = call i8* @malloc(i32 20)
	%114 = bitcast i8* %113 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %114, i32 14)
	%115 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %114, i32 0, i32 0
	store i32 14, i32* %115
	%116 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %114, i32 0, i32 3
	%117 = load i8*, i8** %116
	%118 = bitcast i8* %117 to i8*
	%119 = bitcast i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.14, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %118, i8* %119, i32 14, i1 false)
	%120 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %114
	%121 = load %Foo*, %Foo** %66
	%122 = getelementptr %Foo, %Foo* %121, i32 0, i32 0
	%123 = load i64, i64* %122
	%124 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %114, i32 0, i32 3
	%125 = load i8*, i8** %124
	%126 = call i32 (i8*, ...) @printf(i8* %125, i64 %123)
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

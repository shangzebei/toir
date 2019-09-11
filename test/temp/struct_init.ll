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

define void @init.KK.18501568171573(%struct.6*, %KK*) {
; <label>:2
	%3 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 0
	%4 = load i32, i32* %3
	%5 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 2
	%8 = load i32, i32* %7
	%9 = getelementptr %KK, %KK* %1, i32 0, i32 0
	store i32 19, i32* %9
	%10 = getelementptr %KK, %KK* %1, i32 0, i32 1
	store i32 %6, i32* %10
	%11 = getelementptr %KK, %KK* %1, i32 0, i32 2
	store i32 %8, i32* %11
	ret void
}

define void @init.ListNode.17791568171573(%struct.6*, %ListNode*) {
; <label>:2
	%3 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 0
	%4 = load i32, i32* %3
	%5 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 1
	%6 = load i32, i32* %5
	%7 = getelementptr %struct.6, %struct.6* %0, i32 0, i32 2
	%8 = load i32, i32* %7
	%9 = getelementptr %ListNode, %ListNode* %1, i32 0, i32 0
	store i32 %4, i32* %9
	%10 = getelementptr %ListNode, %ListNode* %1, i32 0, i32 1
	; init param
	; end param
	%11 = call i8* @malloc(i32 12)
	%12 = bitcast i8* %11 to %KK*
	call void @init.KK.18501568171573(%struct.6* %0, %KK* %12)
	%13 = load %KK, %KK* %12
	store %KK* %12, %KK** %10
	ret void
}

declare i32 @printf(i8*, ...)

define void @init1() {
; <label>:0
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
	call void @init.ListNode.17791568171573(%struct.6* %8, %ListNode* %13)
	%14 = load %ListNode, %ListNode* %13
	%15 = call i8* @malloc(i32 12)
	%16 = bitcast i8* %15 to %ListNode*
	store %ListNode %14, %ListNode* %16
	%17 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%18 = load %KK*, %KK** %17
	%19 = getelementptr %KK, %KK* %18, i32 0, i32 2
	%20 = load i32, i32* %19
	%21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0), i32 %20)
	%22 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%23 = load %KK*, %KK** %22
	%24 = getelementptr %KK, %KK* %23, i32 0, i32 1
	%25 = load i32, i32* %24
	%26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0), i32 %25)
	%27 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 1
	%28 = load %KK*, %KK** %27
	%29 = getelementptr %KK, %KK* %28, i32 0, i32 0
	%30 = load i32, i32* %29
	%31 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.2, i64 0, i64 0), i32 %30)
	ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define void @init.ListNode.60411568171573(%ListNode*) {
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
	; init param
	; end param
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %ListNode*
	call void @init.ListNode.60411568171573(%ListNode* %2)
	%3 = load %ListNode, %ListNode* %2
	%4 = call i8* @malloc(i32 12)
	%5 = bitcast i8* %4 to %ListNode*
	store %ListNode %3, %ListNode* %5
	%6 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%7 = load %KK*, %KK** %6
	%8 = getelementptr %KK, %KK* %7, i32 0, i32 2
	%9 = load i32, i32* %8
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.3, i64 0, i64 0), i32 %9)
	%11 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%12 = load %KK*, %KK** %11
	%13 = getelementptr %KK, %KK* %12, i32 0, i32 1
	%14 = load i32, i32* %13
	%15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.4, i64 0, i64 0), i32 %14)
	%16 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 1
	%17 = load %KK*, %KK** %16
	%18 = getelementptr %KK, %KK* %17, i32 0, i32 0
	%19 = load i32, i32* %18
	%20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.5, i64 0, i64 0), i32 %19)
	ret void
}

define void @init.AA.29841568171573(%AA*) {
; <label>:1
	%2 = getelementptr %AA, %AA* %0, i32 0, i32 0
	store i32 11, i32* %2
	%3 = getelementptr %AA, %AA* %0, i32 0, i32 1
	store %AA* null, %AA** %3
	ret void
}

define void @init.B.15761568171573(%struct.7*, %B*) {
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
	; init param
	; end param
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %AA*
	call void @init.AA.29841568171573(%AA* %2)
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
	call void @init.B.15761568171573(%struct.7* %8, %B* %11)
	%12 = load %B, %B* %11
	%13 = call i8* @malloc(i32 16)
	%14 = bitcast i8* %13 to %B*
	store %B %12, %B* %14
	%15 = getelementptr %B, %B* %14, i32 0, i32 0
	%16 = load %AA*, %AA** %15
	%17 = getelementptr %AA, %AA* %16, i32 0, i32 0
	%18 = load i32, i32* %17
	%19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.6, i64 0, i64 0), i32 %18)
	ret void
}

define void @init.Foo.56881568171573(%Foo*) {
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
	; init param
	; end param
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %Foo*
	call void @init.Foo.56881568171573(%Foo* %2)
	%3 = load %Foo, %Foo* %2
	%4 = call i8* @malloc(i32 16)
	%5 = bitcast i8* %4 to %Foo*
	store %Foo %3, %Foo* %5
	%6 = load %Foo, %Foo* %5
	ret %Foo* %5
}

define void @init.Foo.77781568171573(%Foo*) {
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
	; init param
	; end param
	%1 = call i8* @malloc(i32 16)
	%2 = bitcast i8* %1 to %Foo*
	call void @init.Foo.77781568171573(%Foo* %2)
	%3 = load %Foo, %Foo* %2
	%4 = alloca %Foo*
	store %Foo* %2, %Foo** %4
	%5 = load %Foo*, %Foo** %4
	%6 = getelementptr %Foo, %Foo* %5, i32 0, i32 1
	%7 = load %Bar*, %Bar** %6
	%8 = getelementptr %Bar, %Bar* %7, i32 0, i32 0
	%9 = load i64, i64* %8
	%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.7, i64 0, i64 0), i64 %9)
	%11 = load %Foo*, %Foo** %4
	%12 = getelementptr %Foo, %Foo* %11, i32 0, i32 0
	%13 = load i64, i64* %12
	%14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.8, i64 0, i64 0), i64 %13)
	%15 = load %Foo*, %Foo** %4
	%16 = getelementptr %Foo, %Foo* %15, i32 0, i32 1
	%17 = load %Bar*, %Bar** %16
	%18 = getelementptr %Bar, %Bar* %17, i32 0, i32 0
	%19 = load i64, i64* %18
	%20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.9, i64 0, i64 0), i64 %19)
	%21 = load %Foo*, %Foo** %4
	%22 = getelementptr %Foo, %Foo* %21, i32 0, i32 0
	%23 = load i64, i64* %22
	%24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.10, i64 0, i64 0), i64 %23)
	%25 = call %Foo* @GetFooPtr()
	%26 = alloca %Foo*
	store %Foo* %25, %Foo** %26
	%27 = load %Foo*, %Foo** %26
	%28 = getelementptr %Foo, %Foo* %27, i32 0, i32 1
	%29 = load %Bar*, %Bar** %28
	%30 = getelementptr %Bar, %Bar* %29, i32 0, i32 0
	%31 = load i64, i64* %30
	%32 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.11, i64 0, i64 0), i64 %31)
	%33 = load %Foo*, %Foo** %26
	%34 = getelementptr %Foo, %Foo* %33, i32 0, i32 0
	%35 = load i64, i64* %34
	%36 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.12, i64 0, i64 0), i64 %35)
	%37 = load %Foo*, %Foo** %26
	%38 = getelementptr %Foo, %Foo* %37, i32 0, i32 1
	%39 = load %Bar*, %Bar** %38
	%40 = getelementptr %Bar, %Bar* %39, i32 0, i32 0
	%41 = load i64, i64* %40
	%42 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.13, i64 0, i64 0), i64 %41)
	%43 = load %Foo*, %Foo** %26
	%44 = getelementptr %Foo, %Foo* %43, i32 0, i32 0
	%45 = load i64, i64* %44
	%46 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.14, i64 0, i64 0), i64 %45)
	ret void
}

define void @main() {
; <label>:0
	call void @init1()
	call void @init2()
	call void @init3()
	call void @inin4()
	ret void
}

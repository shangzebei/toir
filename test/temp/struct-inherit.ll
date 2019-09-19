%mapStruct = type {}
%string = type { i32, i8* }
%ListNode = type { i32, %ListNode* }
%CircularListNode = type { %ListNode, %CircularListNode* }

@CircularListNode.0 = constant %CircularListNode { %ListNode { i32 0, %ListNode* null }, %CircularListNode* null }
@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [4 x i8] c"%d\0A\00"

declare i8* @malloc(i32)

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 20)
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

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 36)
	%2 = bitcast i8* %1 to %CircularListNode*
	%3 = bitcast %CircularListNode* %2 to i8*
	%4 = bitcast %CircularListNode* @CircularListNode.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %3, i8* %4, i32 28, i1 false)
	%5 = load %CircularListNode, %CircularListNode* %2
	%6 = call i8* @malloc(i32 36)
	%7 = bitcast i8* %6 to %CircularListNode*
	store %CircularListNode %5, %CircularListNode* %7
	%8 = getelementptr %CircularListNode, %CircularListNode* %7, i32 0, i32 0
	%9 = getelementptr %ListNode, %ListNode* %8, i32 0, i32 0
	%10 = load i32, i32* %9
	store i32 89, i32* %9
	%11 = call %string* @runtime.newString(i32 3)
	%12 = getelementptr %string, %string* %11, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	%16 = getelementptr %string, %string* %11, i32 0, i32 0
	%17 = load i32, i32* %16
	%18 = add i32 %17, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 %18, i1 false)
	%19 = load %string, %string* %11
	%20 = getelementptr %CircularListNode, %CircularListNode* %7, i32 0, i32 0
	%21 = load %ListNode, %ListNode* %20
	%22 = getelementptr %ListNode, %ListNode* %20, i32 0, i32 0
	%23 = load i32, i32* %22
	%24 = getelementptr %string, %string* %11, i32 0, i32 1
	%25 = load i8*, i8** %24
	%26 = call i32 (i8*, ...) @printf(i8* %25, i32 %23)
	%27 = call %string* @runtime.newString(i32 3)
	%28 = getelementptr %string, %string* %27, i32 0, i32 1
	%29 = load i8*, i8** %28
	%30 = bitcast i8* %29 to i8*
	%31 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	%32 = getelementptr %string, %string* %27, i32 0, i32 0
	%33 = load i32, i32* %32
	%34 = add i32 %33, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %30, i8* %31, i32 %34, i1 false)
	%35 = load %string, %string* %27
	%36 = getelementptr %CircularListNode, %CircularListNode* %7, i32 0, i32 0
	%37 = getelementptr %ListNode, %ListNode* %36, i32 0, i32 0
	%38 = load i32, i32* %37
	%39 = getelementptr %string, %string* %27, i32 0, i32 1
	%40 = load i8*, i8** %39
	%41 = call i32 (i8*, ...) @printf(i8* %40, i32 %38)
	; end block
	ret void
}

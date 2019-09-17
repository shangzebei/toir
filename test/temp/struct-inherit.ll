%mapStruct = type {}
%string = type { i32, i8* }
%ListNode = type { i32, %ListNode* }
%CircularListNode = type { %ListNode, %CircularListNode* }

@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [4 x i8] c"%d\0A\00"

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

define void @main() {
; <label>:0
	; block start
	%1 = alloca %CircularListNode
	%2 = load %CircularListNode, %CircularListNode* %1
	%3 = call i8* @malloc(i32 16)
	%4 = bitcast i8* %3 to %CircularListNode*
	store %CircularListNode %2, %CircularListNode* %4
	%5 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%6 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 0
	%7 = load i32, i32* %6
	store i32 89, i32* %6
	%8 = call %string* @runtime.newString(i32 3)
	%9 = getelementptr %string, %string* %8, i32 0, i32 1
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	%13 = getelementptr %string, %string* %8, i32 0, i32 0
	%14 = load i32, i32* %13
	%15 = add i32 %14, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 %15, i1 false)
	%16 = load %string, %string* %8
	%17 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%18 = load %ListNode, %ListNode* %17
	%19 = getelementptr %ListNode, %ListNode* %17, i32 0, i32 0
	%20 = load i32, i32* %19
	%21 = getelementptr %string, %string* %8, i32 0, i32 1
	%22 = load i8*, i8** %21
	%23 = call i32 (i8*, ...) @printf(i8* %22, i32 %20)
	%24 = call %string* @runtime.newString(i32 3)
	%25 = getelementptr %string, %string* %24, i32 0, i32 1
	%26 = load i8*, i8** %25
	%27 = bitcast i8* %26 to i8*
	%28 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	%29 = getelementptr %string, %string* %24, i32 0, i32 0
	%30 = load i32, i32* %29
	%31 = add i32 %30, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %27, i8* %28, i32 %31, i1 false)
	%32 = load %string, %string* %24
	%33 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%34 = getelementptr %ListNode, %ListNode* %33, i32 0, i32 0
	%35 = load i32, i32* %34
	%36 = getelementptr %string, %string* %24, i32 0, i32 1
	%37 = load i8*, i8** %36
	%38 = call i32 (i8*, ...) @printf(i8* %37, i32 %35)
	; end block
	ret void
}

%mapStruct = type {}
%string = type { i32, i8* }
%ListNode = type { i32, %ListNode* }
%CircularListNode = type { %ListNode, %CircularListNode* }

@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [4 x i8] c"%d\0A\00"

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
	%8 = call %string* @newString(i32 4)
	%9 = getelementptr %string, %string* %8, i32 0, i32 1
	%10 = load i8*, i8** %9
	%11 = bitcast i8* %10 to i8*
	%12 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %11, i8* %12, i32 4, i1 false)
	%13 = load %string, %string* %8
	%14 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%15 = load %ListNode, %ListNode* %14
	%16 = getelementptr %ListNode, %ListNode* %14, i32 0, i32 0
	%17 = load i32, i32* %16
	%18 = getelementptr %string, %string* %8, i32 0, i32 1
	%19 = load i8*, i8** %18
	%20 = call i32 (i8*, ...) @printf(i8* %19, i32 %17)
	%21 = call %string* @newString(i32 4)
	%22 = getelementptr %string, %string* %21, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = bitcast i8* %23 to i8*
	%25 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %24, i8* %25, i32 4, i1 false)
	%26 = load %string, %string* %21
	%27 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%28 = getelementptr %ListNode, %ListNode* %27, i32 0, i32 0
	%29 = load i32, i32* %28
	%30 = getelementptr %string, %string* %21, i32 0, i32 1
	%31 = load i8*, i8** %30
	%32 = call i32 (i8*, ...) @printf(i8* %31, i32 %29)
	; end block
	ret void
}

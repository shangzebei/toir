%ListNode = type { i32, %ListNode* }
%CircularListNode = type { %ListNode, %CircularListNode* }

@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [4 x i8] c"%d\0A\00"

declare i8* @malloc(i32)

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = alloca %CircularListNode
	%2 = load %CircularListNode, %CircularListNode* %1
	%3 = call i8* @malloc(i32 16)
	%4 = bitcast i8* %3 to %CircularListNode*
	store %CircularListNode %2, %CircularListNode* %4
	%5 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%6 = getelementptr %ListNode, %ListNode* %5, i32 0, i32 0
	%7 = load i32, i32* %6
	store i32 89, i32* %6
	%8 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%9 = load %ListNode, %ListNode* %8
	%10 = getelementptr %ListNode, %ListNode* %8, i32 0, i32 0
	%11 = load i32, i32* %10
	%12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0), i32 %11)
	%13 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%14 = getelementptr %ListNode, %ListNode* %13, i32 0, i32 0
	%15 = load i32, i32* %14
	%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0), i32 %15)
	ret void
}

%ListNode = type { i32, %ListNode* }
%CircularListNode = type { %ListNode, %CircularListNode* }

@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [4 x i8] c"%d\0A\00"

declare i8* @malloc(i32)

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
	%8 = call i8* @malloc(i32 20)
	%9 = bitcast i8* %8 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %9, i32 4)
	%10 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %9, i32 0, i32 0
	store i32 4, i32* %10
	%11 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %9, i32 0, i32 3
	%12 = load i8*, i8** %11
	%13 = bitcast i8* %12 to i8*
	%14 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %14, i32 4, i1 false)
	%15 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %9
	%16 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%17 = load %ListNode, %ListNode* %16
	%18 = getelementptr %ListNode, %ListNode* %16, i32 0, i32 0
	%19 = load i32, i32* %18
	%20 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %9, i32 0, i32 3
	%21 = load i8*, i8** %20
	%22 = call i32 (i8*, ...) @printf(i8* %21, i32 %19)
	%23 = call i8* @malloc(i32 20)
	%24 = bitcast i8* %23 to { i32, i32, i32, i8* }*
	call void @init_slice_i8({ i32, i32, i32, i8* }* %24, i32 4)
	%25 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %24, i32 0, i32 0
	store i32 4, i32* %25
	%26 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %24, i32 0, i32 3
	%27 = load i8*, i8** %26
	%28 = bitcast i8* %27 to i8*
	%29 = bitcast i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0) to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %28, i8* %29, i32 4, i1 false)
	%30 = load { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %24
	%31 = getelementptr %CircularListNode, %CircularListNode* %4, i32 0, i32 0
	%32 = getelementptr %ListNode, %ListNode* %31, i32 0, i32 0
	%33 = load i32, i32* %32
	%34 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %24, i32 0, i32 3
	%35 = load i8*, i8** %34
	%36 = call i32 (i8*, ...) @printf(i8* %35, i32 %33)
	; end block
	ret void
}

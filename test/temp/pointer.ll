%A = type { i8* }

@str.0 = constant [4 x i8] c"%s\0A\00"
@str.1 = constant [7 x i8] c"%d-%d\0A\00"
@str.2 = constant [6 x i8] c"ttttt\00"
@A.3 = constant %A { i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.2, i64 0, i64 0) }

define void @swap(i32* %a, i32* %b) {
; <label>:0
	%1 = load i32, i32* %a
	store i32 44, i32* %a
	%2 = load i32, i32* %b
	store i32 23, i32* %b
	ret void
}

define void @swapFloat(i64* %a, i64* %b) {
; <label>:0
	ret void
}

declare i8* @malloc(i32)

declare i32 @printf(i8*, ...)

define void @do(%A %a) {
; <label>:0
	%1 = call i8* @malloc(i32 8)
	%2 = bitcast i8* %1 to %A*
	store %A %a, %A* %2
	%3 = getelementptr %A, %A* %2, i32 0, i32 0
	%4 = load i8*, i8** %3
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0), i8* %4)
	ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define void @main() {
; <label>:0
	%1 = alloca i32
	store i32 90, i32* %1
	%2 = alloca i32
	store i32 80, i32* %2
	call void @swap(i32* %1, i32* %2)
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.1, i64 0, i64 0), i32 %3, i32 %4)
	%6 = call i8* @malloc(i32 8)
	%7 = bitcast i8* %6 to %A*
	%8 = bitcast %A* %7 to i8*
	%9 = bitcast %A* @A.3 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %8, i8* %9, i32 8, i1 false)
	%10 = load %A, %A* %7
	%11 = call i8* @malloc(i32 8)
	%12 = bitcast i8* %11 to %A*
	store %A %10, %A* %12
	%13 = load %A, %A* %12
	call void @do(%A %13)
	ret void
}

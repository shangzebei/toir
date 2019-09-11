%Hello = type { i8*, i32 }

@str.0 = constant [4 x i8] c"%d\0A\00"
@str.1 = constant [6 x i8] c"shang\00"
@Hello.2 = constant %Hello { i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str.1, i64 0, i64 0), i32 12 }
@str.2 = constant [4 x i8] c"%s\0A\00"

declare i8* @malloc(i32)

declare i32 @printf(i8*, ...)

define void @main.Hello.Show(%Hello %h) {
; <label>:0
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %Hello*
	store %Hello %h, %Hello* %2
	%3 = getelementptr %Hello, %Hello* %2, i32 0, i32 1
	%4 = load i32, i32* %3
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0), i32 %4)
	ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define void @main() {
; <label>:0
	%1 = call i8* @malloc(i32 12)
	%2 = bitcast i8* %1 to %Hello*
	%3 = bitcast %Hello* %2 to i8*
	%4 = bitcast %Hello* @Hello.2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %3, i8* %4, i32 12, i1 false)
	%5 = load %Hello, %Hello* %2
	%6 = call i8* @malloc(i32 12)
	%7 = bitcast i8* %6 to %Hello*
	store %Hello %5, %Hello* %7
	%8 = load %Hello, %Hello* %7
	call void @main.Hello.Show(%Hello %8)
	%9 = getelementptr %Hello, %Hello* %7, i32 0, i32 0
	%10 = load i8*, i8** %9
	%11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0), i8* %10)
	ret void
}

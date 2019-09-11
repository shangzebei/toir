%Person = type { i8*, i8*, i32 }
%ListN = type { i32, %ListN* }

@str.0 = constant [4 x i8] c"man\00"
@Person.1 = constant %Person { i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.0, i64 0, i64 0), i32 12 }
@str.1 = constant [10 x i8] c"%s-%s-%d\0A\00"
@str.2 = constant [4 x i8] c"man\00"
@Person.4 = constant %Person { i8* null, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.2, i64 0, i64 0), i32 12 }
@str.3 = constant [4 x i8] c"%s\0A\00"
@str.4 = constant [4 x i8] c"%d\0A\00"
@str.5 = constant [18 x i8] c"tttttttttttttttt\0A\00"

declare i8* @malloc(i32)

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @initS() {
; <label>:0
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to %Person*
	%3 = bitcast %Person* %2 to i8*
	%4 = bitcast %Person* @Person.1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %3, i8* %4, i32 20, i1 false)
	%5 = load %Person, %Person* %2
	%6 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%7 = load i32, i32* %6
	store i32 45, i32* %6
	%8 = getelementptr %Person, %Person* %2, i32 0, i32 0
	%9 = load i8*, i8** %8
	%10 = getelementptr %Person, %Person* %2, i32 0, i32 1
	%11 = load i8*, i8** %10
	%12 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%13 = load i32, i32* %12
	%14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.1, i64 0, i64 0), i8* %9, i8* %11, i32 %13)
	ret void
}

define void @show(i32 %a) {
; <label>:0
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = load i32, i32* %1
	%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.4, i64 0, i64 0), i32 %2)
	ret void
}

define void @main.Person.Show(%Person* %p) {
; <label>:0
	%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str.5, i64 0, i64 0))
	ret void
}

define void @sFunc() {
; <label>:0
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to %Person*
	%3 = bitcast %Person* %2 to i8*
	%4 = bitcast %Person* @Person.4 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %3, i8* %4, i32 20, i1 false)
	%5 = load %Person, %Person* %2
	%6 = getelementptr %Person, %Person* %2, i32 0, i32 0
	%7 = load i8*, i8** %6
	%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.3, i64 0, i64 0), i8* %7)
	%9 = getelementptr %Person, %Person* %2, i32 0, i32 2
	%10 = load i32, i32* %9
	call void @show(i32 %10)
	call void @main.Person.Show(%Person* %2)
	ret void
}

define void @main() {
; <label>:0
	call void @initS()
	call void @sFunc()
	ret void
}

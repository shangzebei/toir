@str.0 = constant [14 x i8] c"asdfasdfsdfsd\00"
@str.1 = constant [4 x i8] c"%s\0A\00"

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = alloca i8*
	store i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.0, i64 0, i64 0), i8** %1
	%2 = load i8*, i8** %1
	%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str.1, i64 0, i64 0), i8* %2)
	ret void
}

@tt = global i32 0
@str.0 = constant [10 x i8] c"%d-%d=%d\0A\00"

define i32 @add(i32 %a, i32 %b) {
; <label>:0
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = alloca i32
	store i32 %b, i32* %2
	%3 = load i32, i32* %1
	%4 = load i32, i32* %2
	%5 = add i32 %3, %4
	ret i32 %5
}

define void @varBool1() {
; <label>:0
	%1 = alloca i1
	store i1 true, i1* %1
	ret void
}

define void @varBool2() {
; <label>:0
	%1 = alloca i1
	store i1 true, i1* %1
	ret void
}

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = alloca i32
	store i32 4, i32* %1
	%2 = load i32, i32* %1
	%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str.0, i64 0, i64 0), i32 %2, i32 3, i32* @tt)
	ret void
}

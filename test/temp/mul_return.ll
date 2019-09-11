%return.0.0 = type { i32, i32 }

@str.0 = constant [8 x i8] c"%d--%d\0A\00"

define i32 @k() {
; <label>:0
	ret i32 85
}

define %return.0.0 @mul2(i32 %a) {
; <label>:0
	%1 = alloca i32
	store i32 %a, i32* %1
	%2 = call i32 @k()
	%3 = alloca %return.0.0
	%4 = getelementptr %return.0.0, %return.0.0* %3, i32 0, i32 0
	store i32 %2, i32* %4
	%5 = getelementptr %return.0.0, %return.0.0* %3, i32 0, i32 1
	store i32 5, i32* %5
	%6 = load %return.0.0, %return.0.0* %3
	ret %return.0.0 %6
}

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = call %return.0.0 @mul2(i32 1)
	%2 = extractvalue %return.0.0 %1, 0
	%3 = extractvalue %return.0.0 %1, 1
	%4 = alloca i32
	store i32 %2, i32* %4
	%5 = alloca i32
	store i32 %3, i32* %5
	%6 = load i32, i32* %4
	%7 = load i32, i32* %5
	%8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str.0, i64 0, i64 0), i32 %6, i32 %7)
	ret void
}

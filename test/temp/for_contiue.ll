@str.0 = constant [15 x i8] c"okkkkkkkkkkkk\0A\00"
@str.1 = constant [19 x i8] c"bbbbbbbbbbbbbbbbb\0A\00"

declare i32 @printf(i8*, ...)

define void @for1con() {
; <label>:0
	; init block
	%1 = alloca i32
	store i32 0, i32* %1
	br label %5

; <label>:2
	; add block
	%3 = load i32, i32* %1
	%4 = add i32 %3, 1
	store i32 %4, i32* %1
	br label %5

; <label>:5
	; cond Block begin
	%6 = load i32, i32* %1
	%7 = icmp slt i32 %6, 10
	; cond Block end
	br i1 %7, label %8, label %15

; <label>:8
	%9 = load i32, i32* %1
	%10 = icmp sgt i32 %9, 5
	br i1 %10, label %11, label %12

; <label>:11
	br label %2

; <label>:12
	br label %13

; <label>:13
	%14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.0, i64 0, i64 0))
	br label %2

; <label>:15
	; empty block
	%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @str.1, i64 0, i64 0))
	ret void
}

define void @main() {
; <label>:0
	call void @for1con()
	ret void
}

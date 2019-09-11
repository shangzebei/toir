@str.0 = constant [16 x i8] c"aaaaaaaaaaaaaa\0A\00"
@str.1 = constant [17 x i8] c"bbbbbbbbbbbbbbb\0A\00"
@str.2 = constant [16 x i8] c"aaaaaaaaaaaaaa\0A\00"
@str.3 = constant [17 x i8] c"bbbbbbbbbbbbbbb\0A\00"
@str.4 = constant [13 x i8] c"asdfasfdsaf\0A\00"

declare i32 @printf(i8*, ...)

define i32 @ifr2() {
; <label>:0
	%1 = alloca i32
	store i32 90, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp sgt i32 %2, 50
	br i1 %3, label %4, label %6

; <label>:4
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.0, i64 0, i64 0))
	ret i32 0

; <label>:6
	%7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.1, i64 0, i64 0))
	ret i32 1
}

define i32 @ifr1() {
; <label>:0
	%1 = alloca i32
	store i32 90, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp sgt i32 %2, 50
	br i1 %3, label %4, label %6

; <label>:4
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @str.2, i64 0, i64 0))
	br label %8

; <label>:6
	%7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @str.3, i64 0, i64 0))
	ret i32 1

; <label>:8
	ret i32 0
}

define void @ifr3() {
; <label>:0
	%1 = alloca i32
	store i32 90, i32* %1
	%2 = load i32, i32* %1
	%3 = icmp sgt i32 %2, 50
	br i1 %3, label %4, label %5

; <label>:4
	ret void

; <label>:5
	br label %6

; <label>:6
	%7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.4, i64 0, i64 0))
	ret void
}

define void @main() {
; <label>:0
	%1 = call i32 @ifr1()
	%2 = call i32 @ifr2()
	call void @ifr3()
	ret void
}

@str.0 = constant [15 x i8] c"asdfsadfsdfsd\0A\00"

define void @typeFun(void ()* %f) {
; <label>:0
	call void %f()
	ret void
}

declare i32 @printf(i8*, ...)

define void @0() {
; <label>:0
	%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @str.0, i64 0, i64 0))
	ret void
}

define void @main() {
; <label>:0
	call void @typeFun(void ()* @0)
	ret void
}

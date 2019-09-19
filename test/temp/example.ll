%mapStruct = type {}
%string = type { i32, i8* }

@main.str.0 = constant [13 x i8] c"asdfasdfsadf\00"
@kk = global %string { i32 12, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @main.str.0, i64 0, i64 0) }

define void @main() {
; <label>:0
	; block start
	; end block
	ret void
}

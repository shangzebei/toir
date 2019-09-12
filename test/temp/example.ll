@str.0 = constant [11 x i8] c"shangzebei\00"

declare i8* @malloc(i32)

define { i32, i32, i32, i8* }* @init_slice_i8(i32 %len) {
; <label>:0
	; init slice...............
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i8* }*
	%3 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 2
	store i32 1, i32* %3
	%4 = mul i32 %len, 1
	%5 = call i8* @malloc(i32 %4)
	%6 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 3
	%7 = bitcast i8* %5 to i8*
	store i8* %7, i8** %6
	%8 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 1
	store i32 %len, i32* %8
	%9 = getelementptr { i32, i32, i32, i8* }, { i32, i32, i32, i8* }* %2, i32 0, i32 0
	store i32 %len, i32* %9
	; end init slice.................
	ret { i32, i32, i32, i8* }* %2
}

define void @main() {
; <label>:0
	%1 = call { i32, i32, i32, i8* }* @init_slice_i8(i32 4)
	ret void
}

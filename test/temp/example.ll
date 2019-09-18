%mapStruct = type {}
%string = type { i32, i8* }

@main.main.0 = constant [4 x i1] [i1 true, i1 false, i1 true, i1 false]

declare i8* @malloc(i32)

define void @slice.init.i1({ i32, i32, i32, i1* }* %ptr, i32 %len) {
; <label>:0
	; init slice...............
	%1 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %ptr, i32 0, i32 2
	store i32 0, i32* %1
	%2 = mul i32 %len, 0
	%3 = call i8* @malloc(i32 %2)
	%4 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %ptr, i32 0, i32 3
	%5 = bitcast i8* %3 to i1*
	store i1* %5, i1** %4
	%6 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %ptr, i32 0, i32 1
	store i32 %len, i32* %6
	%7 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %ptr, i32 0, i32 0
	store i32 %len, i32* %7
	; end init slice.................
	ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define void @main() {
; <label>:0
	; block start
	%1 = call i8* @malloc(i32 20)
	%2 = bitcast i8* %1 to { i32, i32, i32, i1* }*
	call void @slice.init.i1({ i32, i32, i32, i1* }* %2, i32 4)
	%3 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %2, i32 0, i32 0
	store i32 4, i32* %3
	%4 = getelementptr { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %2, i32 0, i32 3
	%5 = load i1*, i1** %4
	%6 = bitcast i1* %5 to i8*
	%7 = bitcast [4 x i1]* @main.main.0 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %6, i8* %7, i32 0, i1 false)
	%8 = load { i32, i32, i32, i1* }, { i32, i32, i32, i1* }* %2
	; end block
	ret void
}

%mapStruct = type {}
%string = type { i32, i8* }
%TT = type { %string, i32 }
%struct.3 = type { i32 }

@str.0 = constant [3 x i8] c"%s\00"

declare i8* @malloc(i32)

define void @init.TT.17791568864785(%struct.3*, %TT*) {
; <label>:2
	; <inject var
	%3 = getelementptr %struct.3, %struct.3* %0, i32 0, i32 0
	%4 = load i32, i32* %3
	; inject var>
	%5 = getelementptr %TT, %TT* %1, i32 0, i32 1
	store i32 %4, i32* %5
	; <init string>
	%6 = getelementptr %TT, %TT* %1, i32 0, i32 0
	%7 = getelementptr %string, %string* %6, i32 0, i32 1
	store i8* null, i8** %7
	ret void
}

define %string* @runtime.newString(i32 %size) {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 %size, i32* %1
	%2 = call i8* @malloc(i32 20)
	%3 = bitcast i8* %2 to %string*
	%4 = alloca %string*
	store %string* %3, %string** %4
	br label %5

; <label>:5
	%6 = load i32, i32* %1
	%7 = icmp eq i32 %6, 0
	br i1 %7, label %8, label %10

; <label>:8
	; block start
	%9 = load %string*, %string** %4
	; end block
	ret %string* %9

; <label>:10
	br label %11

; <label>:11
	; IF NEW BLOCK
	%12 = load %string*, %string** %4
	%13 = getelementptr %string, %string* %12, i32 0, i32 0
	%14 = load i32, i32* %13
	%15 = load i32, i32* %1
	store i32 %15, i32* %13
	%16 = load i32, i32* %1
	%17 = add i32 %16, 1
	%18 = call i8* @malloc(i32 %17)
	%19 = load %string*, %string** %4
	%20 = getelementptr %string, %string* %19, i32 0, i32 1
	%21 = load i8*, i8** %20
	store i8* %18, i8** %20
	%22 = load %string*, %string** %4
	; end block
	ret %string* %22
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	; block start
	%1 = alloca i32
	store i32 90, i32* %1
	; init param
	%2 = load i32, i32* %1
	%3 = call i8* @malloc(i32 4)
	%4 = bitcast i8* %3 to %struct.3*
	%5 = getelementptr %struct.3, %struct.3* %4, i32 0, i32 0
	store i32 %2, i32* %5
	; end param
	%6 = call i8* @malloc(i32 24)
	%7 = bitcast i8* %6 to %TT*
	call void @init.TT.17791568864785(%struct.3* %4, %TT* %7)
	%8 = load %TT, %TT* %7
	%9 = call i8* @malloc(i32 24)
	%10 = bitcast i8* %9 to %TT*
	store %TT %8, %TT* %10
	%11 = call %string* @runtime.newString(i32 2)
	%12 = getelementptr %string, %string* %11, i32 0, i32 1
	%13 = load i8*, i8** %12
	%14 = bitcast i8* %13 to i8*
	%15 = bitcast i8* getelementptr inbounds ([3 x i8], [3 x i8]* @str.0, i64 0, i64 0) to i8*
	%16 = getelementptr %string, %string* %11, i32 0, i32 0
	%17 = load i32, i32* %16
	%18 = add i32 %17, 1
	call void @llvm.memcpy.p0i8.p0i8.i32(i8* %14, i8* %15, i32 %18, i1 false)
	%19 = load %string, %string* %11
	%20 = getelementptr %TT, %TT* %10, i32 0, i32 0
	%21 = load %string, %string* %20
	%22 = getelementptr %string, %string* %11, i32 0, i32 1
	%23 = load i8*, i8** %22
	%24 = getelementptr %string, %string* %20, i32 0, i32 1
	%25 = load i8*, i8** %24
	%26 = call i32 (i8*, ...) @printf(i8* %23, i8* %25)
	; end block
	ret void
}

@str.0 = constant [7 x i8] c"i: %d\0A\00"
@str.1 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.2 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.3 = constant [14 x i8] c"***iptr3: %d\0A\00"
@str.4 = constant [7 x i8] c"i: %d\0A\00"
@str.5 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.6 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.7 = constant [14 x i8] c"***iptr3: %d\0A\00"
@str.8 = constant [7 x i8] c"i: %d\0A\00"
@str.9 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.10 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.11 = constant [14 x i8] c"***iptr3: %d\0A\00"
@str.12 = constant [7 x i8] c"i: %d\0A\00"
@str.13 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.14 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.15 = constant [14 x i8] c"***iptr3: %d\0A\00"
@str.16 = constant [7 x i8] c"i: %d\0A\00"
@str.17 = constant [12 x i8] c"*iptr1: %d\0A\00"
@str.18 = constant [13 x i8] c"**iptr2: %d\0A\00"
@str.19 = constant [14 x i8] c"***iptr3: %d\0A\00"

declare i32 @printf(i8*, ...)

define void @main() {
; <label>:0
	%1 = alloca i32
	store i32 100, i32* %1
	%2 = alloca i32*
	store i32* %1, i32** %2
	%3 = alloca i32**
	store i32** %2, i32*** %3
	%4 = alloca i32***
	store i32*** %3, i32**** %4
	%5 = load i32, i32* %1
	%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.0, i64 0, i64 0), i32 %5)
	%7 = load i32*, i32** %2
	%8 = load i32, i32* %7
	%9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.1, i64 0, i64 0), i32 %8)
	%10 = load i32**, i32*** %3
	%11 = load i32*, i32** %10
	%12 = load i32, i32* %11
	%13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.2, i64 0, i64 0), i32 %12)
	%14 = load i32***, i32**** %4
	%15 = load i32**, i32*** %14
	%16 = load i32*, i32** %15
	%17 = load i32, i32* %16
	%18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.3, i64 0, i64 0), i32 %17)
	store i32 200, i32* %1
	%19 = load i32, i32* %1
	%20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.4, i64 0, i64 0), i32 %19)
	%21 = load i32*, i32** %2
	%22 = load i32, i32* %21
	%23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.5, i64 0, i64 0), i32 %22)
	%24 = load i32**, i32*** %3
	%25 = load i32*, i32** %24
	%26 = load i32, i32* %25
	%27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.6, i64 0, i64 0), i32 %26)
	%28 = load i32***, i32**** %4
	%29 = load i32**, i32*** %28
	%30 = load i32*, i32** %29
	%31 = load i32, i32* %30
	%32 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.7, i64 0, i64 0), i32 %31)
	%33 = load i32*, i32** %2
	%34 = load i32, i32* %33
	store i32 300, i32* %33
	%35 = load i32, i32* %1
	%36 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.8, i64 0, i64 0), i32 %35)
	%37 = load i32*, i32** %2
	%38 = load i32, i32* %37
	%39 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.9, i64 0, i64 0), i32 %38)
	%40 = load i32**, i32*** %3
	%41 = load i32*, i32** %40
	%42 = load i32, i32* %41
	%43 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.10, i64 0, i64 0), i32 %42)
	%44 = load i32***, i32**** %4
	%45 = load i32**, i32*** %44
	%46 = load i32*, i32** %45
	%47 = load i32, i32* %46
	%48 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.11, i64 0, i64 0), i32 %47)
	%49 = load i32**, i32*** %3
	%50 = load i32*, i32** %49
	%51 = load i32, i32* %50
	store i32 400, i32* %50
	%52 = load i32, i32* %1
	%53 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.12, i64 0, i64 0), i32 %52)
	%54 = load i32*, i32** %2
	%55 = load i32, i32* %54
	%56 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.13, i64 0, i64 0), i32 %55)
	%57 = load i32**, i32*** %3
	%58 = load i32*, i32** %57
	%59 = load i32, i32* %58
	%60 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.14, i64 0, i64 0), i32 %59)
	%61 = load i32***, i32**** %4
	%62 = load i32**, i32*** %61
	%63 = load i32*, i32** %62
	%64 = load i32, i32* %63
	%65 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.15, i64 0, i64 0), i32 %64)
	%66 = load i32***, i32**** %4
	%67 = load i32**, i32*** %66
	%68 = load i32*, i32** %67
	%69 = load i32, i32* %68
	store i32 500, i32* %68
	%70 = load i32, i32* %1
	%71 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str.16, i64 0, i64 0), i32 %70)
	%72 = load i32*, i32** %2
	%73 = load i32, i32* %72
	%74 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @str.17, i64 0, i64 0), i32 %73)
	%75 = load i32**, i32*** %3
	%76 = load i32*, i32** %75
	%77 = load i32, i32* %76
	%78 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str.18, i64 0, i64 0), i32 %77)
	%79 = load i32***, i32**** %4
	%80 = load i32**, i32*** %79
	%81 = load i32*, i32** %80
	%82 = load i32, i32* %81
	%83 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str.19, i64 0, i64 0), i32 %82)
	ret void
}

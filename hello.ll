declare i32 @puts(i8* nocapture) nounwind
declare i32 @getchar() nounwind
declare i32 @putchar(i32) nounwind

@str = private local_unnamed_addr constant [12 x i8] c"hello world\00"

define void @main() {
  call i32 @puts(i8* getelementptr ([12 x i8], [12 x i8]* @str, i64 0, i64 0))
  br label %loop

loop:
  %c = call i32 @getchar()
  call i32 @putchar(i32 %c)
  %eof = icmp ne i32 %c, -1
  br i1 %eof, label %loop, label %done

done:
  ret void
}

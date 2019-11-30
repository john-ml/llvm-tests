declare i32 @putchar(i32)

define i32 @tri_tail(i32 %a, i32 %acc) {
entry:
  %c = icmp eq i32 0, %a
  br i1 %c, label %base, label %ind

base:
  ret i32 %acc

ind:
  %acc1 = add i32 %a, %acc
  %pred = sub i32 %a, 1
  %sum = tail call i32 @tri_tail(i32 %pred, i32 %acc1)
  ret i32 %sum
}

define i32 @tri(i32 %a) {
entry:
  %c = icmp eq i32 0, %a
  br i1 %c, label %base, label %ind

base:
  ret i32 0

ind:
  %pred = sub i32 %a, 1
  %acc = call i32 @tri(i32 %pred)
  %sum = add i32 %a, %acc
  ret i32 %sum
}

define void @main() {
  call i32 @putchar(i32 65)
  %fiftyfive = call i32 @tri(i32 10)
  %sixtyfive = add i32 10, %fiftyfive
  call i32 @putchar(i32 %sixtyfive)
  %lots = call i32 @tri_tail(i32 1000000, i32 0)
  call i32 @putchar(i32 10)
  ret void
}

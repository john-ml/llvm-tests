declare i32 @putchar(i32)

; i32 × i32

%pair = type {i32, i32}

define %pair @pair(i32 %a, i32 %b) {
  %q = alloca %pair
  %p = load %pair, %pair* %q
  %r = insertvalue %pair %p, i32 %a, 0
  %r1 = insertvalue %pair %r, i32 %b, 1
  ret %pair %r1
}

define i32 @fst(%pair %p) {
  %res = extractvalue %pair %p, 0
  ret i32 %res
}

define i32 @snd(%pair %p) {
  %res = extractvalue %pair %p, 1
  ret i32 %res
}

; (i32 × i32) + (i64 × i32*)

%right = type {i64, i32*}
%payload = type {i64, i64}
%sum = type {i1, %payload}

define %sum @inl(%pair %x) {
  %q = alloca %sum
  %r = load %sum, %sum* %q
  ; Unpack all the stuff in %x and cast to right type if necessary
  %left0 = extractvalue %pair %x, 0
  %left1 = extractvalue %pair %x, 1
  %left00 = sext i32 %left0 to i64
  %left10 = sext i32 %left1 to i64
  ; Tag + pack up payload
  %r0 = insertvalue %sum %r, i1 1, 0
  %r1 = insertvalue %sum %r0, i64 %left00, 1, 0
  %r2 = insertvalue %sum %r1, i64 %left10, 1, 1
  ret %sum %r2
}

define %sum @inr(%right %x) {
  %q = alloca %sum
  %r = load %sum, %sum* %q
  ; Unpack all the stuff in %x and cast to right type if necessary
  %right0 = extractvalue %right %x, 0
  %right1 = extractvalue %right %x, 1
  %right10 = ptrtoint i32* %right1 to i64 ; bitcast can only do ptr->ptr
  ; Tag + pack up payload
  %r0 = insertvalue %sum %r, i1 0, 0
  %r1 = insertvalue %sum %r0, i64 %right0, 1, 0
  %r2 = insertvalue %sum %r1, i64 %right10, 1, 1
  ret %sum %r2
}

define i64 @test_elim(%sum %x) {
  %t = extractvalue %sum %x, 0
  switch i1 %t, label %impossible [
    i1 0, label %left
    i1 1, label %right
  ]
left:
  %a = extractvalue %sum %x, 1, 0
  %b = extractvalue %sum %x, 1, 1
  %r = trunc i64 %a to i32
  %r0 = sext i32 %r to i64
  %r1 = shl i64 %r0, 32
  %r2 = or i64 %r1, %b
  ret i64 %r2
right:
  %r3 = extractvalue %sum %x, 1, 0
  ret i64 %r3
impossible:
  unreachable
}

define void @main() {
  %q = alloca %pair
  %p = load %pair, %pair* %q
  %p0 = insertvalue %pair %p, i32 65, 0
  %p1 = insertvalue %pair %p0, i32 66, 1
  %a = call i32 @fst(%pair %p1)
  %b = call i32 @snd(%pair %p1)
  call i32 @putchar(i32 %a)
  call i32 @putchar(i32 %b)
  call i32 @putchar(i32 10)
  ret void
}

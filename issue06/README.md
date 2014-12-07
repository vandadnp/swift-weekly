__WORK IN PROGRESS__

Swift Weekly - Issue 06 - The Swift Runtime (Part 4) - Generics
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
Generics are pretty cool. They let us do complicated stuff that many programmers don't want to deal with sometimes and want to stick with traditional means of achieving the same goals but using basic ideas in OOP. In this edition of Swift Weekly, I won't teach you about generics eventhough you may just see the examples and learn generics anyways. What I __will__ teach you however is how generics are compiled at the assembly level buy the Swift compiler.

I am going to use the release version of the code to make sure the output assembly is as optimized as possible so that the optimization level is set to `-O` in the output when your Swift files are being compiled. Also my `swift -version` shows this:

```bash
Swift version 1.1 (swift-600.0.54.20)
Target: x86_64-apple-darwin14.0.0
```
I am using the latest beta of Xcode, aka `Version 6.2 (6C86e)`. Let's get started.

Note: I am going to get rid of some of the assembly code that is not relevant to the main point of this week's objective.

A simple `+` Generic Function
===
So here is the function I am going to write:

```swift
func add<T: IntegerType>(l: T, r: T) -> T{
  return l + r
}
```

and I'm going to use it like so:

```swift
func example1(){
  
  let a = 0xabcdefa
  let b = 0xabcdefb
  let c = add(a, b)
  println(c)
  
}
```

Let's have a look at the assembly output of `example1()` function:

```asm
push       rbp
mov        rbp, rsp
push       rbx
push       rax
mov        rbx, rdi
mov        qword [ss:rbp+var_10], 0x1579bdf5
lea        rdi, qword [ss:rbp+var_10]
call       __TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_
mov        edi, 0xa          ; argument #1 for method imp___stubs__putchar
call       imp___stubs__putchar
mov        rdi, rbx
add        rsp, 0x8
pop        rbx
pop        rbp
jmp        imp___stubs__swift_release
nop        qword [cs:rax+rax+0x0]
```
Well, this is a crap load of code. What is happening here? Let me explain:

1. The stack is being set up.
2. The result of the addition of the value `a` and `b` which were `0xabcdefa` and `0xabcdefb` are added and directly put into the code segment as you can see here:

	```asm
	mov        qword [ss:rbp+var_10], 0x1579bdf5
	lea        rdi, qword [ss:rbp+var_10]
	```
	and you can do the maths yourself if you want or [use Calc.app on your mac to find the results](http://d.pr/i/18viW/20JMe185+)
	
3. the `imp___stubs__putchar` internal function is then called to do the `println()` for us.
4. The stack is put back together ready to return to the caller.

Well this was really easy. This tells me that the compiler noticed that we called this generic function only once so didn't feel the need to make it a real function. How about if we call this function a few times? Let's see:

```swift
func example2(){
  
  var a = 0
  for _ in 0..<10{
    add(a, randomInt())
  }
  
}
```

before I show you the output assembly, please grab a cup of tea or coffee because this is getting quite interesting. Also make sure that you have a diaper around because this code that the compiler has generated is just... wow:

```asm
push       rbp
mov        rbp, rsp
push       r15
push       r14
push       r12
push       rbx
mov        rbx, rdi
test       rbx, rbx
mov        rax, qword [ds:rbx]
je         0x1000027a0

lea        r15, qword [ds:objc_class__TtC12swift_weekly4Test] ; objc_class__TtC12swift_weekly4Test
cmp        rax, r15
je         0x100002887

mov        r12, qword [ds:rax+0x48]
mov        rdi, rbx
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x100002894

mov        r15, qword [ds:rax+0x48] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+20
mov        rdi, rbx

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+32
call       imp___stubs__arc4random_uniform
mov        r14, rbx

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+59
cmp        rax, r15
je         0x1000028b3

mov        r12, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x1000028bd

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+314
call       imp___stubs__arc4random_uniform

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+337
cmp        rax, r15
je         0x1000028dc

mov        r12, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x1000028e6

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+355
call       imp___stubs__arc4random_uniform

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+378
cmp        rax, r15
je         0x100002905

mov        r12, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x10000290f

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+396
call       imp___stubs__arc4random_uniform

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+419
cmp        rax, r15
je         0x10000292e

mov        r12, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x100002938

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+437
call       imp___stubs__arc4random_uniform

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+460
cmp        rax, r15
je         0x100002957

mov        r12, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x100002961

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+478
call       imp___stubs__arc4random_uniform

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+501
cmp        rax, r15
je         0x100002980

mov        r12, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x10000298a

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+519
call       imp___stubs__arc4random_uniform

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+542
cmp        rax, r15
je         0x1000029a9

mov        r12, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x1000029b3

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+560
call       imp___stubs__arc4random_uniform

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+583
cmp        rax, r15
je         0x1000029d2

mov        r12, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r12
jmp        0x1000029dc

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+601
call       imp___stubs__arc4random_uniform

mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+624
cmp        rax, r15
je         0x1000029fb

mov        r15, qword [ds:rax+0x48]
mov        rdi, r14
call       imp___stubs__swift_retain
mov        r14, rax
mov        rdi, rbx
call       r15
jmp        0x100002a05

mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+642
call       imp___stubs__arc4random_uniform

mov        rdi, r14          ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+290, __TFC12swift_weekly4Test8example2fS0_FT_T_+665
pop        rbx
pop        r12
pop        r14
pop        r15
pop        rbp
jmp        imp___stubs__swift_release

nop        qword [cs:rax+rax+0x0]
```
__Note__: I've removed the code-segment addresses from the output assembly to make it neater to look at. If you are interested in reading the output assembly, [contact me](mailto:vandad.np@gmail.com) and I will email them to you.

Yes ladies and gents, you guessed it right. The compiler basically wrote the same code for 1 of the loops, but x10 times. So this means that the compiler didn't really understand that we had a generic __function__ and did not respect it as a function, instead, it wrote the code for the function and basically for the whole loop, `X` times where `X` in our example is 10. This is not good. I will now break down the code:

1. The stack is being set up
2. The code then executes this instruction:

	```asm
	lea        r15, qword [ds:objc_class__TtC12swift_weekly4Test]
	```
	
	I was curious as to what that whole `ds:objc_class__TtC12swift_weekly4Test` points to, which is basically an address in the data segment so I followed it along in the output assembly to 	reach this gem:
	
	```asm
	dq         __TMmC12swift_weekly4Test ; metaclass, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+22, __TFC12swift_weekly4TestCfMS0_FT_S0_+16, __TMaC12swift_weekly4Test+16, _objc_classes_100015288, _objc_non_lazy_classes_1000152a0
	dq         _OBJC_CLASS_$_SwiftObject ; superclass
	dq         __objc_empty_cache ; cache
	dq         0x0               ; vtable
	dq         0x100015f21       ; data (Swift class)
	```
	
	oh looky looky what we found! `objc` references in a Swift class? What is going on here? It looks like the Swift compiler has turned out whole `Test` class into an Objective-C class 	which its super class set to `SwiftObject`. So I am guessing that this is some sort of a private class that Apple has shipped inside the SDK but never told us. The problem here is that Apple actually said that Swift classes do not need a super class. I don't know the answer to these two questions:
	
	1. Why is it that we have a metadata for our class generated in the data segment telling us that our class is actually turned into an Objective-C class?
	2. Why is it that our class which has no super-class actually has been given a super-class with the private name of `SwiftObject`?

	If you know the anser to these two questions, please submit a pull request and correct this article.

So the compiler generated the code for our generic function `10` times because we were looping that code `10` times. That makes me curious as to whether this is because it treated the generic function as an inline function because of its simplicity or not. So let's change that function to make it a bit more complicated and see if we get the same results:

```swift
//make the function more complicated for the compiler to inline in a very silly way. the goal is to make the function longer
func moreComplextGenericFunction<T: IntegerType>(l: T, r: T) -> T{
  
  if l > r{
    UIViewController()
    UIView()
    UILabel()
    UIButton()
  }
  
  else{
    UILabel()
    UIButton()
    UIViewController()
    UIView()
  }
  
  return 0
  
}
```

and then I am going to go ahead and use this function in the same fashion as before:

```swift
func example3(){
  
  var a = 0
  for _ in 0..<randomInt(){
    moreComplextGenericFunction(a, randomInt())
  }
  
}
```

note that I am setting the higher boundary of the loop to a random number that the compiler cannot/will not determine during compile time even though it could. So this will allow us to circumvent any smart tricks that the compiler may do in code generation (pre-determining the loop count and pasting code in the loop `N` times where `N` is the higher boundary of our loop), just so that we can really see how the compiler deals with generics, not loops. This is going to be a long chunk of asm code which I will do my best to break down so bear with me please:

```asm
00000001000025a0   push       rbp
00000001000025a1   mov        rbp, rsp
00000001000025a4   push       r15
00000001000025a6   push       r14
00000001000025a8   push       r13
00000001000025aa   push       r12
00000001000025ac   push       rbx
00000001000025ad   push       rax
00000001000025ae   mov        r14, rdi
00000001000025b1   mov        rax, qword [ds:r14]
00000001000025b4   lea        r13, qword [ds:objc_class__TtC12swift_weekly4Test] ; objc_class__TtC12swift_weekly4Test
00000001000025bb   cmp        rax, r13
00000001000025be   jne        0x1000025d3

00000001000025c0   test       r14, r14
00000001000025c3   je         0x1000025d3

00000001000025c5   mov        edi, 0xffffffff                             ; argument #1 for method imp___stubs__arc4random_uniform
00000001000025ca   call       imp___stubs__arc4random_uniform
00000001000025cf   mov        ebx, eax
00000001000025d1   jmp        0x1000025f0

00000001000025d3   mov        rbx, qword [ds:rax+0x48]                    ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+30, __TFC12swift_weekly4Test8example3fS0_FT_T_+35
00000001000025d7   mov        rdi, r14
00000001000025da   call       imp___stubs__swift_retain
00000001000025df   mov        rdi, r14
00000001000025e2   call       rbx
00000001000025e4   mov        rbx, rax
00000001000025e7   test       rbx, rbx
00000001000025ea   js         0x1000029ab

00000001000025f0   test       rbx, rbx                                    ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+49
00000001000025f3   mov        r15, r14
00000001000025f6   je         0x100002995

00000001000025fc   test       r14, r14
00000001000025ff   je         0x1000027d8

0000000100002605   mov        r15, r14
0000000100002608   nop        qword [ds:rax+rax+0x0]

0000000100002610   mov        rax, qword [ds:r14]                         ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+557
0000000100002613   cmp        rax, r13
0000000100002616   je         0x1000026f0

000000010000261c   mov        r12, qword [ds:rax+0x48]
0000000100002620   mov        rdi, r15
0000000100002623   call       imp___stubs__swift_retain
0000000100002628   mov        r15, rax
000000010000262b   mov        rdi, r14
000000010000262e   call       r12
0000000100002631   test       rax, rax
0000000100002634   jns        0x1000026fa

000000010000263a   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIViewController] ; imp___got__OBJC_CLASS_$_UIViewController
0000000100002641   call       imp___stubs__swift_getInitializedObjCClass
0000000100002646   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
000000010000264d   xor        edx, edx
000000010000264f   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002652   call       imp___stubs__objc_msgSend
0000000100002657   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
000000010000265e   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002661   call       imp___stubs__objc_msgSend
0000000100002666   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
0000000100002669   call       imp___stubs__objc_release
000000010000266e   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIView] ; imp___got__OBJC_CLASS_$_UIView
0000000100002675   call       imp___stubs__swift_getInitializedObjCClass
000000010000267a   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
0000000100002681   xor        edx, edx
0000000100002683   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002686   call       imp___stubs__objc_msgSend
000000010000268b   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
0000000100002692   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002695   call       imp___stubs__objc_msgSend
000000010000269a   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
000000010000269d   call       imp___stubs__objc_release
00000001000026a2   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UILabel] ; imp___got__OBJC_CLASS_$_UILabel
00000001000026a9   call       imp___stubs__swift_getInitializedObjCClass
00000001000026ae   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
00000001000026b5   xor        edx, edx
00000001000026b7   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000026ba   call       imp___stubs__objc_msgSend
00000001000026bf   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
00000001000026c6   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000026c9   call       imp___stubs__objc_msgSend
00000001000026ce   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
00000001000026d1   call       imp___stubs__objc_release
00000001000026d6   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIButton] ; imp___got__OBJC_CLASS_$_UIButton
00000001000026dd   jmp        0x10000279d
00000001000026e2   nop        qword [cs:rax+rax+0x0]

00000001000026f0   mov        edi, 0xffffffff                             ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+118
00000001000026f5   call       imp___stubs__arc4random_uniform

00000001000026fa   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UILabel] ; imp___got__OBJC_CLASS_$_UILabel, XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+148
0000000100002701   call       imp___stubs__swift_getInitializedObjCClass
0000000100002706   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
000000010000270d   xor        edx, edx
000000010000270f   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002712   call       imp___stubs__objc_msgSend
0000000100002717   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
000000010000271e   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002721   call       imp___stubs__objc_msgSend
0000000100002726   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
0000000100002729   call       imp___stubs__objc_release
000000010000272e   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIButton] ; imp___got__OBJC_CLASS_$_UIButton
0000000100002735   call       imp___stubs__swift_getInitializedObjCClass
000000010000273a   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
0000000100002741   xor        edx, edx
0000000100002743   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002746   call       imp___stubs__objc_msgSend
000000010000274b   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
0000000100002752   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002755   call       imp___stubs__objc_msgSend
000000010000275a   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
000000010000275d   call       imp___stubs__objc_release
0000000100002762   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIViewController] ; imp___got__OBJC_CLASS_$_UIViewController
0000000100002769   call       imp___stubs__swift_getInitializedObjCClass
000000010000276e   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
0000000100002775   xor        edx, edx
0000000100002777   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000277a   call       imp___stubs__objc_msgSend
000000010000277f   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
0000000100002786   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002789   call       imp___stubs__objc_msgSend
000000010000278e   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
0000000100002791   call       imp___stubs__objc_release
0000000100002796   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIView] ; imp___got__OBJC_CLASS_$_UIView

000000010000279d   call       imp___stubs__swift_getInitializedObjCClass  ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+317
00000001000027a2   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
00000001000027a9   xor        edx, edx
00000001000027ab   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000027ae   call       imp___stubs__objc_msgSend
00000001000027b3   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
00000001000027ba   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000027bd   call       imp___stubs__objc_msgSend
00000001000027c2   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
00000001000027c5   call       imp___stubs__objc_release
00000001000027ca   dec        rbx
00000001000027cd   jne        0x100002610

00000001000027d3   jmp        0x100002995

00000001000027d8   mov        r13, qword [ds:imp___got__OBJC_CLASS_$_UIButton] ; imp___got__OBJC_CLASS_$_UIButton, XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+95
00000001000027df   mov        r15, r14
00000001000027e2   nop        qword [cs:rax+rax+0x0]

00000001000027f0   mov        rax, qword [ds:r14]                         ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+1007
00000001000027f3   mov        r12, qword [ds:rax+0x48]
00000001000027f7   mov        rdi, r15
00000001000027fa   call       imp___stubs__swift_retain
00000001000027ff   mov        r15, rax
0000000100002802   xor        edi, edi
0000000100002804   call       r12
0000000100002807   test       rax, rax
000000010000280a   js         0x1000028c0

0000000100002810   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UILabel] ; imp___got__OBJC_CLASS_$_UILabel
0000000100002817   call       imp___stubs__swift_getInitializedObjCClass
000000010000281c   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
0000000100002823   xor        edx, edx
0000000100002825   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002828   call       imp___stubs__objc_msgSend
000000010000282d   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
0000000100002834   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002837   call       imp___stubs__objc_msgSend
000000010000283c   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
000000010000283f   call       imp___stubs__objc_release
0000000100002844   mov        rdi, r13
0000000100002847   call       imp___stubs__swift_getInitializedObjCClass
000000010000284c   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
0000000100002853   xor        edx, edx
0000000100002855   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002858   call       imp___stubs__objc_msgSend
000000010000285d   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
0000000100002864   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002867   call       imp___stubs__objc_msgSend
000000010000286c   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
000000010000286f   call       imp___stubs__objc_release
0000000100002874   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIViewController] ; imp___got__OBJC_CLASS_$_UIViewController
000000010000287b   call       imp___stubs__swift_getInitializedObjCClass
0000000100002880   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
0000000100002887   xor        edx, edx
0000000100002889   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000288c   call       imp___stubs__objc_msgSend
0000000100002891   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
0000000100002898   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000289b   call       imp___stubs__objc_msgSend
00000001000028a0   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
00000001000028a3   call       imp___stubs__objc_release
00000001000028a8   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIView] ; imp___got__OBJC_CLASS_$_UIView
00000001000028af   jmp        0x10000295f
00000001000028b4   nop        qword [cs:rax+rax+0x0]

00000001000028c0   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIViewController] ; imp___got__OBJC_CLASS_$_UIViewController, XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+618
00000001000028c7   call       imp___stubs__swift_getInitializedObjCClass
00000001000028cc   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
00000001000028d3   xor        edx, edx
00000001000028d5   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000028d8   call       imp___stubs__objc_msgSend
00000001000028dd   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
00000001000028e4   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000028e7   call       imp___stubs__objc_msgSend
00000001000028ec   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
00000001000028ef   call       imp___stubs__objc_release
00000001000028f4   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIView] ; imp___got__OBJC_CLASS_$_UIView
00000001000028fb   call       imp___stubs__swift_getInitializedObjCClass
0000000100002900   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
0000000100002907   xor        edx, edx
0000000100002909   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000290c   call       imp___stubs__objc_msgSend
0000000100002911   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
0000000100002918   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000291b   call       imp___stubs__objc_msgSend
0000000100002920   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
0000000100002923   call       imp___stubs__objc_release
0000000100002928   mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UILabel] ; imp___got__OBJC_CLASS_$_UILabel
000000010000292f   call       imp___stubs__swift_getInitializedObjCClass
0000000100002934   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
000000010000293b   xor        edx, edx
000000010000293d   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002940   call       imp___stubs__objc_msgSend
0000000100002945   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
000000010000294c   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000294f   call       imp___stubs__objc_msgSend
0000000100002954   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
0000000100002957   call       imp___stubs__objc_release
000000010000295c   mov        rdi, r13

000000010000295f   call       imp___stubs__swift_getInitializedObjCClass  ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+783
0000000100002964   mov        rsi, qword [ds:0x100015fa8]                 ; @selector(allocWithZone:), argument "selector" for method imp___stubs__objc_msgSend
000000010000296b   xor        edx, edx
000000010000296d   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100002970   call       imp___stubs__objc_msgSend
0000000100002975   mov        rsi, qword [ds:0x100015fb0]                 ; @selector(init), argument "selector" for method imp___stubs__objc_msgSend
000000010000297c   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000297f   call       imp___stubs__objc_msgSend
0000000100002984   mov        rdi, rax                                    ; argument "instance" for method imp___stubs__objc_release
0000000100002987   call       imp___stubs__objc_release
000000010000298c   dec        rbx
000000010000298f   jne        0x1000027f0

0000000100002995   mov        rdi, r15                                    ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+86, __TFC12swift_weekly4Test8example3fS0_FT_T_+563
0000000100002998   add        rsp, 0x8
000000010000299c   pop        rbx
000000010000299d   pop        r12
000000010000299f   pop        r13
00000001000029a1   pop        r14
00000001000029a3   pop        r15
00000001000029a5   pop        rbp
00000001000029a6   jmp        imp___stubs__swift_release

00000001000029ab   ud2                                                    ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+74
00000001000029ad   nop        qword [ds:rax]
                   	__TFC12swift_weekly4Testd:
00000001000029b0   push       rbp
00000001000029b1   mov        rbp, rsp
00000001000029b4   mov        rax, rdi
00000001000029b7   pop        rbp
00000001000029b8   ret        
                   ; endp
00000001000029b9   nop        qword [ds:rax+0x0]
```

I've left the code segment addresses intact to let you also have a look at how the conditional and unconfitional jump statements are working.

Here is a breakdown of what the code is doing:

1. The random number gets generated and placed inside the `ebx` 32-bit register:

	```asm
	00000001000025c5         mov        edi, 0xffffffff                             ; argument #1 for method imp___stubs__arc4random_uniform
	00000001000025ca         call       imp___stubs__arc4random_uniform
	00000001000025cf         mov        ebx, eax
	00000001000025d1         jmp        0x1000025f0
	```

2. an unconditional `jmp` statement jumps to the following section of the code:

	```asm
	00000001000025f0         test       rbx, rbx                                    ; XREF=__TFC12swift_weekly4Test8example3fS0_FT_T_+49
	00000001000025f3         mov        r15, r14
	00000001000025f6         je         0x100002995
	```

	this is checking if the generated random number is `0` and if yes, it jumps over all the other code in the `example3()` function and straight to the end. So this is what we expect. 0 loops, 0 execution of the loop 	code.
	
3. Almost near the end of the code, you can see where the loop is happening:

	```asm
	000000010000298c         dec        rbx
	000000010000298f         jne        0x1000027f0
	```

	It seems like Swift generally perfers to keep the integer counter inside a loop in the `ebx` register. If you have a loop that goes from `0` to `1000`, that number range that moves from `0` to `1000` is usually 	kept inside the `ebx` register. I have done some researching around the web and it seems like `ebx` or its 64-bit counterpart of `rbx` are just general purpose registers and they are not designated to be a counter 	as such. But it's good to know that Swift uses `ebx` usually for counters.

4. If you look at the code, you will realize what the Swift compiler has done. It has noticed that the code for the generic function of `moreComplextGenericFunction()` is actually quite long so it has done what it did before, that is to say that it brought the code in-line, however, it did not write the same code `N` times. It created conditional jumps around it so that the code is inline but not repeated. This is quite clever.

A simple Generic Type
===
I am going to define a simple type like so:

```swift
struct Finder<T: Equatable>{
  let array: [T]
  let item: T
  func isItemInArray() -> Bool{
    for i in array{
      if i == item{
        return true
      }
    }
    return false
  }
}
```

I know already that there are tons of other ways to look for items in an array but this is to test generics. I am then going to use it:

```swift
func example4(){
  let int1 = 0xabcdefa
  let int2 = 0xabcdefb
  let array = [int1, int2]
  if Finder<Int>(array: array, item: int1).isItemInArray(){
    println("Found int1 in array")
  } else {
    println("Could not find int1")
  }
}
```

let's see the output assembly code:

```asm
0000000100003170   push       rbp
0000000100003171   mov        rbp, rsp
0000000100003174   push       r15
0000000100003176   push       r14
0000000100003178   push       r12
000000010000317a   push       rbx
000000010000317b   sub        rsp, 0x40
000000010000317f   mov        r14, rdi
0000000100003182   lea        rdi, qword [ds:0x10001a2f0]                 ; 0x10001a2f0 (_metadata + 0x10)
0000000100003189   mov        esi, 0x28
000000010000318e   mov        edx, 0x7
0000000100003193   call       imp___stubs__swift_allocObject
0000000100003198   mov        r15, rax
000000010000319b   mov        qword [ds:r15+0x10], 0x2
00000001000031a3   mov        qword [ds:r15+0x18], 0xabcdefa
00000001000031ab   mov        qword [ds:r15+0x20], 0xabcdefb
00000001000031b3   mov        rdi, qword [ds:__TMLGCSs23_ContiguousArrayStorageSi_] ; __TMLGCSs23_ContiguousArrayStorageSi_
00000001000031ba   test       rdi, rdi
00000001000031bd   jne        0x1000031e0

00000001000031bf   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
00000001000031c6   add        rsi, 0x8
00000001000031ca   mov        rdi, qword [ds:imp___got___TMPdCSs23_ContiguousArrayStorage] ; imp___got___TMPdCSs23_ContiguousArrayStorage
00000001000031d1   call       imp___stubs__swift_getGenericMetadata1
00000001000031d6   mov        rdi, rax
00000001000031d9   mov        qword [ds:__TMLGCSs23_ContiguousArrayStorageSi_], rdi ; __TMLGCSs23_ContiguousArrayStorageSi_

00000001000031e0   mov        esi, 0x30                                   ; XREF=__TFC12swift_weekly4Test8example4fS0_FT_T_+77
00000001000031e5   mov        edx, 0x7
00000001000031ea   call       imp___stubs__swift_bufferAllocate
00000001000031ef   mov        rbx, rax
00000001000031f2   mov        qword [ds:rbx+0x18], 0x0
00000001000031fa   mov        qword [ds:rbx+0x10], 0x0
0000000100003202   mov        rdi, rbx                                    ; argument "ptr" for method imp___stubs__malloc_size
0000000100003205   call       imp___stubs__malloc_size
000000010000320a   sub        rax, 0x20
000000010000320e   jo         0x10000336e

0000000100003214   cmp        rax, 0xfffffffffffffff9
0000000100003218   jl         0x10000336e

000000010000321e   mov        rcx, rax
0000000100003221   sar        rcx, 0x3f
0000000100003225   shr        rcx, 0x3d
0000000100003229   add        rcx, rax
000000010000322c   sar        rcx, 0x3
0000000100003230   add        rcx, rcx
0000000100003233   mov        qword [ds:rbx+0x10], 0x2
000000010000323b   mov        qword [ds:rbx+0x18], rcx
000000010000323f   mov        rax, qword [ds:r15+0x18]
0000000100003243   mov        qword [ds:rbx+0x20], rax
0000000100003247   mov        rax, qword [ds:r15+0x20]
000000010000324b   mov        qword [ds:rbx+0x28], rax
000000010000324f   mov        qword [ss:rbp+var_28], r15
0000000100003253   lea        rdi, qword [ss:rbp+var_28]
0000000100003257   call       imp___stubs__swift_fixLifetime
000000010000325c   mov        rdi, qword [ss:rbp+var_28]
0000000100003260   call       imp___stubs__swift_release
0000000100003265   test       rbx, rbx
0000000100003268   je         0x1000032c9

000000010000326a   mov        r12, qword [ds:rbx+0x10]
000000010000326e   mov        rdi, rbx
0000000100003271   call       imp___stubs__swift_retain
0000000100003276   mov        rdi, rax
0000000100003279   call       imp___stubs__swift_retain
000000010000327e   mov        r15, rax
0000000100003281   test       r12, r12
0000000100003284   je         0x1000032ec

0000000100003286   add        rbx, 0x20
000000010000328a   xor        eax, eax
000000010000328c   mov        rcx, 0x7fffffffffffffff
0000000100003296   nop        qword [cs:rax+rax+0x0]

00000001000032a0   cmp        rax, r12                                    ; XREF=__TFC12swift_weekly4Test8example4fS0_FT_T_+341
00000001000032a3   jge        0x10000336e

00000001000032a9   cmp        rax, rcx
00000001000032ac   je         0x10000336e

00000001000032b2   cmp        qword [ds:rbx], 0xabcdefa
00000001000032b9   je         0x10000331d

00000001000032bb   inc        rax
00000001000032be   add        rbx, 0x8
00000001000032c2   cmp        r12, rax
00000001000032c5   jne        0x1000032a0

00000001000032c7   jmp        0x1000032ec

00000001000032c9   mov        rdi, rbx                                    ; XREF=__TFC12swift_weekly4Test8example4fS0_FT_T_+248
00000001000032cc   call       imp___stubs__swift_retain
00000001000032d1   mov        rdi, rax
00000001000032d4   call       imp___stubs__swift_retain
00000001000032d9   mov        rdi, rax
00000001000032dc   call       imp___stubs__swift_retain
00000001000032e1   mov        rdi, rax
00000001000032e4   call       imp___stubs__swift_retain
00000001000032e9   mov        r15, rax

00000001000032ec   mov        rdi, r15                                    ; XREF=__TFC12swift_weekly4Test8example4fS0_FT_T_+276, __TFC12swift_weekly4Test8example4fS0_FT_T_+343
00000001000032ef   call       imp___stubs__swift_release
00000001000032f4   mov        rdi, r15
00000001000032f7   call       imp___stubs__swift_release
00000001000032fc   lea        rax, qword [ds:___unnamed_1_1000186d0]      ; "Could not find int1"
0000000100003303   mov        qword [ss:rbp+var_58], rax
0000000100003307   mov        qword [ss:rbp+var_50], 0x13
000000010000330f   mov        qword [ss:rbp+var_48], 0x0
0000000100003317   lea        rdi, qword [ss:rbp+var_58]
000000010000331b   jmp        0x10000334c

000000010000331d   mov        rdi, r15                                    ; XREF=__TFC12swift_weekly4Test8example4fS0_FT_T_+329
0000000100003320   call       imp___stubs__swift_release
0000000100003325   mov        rdi, r15
0000000100003328   call       imp___stubs__swift_release
000000010000332d   lea        rax, qword [ds:___unnamed_2_1000186b0]      ; "Found int1 in array"
0000000100003334   mov        qword [ss:rbp+var_40], rax
0000000100003338   mov        qword [ss:rbp+var_38], 0x13
0000000100003340   mov        qword [ss:rbp+var_30], 0x0
0000000100003348   lea        rdi, qword [ss:rbp+var_40]

000000010000334c   call       __TTSSS___TFSs7printlnU__FQ_T_              ; XREF=__TFC12swift_weekly4Test8example4fS0_FT_T_+427
0000000100003351   mov        rdi, r15
0000000100003354   call       imp___stubs__swift_release
0000000100003359   mov        rdi, r14
000000010000335c   call       imp___stubs__swift_release
0000000100003361   add        rsp, 0x40
0000000100003365   pop        rbx
0000000100003366   pop        r12
0000000100003368   pop        r14
000000010000336a   pop        r15
000000010000336c   pop        rbp
000000010000336d   ret
```

here are the things that I understand about this code:

1. Our code is again inlined. the whole generic type brought inline into the code. This can be good and bad.
2. The loop is happening here:

	```asm
	00000001000032a0   cmp        rax, r12                                    ; XREF=__TFC12swift_weekly4Test8example4fS0_FT_T_+341
	00000001000032a3   jge        0x10000336e

	00000001000032a9   cmp        rax, rcx
	00000001000032ac   je         0x10000336e

	00000001000032b2   cmp        qword [ds:rbx], 0xabcdefa
	00000001000032b9   je         0x10000331d

	00000001000032bb   inc        rax
	00000001000032be   add        rbx, 0x8
	00000001000032c2   cmp        r12, rax
	00000001000032c5   jne        0x1000032a0
	```
	
3. `rax` is the 64-bit register that Swift has designated to be equal to the `i` variable in our generic type's `isItemInArray()` function. So this time Swift did not keep the counter in `ebx`. The compiler's choice of the counter register seems sporadic to say the least.
4. the `rbx` generic purpose register is really working as a base address register here and it is the index into the array and is incremented by `0x08` every time. Remember every `Int` is 8 bytes long (64-bits) hence the whole `add rbx, 0x08` in the asm code.
5. The value inside the current index of the array is being compared to `0xabcdefa` (the value we are trying to find), straight in the code. That is here `cmp qword [ds:rbx], 0xabcdefa`. I can see here that even though our app is compiled for the release configuration and the optimization level is at highest, the compiler was not intelligent enough to store our array in the code segment. Instead, it has stored the array in the data segment. That happened pretty much at the head of our asm code:

	```asm
	000000010000319b  mov  qword [ds:r15+0x10], 0x2
	00000001000031a3  mov  qword [ds:r15+0x18], 0xabcdefa
	00000001000031ab  mov  qword [ds:r15+0x20], 0xabcdefb
	```
there is a chunk of the output asm code that I have no idea (as of yet) about:

```asm
000000010000321e   mov        rcx, rax
0000000100003221   sar        rcx, 0x3f
0000000100003225   shr        rcx, 0x3d
0000000100003229   add        rcx, rax
000000010000322c   sar        rcx, 0x3
0000000100003230   add        rcx, rcx
0000000100003233   mov        qword [ds:rbx+0x10], 0x2
000000010000323b   mov        qword [ds:rbx+0x18], rcx
000000010000323f   mov        rax, qword [ds:r15+0x18]
0000000100003243   mov        qword [ds:rbx+0x20], rax
0000000100003247   mov        rax, qword [ds:r15+0x20]
000000010000324b   mov        qword [ds:rbx+0x28], rax
000000010000324f   mov        qword [ss:rbp+var_28], r15
0000000100003253   lea        rdi, qword [ss:rbp+var_28]
0000000100003257   call       imp___stubs__swift_fixLifetime
000000010000325c   mov        rdi, qword [ss:rbp+var_28]
0000000100003260   call       imp___stubs__swift_release
0000000100003265   test       rbx, rbx
0000000100003268   je         0x1000032c9
```

I can see a lot of logical and arithmatic shift operations to the left and right all, and I see a `sar` instruction shifting the `rcx` register to the right 3 bits. Shiting a register to the right 3 bits is the fastest way for a compiler to divide a value by 8. If you shift right by 1 bit, you divide by 2, shift twice you divide by 4 and 3 bits divides by 8. If you know what this code is doing, please send a pull request so that everybody else will get to learn.



Conclusion
===
1. For very simple `add` generic functions for the `IntegerType` protocol, the compiler does the addition of the integers at compile-time and puts the results directly into the code segment. No `add` function will be written in the code as such.
2. If you place a generic function inside a loop of `N` times, the compiler will generate the code for the generic function `N` times. This can be good and bad.
3. It seems like Swift generally perfers to keep the integer counter inside a loop in the `ebx` register. If you have a loop that goes from `0` to `1000`, that number range that moves from `0` to `1000` is usually kept inside the `ebx` register.
4. For more complext generic functions inside loops, the code __is__ brought inline like less complex generic functions however the conditional `jmp` instructions that are placed around the inlined function allow it to be inlined only once.
5. Generic types, depending on their complexity, can also be brought inline. Swift, more often than not, brings generic code inline.
6. For small or large constant arrays constructed inline, array values are inserted into the data segment in the opening lines of your function. This makes the code execute slower (than if the items were in the code segment) and accessed through general purpose registers, depending on how many items your array has.

References
===
1. [System V Calling Convention](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI)
2. [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 3A, 3B, and 3C](http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf)
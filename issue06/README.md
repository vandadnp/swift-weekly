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

```swift
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


Conclusion
===
1. For very simple `add` generic functions for the `IntegerType` protocol, the compiler does the addition of the integers at compile-time and puts the results directly into the code segment. No `add` function will be written in the code as such.

References
===
1. [System V Calling Convention](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI)
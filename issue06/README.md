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
0x0000000100002760 55                              push       rbp
0x0000000100002761 4889E5                          mov        rbp, rsp
0x0000000100002764 4157                            push       r15
0x0000000100002766 4156                            push       r14
0x0000000100002768 4154                            push       r12
0x000000010000276a 53                              push       rbx
0x000000010000276b 4889FB                          mov        rbx, rdi
0x000000010000276e 4885DB                          test       rbx, rbx
0x0000000100002771 488B03                          mov        rax, qword [ds:rbx]
0x0000000100002774 742A                            je         0x1000027a0

0x0000000100002776 4C8D3D833A0100                  lea        r15, qword [ds:objc_class__TtC12swift_weekly4Test] ; objc_class__TtC12swift_weekly4Test
0x000000010000277d 4C39F8                          cmp        rax, r15
0x0000000100002780 0F8401010000                    je         0x100002887

0x0000000100002786 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x000000010000278a 4889DF                          mov        rdi, rbx
0x000000010000278d E828090100                      call       imp___stubs__swift_retain
0x0000000100002792 4989C6                          mov        r14, rax
0x0000000100002795 4889DF                          mov        rdi, rbx
0x0000000100002798 41FFD4                          call       r12
0x000000010000279b E9F4000000                      jmp        0x100002894

0x00000001000027a0 4C8B7848                        mov        r15, qword [ds:rax+0x48] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+20
0x00000001000027a4 4889DF                          mov        rdi, rbx

0x0000000100002887 BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+32
0x000000010000288c E88D070100                      call       imp___stubs__arc4random_uniform
0x0000000100002891 4989DE                          mov        r14, rbx

0x0000000100002894 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+59
0x0000000100002897 4C39F8                          cmp        rax, r15
0x000000010000289a 7417                            je         0x1000028b3

0x000000010000289c 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x00000001000028a0 4C89F7                          mov        rdi, r14
0x00000001000028a3 E812080100                      call       imp___stubs__swift_retain
0x00000001000028a8 4989C6                          mov        r14, rax
0x00000001000028ab 4889DF                          mov        rdi, rbx
0x00000001000028ae 41FFD4                          call       r12
0x00000001000028b1 EB0A                            jmp        0x1000028bd

0x00000001000028b3 BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+314
0x00000001000028b8 E861070100                      call       imp___stubs__arc4random_uniform

0x00000001000028bd 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+337
0x00000001000028c0 4C39F8                          cmp        rax, r15
0x00000001000028c3 7417                            je         0x1000028dc

0x00000001000028c5 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x00000001000028c9 4C89F7                          mov        rdi, r14
0x00000001000028cc E8E9070100                      call       imp___stubs__swift_retain
0x00000001000028d1 4989C6                          mov        r14, rax
0x00000001000028d4 4889DF                          mov        rdi, rbx
0x00000001000028d7 41FFD4                          call       r12
0x00000001000028da EB0A                            jmp        0x1000028e6

0x00000001000028dc BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+355
0x00000001000028e1 E838070100                      call       imp___stubs__arc4random_uniform

0x00000001000028e6 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+378
0x00000001000028e9 4C39F8                          cmp        rax, r15
0x00000001000028ec 7417                            je         0x100002905

0x00000001000028ee 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x00000001000028f2 4C89F7                          mov        rdi, r14
0x00000001000028f5 E8C0070100                      call       imp___stubs__swift_retain
0x00000001000028fa 4989C6                          mov        r14, rax
0x00000001000028fd 4889DF                          mov        rdi, rbx
0x0000000100002900 41FFD4                          call       r12
0x0000000100002903 EB0A                            jmp        0x10000290f

0x0000000100002905 BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+396
0x000000010000290a E80F070100                      call       imp___stubs__arc4random_uniform

0x000000010000290f 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+419
0x0000000100002912 4C39F8                          cmp        rax, r15
0x0000000100002915 7417                            je         0x10000292e

0x0000000100002917 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x000000010000291b 4C89F7                          mov        rdi, r14
0x000000010000291e E897070100                      call       imp___stubs__swift_retain
0x0000000100002923 4989C6                          mov        r14, rax
0x0000000100002926 4889DF                          mov        rdi, rbx
0x0000000100002929 41FFD4                          call       r12
0x000000010000292c EB0A                            jmp        0x100002938

0x000000010000292e BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+437
0x0000000100002933 E8E6060100                      call       imp___stubs__arc4random_uniform

0x0000000100002938 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+460
0x000000010000293b 4C39F8                          cmp        rax, r15
0x000000010000293e 7417                            je         0x100002957

0x0000000100002940 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x0000000100002944 4C89F7                          mov        rdi, r14
0x0000000100002947 E86E070100                      call       imp___stubs__swift_retain
0x000000010000294c 4989C6                          mov        r14, rax
0x000000010000294f 4889DF                          mov        rdi, rbx
0x0000000100002952 41FFD4                          call       r12
0x0000000100002955 EB0A                            jmp        0x100002961

0x0000000100002957 BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+478
0x000000010000295c E8BD060100                      call       imp___stubs__arc4random_uniform

0x0000000100002961 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+501
0x0000000100002964 4C39F8                          cmp        rax, r15
0x0000000100002967 7417                            je         0x100002980

0x0000000100002969 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x000000010000296d 4C89F7                          mov        rdi, r14
0x0000000100002970 E845070100                      call       imp___stubs__swift_retain
0x0000000100002975 4989C6                          mov        r14, rax
0x0000000100002978 4889DF                          mov        rdi, rbx
0x000000010000297b 41FFD4                          call       r12
0x000000010000297e EB0A                            jmp        0x10000298a

0x0000000100002980 BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+519
0x0000000100002985 E894060100                      call       imp___stubs__arc4random_uniform

0x000000010000298a 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+542
0x000000010000298d 4C39F8                          cmp        rax, r15
0x0000000100002990 7417                            je         0x1000029a9

0x0000000100002992 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x0000000100002996 4C89F7                          mov        rdi, r14
0x0000000100002999 E81C070100                      call       imp___stubs__swift_retain
0x000000010000299e 4989C6                          mov        r14, rax
0x00000001000029a1 4889DF                          mov        rdi, rbx
0x00000001000029a4 41FFD4                          call       r12
0x00000001000029a7 EB0A                            jmp        0x1000029b3

0x00000001000029a9 BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+560
0x00000001000029ae E86B060100                      call       imp___stubs__arc4random_uniform

0x00000001000029b3 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+583
0x00000001000029b6 4C39F8                          cmp        rax, r15
0x00000001000029b9 7417                            je         0x1000029d2

0x00000001000029bb 4C8B6048                        mov        r12, qword [ds:rax+0x48]
0x00000001000029bf 4C89F7                          mov        rdi, r14
0x00000001000029c2 E8F3060100                      call       imp___stubs__swift_retain
0x00000001000029c7 4989C6                          mov        r14, rax
0x00000001000029ca 4889DF                          mov        rdi, rbx
0x00000001000029cd 41FFD4                          call       r12
0x00000001000029d0 EB0A                            jmp        0x1000029dc

0x00000001000029d2 BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+601
0x00000001000029d7 E842060100                      call       imp___stubs__arc4random_uniform

0x00000001000029dc 488B03                          mov        rax, qword [ds:rbx] ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+624
0x00000001000029df 4C39F8                          cmp        rax, r15
0x00000001000029e2 7417                            je         0x1000029fb

0x00000001000029e4 4C8B7848                        mov        r15, qword [ds:rax+0x48]
0x00000001000029e8 4C89F7                          mov        rdi, r14
0x00000001000029eb E8CA060100                      call       imp___stubs__swift_retain
0x00000001000029f0 4989C6                          mov        r14, rax
0x00000001000029f3 4889DF                          mov        rdi, rbx
0x00000001000029f6 41FFD7                          call       r15
0x00000001000029f9 EB0A                            jmp        0x100002a05

0x00000001000029fb BFFFFFFFFF                      mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform, XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+642
0x0000000100002a00 E819060100                      call       imp___stubs__arc4random_uniform

0x0000000100002a05 4C89F7                          mov        rdi, r14          ; XREF=__TFC12swift_weekly4Test8example2fS0_FT_T_+290, __TFC12swift_weekly4Test8example2fS0_FT_T_+665
0x0000000100002a08 5B                              pop        rbx
0x0000000100002a09 415C                            pop        r12
0x0000000100002a0b 415E                            pop        r14
0x0000000100002a0d 415F                            pop        r15
0x0000000100002a0f 5D                              pop        rbp
0x0000000100002a10 E99F060100                      jmp        imp___stubs__swift_release
                        ; endp
0x0000000100002a15 66662E0F1F840000000000          nop        qword [cs:rax+rax+0x0]
```

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
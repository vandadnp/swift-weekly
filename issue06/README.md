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
xor        edi, edi
call       imp___stubs__swift_unknownRelease
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
	and you can do the maths yourself if you want or [use Calc.app on your mac to find the results](http://d.pr/i/18viW/20JMe185)
	

Conclusion
===
1. 

References
===
1. [System V Calling Convention](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI)
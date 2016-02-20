__WORK IN PROGRESS__

Swift Weekly - Issue 13 - Pattern Matching in Swift
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
One of the recent problems that I had in Swift was to determine if a person's age, of type `UInt`, was inside a given range. Let's assume that the range I was looking for was 18...24, inclusive. Sure! You can write a code similar to this:

```swift
let age: UInt = 32

if age >= 18 && age <= 24{
  //do something
} else {
  //do something else
}
```

But as you can be sure, there are other, and _sometimes_ better ways of doing this in Swift. In this issue of Swift Weekly, we will have a look at various pattern matching mechanisms in Swift's standard library and we will have a look at their performance, through looking at their underlying compiled Assembly code. I will provide the x86_64 code as well and analyze it, in order to determine how pattern matching _really_ works in Swift.

__Note:__ I have set the optimization level of the code to _"s"_, which translates to _Fastest, Smallest Code_ in Xcode's build settings. I'm on the _Release_ configuration and using the default settings.

The `case` Statement
===
The `case` statement isn't just for enumerations in Swift. You can also use it for pattern matching. Here is the same code as before, but this time using `case`:

```swift
let age: UInt = 22

if case 18...24 = age{
  print("You are between 18 and 24")
} else {
  print("I have nothing to say!")
}
```
And here is the generated x86_64 assembly code for it, after removing some stack-setup code, and demangling the function calls:

```asm
sub        rsp, 0x18
mov        r15, rdi
call       imp___stubs__objc_retain
mov        edi, 0x1                                    ; argument #1 for method __TTSg5P____TFSs27_allocateUninitializedArrayurFBwTGSaq__Bp_
call       generic specialization <protocol<>> of Swift._allocateUninitializedArray <A> (Builtin.Word) -> ([A], Builtin.RawPointer)
mov        qword [ss:rbp+var_30], rax
mov        rax, qword [ds:imp___got___TMdSS]
mov        qword [ds:rdx+0x18], rax
lea        rax, qword [ds:0x1000033d0]                 ; "You are between 18 and 24"
mov        qword [ds:rdx], rax
mov        qword [ds:rdx+0x8], 0x19
mov        qword [ds:rdx+0x10], 0x0
call       imp___stubs___TIFSs5printFTGSaP__9separatorSS10terminatorSS_T_A0_
mov        r14, rax
mov        r12, rdx
mov        r13, rcx
call       imp___stubs___TIFSs5printFTGSaP__9separatorSS10terminatorSS_T_A1_
mov        rbx, rdx
mov        qword [ss:rsp], rcx
mov        rdi, qword [ss:rbp+var_30]
mov        rsi, r14
mov        rdx, r12
mov        rcx, r13
mov        r8, rax
mov        r9, rbx
call       imp___stubs___TFSs5printFTGSaP__9separatorSS10terminatorSS_T_
mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_release
add        rsp, 0x18
jmp        imp___stubs__objc_release
```



References
===
1. [The Swift Programming Language (Swift 2.1)](https://goo.gl/ubGNKN)
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

The `case` Statement
===
The `case` statement isn't just for enumerations in Swift. You can also use it for pattern matching. Here is the same code as before, but this time using `case`:

```swift
func detectAge(age: UInt){
  if case 18...24 = age{
    print("You are between 18 and 24")
  } else {
    print("I have nothing to say!")
  }
}
```
And here is the generated x86_64 assembly code for it, after removing some stack-setup code, and demangling the function calls:

```asm
swift-weekly`function signature specialization <Arg[1] = Dead> of swift_weekly.AppDelegate.detectAge (swift_weekly.AppDelegate)(Swift.UInt) -> ():
movq   %rdi, %rbx
addq   $-0x12, %rbx
movl   $0x1, %edi
callq  0x10888f660               ; function signature specialization <Arg[1] = Dead> of generic specialization <protocol<>> of static Swift.Array._allocateBufferUninitialized <A> (Swift.Array<A>.Type)(Swift.Int) -> Swift._ArrayBuffer<A> at AppDelegate.swift
movq   %rax, %r14
movq   $0x1, 0x10(%r14)
movq   0x1b6f(%rip), %rax        ; (void *)0x000000010ae71f28: direct type metadata for Swift.String
movq   %rax, 0x38(%r14)
cmpq   $0x6, %rbx
ja     0x10888f4e0               ; <+80> at AppDelegate.swift:20
leaq   0xeee(%rip), %rax         ; "You are between 18 and 24"
movq   %rax, 0x20(%r14)
movq   $0x19, 0x28(%r14)
jmp    0x10888f4f3               ; <+99> at AppDelegate.swift:18
leaq   0xeb9(%rip), %rax         ; "I have nothing to say!"
movq   %rax, 0x20(%r14)
movq   $0x16, 0x28(%r14)
movq   $0x0, 0x30(%r14)
callq  0x10888f746               ; symbol stub for: Swift.(print (Swift.Array<protocol<>>, separator : Swift.String, terminator : Swift.String) -> ()).(default argument 1)
movq   %rax, %r13
movq   %rdx, %r15
movq   %rcx, %r12
callq  0x10888f74c               ; symbol stub for: Swift.(print (Swift.Array<protocol<>>, separator : Swift.String, terminator : Swift.String) -> ()).(default argument 2)
movq   %rdx, %rbx
movq   %rcx, (%rsp)
movq   %r14, %rdi
movq   %r13, %rsi
movq   %r15, %rdx
movq   %r12, %rcx
movq   %rax, %r8
movq   %rbx, %r9
callq  0x10888f740               ; symbol stub for: Swift.print (Swift.Array<protocol<>>, separator : Swift.String, terminator : Swift.String) -> ()
retq   
```



References
===
1. [The Swift Programming Language (Swift 2.1)](https://goo.gl/ubGNKN)
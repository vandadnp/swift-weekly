Swift Weekly - Issue 02 - Digging into the Swift Runtime
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
In this edition, I wanted to write about arrays and dictionaires and take the easy route. But I thought to myself: wouldn't be cool if _somebody_ dug deep into the Swift runtime for crying out loud? Then I thought that I cannot wait for somebody to do that so I'm going to have to do that myself. So here, this edition of Swift Weekly is about the Swift runtime. At least the basics.

Please note that I am using a disassembler + dSYM file. I am disassembling the contents of the AppDelegate with some basic code in it and then hooking my disassembler up with the dSYM file to see more details.

Also in this article I am testing the output disassembly of Xcode 6.1 on the x86_64 architecture, not ARM which is available on iOS devices.

Constants in Swift
===
I wrote the following code in Swift

```swift
let a = 0xabcdefa
println(a)
let b = 0xabcdefb
println(b)
```
And then I had a look at the generated assembly:

```asm
qword [ss:rbp+var_48], 0xabcdefa
mov        qword [ss:rbp+var_50], 0xabcdefa
mov        r8, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
add        r8, 0x8
lea        r9, qword [ss:rbp+var_50]
mov        qword [ss:rbp+var_68], rdi
mov        rdi, r9
mov        qword [ss:rbp+var_70], rsi
mov        rsi, r8
mov        qword [ss:rbp+var_78], r8
mov        byte [ss:rbp+var_79], al
mov        qword [ss:rbp+var_88], rcx
call       imp___stubs___TFSs7printlnU__FQ_T_
mov        qword [ss:rbp+var_58], 0xabcdefb
mov        qword [ss:rbp+var_60], 0xabcdefb
lea        rdi, qword [ss:rbp+var_60]
mov        rsi, qword [ss:rbp+var_78]
call       imp___stubs___TFSs7printlnU__FQ_T_
mov        rdi, qword [ss:rbp+var_88] ; argument #1 for method imp___stubs__objc_release
call       imp___stubs__objc_release
```
This is quite a bit of code really for that very simple Swift code that we wrote but let's try to understand what is happening:

1.	

__WORK IN PROGRESS__
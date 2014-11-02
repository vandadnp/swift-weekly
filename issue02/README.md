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
import Foundation

struct Person{
  
  func example1(){
    let a = 0xabcdefa
    println(a)
    let b = 0xabcdefb
    println(b)
  }
  
}
```
And then I had a look at the generated assembly for the `example1()` function:

```asm
0x0000000100001b60 55                              push       rbp               ; XREF=0x1000000d0
0x0000000100001b61 4889E5                          mov        rbp, rsp
0x0000000100001b64 4883EC20                        sub        rsp, 0x20
0x0000000100001b68 488B05D1340000                  mov        rax, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
0x0000000100001b6f 480508000000                    add        rax, 0x8
0x0000000100001b75 488D4DF0                        lea        rcx, qword [ss:rbp+var_10]
0x0000000100001b79 48C745F8FADEBC0A                mov        qword [ss:rbp+var_8], 0xabcdefa
0x0000000100001b81 48C745F0FADEBC0A                mov        qword [ss:rbp+var_10], 0xabcdefa
0x0000000100001b89 4889CF                          mov        rdi, rcx
0x0000000100001b8c 4889C6                          mov        rsi, rax
0x0000000100001b8f E832170000                      call       imp___stubs___TFSs7printlnU__FQ_T_
0x0000000100001b94 488B05A5340000                  mov        rax, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
0x0000000100001b9b 480508000000                    add        rax, 0x8
0x0000000100001ba1 488D4DE0                        lea        rcx, qword [ss:rbp+var_20]
0x0000000100001ba5 48C745E8FBDEBC0A                mov        qword [ss:rbp+var_18], 0xabcdefb
0x0000000100001bad 48C745E0FBDEBC0A                mov        qword [ss:rbp+var_20], 0xabcdefb
0x0000000100001bb5 4889CF                          mov        rdi, rcx
0x0000000100001bb8 4889C6                          mov        rsi, rax
0x0000000100001bbb E806170000                      call       imp___stubs___TFSs7printlnU__FQ_T_
0x0000000100001bc0 4883C420                        add        rsp, 0x20
0x0000000100001bc4 5D                              pop        rbp
0x0000000100001bc5 C3                              ret  
```
This is quite a bit of code really for that very simple Swift code that we wrote but let's try to understand what is happening:

1.	The code is setting up the stack
2. The code is then placing the value of `0xabcdefa` into the stack segment `ss:rbp+var_8`. However, as you can see, the `mov` instruction is called twice on two offsets into the stack with names of `var_8` and `var_10` with the exact same value. And the mov operation is a `qword` instruction which is a _move quad_ operation in fact, moving 64-bits of data to a specific address. Now if I try to get the actual offsets of `var_8` and `var_10` in the disassembler, I get the following results:

	```asm
	0x0000000100001b75 488D4DF0                        lea        rcx, qword [ss:rbp+0xfffffffffffffff0]
	0x0000000100001b79 48C745F8FADEBC0A                mov        qword [ss:rbp+0xfffffffffffffff8], 0xabcdefa
	0x0000000100001b81 48C745F0FADEBC0A                mov        qword [ss:rbp+0xfffffffffffffff0], 0xabcdefa
	```

	So this tells me that `var_10` comes __before__ `var_8` in memory. So the compiler is placing the value of `0xabcdefa` into the memory address at `0xfffffffffffffff0` in the stack and then placing the same value in the stack again at 8 bytes __after__ the first one. So the reason for this is that the first `mov` instruction places the value of `0xabcdefa` into our constant and the next one places the same value into the stack, ready for the `println` call. So the compiler is intelligent enough to know that the `println` instruction is passed the value of the constant `a` but since the value of this constant is now in the stack, it is more efficient to place the same value directly into the stack for the `println` call rather than read the value of the `a` constant from the stack and place it in the stack again. So this is what we learnt.
	
3. As you can see, the rest is also self explanatory. The value of `0xabcdefb` is placed inside the `b` constant, `println` again and so on.

Now let's see what the compiler will generate if we execute this code:

```swift
func example2(){
  let a = 0xabcdefa
  println(0xabcdefa)
}
```

The reason that I want to find this information out is to find out if the compiler will be intelligent enough to somehow understand that the value we are printing is the same value in the `a` constant and use that instead... Let's see what happens:

```asm
0x0000000100001b60 55                              push       rbp
0x0000000100001b61 4889E5                          mov        rbp, rsp
0x0000000100001b64 4883EC10                        sub        rsp, 0x10
0x0000000100001b68 488B05D1340000                  mov        rax, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
0x0000000100001b6f 480508000000                    add        rax, 0x8
0x0000000100001b75 488D4DF0                        lea        rcx, qword [ss:rbp+var_10]
0x0000000100001b79 48C745F8FADEBC0A                mov        qword [ss:rbp+var_8], 0xabcdefa
0x0000000100001b81 48C745F0FADEBC0A                mov        qword [ss:rbp+var_10], 0xabcdefa
0x0000000100001b89 4889CF                          mov        rdi, rcx
0x0000000100001b8c 4889C6                          mov        rsi, rax
0x0000000100001b8f E802170000                      call       imp___stubs___TFSs7printlnU__FQ_T_
0x0000000100001b94 4883C410                        add        rsp, 0x10
0x0000000100001b98 5D                              pop        rbp
0x0000000100001b99 C3                              ret 
```

Well, it turns out that the compiler generated the same code as before without reusing the value of the `a` constant.

One more observation is that the `rdi` and the `rsi` registers are being set up before the `println` function is called. The `rdi` register is set to `rcx` which as you can see, itself is set to `wrod [ss:rbp+var_10]`. `rcx` is loading the effective address for a location in stack where the value of `0xabcdefb` is stored and then `rdi` will point to that address. This tells me that whenever Swift calls a function like `println`, two things will happen:

1.	The `rdi` register will point to the top of the stack where the parameters for the function are stored.
2. The `rsi` register will be set to _a_ value in the data-segment (I don't really understand that part of the code, `[ds:imp___got___TMdSi]`. If you know what this means, please correct this sentence and send a pull request.

Mixing Constants and Variables
===
Now let's see how the Swift compiler deals with constants and variables in how it generates the assembly code:

```swift
func example3(){
  let a = 0xabcdefa
  var b = 0xabcdefb
  let c = a + b
}
```

The assembly for this is:

```asm
0x0000000100001b60 55                              push       rbp
0x0000000100001b61 4889E5                          mov        rbp, rsp
0x0000000100001b64 48C745F0FADEBC0A                mov        qword [ss:rbp+var_10], 0xabcdefa
0x0000000100001b6c 48C745F8FBDEBC0A                mov        qword [ss:rbp+var_8], 0xabcdefb
0x0000000100001b74 48C745E8F5BD7915                mov        qword [ss:rbp+var_18], 0x1579bdf5
0x0000000100001b7c 5D                              pop        rbp
0x0000000100001b7d C3                              ret
```

The results are very clear:
1.	Both __local__ constants and variables of type `Int` are stack values.
2. When a constant and a variable of type `Int` are added, Swift does not write code for the addition, but instead, if the information is available, adds the values at compile time and puts the results into the stack directly, saving execution time.


Now let's have a look at some more data types like _Bool_, _double_ and _CGFloat__.

```swift
func example4(){
  let intConstant = 0xabcdefa
  let intVariable = 0xabcdefb
  
  let boolConstant = true
  var boolVariable = false
  
  let doubleConstant = 1.23
  let doubleVariable = 2.34
  
  let floatConstant:Float = 1.23
  let floatVariable: Float = 2.34
}
```

And let's have a look at the output assembly:

```asm
0x0000000100001ae0 55                              push       rbp
0x0000000100001ae1 4889E5                          mov        rbp, rsp
0x0000000100001ae4 F30F1005CC180000                movss      xmm0, dword [ds:0x1000033b8] ; 0x1000033b8
0x0000000100001aec F30F100DC8180000                movss      xmm1, dword [ds:0x1000033bc] ; 0x1000033bc
0x0000000100001af4 F20F1015C4180000                movsd      xmm2, qword [ds:0x1000033c0] ; 0x1000033c0
0x0000000100001afc F20F101DC4180000                movsd      xmm3, qword [ds:0x1000033c8] ; 0x1000033c8
0x0000000100001b04 48C745F0FADEBC0A                mov        qword [ss:rbp+var_10], 0xabcdefa
0x0000000100001b0c 48C745E8FBDEBC0A                mov        qword [ss:rbp+var_18], 0xabcdefb
0x0000000100001b14 C645E001                        mov        byte [ss:rbp+var_20], 0x1
0x0000000100001b18 C645F800                        mov        byte [ss:rbp+var_8], 0x0
0x0000000100001b1c F20F115DD8                      movsd      xmmword [ss:rbp+var_28], xmm3
0x0000000100001b21 F20F1155D0                      movsd      xmmword [ss:rbp+var_30], xmm2
0x0000000100001b26 F30F114DC8                      movss      xmmword [ss:rbp+var_38], xmm1
0x0000000100001b2b F30F1145C0                      movss      xmmword [ss:rbp+var_40], xmm0
0x0000000100001b30 5D                              pop        rbp
0x0000000100001b31 C3                              ret
```

What is happening here is that the Swift compiler, for the x86_64 architecture:

1. Is placing the values of the doubles and the floats into the 128-bit SSE before the function even starts. The values for the floats and the doubles are stored in the data segment, so they are loaded into the `xmm0` through to the `xmm3` SSE registers.
2. Is loading the values of `0xabcdefa` and `0xabcdefb` into the stack segment, for the `Int` values, as we saw before.
3. Is loading the values of `true` and `false` as `0x01` and `0x00` into the stack, as bytes. That makes perfect sense.
4. It is then placing the 2x double values and 2x float values from the SSE registers of `xmm3` to `xmm0` into the stack, using the `movsd` instruction for doubles and `movss` for floats. `movsd` is for moving double precision floating point values and `movss` is for single precision so in fact Swift is differentiating between double and float. By defaut, we are encouraged to use doubles in Swift by the way instead of floats. However, reading the actual address of the `var_28`, `var_30`, 38 and 40 we can see the following:

	```asm
	0x0000000100001b1c F20F115DD8                      movsd      xmmword [ss:rbp+0xffffffffffffffd8], xmm3
	0x0000000100001b21 F20F1155D0                      movsd      xmmword [ss:rbp+0xffffffffffffffd0], xmm2
	0x0000000100001b26 F30F114DC8                      movss      xmmword [ss:rbp+0xffffffffffffffc8], xmm1
	0x0000000100001b2b F30F1145C0                      movss      xmmword [ss:rbp+0xffffffffffffffc0], xmm0
	```
	
	This tells me that each one of the floating points and doubles is 8 bytes long. So single precision and double precision values are both stored in an 8-byte long data-segment space. So that's good to know. If you use floating values instead of double, you are __not__ making your binary smaller, so you might as well use double!
	
Now let's look an example for strings:

```swift
func example5(){
  let stringConstant = "Vandad"
  var stringVariable = "Sara"
  let concatenatedConstant = stringConstant + stringVariable
  var concatenatedVariable = stringConstant + stringVariable
}
```



__WORK IN PROGRESS__
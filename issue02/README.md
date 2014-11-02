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
func example1(){
  let a = 0xabcdefa
  println(a)
  let b = 0xabcdefb
  println(b)
}
```
And then I had a look at the generated assembly for the `example1()` function:

```asm
push       rbp               ; XREF=0x1000000d0
mov        rbp, rsp
sub        rsp, 0x20
mov        rax, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
add        rax, 0x8
lea        rcx, qword [ss:rbp+var_10]
mov        qword [ss:rbp+var_8], 0xabcdefa
mov        qword [ss:rbp+var_10], 0xabcdefa
mov        rdi, rcx
mov        rsi, rax
call       imp___stubs___TFSs7printlnU__FQ_T_
mov        rax, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
add        rax, 0x8
lea        rcx, qword [ss:rbp+var_20]
mov        qword [ss:rbp+var_18], 0xabcdefb
mov        qword [ss:rbp+var_20], 0xabcdefb
mov        rdi, rcx
mov        rsi, rax
call       imp___stubs___TFSs7printlnU__FQ_T_
add        rsp, 0x20
pop        rbp
ret  
```
This is quite a bit of code really for that very simple Swift code that we wrote but let's try to understand what is happening:

1.	The code is setting up the stack
2. The code is then placing the value of `0xabcdefa` into the stack segment `ss:rbp+var_8`. However, as you can see, the `mov` instruction is called twice on two offsets into the stack with names of `var_8` and `var_10` with the exact same value. And the mov operation is a `qword` instruction which is a _move quad_ operation in fact, moving 64-bits of data to a specific address. Now if I try to get the actual offsets of `var_8` and `var_10` in the disassembler, I get the following results:

	```asm
	lea        rcx, qword [ss:rbp+0xfffffffffffffff0]
	mov        qword [ss:rbp+0xfffffffffffffff8], 0xabcdefa
	mov        qword [ss:rbp+0xfffffffffffffff0], 0xabcdefa
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
push       rbp
mov        rbp, rsp
sub        rsp, 0x10
mov        rax, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
add        rax, 0x8
lea        rcx, qword [ss:rbp+var_10]
mov        qword [ss:rbp+var_8], 0xabcdefa
mov        qword [ss:rbp+var_10], 0xabcdefa
mov        rdi, rcx
mov        rsi, rax
call       imp___stubs___TFSs7printlnU__FQ_T_
add        rsp, 0x10
pop        rbp
ret 
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
push       rbp
mov        rbp, rsp
mov        qword [ss:rbp+var_10], 0xabcdefa
mov        qword [ss:rbp+var_8], 0xabcdefb
mov        qword [ss:rbp+var_18], 0x1579bdf5
pop        rbp
ret
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
push       rbp
mov        rbp, rsp
movss      xmm0, dword [ds:0x1000033b8] ; 0x1000033b8
movss      xmm1, dword [ds:0x1000033bc] ; 0x1000033bc
movsd      xmm2, qword [ds:0x1000033c0] ; 0x1000033c0
movsd      xmm3, qword [ds:0x1000033c8] ; 0x1000033c8
mov        qword [ss:rbp+var_10], 0xabcdefa
mov        qword [ss:rbp+var_18], 0xabcdefb
mov        byte [ss:rbp+var_20], 0x1
mov        byte [ss:rbp+var_8], 0x0
movsd      xmmword [ss:rbp+var_28], xmm3
movsd      xmmword [ss:rbp+var_30], xmm2
movss      xmmword [ss:rbp+var_38], xmm1
movss      xmmword [ss:rbp+var_40], xmm0
pop        rbp
ret
```

What is happening here is that the Swift compiler, for the x86_64 architecture:

1. Is placing the values of the doubles and the floats into the 128-bit SSE before the function even starts. The values for the floats and the doubles are stored in the data segment, so they are loaded into the `xmm0` through to the `xmm3` SSE registers.
2. Is loading the values of `0xabcdefa` and `0xabcdefb` into the stack segment, for the `Int` values, as we saw before.
3. Is loading the values of `true` and `false` as `0x01` and `0x00` into the stack, as bytes. That makes perfect sense.
4. It is then placing the 2x double values and 2x float values from the SSE registers of `xmm3` to `xmm0` into the stack, using the `movsd` instruction for doubles and `movss` for floats. `movsd` is for moving double precision floating point values and `movss` is for single precision so in fact Swift is differentiating between double and float. By defaut, we are encouraged to use doubles in Swift by the way instead of floats. However, reading the actual address of the `var_28`, `var_30`, 38 and 40 we can see the following:

	```asm
	movsd      xmmword [ss:rbp+0xffffffffffffffd8], xmm3
	movsd      xmmword [ss:rbp+0xffffffffffffffd0], xmm2
	movss      xmmword [ss:rbp+0xffffffffffffffc8], xmm1
	movss      xmmword [ss:rbp+0xffffffffffffffc0], xmm0
	```
	
	This tells me that each one of the floating points and doubles is 8 bytes long. So single precision and double precision values are both stored in an 8-byte long data-segment space. So that's good to know. If you use floating values instead of double, you are __not__ making your binary smaller, so you might as well use double!
	
Structures
===
Let's say that we have a structure like so:

```swift
struct Person{
  var age: Int
}
```

And then we want to allocate an instance of it like so:

```swift
func example5(){
  let person = Person(age: 30)
}
```

The output assembly for the `example5()` function will be like so:

```asm
push       rbp               ; XREF=-[_TtC12swift_weekly11AppDelegate example5]+29
mov        rbp, rsp
sub        rsp, 0x20
mov        rax, 0x1e
mov        qword [ss:rbp+var_8], rdi
mov        qword [ss:rbp+var_10], rdi
mov        qword [ss:rbp+var_20], rdi
mov        rdi, rax          ; argument #1 for method __TFV12swift_weekly6PersonCfMS0_FT3ageSi_S0_
call       __TFV12swift_weekly6PersonCfMS0_FT3ageSi_S0_
mov        qword [ss:rbp+var_18], rax
mov        rdi, qword [ss:rbp+var_20] ; argument #1 for method imp___stubs__objc_release
call       imp___stubs__objc_release
add        rsp, 0x20
pop        rbp
```

So what happens here is that the stack is first set up and the value of 30 (the person's age) is placed inside the `rax` register and then `rax` is placed inside the `rdi` register before the `__TFV12swift_weekly6PersonCfMS0_FT3ageSi_S0_` function is called. What this really means is that we are following the System V calling convention when Swift compiles for x86_64 architecture. You can read more about the System V calling convention online but the gist is that the parameters to a method are placed inside `rdi`, then `rsi` and then `rdx` and `rcx` registers. In this case, the age of the person to be created (30) is being placed inside the `rdi` register. I can see that Swift in this case first put the value of 30 inside the `rax` and then moves the `rax` into `rdi`. Obviously this is very redundant but probably it's because the debug code is not optimized (optimization level = none, O).

Then the important thing is the call to the `__TFV12swift_weekly6PersonCfMS0_FT3ageSi_S0_` system function. This is where the actual creation of the `Person` instance is done. Let's have a look at it:

```asm
push       rbp               ; XREF=0x1000000d0, __TFC12swift_weekly11AppDelegate8example5fS0_FT_T_+33
mov        rbp, rsp
mov        qword [ss:rbp+var_8], rdi
mov        rax, rdi
pop        rbp
ret 
```

Holy cow that was nothing like what you expected, right? You can see that the value of the `rdi` register is placed inside the stack at the address of `ss:rbp+var_8` and in my assembler `var_8` is defined to have the displacement of -8, so read that code as `ss:rbp-8`. So what is happening here is that the code is going into the stack and placing the age inside it. Well this tells us something. That the `Person` instance aws actually created in the stack of the `example5()` function. So this is very interesting. The caller creates the instance. This is very important to remember about Swift. No system call was made in this case to create an instance of the `Person` structure, nothing like an `alloc` or `init` method in Objective-C.

Then once the value is placed into the stack, the `ret` instruction is called to return the instruction pointer to the caller, aka, `example5()`. So let's extend this example and have a look at an example where we set a few properties for the `Person` class. Let's change the `Person` class a bit:

```swift
struct Person{
  var age: Int = 0
  var sex: Int = 0
  var numberOfChildren: Int = 0
  
  mutating func setAge(paramAge: Int){
    age = paramAge
  }
  
  mutating func setSex(paramSex: Int){
    sex = paramSex
  }
  
  mutating func setNumberOfChildren(paramNumberOfChildren: Int){
    numberOfChildren = paramNumberOfChildren
  }
  
}
```

And then create an instance:

```swift
func example6(){
  var person = Person()
  person.age = 0xabcdefa
  person.sex = 0xabcdefb
  person.numberOfChildren = 0xabcdefc
}
```

And the assembly for `example6()` is like so:

```asm
push       rbp               ; XREF=-[_TtC12swift_weekly11AppDelegate example6]+29
mov        rbp, rsp
sub        rsp, 0x30
mov        qword [ss:rbp+var_20], rdi
mov        qword [ss:rbp+var_28], rdi
mov        qword [ss:rbp+var_30], rdi
call       __TFV12swift_weekly6PersonCfMS0_FT_S0_
mov        qword [ss:rbp+var_18], rax
mov        qword [ss:rbp+var_10], rdx
mov        qword [ss:rbp+var_8], rcx
mov        qword [ss:rbp+var_18], 0xabcdefa
mov        qword [ss:rbp+var_10], 0xabcdefb
mov        qword [ss:rbp+var_8], 0xabcdefc
mov        rdi, qword [ss:rbp+var_30] ; argument #1 for method imp___stubs__objc_release
call       imp___stubs__objc_release
add        rsp, 0x30
pop        rbp
ret
```

Well what you can see here is that: (based on a few speculations, submit pull-request if you can tell better please):

1. Again the stack is set up
2. The three quad-word `mov` instructions after the first `sub` instruction are actually setting up the Person structure in the stack. So here again, the Swift runtime is __not__ allocating an instance of Person as such, it is just freeing up memory in the stack for the 3 variables that this structure contains. Later in the code you can see that the mov quad-word instructions are being called to place the values of `0xabcdefa` and so on into the stack, or the instance of the `Person` structure.

Conclusion
===
1.	Local variables are stored in the stack for structure types. No allocation or initialization is done such as those in `alloc` or `init` methods of the Objective-C class of `NSObject`.
2. The calling convention that Swift follows for x86_64 architecture is System V.
3. Double and Float values are stored into the memory using the `movsd` and `movss` instructions respectively, creating a real difference between how they are stored. Both these types take 8 bytes on a 64-bit iOS.
4. The `Bool` type is truely a `byte`, not a 32-bit or 64-bit natural data-type on a 64-bit operating system. I know that on x86_32 at least, doing `byte` operations are naturally slower than doing `dword` operations so keep a look out for that. If you are really concerned about optimization, use Int instead of Bool!
5. On 0-optimization, the compiler is intelligent enough to not move values from stack to stack, but rather reserver values into the registers directly, even if the value is the result of the addition or subtraction of 2 constants on the stack. The addition or the subtraction is done at compile-time!

Where to go from Here
===
Obviously when I started writing this article, I knew I was opening a can of worms and that's the way daddy likes it so if you want to continue somewhere from here, just wait one week for the next issue of Swift Weekly where I will explore the Swift runtime even more.
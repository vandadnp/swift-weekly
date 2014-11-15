WORK IN PROGRESS



Swift Weekly - Issue 04 - The Swift Runtime (Part 3) - Operators
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
I have always been interested in finding out how different compilers work with basic operators such as +, -, % and so on. This week on the train I was thinking that it would be nice if somebody could explore how Swift deals with operators so, long story short, I decided to do it myself.

In this edition of Swift Weekly, I will show you how the Swift compiler works deals with (system and your own) operators and how to use operators to ensure you get the maximum performance.

__Note__: in this edition of Swift Weekly, I'm going to change things a little bit and instead of building for the debug configuration, I am going to build for Release to ensure that the assembly code that we are going to analyze is as optimized as what you will get when you release the app for the App Store. Optimization is hence enabled and the assembly output is long. That means setting the `Optimization Level` in your build settings to `Fastest, Smallest [-Os]` to ensure you get the `export GCC_OPTIMIZATION_LEVEL=s` export when you build your project.

The `+` Operator on Constant `Int` Values
===
The `+` operator is usually used for integers so let's have a look at a basic usage:

```swift
func example1(){
  
  let int1 = 0xabcdefa
  let int2 = 0xabcdefb
  let int3 = int1 + int2
  println(int3)
  
  let int4 = 0xabcdefa + 0xabcdefb
  println(int4)
  
}
```

Note that the reason I've done the same operation twice is to see if the compiler is intelligent enough to compile the first sequence into the same code as the second sequence. Both are doing the same thing after all! And here is our output (long output, due to optimization level being set to `Fastest, Smallest [-Os]`):

```asm
push       rbp
mov        rbp, rsp
push       rbx
sub        rsp, 0x18
mov        rbx, rdi
mov        qword [ss:rbp+var_10], 0x1579bdf5
lea        rdi, qword [ss:rbp+var_10]
call       __TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_
xor        edi, edi
call       imp___stubs__swift_unknownRetain
xor        edi, edi
call       imp___stubs__swift_unknownRetain
xor        edi, edi
call       imp___stubs__swift_unknownRetain
xor        edi, edi
call       imp___stubs__swift_unknownRelease
xor        edi, edi
call       imp___stubs__swift_unknownRetain
xor        edi, edi
call       imp___stubs__swift_unknownRelease
xor        edi, edi
call       imp___stubs__swift_unknownRelease
xor        edi, edi
call       imp___stubs__swift_unknownRelease
mov        edi, 0xa          ; argument #1 for method imp___stubs__putchar
call       imp___stubs__putchar
xor        edi, edi
call       imp___stubs__swift_unknownRelease
mov        qword [ss:rbp+var_18], 0x1579bdf5
lea        rdi, qword [ss:rbp+var_18]
call       __TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_
xor        edi, edi
call       imp___stubs__swift_unknownRetain
xor        edi, edi
call       imp___stubs__swift_unknownRetain
xor        edi, edi
call       imp___stubs__swift_unknownRetain
xor        edi, edi
call       imp___stubs__swift_unknownRelease
xor        edi, edi
call       imp___stubs__swift_unknownRetain
xor        edi, edi
call       imp___stubs__swift_unknownRelease
xor        edi, edi
call       imp___stubs__swift_unknownRelease
xor        edi, edi
call       imp___stubs__swift_unknownRelease
mov        edi, 0xa          ; argument #1 for method imp___stubs__putchar
call       imp___stubs__putchar
xor        edi, edi
call       imp___stubs__swift_unknownRelease
mov        rdi, rbx
add        rsp, 0x18
pop        rbx
pop        rbp
jmp        imp___stubs__swift_release
```

So what is happening in this monster of a code? I'll explain:

1. The stack is being set up
2. The values of `0xabcdefa` and `0xabcdefb` __are added at compile time__ and placed inside the stack. The result is the value of `0x1579bdf5` as you can see here:

	```asm
	mov        qword [ss:rbp+var_10], 0x1579bdf5
	```
	
3. Then the `rdi` register is being set to the address in the stack that points to the calculated value (`lea` means load effective address, pretty much setting up `rdi` as a pointer to the value in the stack):

	```asm
	lea        rdi, qword [ss:rbp+var_10]
	```

4. After that, the call is made to a function whose name is ginormous (`__TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_`). I'm going to break this name down into smaller pieces to see if I can understand it, ignoring anything that I don't understand. `Std` + `out` + `S`. That tells me it outputs a stream to the standard output. Then `OutputStreamType` followed by `printU` telling me that this is a function that prepares the output for the `println()` function based on the value that it is given. So to cut the story short, this long function name is a function that takes __any__ value in, and then outputs it as a stream to be digested by the `println()` function.
5. As we have seen in the previous editions of Swift Weekly, Swift uses the [System V calling convention](http://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI) for calling functions which states that:

	> ...additional arguments are passed on the stack and __the return value is stored in RAX__.

	So when we the function is called, its return value is stored in the `rax` register.

I just remembered that this edition is only about how Swift deals with operators so I am going to ignore the rest of the details. For now, bear in mind that for constant integers whose addition can be calculated at compile-time, Swift does this elegently as you would expect.

So that was the first piece of code that added two constant `Int` values together. Then later we added two constant values inline, without using the `let` syntax. The output of that code was, as you saw, the same:

```asm
mov        qword [ss:rbp+var_18], 0x1579bdf5
lea        rdi, qword [ss:rbp+var_18]
```

So Swift compiles this code:

```swift
let int1 = 0xabcdefa
let int2 = 0xabcdefb
let int3 = int1 + int2
println(int3)
```

and this code:

```swift
let int4 = 0xabcdefa + 0xabcdefb
println(int4)
```

in the exact same way. Lesson? Don't be afraid to use additional constant integers if it makes your code more readable.


Conclusion
===
1.	If you use the `let` syntax to create two compile-time constants and add them together using the `+` operator, the result is calculated at __compile time__ and no stack variable is used. The addition is performed at compile-time and the result is placed right into the code segment, not the data-segment.
2. 

Where to go from Here
===


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

in the exact same way. Lesson? __Don't be afraid to use additional constant integers if it makes your code more readable__.

The `+` Operator on Variable `Int` Values
===
Let's see how the Swift compiler deals with `Int` variables and the `+` operator though:

```swift
func example2(){
  
  var int1 = 0xabcdefa
  var int2 = 0xabcdefb
  var int3 = int1 + int2
  println(int3)
  
  var int4 = 0xabcdefa + 0xabcdefb
  println(int4)

}
```

the output assembly code will look like this:

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

Look closely at this line of code:

```asm
mov        qword [ss:rbp+var_10], 0x1579bdf5
lea        rdi, qword [ss:rbp+var_10]
call       __TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_
```

Yes, you guessed it. The variables didn't make any difference. Swift realized that even though we had variables, the values that we assigned to them were constants and the `+` operator also added two constant values assigned to variables, and assigned the result back to a variable instead of a constant. Sooooo, cutting the long story short (probably all that what I said in the previous sentence was so difficult to get anyways), in this case, creating variables and constants is __exactly__ the same. No stack variable was created. No constant was created in the stack. All that happened was that the addition was performed at __compile time__ and the results were placed in the stack. So again, don't be afraid to use variables if you have to. They are very well optimized.

The above example has one simple flaw: even though we are using `var` to create variables, the values we are using are constants, and the compiler knows that. But what if we change this example to this?

```swift
func randomInt() -> Int{
  return Int(arc4random_uniform(UInt32.max))
}

func example3(){
  
  var int1 = randomInt()
  var int2 = randomInt()
  var int3 = int1 + int2
  
}
```

now what is happening here is obviously that our `var` variables are definitely __not__ set to compile-time constants. We are going to check out how the compiler deals with additions on real variables:

```asm
0x0000000100002a70 55                      push       rbp
0x0000000100002a71 4889E5                  mov        rbp, rsp
0x0000000100002a74 4157                    push       r15
0x0000000100002a76 4156                    push       r14
0x0000000100002a78 4154                    push       r12
0x0000000100002a7a 53                      push       rbx
0x0000000100002a7b 4989FF                  mov        r15, rdi
0x0000000100002a7e 498B07                  mov        rax, qword [ds:r15]
0x0000000100002a81 4C8D2528370100          lea        r12, qword [ds:objc_class__TtC12swift_weekly7Example] ; objc_class__TtC12swift_weekly7Example
0x0000000100002a88 4C39E0                  cmp        rax, r12
0x0000000100002a8b 7514                    jne        0x100002aa1

0x0000000100002a8d 4D85FF                  test       r15, r15
0x0000000100002a90 740F                    je         0x100002aa1

0x0000000100002a92 BFFFFFFFFF              mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform
0x0000000100002a97 E862060100              call       imp___stubs__arc4random_uniform
0x0000000100002a9c 4189C6                  mov        r14d, eax
0x0000000100002a9f EB14                    jmp        0x100002ab5

0x0000000100002aa1 488B5858                mov        rbx, qword [ds:rax+0x58] ; XREF=__TFC12swift_weekly7Example8example3fS0_FT_T_+27, __TFC12swift_weekly7Example8example3fS0_FT_T_+32
0x0000000100002aa5 4C89FF                  mov        rdi, r15
0x0000000100002aa8 E8ED060100              call       imp___stubs__swift_retain
0x0000000100002aad 4C89FF                  mov        rdi, r15
0x0000000100002ab0 FFD3                    call       rbx
0x0000000100002ab2 4989C6                  mov        r14, rax

0x0000000100002ab5 498B07                  mov        rax, qword [ds:r15] ; XREF=__TFC12swift_weekly7Example8example3fS0_FT_T_+47
0x0000000100002ab8 31DB                    xor        ebx, ebx
0x0000000100002aba 4C39E0                  cmp        rax, r12
0x0000000100002abd 490F44DF                cmove      rbx, r15
0x0000000100002ac1 4885DB                  test       rbx, rbx
0x0000000100002ac4 7417                    je         0x100002add

0x0000000100002ac6 BFFFFFFFFF              mov        edi, 0xffffffff   ; argument #1 for method imp___stubs__arc4random_uniform
0x0000000100002acb E82E060100              call       imp___stubs__arc4random_uniform
0x0000000100002ad0 4189C7                  mov        r15d, eax
0x0000000100002ad3 4889DF                  mov        rdi, rbx
0x0000000100002ad6 E8B9060100              call       imp___stubs__swift_release
0x0000000100002adb EB09                    jmp        0x100002ae6

0x0000000100002add 4C89FF                  mov        rdi, r15          ; XREF=__TFC12swift_weekly7Example8example3fS0_FT_T_+84
0x0000000100002ae0 FF5058                  call       qword [ds:rax+0x58]
0x0000000100002ae3 4989C7                  mov        r15, rax

0x0000000100002ae6 4D01FE                  add        r14, r15          ; XREF=__TFC12swift_weekly7Example8example3fS0_FT_T_+107
0x0000000100002ae9 7009                    jo         0x100002af4

0x0000000100002aeb 5B                      pop        rbx
0x0000000100002aec 415C                    pop        r12
0x0000000100002aee 415E                    pop        r14
0x0000000100002af0 415F                    pop        r15
0x0000000100002af2 5D                      pop        rbp
0x0000000100002af3 C3                      ret        

0x0000000100002af4 0F0B                    ud2                          ; XREF=__TFC12swift_weekly7Example8example3fS0_FT_T_+121
0x0000000100002af6 662E0F1F840000000000    nop        qword [cs:rax+rax+0x0]
                                           __TFC12swift_weekly7Exampled:
0x0000000100002b00 55                      push       rbp
0x0000000100002b01 4889E5                  mov        rbp, rsp
0x0000000100002b04 4889F8                  mov        rax, rdi
0x0000000100002b07 5D                      pop        rbp
0x0000000100002b08 C3                      ret
```

Conclusion
===
1.	If you use the `let` syntax to create two compile-time `Int` constants and add them together using the `+` operator, the result is calculated at __compile time__ and no stack variable is used. The addition is performed at compile-time and the result is placed right into the code segment, not the data-segment. No addition `add` instructions are created in the assembly output.
2. Adding two constant inline `Int` values in one line of code and assigning the result to a constant `Int` value with the `let` statement will also create the results as a __compile time__ constant placed inside the code segment.
3. If two `var` of type `Int` point to a compile-time `Int` constant and are added into another variable of type `Int` using the `+` operator, no variable is created for the compiled code. The addition between the constants are calculated at compile time and placed right inside the code segment.

Where to go from Here
===


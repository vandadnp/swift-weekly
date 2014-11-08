Swift Weekly - Issue 03 - The Swift Runtime (Part 2) - Enumerations
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
This is the second article in the Swift Runtime series of the Swift Weekly. In this article, we will dig deeper into the Swift Runtime and how the compiler deals with producing code for enumerations. Saturday morning writings are always fun! Let's get this show started.

`Int` Enumerations in Swift
===
Here is a simple enumeration that I've written:

```swift
enum CarType: Int{
  case CarTypeSaloon = 0xabcdefa
  case CarTypeHatchback
}
```
The value of the Saloon car-type is `0xabcdefa` and the next item which is the hatchback is naturally equal to the previous item + 1 in the case of integer enum items. So let's then start using it in the code:

```swift
func example1(){
  
  let saloon = CarType.CarTypeSaloon
  println(saloon.rawValue)
  
  let hatchback = CarType.CarTypeHatchback
  println(hatchback.rawValue)
  
}
```

I'm now going to show you the code that the compiler produces and then we are going to have a look at an explanation of how the code was produced:

```asm
push       rbp
mov        rbp, rsp
sub        rsp, 0x20
mov        edi, 0x0          ; argument #1 for method __TFO12swift_weekly7CarTypeg8rawValueSi
mov        byte [ss:rbp+var_8], 0x0
call       __TFO12swift_weekly7CarTypeg8rawValueSi
mov        rcx, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
add        rcx, 0x8
lea        rdx, qword [ss:rbp+var_10]
mov        qword [ss:rbp+var_10], rax
mov        rdi, rdx
mov        rsi, rcx
call       imp___stubs___TFSs7printlnU__FQ_T_
mov        edi, 0x1          ; argument #1 for method __TFO12swift_weekly7CarTypeg8rawValueSi
mov        byte [ss:rbp+var_18], 0x1
call       __TFO12swift_weekly7CarTypeg8rawValueSi
mov        rcx, qword [ds:imp___got___TMdSi] ; imp___got___TMdSi
add        rcx, 0x8
lea        rdx, qword [ss:rbp+var_20]
mov        qword [ss:rbp+var_20], rax
mov        rdi, rdx
mov        rsi, rcx
call       imp___stubs___TFSs7printlnU__FQ_T_
add        rsp, 0x20
pop        rbp
ret
```

Holy Jesus that's a lot of code. But it's really simple to understand. This is what's happening:

1.	The stack is being set up
2. Then we are seeing this code `mov        edi, 0x0` and right after that, we see a call to this function `__TFO12swift_weekly7CarTypeg8rawValueSi`. What the hell just happened? Before I explain that, have a look a few lines down and you will see that we are doing the same `mov byte` insruction but with the value of `0x01` as opposed to `0x00` and then calling the same function `__TFO12swift_weekly7CarTypeg8rawValueSi`, all the while bearing in mind that in the first go, we are putting the first item of our `CarType` enumeration into a value (first item, `0x00`, get it?) and in the second time around, we get the value of the second item (second item, `0x01`, get it again? okay!). So let's have a look at the implementation of the `__TFO12swift_weekly7CarTypeg8rawValueSi` function:

	```asm
	0x0000000100002dc0 55                    push       rbp
	0x0000000100002dc1 4889E5                mov        rbp, rsp
	0x0000000100002dc4 4088F8                mov        al, dil
	0x0000000100002dc7 88C1                  mov        cl, al
	0x0000000100002dc9 80E101                and        cl, 0x1
	0x0000000100002dcc 884DF8                mov        byte [ss:rbp+var_8], cl
	0x0000000100002dcf 84C9                  test       cl, cl
	0x0000000100002dd1 8845F7                mov        byte [ss:rbp+var_9], al
	0x0000000100002dd4 751D                  jne        0x100002df3

	0x0000000100002dd6 EB00                  jmp        0x100002dd8

	0x0000000100002dd8 8A45F7                mov        al, byte [ss:rbp+var_9] ; XREF=__TFO12swift_weekly7CarTypeg8rawValueSi+22
	0x0000000100002ddb A801                  test       al, 0x1
	0x0000000100002ddd 7402                  je         0x100002de1

	0x0000000100002ddf EB00                  jmp        0x100002de1

	0x0000000100002de1 EB00                  jmp        0x100002de3       ; XREF=__TFO12swift_weekly7CarTypeg8rawValueSi+29, __TFO12swift_weekly7CarTypeg8rawValueSi+31

	0x0000000100002de3 48B8FADEBC0A00000000  mov        rax, 0xabcdefa    ; XREF=__TFO12swift_weekly7CarTypeg8rawValueSi+33
	0x0000000100002ded 488945E8              mov        qword [ss:rbp+var_18], rax
	0x0000000100002df1 EB12                  jmp        0x100002e05

	0x0000000100002df3 EB00                  jmp        0x100002df5       ; XREF=__TFO12swift_weekly7CarTypeg8rawValueSi+20

	0x0000000100002df5 48B8FBDEBC0A00000000  mov        rax, 0xabcdefb    ; XREF=__TFO12swift_weekly7CarTypeg8rawValueSi+51
	0x0000000100002dff 488945E8              mov        qword [ss:rbp+var_18], rax
	0x0000000100002e03 EB00                  jmp        0x100002e05

	0x0000000100002e05 488B45E8              mov        rax, qword [ss:rbp+var_18] ; XREF=__TFO12swift_weekly7CarTypeg8rawValueSi+49, __TFO12swift_weekly7CarTypeg8rawValueSi+67
	0x0000000100002e09 5D                    pop        rbp
	0x0000000100002e0a C3                    ret
	```
	
	Now to fully understand this code, I have left the addresses for the code instructions on the left hand side margin as there are a lot of conditional and unconditional jumps `jmp` instructions in this code. Without 	the addresses, we won't be able to fully understand what is happening. In this code, pay particular attention to the `mov        rax, 0xabcdefa` and then the `mov        rax, 0xabcdefb` instructions. Wait a minute! 	These are our Saloon and Hatchback car types that we had created an enumeration from previously. Their values are right here in this method.
	
	When we came into this function, the `edi` register is the __index__ of the item in our `CarType` enumeration whose value we want to get. Knowing that, let's have a look at the code. When this function is executed, 	we move `dil` into the `al` 8 bit register. `dil` is the lower 8 bits of the `edi` register. Remember? So we read that, then check if it is 0, and then if not, we first jump to `0x100002df3` into the code segment 	which is another jump instruction which itself jumps to `0x100002df5`. That itself arrives to the `mov        rax, 0xabcdefb` instruction which puts the value of `CarTypeHatchback` into the `rax` register. So this 	function really is translating our `CarType` enumeration into raw values, as we kind of guessed. After the raw value of the enumeration is retrieved, the value is placed inside the `rax` register and passed back to 	the original caller.

3.	After we get the raw value of the enumeration, we call the `println` function and so on... the rest is really easy.

`


Conclusions
===
1.	For every `Int` enumeration, Swift compiles a function that maps the enumeration items into their raw values.
2. The index of the item into the `Int` enum is passed through the `edi` register to the function for translation into its raw value. Again, as we saw in the second issue of Swift Weekly, this is the System V calling convention.
3. The raw value of `Int` enumeration items are stored on the `cs` segment (code segment), not data segment.
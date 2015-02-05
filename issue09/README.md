WORK IN PROGRESS
===

Swift Weekly - Issue 09 - The Swift Runtime (Part 7) - Subscripts
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
Apple has thoroughly [explained subscripting](http://goo.gl/C15J0l) in their Swift manual so i'm not going to do that. instead, we will have a look at how swift actually deals with subscripting at a low level. whether it just simply grabs an item from a certain memory index from the start of the object's memory or something more complicated.

first we will check out subscripts on existing structures and classes such as arrays and dictionaries, and then we will implement custom subscripts on our own structures and classes.

i am using the fourth beta of xcode 6.2 (Version 6.2 (6C107a)) to compile these examples for release only (no debug builds to ensure that the compiler gives us its best in optimization).

```bash
xcrun xcodebuild -version
Xcode 6.2
Build version 6C107a
```

Subscripting Arrays
===
let's begin with a simple array of strings and integers:

```swift
let array = ["Vandad",0xabcdefa, "Julian",0xabcdefb, "Leif", 0xabcdefc]
    as [AnyObject] //done to ensure no implicit NSArray conversion is happening
```

now let's have a look at a loop that extracts each item and then prints the results to the console. we will start with a function that can generate an index inside an array:

```swift
func randomIndexInArray(a: [AnyObject]) -> Int{
    return Int(arc4random_uniform(UInt32(a.count)))
}
```

and then we will grab a random item from the array in a loop:

```swift
func example1(){
    
    for i in 0..<array.count{
        let index = randomIndexInArray(array)
        let obj: AnyObject = array[index]
        println(obj)
    }
    
}
```

let's check out the assembly output for the `example1()` function:

```asm
00000001000015c0         push       rbp                                         ; XREF=__TFC12swift_weekly14ViewController11viewDidLoadfS0_FT_T_+111, -[_TtC12swift_weekly14ViewController viewDidLoad]+119
00000001000015c1         mov        rbp, rsp
00000001000015c4         push       r15
00000001000015c6         push       r14
00000001000015c8         push       r13
00000001000015ca         push       r12
00000001000015cc         push       rbx
00000001000015cd         sub        rsp, 0x28
00000001000015d1         mov        rax, qword [ds:__TWvdvC12swift_weekly14ViewController5arrayGSaPSs9AnyObject__] ; __TWvdvC12swift_weekly14ViewController5arrayGSaPSs9AnyObject__
00000001000015d8         mov        qword [ss:rbp+var_40], rax
00000001000015dc         mov        rbx, qword [ds:rdi+rax]
00000001000015e0         mov        r14, rdi
00000001000015e3         test       rbx, rbx
00000001000015e6         je         0x100001911

00000001000015ec         mov        al, byte [ds:rbx+0x19]
00000001000015ef         mov        r15, qword [ds:rbx+0x10]
00000001000015f3         test       al, al
00000001000015f5         je         0x10000163f

0000000100001607         mov        r12, rax
000000010000160a         test       r15, r15
000000010000160d         je         0x1000018ff

0000000100001623         mov        rsi, qword [ds:0x100018320]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
000000010000162a         mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000162d         call       imp___stubs__objc_msgSend
0000000100001632         mov        rbx, rax
000000010000163d         jmp        0x100001665

000000010000164f         mov        r12, rax
0000000100001652         xor        ebx, ebx
0000000100001654         test       r15, r15
0000000100001657         je         0x100001665

0000000100001659         mov        rbx, qword [ds:r15+0x10]

000000010000166d         mov        qword [ss:rbp+var_48], rbx
0000000100001671         test       rbx, rbx
0000000100001674         js         0x100001911

000000010000167a         mov        rbx, r14
000000010000167d         je         0x1000018e9

0000000100001683         nop        qword [cs:rax+rax+0x0]

0000000100001690         mov        rax, qword [ss:rbp+var_40]                  ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+803
0000000100001694         mov        r13, qword [ds:rbx+rax]
0000000100001698         mov        rax, qword [ds:imp___got__swift_isaMask]    ; imp___got__swift_isaMask
000000010000169f         mov        rax, qword [ds:rax]
00000001000016a2         and        rax, qword [ds:rbx]
00000001000016a5         lea        rcx, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
00000001000016ac         cmp        rax, rcx
00000001000016af         mov        edi, 0x0
00000001000016b4         cmove      rdi, rbx
00000001000016b8         test       rdi, rdi
00000001000016bb         je         0x100001730

00000001000016cd         mov        r15, rax
00000001000016d0         test       r13, r13
00000001000016d3         je         0x100001911

00000001000016d9         mov        al, byte [ds:r13+0x19]
00000001000016dd         mov        r12, qword [ds:r13+0x10]
00000001000016e1         test       al, al
00000001000016e3         je         0x100001760

00000001000016ed         mov        r15, rax
00000001000016f0         test       r12, r12
00000001000016f3         je         0x1000018ff

0000000100001709         mov        rsi, qword [ds:0x100018320]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
0000000100001710         mov        rdi, r12                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001713         call       imp___stubs__objc_msgSend
0000000100001718         mov        rbx, rax
0000000100001723         jmp        0x100001780
0000000100001725         nop        qword [cs:rax+rax+0x0]

0000000100001730         mov        r14, qword [ds:rax+0x48]                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+251
000000010000174c         mov        rdi, r13
000000010000174f         mov        rsi, rbx
0000000100001752         call       r14
0000000100001755         mov        r12, rax
0000000100001758         jmp        0x1000017a2
000000010000175a         nop        qword [ds:rax+rax+0x0]

0000000100001768         test       r12, r12
000000010000176b         je         0x10000177c

000000010000176d         mov        rbx, qword [ds:r12+0x10]
000000010000177a         jmp        0x100001780

000000010000177c         xor        ebx, ebx                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+427
000000010000177e         nop

0000000100001780         mov        eax, ebx                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+355, __TFC12swift_weekly14ViewController8example1fS0_FT_T_+442
0000000100001782         cmp        rbx, rax
0000000100001785         jne        0x100001911

000000010000178b         mov        edi, ebx                                    ; argument "upper_bound" for method imp___stubs__arc4random_uniform
000000010000178d         call       imp___stubs__arc4random_uniform
0000000100001792         mov        ebx, eax
000000010000179c         mov        r12d, ebx
000000010000179f         mov        rbx, r14

00000001000017a2         mov        rax, qword [ss:rbp+var_40]                  ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+408
00000001000017a6         mov        r15, qword [ds:rbx+rax]
00000001000017aa         mov        r13, rbx
00000001000017ad         test       r15, r15
00000001000017b0         je         0x100001911

00000001000017b6         mov        al, byte [ds:r15+0x19]
00000001000017ba         test       al, al
00000001000017bc         je         0x100001810

00000001000017d6         mov        rbx, rax
00000001000017d9         test       r12, r12
00000001000017dc         js         0x100001901

00000001000017ea         mov        rbx, rax
00000001000017ed         mov        rdi, r15
00000001000017f0         call       __TTSPSs9AnyObject____TFVSs12_ArrayBufferg5countSi
00000001000017f5         mov        r14, rax
0000000100001808         jmp        0x100001852
000000010000180a         nop        qword [ds:rax+rax+0x0]

0000000100001810         mov        rbx, qword [ds:r15+0x10]                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+508
000000010000182c         test       rbx, rbx
000000010000182f         je         0x100001911

0000000100001835         mov        r14, qword [ds:rbx+0x10]
0000000100001849         test       r12, r12
000000010000184c         js         0x100001911

0000000100001852         cmp        r12, r14                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+584
0000000100001855         jge        0x100001911

000000010000185b         lea        rdi, qword [ss:rbp+var_30]
000000010000185f         mov        rsi, r12
0000000100001862         mov        rdx, r15
0000000100001865         call       __TTSPSs9AnyObject____TFVSs12_ArrayBufferg9subscriptFSiQ_
000000010000186a         mov        rbx, r13
0000000100001875         mov        r14, qword [ss:rbp+var_30]
0000000100001879         mov        qword [ss:rbp+var_38], r14
0000000100001885         lea        rdi, qword [ss:rbp+var_38]
0000000100001889         call       __TTSPSs9AnyObject__VSs7_StdoutS0_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_
00000001000018c6         mov        edi, 0xa                                    ; argument "c" for method imp___stubs__putchar
00000001000018cb         call       imp___stubs__putchar
00000001000018df         dec        qword [ss:rbp+var_48]
00000001000018e3         jne        0x100001690

00000001000018ec         add        rsp, 0x28
00000001000018f0         pop        rbx
00000001000018f1         pop        r12
00000001000018f3         pop        r13
00000001000018f5         pop        r14
00000001000018f7         pop        r15
00000001000018f9         pop        rbp
```

_Note_: I've removed tons of calls to retain and release functions as they aren't really relevant to what we are trying to achieve here, which is finding out how subscripts work in Swift.

so here is what the code is doing:

1. first we find our array in the data segment (`ds`) and then load it into the `rbx` register. Swift then, cleverly, checks if the array is actually nil before executing any of our code and if it is `nil`, then it jumps to the end of our function:

	```asm
	00000001000015d1         mov        rax, qword [ds:__TWvdvC12swift_weekly14ViewController5arrayGSaPSs9AnyObject__] ; __TWvdvC12swift_weekly14ViewController5arrayGSaPSs9AnyObject__
	00000001000015d8         mov        qword [ss:rbp+var_40], rax
	00000001000015dc         mov        rbx, qword [ds:rdi+rax]
	00000001000015e0         mov        r14, rdi
	00000001000015e3         test       rbx, rbx
	00000001000015e6         je         0x100001911
	```

	the `test` instruction is important there since the array is now in the `ebx` register and if `ebx` is zero/`nil`, then the zero flag (`zf`) will be set to 1 and the `je` instruction 	checks the zero flag and then jumps to `cs: 0x100001911` if it is set. it just so happens that `cs:0x100001911` is the end of our function right before the stack is put back to its 	original form.

2. then swift calls the `count()` function on the array to find out how many items there are in it. it is interesting that Swift cannot find the elements in the array without calling `count()` considering the fact that our array is constructed during compile time and we don't modify it on the way:

	```asm
	0000000100001623         mov        rsi, qword [ds:0x100018320]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
	000000010000162a         mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_msgSend
	000000010000162d         call       imp___stubs__objc_msgSend
	0000000100001632         mov        rbx, rax
	000000010000163d         jmp        0x100001665
	```

	so here according to the [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG), we know that the `rdi` register is the first parameter to the `count()` function so it must be our array's instance. great. how about the `rsi` register though? it seems like we are reading the `qword` value at `ds:0x100018320` and placing it inside the `rsi` register, dictating to the runtime that we want to call the `count()` function on our array. so the `SEL` for the `count()` is inside the data segment somewhere. interesting. if i follow that `qword` value in the data segment, i will see this:

	```asm
	0000000100018320         dq         0x1000158fd
	```

	so in this case, the `rsi` register's value will be set to `0x1000158fd`. the `imp___stubs__objc_msgSend` function then gets called with those values. i am guessing that the value of `0x1000158fd` is then picked by the aforementioned function and will be understood to be the `count()` function somehow. do you know how? send a pull request to inform others.

3. at this point, the `rbx` register contains our array's count:

	```asm
	0000000100001632         mov        rbx, rax
	```

	and then the counter gets stored in the stack (so that we won't occupy a general purpose register for this) like so:

	```asm
	mov        qword [ss:rbp+var_48], rbx
	```

	obviously then we check the count to make sure it is not zero:

	```asm
	00000001000019d6         test       rbx, rbx
	00000001000019d9         js         0x100001c71
	```

	because if it is, then there is no point going through the loop.

4. then we get our index:

	```asm
	0000000100001aeb         mov        edi, ebx                                    ; argument "upper_bound" for method imp___stubs__arc4random_uniform
	0000000100001aed         call       imp___stubs__arc4random_uniform
	```

	and this index will then be used to retrieve an object out of our array using its `[]` subscript:

	```asm
	0000000100001bbb         lea        rdi, qword [ss:rbp+var_30]
	0000000100001bbf         mov        rsi, r12
	0000000100001bc2         mov        rdx, r15
	0000000100001bc5         call       __TTSPSs9AnyObject____TFVSs12_ArrayBufferg9subscriptFSiQ_
	```

	okay so it seems like an internal function called `__TTSPSs9AnyObject____TFVSs12_ArrayBufferg9subscriptFSiQ_` is responsible for retrieving a value out of our array with a subscript.

5. since the value that we grab out of the array is of type `AnyObject`, an internal function with a very very, veeeeery long name gets called to print its value to the console:

	```asm
	0000000100001be5         lea        rdi, qword [ss:rbp+var_38]
	0000000100001be9         call       __TTSPSs9AnyObject__VSs7_StdoutS0_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_
	```
	
6. at the end of the loop, our index variable is decreased with the `dec` instruction:

	```asm
	0000000100001c3f         dec        qword [ss:rbp+var_48]
	```



Conclusion
===
1. On arrays of type `[AnyObject]`, an internal Swift function called `__TTSPSs9AnyObject____TFVSs12_ArrayBufferg9subscriptFSiQ_` is responsible for the subscripting for an integer value.

References
===
1. [The Swift Programming Language - Type Casting](http://goo.gl/C15J0l)
2. [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 3A, 3B, and 3C](http://goo.gl/ZBA5oK) 
3. [`X86CallingConv.td`](http://goo.gl/CYOxoB) file, a part of LLVM compiler's open source code
4. [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG)


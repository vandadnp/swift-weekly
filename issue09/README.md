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

alright, we get it now. so the `__TTSPSs9AnyObject____TFVSs12_ArrayBufferg9subscriptFSiQ_` function is retrieving our items from the `[AnyObject]` array.

Subscripting Dictionaries
===
I started this article about a week and a half ago and now I have time to write this part of the article. Now, Xcode 6.3 Beta 1 is released so I am going to switch to building with that version

```bash
xcrun xcodebuild -version                                  
Xcode 6.3
Build version 6D520o
```

Let's now have a look at how subscripting works in dictionaries. first the dictionary itself:

```swift
let dict = [
    0xabcdefa : 0xabcdefa,
    0xabcdefb : 0xabcdefb,
    0xabcdefc : 0xabcdefc
]
```

and then a method that can grab a random index out of this dictionary for us:

```swift
func randomIndexInDictionary(a: [Int : Int]) -> Int{
    return Int(arc4random_uniform(UInt32(a.count)))
}
```

and then the example code which we will soon analyze:

```swift
func example2(){
    
    let value2 = dict[randomIndexInDictionary(dict)]!
    println(value2)
    
}
```

this just grabs a random `Int` out of the dictionary using its key which itself is an `Int`. let's see how the output assembly for this looks like:

```asm
0000000100002380   push       rbp                                         ; Objective C Implementation defined at 0x100008418 (instance)
0000000100002381   mov        rbp, rsp
0000000100002384   push       r15
0000000100002386   push       r14
0000000100002388   push       r13
000000010000238a   push       r12
000000010000238c   push       rbx
000000010000238d   sub        rsp, 0x38
0000000100002391   mov        r15, rdi
0000000100002394   mov        r13, 0x7fffffffffffffff
000000010000239e   mov        rax, qword [ds:__TWvdvC12swift_weekly14ViewController4dictGVSs10DictionarySiSi_] ; __TWvdvC12swift_weekly14ViewController4dictGVSs10DictionarySiSi_
00000001000023a5   mov        rbx, qword [ds:r15+rax]
00000001000023a9   mov        rax, qword [ds:imp___got__swift_isaMask]    ; imp___got__swift_isaMask
00000001000023b0   mov        rax, qword [ds:rax]
00000001000023b3   and        rax, qword [ds:r15]
00000001000023b6   lea        rcx, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
00000001000023bd   xor        edx, edx
00000001000023bf   cmp        rax, rcx
00000001000023c2   cmove      rdx, r15
00000001000023c6   test       rdx, rdx
00000001000023c9   je         0x100002403

00000001000023db   test       rbx, rbx
00000001000023de   js         0x10000243b

00000001000023e0   mov        r14, qword [ds:rbx+0x18]
00000001000023f4   test       r14, r14
00000001000023f7   je         0x10000274f

00000001000023fd   mov        rdi, qword [ds:r14+0x18]
0000000100002401   jmp        0x100002466

0000000100002403   mov        r12, qword [ds:rax+0x50]                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+73
0000000100002417   test       rbx, rbx
000000010000241a   jns        0x1000024a8

0000000100002420   mov        r14, rbx
0000000100002423   and        r14, r13
0000000100002436   jmp        0x1000024c3

000000010000243b   mov        r14, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+94
000000010000243e   and        r14, r13
0000000100002441   mov        r12, qword [ds:0x100009080]                 ; @selector(count)
0000000100002458   mov        rdi, r14                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000245b   mov        rsi, r12                                    ; argument "selector" for method imp___stubs__objc_msgSend
000000010000245e   call       imp___stubs__objc_msgSend
0000000100002463   mov        rdi, rax

0000000100002466   mov        eax, edi                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+129
0000000100002468   cmp        rdi, rax
000000010000246b   jne        0x10000274f

0000000100002471   call       imp___stubs__arc4random_uniform
0000000100002476   test       rbx, rbx
0000000100002479   mov        r12d, eax
000000010000247c   jns        0x10000248b

000000010000247e   mov        rdi, rbx
0000000100002489   jmp        0x10000249e

000000010000248b   mov        rax, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+252
000000010000248e   shr        rax, 0x3f
0000000100002492   test       al, al
0000000100002494   jne        0x10000249e

00000001000024a6   jmp        0x1000024cf

00000001000024a8   mov        rax, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+154
00000001000024ab   shr        rax, 0x3f
00000001000024af   test       al, al
00000001000024b1   jne        0x1000024c3


00000001000024c3   mov        rdi, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+182, __TToFC12swift_weekly14ViewController8example2fS0_FT_T_+305
00000001000024c6   mov        rsi, r15
00000001000024c9   call       r12
00000001000024cc   mov        r12, rax

00000001000024cf   test       rbx, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+294
00000001000024d2   js         0x100002590

00000001000024d8   mov        qword [ss:rbp+var_58], r15
00000001000024dc   mov        r15, qword [ds:rbx+0x18]
00000001000024e0   test       r15, r15
00000001000024e3   je         0x10000274f

00000001000024e9   mov        qword [ss:rbp+var_50], rbx
00000001000024ed   mov        r13, qword [ds:r15+0x10]
00000001000024f1   test       r13, r13
00000001000024f4   js         0x10000274f

00000001000024fa   mov        rax, qword [ds:imp___got___swift_stdlib_HashingDetail_fixedSeedOverride] ; imp___got___swift_stdlib_HashingDetail_fixedSeedOverride
0000000100002501   mov        rax, qword [ds:rax]
0000000100002504   test       rax, rax
0000000100002507   mov        r14, 0xff51afd7ed558ccd
0000000100002511   cmovne     r14, rax
0000000100002515   mov        ebx, r12d
0000000100002528   mov        rdi, rax
000000010000252b   test       r13, r13
000000010000252e   je         0x10000274f

0000000100002534   mov        rax, r12
0000000100002537   shr        rax, 0x20
000000010000253b   lea        rcx, qword [ds:r14+rbx*8]
000000010000253f   xor        rcx, rax
0000000100002542   mov        rdx, 0x9ddfea08eb382d69
000000010000254c   imul       rcx, rdx
0000000100002550   mov        rsi, rcx
0000000100002553   shr        rsi, 0x2f
0000000100002557   xor        rcx, rax
000000010000255a   xor        rcx, rsi
000000010000255d   imul       rcx, rdx
0000000100002561   mov        rax, rcx
0000000100002564   shr        rax, 0x2f
0000000100002568   xor        rax, rcx
000000010000256b   imul       rax, rdx
000000010000256f   mov        rdx, r13
0000000100002572   sub        rdx, 0x1
0000000100002576   setb       cl
0000000100002579   test       r13, rdx
000000010000257c   je         0x10000267e

0000000100002582   xor        edx, edx
0000000100002584   div        r13
0000000100002587   mov        r14, qword [ss:rbp+var_50]
000000010000258b   jmp        0x100002689

0000000100002590   and        rbx, r13                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+338
0000000100002593   mov        qword [ss:rbp+var_30], r12
000000010000259f   mov        r13, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
00000001000025a6   add        r13, 0x8
00000001000025aa   lea        rdi, qword [ss:rbp+var_30]
00000001000025ae   mov        rsi, r13
00000001000025b1   call       imp___stubs__swift_bridgeNonVerbatimToObjectiveC
00000001000025b6   mov        r12, rax
00000001000025b9   test       r12, r12
00000001000025bc   je         0x10000274f

00000001000025c2   mov        r14, qword [ds:0x100009090]                 ; @selector(objectForKey:)
00000001000025d9   mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000025dc   mov        rsi, r14                                    ; argument "selector" for method imp___stubs__objc_msgSend
00000001000025df   mov        rdx, r12
00000001000025e2   call       imp___stubs__objc_msgSend
0000000100002606   test       r12, r12
0000000100002609   je         0x100002753

000000010000260f   mov        qword [ss:rbp+var_48], 0x0
0000000100002617   mov        byte [ss:rbp+var_40], 0x1
0000000100002623   lea        rdx, qword [ss:rbp+var_48]
0000000100002627   mov        rdi, r12
000000010000262a   mov        rsi, r13
000000010000262d   mov        rcx, r13
0000000100002630   call       imp___stubs__swift_bridgeNonVerbatimFromObjectiveC
0000000100002635   mov        r13, qword [ss:rbp+var_48]
0000000100002639   mov        r14b, byte [ss:rbp+var_40]
0000000100002645   movzx      eax, r14b
0000000100002649   cmp        eax, 0x1
000000010000264c   jne        0x100002657

000000010000264e   test       r13, r13
0000000100002651   je         0x10000274f

0000000100002670   test       r14b, r14b
0000000100002673   je         0x100002720

0000000100002679   jmp        0x100002751

000000010000267e   test       cl, cl                                      ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+508
0000000100002680   mov        r14, qword [ss:rbp+var_50]
0000000100002684   jne        0x1000026d7

0000000100002686   and        rdx, rax

0000000100002689   test       rdx, rdx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+523
000000010000268c   js         0x1000026d7

000000010000268e   nop        

0000000100002690   cmp        rdx, r13                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+853
0000000100002693   jge        0x10000274f

0000000100002699   lea        rax, qword [ds:0x0+rdx*8]
00000001000026a1   lea        rsi, qword [ds:rax+rax*2]
00000001000026a5   mov        rcx, qword [ds:r15+rsi+0x28]
00000001000026aa   mov        rax, qword [ds:r15+rsi+0x30]
00000001000026af   mov        bl, byte [ds:r15+rsi+0x38]
00000001000026b4   test       bl, bl
00000001000026b6   jne        0x1000026d9

00000001000026b8   cmp        rcx, r12
00000001000026bb   je         0x1000026d9

00000001000026bd   inc        rdx
00000001000026c0   jo         0x10000274f

00000001000026c6   mov        r13, qword [ds:r15+0x10]
00000001000026ca   mov        rax, r13
00000001000026cd   dec        rax
00000001000026d0   jo         0x10000274f

00000001000026d2   and        rdx, rax
00000001000026d5   jns        0x100002690

00000001000026d7   ud2                                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+772, __TToFC12swift_weekly14ViewController8example2fS0_FT_T_+780

00000001000026d9   mov        r12b, 0x1                                   ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+822, __TToFC12swift_weekly14ViewController8example2fS0_FT_T_+827
00000001000026dc   xor        r13d, r13d
00000001000026df   test       bl, bl
00000001000026e1   jne        0x1000026ff

00000001000026e3   cmp        rdx, qword [ds:r15+0x10]
00000001000026e7   jge        0x10000274f

00000001000026e9   movzx      edx, byte [ds:r15+rsi+0x38]
00000001000026ef   cmp        edx, 0x1
00000001000026f2   jne        0x1000026f9

00000001000026f4   or         rcx, rax
00000001000026f7   je         0x10000274f

00000001000026f9   xor        r12d, r12d                                  ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+882
00000001000026fc   mov        r13, rax

00000001000026ff   mov        rbx, rdi                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+865
0000000100002717   test       r12b, r12b
000000010000271a   mov        r15, qword [ss:rbp+var_58]
000000010000271e   jne        0x100002751

0000000100002720   mov        qword [ss:rbp+var_38], r13                  ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+755
0000000100002724   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
000000010000272b   add        rsi, 0x8
000000010000272f   lea        rdi, qword [ss:rbp+var_38]
0000000100002733   call       imp___stubs___TFSs7printlnU__FQ_T_
0000000100002740   add        rsp, 0x38
0000000100002744   pop        rbx
0000000100002745   pop        r12
0000000100002747   pop        r13
0000000100002749   pop        r14
000000010000274b   pop        r15
000000010000274d   pop        rbp
000000010000274e   ret
```
let's see what is happening here:

1. we are first getting the count of our dictionary's keys in order to generate a random integer from 0 to that count:

	```asm
	0000000100005153         mov        rbx, r14                                    ; XREF=__TTSf4g___TFC12swift_weekly14ViewController8example2fS0_FT_T_+78
	0000000100005156         and        rbx, r12
	0000000100005159         mov        r15, qword [ds:0x100009080]                 ; @selector(count)
	0000000100005170         mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
	0000000100005173         mov        rsi, r15                                    ; argument "selector" for method imp___stubs__objc_msgSend
	0000000100005176         call       imp___stubs__objc_msgSend
	000000010000517b         mov        rdi, rax
	```

	in this case, according to [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG), `rdi` is the `dict`, `rsi` is the selector for `count` which was previously inside the `r15` register. this register is set up like so:

	```asm
	0000000100005159         mov        r15, qword [ds:0x100009080]                 ; @selector(count)
	```

	what 64-bit value is in `[ds:0x100009080]`? let's see:

	```asm
	0000000100009080         dq         0x10000757d
	```

	so let's also follow that value to end pu here:

	```asm
	000000010000757d         db         "count", 0                                  ; XREF=0x100000260, 0x100009080
	```
	so it seems like `[ds:0x100009080]` is basically a pointer to the `count` method on our dictionary. the count is now inside the `rdi` register after the `mov` instruction at `cs:000000010000517b`.

2. after we have the count of the keys in the dictionary, we want to generate a random number and that code is written like so in our output assembly:

	```asm
	0000000100002471         call       imp___stubs__arc4random_uniform
	0000000100002476         test       rbx, rbx
	0000000100002479         mov        r12d, eax
	000000010000247c         jns        0x10000248b
	```

	note that the `randomIndexInDictionary()` function that we wrote has now been inlined. Swift optimized this out and did not make it a function. You have probably already read the previous Swift Weekly articles and by now noticed that this is a fairly common pattern in Swift.

3. after we have the random index, we get our object out of the dictionary using its key like so:

	```asm
	00000001000025c2         mov        r14, qword [ds:0x100009090]                 ; @selector(objectForKey:)
	00000001000025d9         mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
	00000001000025dc         mov        rsi, r14                                    ; argument "selector" for method imp___stubs__objc_msgSend
	00000001000025df         mov        rdx, r12
	00000001000025e2         call       imp___stubs__objc_msgSend
	```

	and as you can see, the method that we are calling is at `[ds:0x100009090]` and our instance is the dictionary which we have in the `rbx` and now in the `rdi` register. let's have a look at `[ds:0x100009090]`:

	```asm
	0000000100009090         dq         0x100007592
	```

	and then dig further:

	```asm
	0000000100007592         db         "objectForKey:", 0                          ; XREF=0x100009090
	```

	okay so if you look closely, it seems like the selector is really `objectForKey:` and it is written as `objectForKey:` which is very similar to how selectors in ObjC were written. Do you know why? send a pull request and inform others.

4. once the value is found, we print it to the console:

	```asm
	0000000100002720         mov        qword [ss:rbp+var_38], r13                  ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+755
	0000000100002724         mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
	000000010000272b         add        rsi, 0x8
	000000010000272f         lea        rdi, qword [ss:rbp+var_38]
	0000000100002733         call       imp___stubs___TFSs7printlnU__FQ_T_
	```

Subscripting Strings
===
Let's see a simple code:

```swift
func example3(){
    let s = "Hello, World!"
    let c = s[advance(s.startIndex, 4)]
    println(c)
}
```

and this is how it is assembled:

```asm
0000000100003070  push       rbp                                         ; Objective C Implementation defined at 0x10000d518 (instance)
0000000100003071  mov        rbp, rsp
0000000100003074  push       r15
0000000100003076  push       r14
0000000100003078  push       r12
000000010000307a  push       rbx
000000010000307b  sub        rsp, 0x90
000000010000308a  lea        rbx, qword [ds:0x10000bb52]                 ; "Hello, World!"
0000000100003091  lea        rdi, qword [ss:rbp+var_48]                  ; argument #1 for method __TFSSg10startIndexVSS5Index
0000000100003095  mov        edx, 0xd                                    ; argument #3 for method __TFSSg10startIndexVSS5Index
000000010000309a  xor        ecx, ecx                                    ; argument #4 for method __TFSSg10startIndexVSS5Index
000000010000309c  mov        rsi, rbx                                    ; argument #2 for method __TFSSg10startIndexVSS5Index
000000010000309f  call       __TFSSg10startIndexVSS5Index
00000001000030a4  mov        rax, qword [ss:rbp+var_48]
00000001000030a8  mov        rcx, qword [ss:rbp+var_40]
00000001000030ac  movups     xmm0, xmmword [ss:rbp+var_38]
00000001000030b0  mov        rdx, qword [ss:rbp+var_28]
00000001000030b4  mov        qword [ss:rbp+var_70], rax
00000001000030b8  mov        qword [ss:rbp+var_68], rcx
00000001000030bc  movups     xmmword [ss:rbp+var_60], xmm0
00000001000030c0  mov        qword [ss:rbp+var_50], rdx
00000001000030c4  mov        qword [ss:rbp+var_A0], 0x4
00000001000030cf  mov        rcx, qword [ds:imp___got___TMdVSS5Index]    ; imp___got___TMdVSS5Index
00000001000030d6  add        rcx, 0x8
00000001000030da  lea        rdi, qword [ss:rbp+var_98]                  ; argument #1 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
00000001000030e1  lea        rsi, qword [ss:rbp+var_70]                  ; argument #2 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
00000001000030e5  lea        rdx, qword [ss:rbp+var_A0]                  ; argument #3 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
00000001000030ec  mov        r8, rcx
00000001000030ef  call       __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
00000001000030f4  mov        rax, qword [ss:rbp+var_98]
00000001000030fb  mov        rsi, qword [ss:rbp+var_78]
00000001000030ff  add        rsi, rax
0000000100003102  jo         0x10000317b

0000000100003104  cmp        rsi, rax
0000000100003107  jl         0x10000317b

0000000100003109  test       rax, rax
000000010000310c  js         0x10000317b

000000010000310e  cmp        rsi, 0xd
0000000100003112  jg         0x10000317b

0000000100003114  sub        rsi, rax
0000000100003117  jo         0x10000317b

0000000100003119  test       rsi, rsi
000000010000311c  js         0x10000317b

000000010000311e  mov        r15, qword [ss:rbp+var_80]
0000000100003122  add        rbx, rax
0000000100003125  xor        edx, edx                                    ; argument #3 for method __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
0000000100003127  mov        rdi, rbx                                    ; argument #1 for method __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
000000010000312a  call       __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
000000010000312f  mov        r12, rax
0000000100003132  mov        bl, dl
000000010000313c  mov        qword [ss:rbp+var_B0], r12
0000000100003143  and        bl, 0x1
0000000100003146  mov        byte [ss:rbp+var_A8], bl
000000010000314c  mov        rsi, qword [ds:imp___got___TMdVSs9Character] ; imp___got___TMdVSs9Character
0000000100003153  add        rsi, 0x8
0000000100003157  lea        rdi, qword [ss:rbp+var_B0]
000000010000315e  call       imp___stubs___TFSs7printlnU__FQ_T_
000000010000316b  add        rsp, 0x90
0000000100003172  pop        rbx
0000000100003173  pop        r12
0000000100003175  pop        r14
0000000100003177  pop        r15
0000000100003179  pop        rbp
000000010000317a  ret
```

1. the first thing is loading the string into a gpr:

	```asm
	000000010000308a         lea        rbx, qword [ds:0x10000bb52]
	```

	let's follow that address in the data segment:

	```asm
	000000010000bb52         db         "Hello, World!", 0
	```

	while looking at this string, i saw some other strings:

	```asm
	000000010000bb60         db         "Vandad", 0
	000000010000bb67         db         "Julian", 0
	000000010000bb6e         db         "Leif", 0
	```

	wait a minute! those strings are part of the previous exercises and they aren't even being used or called in any way. it seems like the string optimization and stripping in the latest Swift compiler is not doing a very good job in getting rid of unused strings in the data segment.

2. What we then need to resolve is this codeÖ

	```swift
	s.startIndex
	```

	and that is translated to this asm code:

	```asm
	0000000100003091         lea        rdi, qword [ss:rbp+var_48]                  ; argument #1 for method __TFSSg10startIndexVSS5Index
	0000000100003095         mov        edx, 0xd                                    ; argument #3 for method __TFSSg10startIndexVSS5Index
	000000010000309a         xor        ecx, ecx                                    ; argument #4 for method __TFSSg10startIndexVSS5Index
	000000010000309c         mov        rsi, rbx                                    ; argument #2 for method __TFSSg10startIndexVSS5Index
	000000010000309f         call       __TFSSg10startIndexVSS5Index
	```

	if you remember, `rbx` in the previous stage pointed to our string. so now `rsi` (param #2) of the `__TFSSg10startIndexVSS5Index` function is our string.

3. after this, `rax` should contain the result of the `startIndex` property on our `String`. what has to be resolved next is `advance(s.startIndex, 4)` and the call to the `advance()` function:

	```asm
	00000001000030a4         mov        rax, qword [ss:rbp+var_48]
	00000001000030a8         mov        rcx, qword [ss:rbp+var_40]
	00000001000030ac         movups     xmm0, xmmword [ss:rbp+var_38]
	00000001000030b0         mov        rdx, qword [ss:rbp+var_28]
	00000001000030b4         mov        qword [ss:rbp+var_70], rax
	00000001000030b8         mov        qword [ss:rbp+var_68], rcx
	00000001000030bc         movups     xmmword [ss:rbp+var_60], xmm0
	00000001000030c0         mov        qword [ss:rbp+var_50], rdx
	00000001000030c4         mov        qword [ss:rbp+var_A0], 0x4
	00000001000030cf         mov        rcx, qword [ds:imp___got___TMdVSS5Index]    ; imp___got___TMdVSS5Index
	00000001000030d6         add        rcx, 0x8
	00000001000030da         lea        rdi, qword [ss:rbp+var_98]                  ; argument #1 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
	00000001000030e1         lea        rsi, qword [ss:rbp+var_70]                  ; argument #2 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
	00000001000030e5         lea        rdx, qword [ss:rbp+var_A0]                  ; argument #3 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
	00000001000030ec         mov        r8, rcx
	00000001000030ef         call       __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
	```

	what I am confused about is the first instruction which is `mov        rax, qword [ss:rbp+var_48]`. This instruction effectively changes the value of `rax` 64-bit gpr but at the same time, it's the instruction right after the call to the `__TFSSg10startIndexVSS5Index` function. According to the [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG), return values are stored in `rax` so how is it that Swift is discarding the value of `rax` as soon as that function has come back to the caller? could it be that `__TFSSg10startIndexVSS5Index` stored the value of the `startIndex` property into the stack? if yes, where and why? I don't get this. could it be that the `mov` instruction that is reading the value from stack is reading the return value? let's resolve `mov        rax, qword [ss:rbp+var_48]` to its real address:

	```asm
	mov        rax, qword [ss:rbp+0xffffffffffffffb8]
	```

	`0xb8` in decimal is 184 and 184/8 (to get the bytes, _if_ this is in bits) would be 23 so this makes no sense. the instruction is `mov` and is clearly reading a 64-bit (8 bytes) value from that location. so there must be a value from `0xffffffffffffffb8` to `0xffffffffffffffc0` but what value? if you know, send a pull request. this is quite vague.

	I have now moved this same Swift code into a Mac app, then attached a debugger to the disassembled code and let 'er rip. So after the `__TFSSg10startIndexVSS5Index` function, our general purpose registers are set to the following values:

	General purpose register | Value
	---|---
	RAX | 0x00007FFF5DFCFE30
	RBX | 0x0000000101C36180
	RCX | 0x0000000000000090
	RDX | 0x0000000101C36180
	RSI | 0x0000000101E21D70
	RDI | 0x0000000000000000
	RBP | 0x00007FFF5DFCFE80
	RSP | 0x00007FFF5DFCFDC0
	RIP | 0x0000000101C304A4

	abd we know that the result of the `startIndex` property of `String` is of type `String.Index` which is defined in this way:

	```swift
	/// A character position in a `String`
	struct Index : BidirectionalIndexType, Comparable, Reflectable {

	   /// Returns the next consecutive value after `self`.
	   ///
	   /// Requires: the next value is representable.
	   func successor() -> String.Index

	   /// Returns the previous consecutive value before `self`.
	   ///
	   /// Requires: the previous value is representable.
	   func predecessor() -> String.Index

	   /// Returns a mirror that reflects `self`.
	   func getMirror() -> MirrorType
	}
	```

	so we expect the `__TFSSg10startIndexVSS5Index` function to return this index to us but where is it returning it? all those that `Index` conforms to are protocols, not classes. so `String.Index` is a simple structure that conforms to three protocols. should we expect the value of an item of this type to be stored in a general purpose register? if we assume _yes_, and knowing that the start index of our string is 0, the only gpr that is 0 after the execution of `TFSSg10startIndexVSS5Index` is done is the `rdi` register. but could it be that `rdi` was set to 0 _before_ the `__TFSSg10startIndexVSS5Index` function? if we look closely:

	```asm
	0000000100001491         lea        rdi, qword [ss:rbp+var_50]                  ; argument #1 for method __TFSSg10startIndexVSS5Index
	0000000100001495         mov        edx, 0xd                                    ; argument #3 for method __TFSSg10startIndexVSS5Index
	000000010000149a         xor        ecx, ecx                                    ; argument #4 for method __TFSSg10startIndexVSS5Index
	000000010000149c         mov        rsi, rbx                                    ; argument #2 for method __TFSSg10startIndexVSS5Index
	000000010000149f         call       __TFSSg10startIndexVSS5Index
	```

	`rdi` is pointing to the value at `ss:rbp+var_50`. Having a debugger in hand, I can debug that line and see that after that specific line, `rdi` gets set to `0x00007FFF5E479E30` which is a memory address since the instruction used was `lea`, load effective address. You can find information about it in [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 3A, 3B, and 3C](http://goo.gl/ZBA5oK). I then used the debugger to read the qword value at `0x00007FFF5E479E30` and I found a quad-word value of all-zeros there. So the memory for that address contains a good 8 bytes of zeroes. Could the `__TFSSg10startIndexVSS5Index` function freely change the `rdx` register under our feet? Referring to [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG), it turns out yes:

	> Registers RBP, RBX, and R12-R15 are callee-save registers; all others must be saved by the caller if they wish to preserve their values.[15]

	but there is no sign yet as to whether or not this function actually stored its value in the `rdi` register or not. If you know for sure if this is true or not, send a pull request and correct this article.

	before the call to the `__TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_` function, the `rbx` register contains the pointer to our string `Hello, World!"`. `rdx` will point to `0x00007FFF5E479DD8` whose memory contains `0x0000000000000004` that is the 4 characters which we are hopping over the original index with. So `rbx` is our first  and `rdx` is the second parameter to the `advance` function.

4. last but not least, we get down to the bottom of what we wanted to find out initially and that is subscripting on strings and that happens here:

	```asm
	000000010000311e         mov        r15, qword [ss:rbp+var_80]
	0000000100003122         add        rbx, rax
	0000000100003125         xor        edx, edx                                    ; argument #3 for method __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
	0000000100003127         mov        rdi, rbx                                    ; argument #1 for method __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
	000000010000312a         call       __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
	```

	at this point, you can see that `rdi` is set to the value of `rbx` and the value of `rdi` is currently `0x000000010178C184`. this is a memory address so let's see what it contains: `o, World!`. Oh hello hello. what do we have here? it seems like Swift has already prepared our string, from the 4th index, just like we wanted. How did this happen?

	Pay attention to these:

	```asm
	00000001000030ef         call       __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
	00000001000030f4         mov        rax, qword [ss:rbp+var_98]
	... some code
	0000000100003122         add        rbx, rax
	... some code
	```

	Oh wait a minute! Holy moly! After the call to the `__TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_` function, Swift is setting the `rax` register to `qword [ss:rbp+var_98]` which turns out to be the `4` index which we hopped over. So this proves something. The value inside `[ss:rbp+var_98]` is `0x04` which is our final index to read from inside the string. That function put its return value inside the stack? But why? Could it be because `String.Index` is a `struct` and `struct`s are stack based in Swift. It could well be. If you know, send a pull request and add to this article.

	great, so with `rbx` pointing to our string exactly at index 4, `rdi` then gets set to `rbx` according to [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG) as the first parameter to the `__TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_` function. great, mystery solved!

I know there is a lot left to be discussed, for instance, custom subscripts, how do they work? since this article has already grown very long, I think it's best that I move the other discussions out to another article. For now, enjoy coding and have fun!

Conclusion
===
1. On arrays of type `[AnyObject]`, an internal Swift function called `__TTSPSs9AnyObject____TFVSs12_ArrayBufferg9subscriptFSiQ_` is responsible for the subscripting for an integer value.
2. Swift saves a table with information to methods for internal data structures such as dictionaries of type `[Int : Int]` inside the data segment. The method location is read from `ds` and called using a simple `call` function. Having the method names and their locations inside binaries means that those locations will probably __not__ ever be changed since if Apple changes those locations, old apps will not work. So those are already set and will _probably_ never change. Which makes you think why they are being read dynamically from `ds` anyways. If you know why, please send a pull request.
3. Unused `String` objects keep hanging in the data segment in Xcode 6.3 Beta 1 with Swift 1.2. This is, well, not very good. Make sure that you remove unused strings from your code manually for now.
4. The `startIndex` function on `String` types is called `__TFSSg10startIndexVSS5Index` in Swift output binaries.
5. The internal and private name of the function that we all know as `advance` in Swift 1.2 is called `__TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_`. If this is not the longest function name, I don't know what is.
6. The `__TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_` function is essentially responsible for reading a `Character` from a `String` as an `String.Index` subscript on `String`.

References
===
1. [The Swift Programming Language - Type Casting](http://goo.gl/C15J0l)
2. [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 3A, 3B, and 3C](http://goo.gl/ZBA5oK)
3. [`X86CallingConv.td`](http://goo.gl/CYOxoB) file, a part of LLVM compiler's open source code
4. [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG)


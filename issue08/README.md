WORK IN PROGRESS
===

Swift Weekly - Issue 08 - The Swift Runtime (Part 6) - Type Casting
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
In Swift, typecasting works in a different way than in Objective-C. We need to use the `is` keyword really to typecast and downcast, as you will see later. i am not going to teach you how to typecast in Swift. you can learn that [here](http://goo.gl/C15J0l). i will however teach you the low-level details of how Swift deals with typecasting and downcasting. as always, if you find something wrong with this article, you can just send a pull request and correct it.

i will be using the release scheme for the builds. i will also use the following xcodebuild version:

```bash
Xcode 6.2
Build version 6C101
```

if you are curious as to knowing which version of the SDK you have on your own machine, you can run the `xcrun xcodebuild -version` command to find out.

Conditional Typecasting
===
So let's say you have this array:

```swift
let items = [
    0xabcdefa,
    "Foo",
    0xabcdefb,
    "Bar"
]
```

and you want to go through the items in the array and find the ones which are integers and the ones which are strings like so:

```swift
func example1(){
    
    for v in items{
        if v is Int{
            println(0xabcdefc)
        }
        else if v is String{
            println(0xabcdefd)
        }
    }
}
```

so we are conditionally typecasting the values and if we yield a result, then we print a value to the console. let's see how the compiler assembled the `example1()` function:

```asm
0000000100001280    push       rbp                                         ; XREF=-[_TtC12swift_weekly14ViewController example1]+23, __TFC12swift_weekly14ViewController11viewDidLoadfS0_FT_T_+111, -[_TtC12swift_weekly14ViewController viewDidLoad]+119
0000000100001281    mov        rbp, rsp
0000000100001284    push       r15
0000000100001286    push       r14
0000000100001288    push       r13
000000010000128a    push       r12
000000010000128c    push       rbx
000000010000128d    sub        rsp, 0x68
0000000100001291    mov        qword [ss:rbp+var_90], rdi
0000000100001298    mov        rax, qword [ds:__TWvdvC12swift_weekly14ViewController5itemsGSaCSo8NSObject_] ; __TWvdvC12swift_weekly14ViewController5itemsGSaCSo8NSObject_
000000010000129f    mov        r12, qword [ds:rdi+rax]
00000001000012a3    test       r12, r12
00000001000012a6    je         0x100001617

00000001000012ac    mov        al, byte [ds:r12+0x19]
00000001000012b1    mov        rbx, qword [ds:r12+0x10]
00000001000012b6    test       al, al
00000001000012b8    je         0x10000130a

00000001000012d2    mov        r14, rax
00000001000012d5    test       rbx, rbx
00000001000012d8    je         0x100001619

00000001000012ee    mov        rsi, qword [ds:0x100018558]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
00000001000012f5    mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000012f8    call       imp___stubs__objc_msgSend
00000001000012fd    mov        r15, rax
0000000100001308    jmp        0x100001339

0000000100001322    mov        r14, rax
0000000100001325    xor        r15d, r15d
0000000100001328    test       rbx, rbx
000000010000132b    je         0x100001339

000000010000132d    mov        r15, qword [ds:rbx+0x10]

0000000100001341    test       r15, r15
0000000100001344    je         0x1000015e2

000000010000134a    xor        r15d, r15d
000000010000134d    mov        rax, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
0000000100001354    add        rax, 0x8
0000000100001358    mov        qword [ss:rbp+var_80], rax
000000010000135c    mov        rax, qword [ds:imp___got___TMdSS]           ; imp___got___TMdSS
0000000100001363    add        rax, 0x8
0000000100001367    mov        qword [ss:rbp+var_88], rax
000000010000136e    nop

0000000100001370    lea        rax, qword [ds:r15+0x1]                     ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+860
0000000100001374    mov        qword [ss:rbp+var_78], rax
0000000100001378    mov        al, byte [ds:r12+0x19]
000000010000137d    test       al, al
000000010000137f    je         0x1000013e0

0000000100001399    mov        rbx, rax
000000010000139c    test       r15, r15
000000010000139f    js         0x100001605

00000001000013ad    mov        r14, rax
00000001000013b0    mov        rdi, r12
00000001000013b3    call       __TTSCSo8NSObject___TFVSs12_ArrayBufferg5countSi
00000001000013b8    mov        rbx, rax
00000001000013cb    cmp        r15, rbx
00000001000013ce    jl         0x10000142f

00000001000013d0    jmp        0x100001617
00000001000013d5    nop        qword [cs:rax+rax+0x0]

00000001000013e0    mov        rbx, qword [ds:r12+0x10]                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+255
00000001000013fd    mov        r14, rax
0000000100001400    test       rbx, rbx
0000000100001403    je         0x100001617

0000000100001409    mov        r13, qword [ds:rbx+0x10]
000000010000141d    test       r15, r15
0000000100001420    js         0x100001617

0000000100001426    cmp        r15, r13
0000000100001429    jge        0x100001617

000000010000142f    lea        rdi, qword [ss:rbp+var_30]                  ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+334
0000000100001433    mov        rsi, r15
0000000100001436    mov        rdx, r12
0000000100001439    call       __TTSCSo8NSObject___TFVSs12_ArrayBufferg9subscriptFSiQ_
000000010000143e    mov        r15, qword [ss:rbp+var_30]
0000000100001442    mov        qword [ss:rbp+var_38], r15
0000000100001446    mov        rbx, qword [ds:__TMLCSo8NSObject]           ; __TMLCSo8NSObject
0000000100001455    test       rbx, rbx
0000000100001458    jne        0x100001478

000000010000145a    mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_NSObject] ; imp___got__OBJC_CLASS_$_NSObject
0000000100001461    call       imp___stubs__swift_getInitializedObjCClass
0000000100001466    mov        rdi, rax
0000000100001469    call       imp___stubs__swift_getObjCClassMetadata
000000010000146e    mov        rbx, rax
0000000100001471    mov        qword [ds:__TMLCSo8NSObject], rbx           ; __TMLCSo8NSObject

0000000100001478    mov        r8d, 0x6                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+472
000000010000147e    lea        rdi, qword [ss:rbp+var_40]
0000000100001482    lea        rsi, qword [ss:rbp+var_38]
0000000100001486    mov        rdx, rbx
0000000100001489    mov        rcx, qword [ss:rbp+var_80]
000000010000148d    call       imp___stubs__swift_dynamicCast
0000000100001492    test       al, 0x1
0000000100001494    je         0x1000014b0

0000000100001496    mov        qword [ss:rbp+var_70], 0xabcdefc
000000010000149e    lea        rdi, qword [ss:rbp+var_70]
00000001000014a2    jmp        0x1000014f2
00000001000014a4    nop        qword [cs:rax+rax+0x0]

00000001000014b0    mov        qword [ss:rbp+var_48], r15                  ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+532
00000001000014bc    mov        r8d, 0x6
00000001000014c2    lea        rdi, qword [ss:rbp+var_60]
00000001000014c6    lea        rsi, qword [ss:rbp+var_48]
00000001000014ca    mov        rdx, rbx
00000001000014cd    mov        rcx, qword [ss:rbp+var_88]
00000001000014d4    call       imp___stubs__swift_dynamicCast
00000001000014d9    test       al, 0x1
00000001000014db    je         0x100001540

00000001000014e6    mov        qword [ss:rbp+var_68], 0xabcdefd
00000001000014ee    lea        rdi, qword [ss:rbp+var_68]

00000001000014f2    call       __TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_ ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+546
000000010000152f    mov        edi, 0xa                                    ; argument "c" for method imp___stubs__putchar
0000000100001534    call       imp___stubs__putchar

0000000100001548    mov        al, byte [ds:r12+0x19]
000000010000154d    mov        rbx, qword [ds:r12+0x10]
0000000100001552    test       al, al
0000000100001554    je         0x1000015a0

0000000100001566    mov        r14, rax
0000000100001569    test       rbx, rbx
000000010000156c    je         0x100001619

0000000100001582    mov        rsi, qword [ds:0x100018558]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
0000000100001589    mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000158c    call       imp___stubs__objc_msgSend
0000000100001591    mov        r15, rax
000000010000159c    jmp        0x1000015ca
000000010000159e    nop

00000001000015b0    mov        r14, rax
00000001000015b3    test       rbx, rbx
00000001000015b6    mov        r15d, 0x0
00000001000015bc    je         0x1000015ca

00000001000015be    mov        r15, qword [ds:rbx+0x10]

00000001000015d2    mov        rax, qword [ss:rbp+var_78]
00000001000015d6    cmp        rax, r15
00000001000015d9    mov        r15, rax
00000001000015dc    jne        0x100001370

00000001000015f6    add        rsp, 0x68
00000001000015fa    pop        rbx
00000001000015fb    pop        r12
00000001000015fd    pop        r13
00000001000015ff    pop        r14
0000000100001601    pop        r15
0000000100001603    pop        rbp
0000000100001604    ret

0000000100001615    ud2

0000000100001617    ud2                                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+38, __TFC12swift_weekly14ViewController8example1fS0_FT_T_+336, __TFC12swift_weekly14ViewController8example1fS0_FT_T_+387, __TFC12swift_weekly14ViewController8example1fS0_FT_T_+416, __TFC12swift_weekly14ViewController8example1fS0_FT_T_+425

0000000100001619    ud2                                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+88, __TFC12swift_weekly14ViewController8example1fS0_FT_T_+748
000000010000161b    nop        qword [ds:rax+rax+0x0]                      -[_TtC12swift_weekly14ViewController example1]:
0000000100001620    push       rbp                                         ; Objective C Implementation defined at 0x100017708 (instance)
0000000100001621    mov        rbp, rsp
0000000100001624    push       rbx
0000000100001625    push       rax
000000010000162e    mov        rdi, rbx                                    ; argument #1 for method __TFC12swift_weekly14ViewController8example1fS0_FT_T_
0000000100001631    add        rsp, 0x8
0000000100001635    pop        rbx
0000000100001636    pop        rbp
0000000100001637    jmp        __TFC12swift_weekly14ViewController8example1fS0_FT_T_
; endp
000000010000163c    nop        qword [ds:rax+0x0]
```

note that i have removed big chunks of the output assembly because they are all about retain/release codes which aren't relevant to what we are trying to analyse. so this is not the full assembly, but the most interesting part!

this is what the code is doing:

1. in order to do the fast enumeration over our `items` array, swift first has to find out how many items are available in the array. this is how our program finds that out:

	```asm
	00000001000012ee         mov        rsi, qword [ds:0x100018558]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
	00000001000012f5         mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
	00000001000012f8         call       imp___stubs__objc_msgSend
	00000001000012fd         mov        r15, rax
	```

	according to the [System V calling convention](http://goo.gl/mBdSoG), the first parameter to a method call is passed in `rdi` and the next in `rsi` registers. here `rdi` is being set to the address of our `items` array 	and `rsi` is set to the `count` method of the array and once we get the count, we store it in the `r15` general purpose register.
	
2. after we store the count of `items` in the `r15` register, we jump to `0x100001339` which eventually checks if the array is empty and if it is, jumps out of the loop...

	```asm
	0000000100001341         test       r15, r15
	0000000100001344         je         0x1000015e2
	```
	
3. we know that our array is not empty so if we carry on, swift will attempt to get the `n`th object out of the `items` array where `n` is our current implicit loop counter:

	```asm
	0000000100001b6f         lea        rdi, qword [ss:rbp+var_30]                  ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+334
	0000000100001b73         mov        rsi, r15
	0000000100001b76         mov        rdx, r12
	0000000100001b79         call       __TTSCSo8NSObject___TFVSs12_ArrayBufferg9subscriptFSiQ_
	```

	according to the [System V calling convention](http://goo.gl/mBdSoG), `rdi`, `rsi` and `rdx` contain the parameters that are passed to a method in that particular order. here `rdi` is being set to `qword [ss:rbp+0xffffffffffffffd0]` (i decoded the `var_30` value in the address). i have no clue what this is doing. do you? please send a pull request.

	then the `rsi` register is being set to the value inside the `r15` register. that register was previously set to the count of our `items` array so now `rsi` is equal to the count of the array. then the third parameter which is `rdx` is set to `r12` which, if you recall from the beginning of the asm code, was set to the address of the `items` array like so:

	```asm
	00000001000019d1         mov        qword [ss:rbp+var_90], rdi
	00000001000019d8         mov        rax, qword [ds:__TWvdvC12swift_weekly14ViewController5itemsGSaCSo8NSObject_] ; __TWvdvC12swift_weekly14ViewController5itemsGSaCSo8NSObject_
	00000001000019df         mov        r12, qword [ds:rdi+rax]
	00000001000019e3         test       r12, r12
	```

	so:

	* `rdi` is set to (i don't know, do you? send a pull request please)
	* `rsi` is set to `items.count`
	* `rdx` is pointing to the `items` array

	after these values are set, swift is calling the `__TTSCSo8NSObject___TFVSs12_ArrayBufferg9subscriptFSiQ_` internal function which i am not going to get into. 	this is basically a function that takes an array of items, and then extracts a given value out of it. so could it be that `rdi` in this case is the index into the 	`items` array before we call the aforementioned function? maybe! after this call is made, `rax` will be set to the extracted item.
	
4. then i _think_ what is happening next (submit a pull request please if this is incorrect) is that swift is trying to find out if the retrieved item inside the array is an instance of `NSObject` or not and if yes, then it is trying to get its metadata to find out if its of the type that we are conditionally looking for:

	```asm
	0000000100001b7e         mov        r15, qword [ss:rbp+0xffffffffffffffd0]
	0000000100001b82         mov        qword [ss:rbp+var_38], r15
	0000000100001b86         mov        rbx, qword [ds:__TMLCSo8NSObject]           ; __TMLCSo8NSObject
	0000000100001b95         test       rbx, rbx
	0000000100001b98         jne        0x100001bb8

	0000000100001b9a         mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_NSObject] ; imp___got__OBJC_CLASS_$_NSObject
	0000000100001ba1         call       imp___stubs__swift_getInitializedObjCClass
	0000000100001ba6         mov        rdi, rax
	0000000100001ba9         call       imp___stubs__swift_getObjCClassMetadata
	0000000100001bae         mov        rbx, rax
	0000000100001bb1         mov        qword [ds:__TMLCSo8NSObject], rbx           ; __TMLCSo8NSObject
	```

	as you can see, a call is being made to a private internal method called `imp___stubs__swift_getObjCClassMetadata` and as its name explains, i believe it receives an instance of `NSObject` and then retrives 	information about that object, such as its class name.
	
5. now the juicy part is going to happen. this is where swift will try to typecast the enumerated value to `Int`

	```asm
	0000000100001bb8         mov        r8d, 0x6                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+472
	0000000100001bbe         lea        rdi, qword [ss:rbp+0xffffffffffffffc0]
	0000000100001bc2         lea        rsi, qword [ss:rbp+0xffffffffffffffc8]
	0000000100001bc6         mov        rdx, rbx
	0000000100001bc9         mov        rcx, qword [ss:rbp+0xffffffffffffff80]
	0000000100001bcd         call       imp___stubs__swift_dynamicCast
	0000000100001bd2         test       al, 0x1
	0000000100001bd4         je         0x100001bf0
	```

	parameters are passed in `rdi`, `rsi`, `rdx` and `rcx` as explained in [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG). then a magic function called `imp___stubs__swift_dynamicCast` is executed 	to the typecasting. oh shit. so typecasting is done by making a function call in swift. that's not good news if you ask me. imagine performing typecasts in a loop that repeats thousands of times during the 	lifetime of your app. can you live with the performance implications? it's up to you.
	
	then at the end of this call, we check if `al` has a `true` or not and if no, we jump over to `0x100001bf0`. but wait a minute. before discussing that jump, let's see how swift understood that we are 	typecasting our value to `Int`... i've looked at the code for a while (considering that it is quite late at night here), and i cannot, for the life of me, find out how swift is asking for a specific type from 	the  `imp___stubs__swift_dynamicCast` function. so if you do know how this function works, send a pull request and enlighten everybody. thanks.
	
6. as you saw in the previous step, if we could find an `Int`, then we continued on without jumping over to `cs:0x100001bf0` and that could would be:

	```asm
	0000000100001bd6         mov        qword [ss:rbp+var_70], 0xabcdefc
	0000000100001bde         lea        rdi, qword [ss:rbp+var_70]
	0000000100001be2         jmp        0x100001c32
	0000000100001be4         nop        qword [cs:rax+rax+0x0]
	```

	so here our `0xabcdefc` value is loaded into the stack and then the `rdi` register will point to it and we will jump over to `cs:0x100001c32` which is this:

	```asm
	0000000100001c32         call       __TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_ ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+546
	```

	and this is a call to a long-ass function named `__TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_`. this will eventually print our `0xabcdefc` int value to the screen.

7. if we weren't successful in finding the `Int` value, then we would have this code in front of us:

	```asm
	0000000100001bfc         mov        r8d, 0x6
	0000000100001c02         lea        rdi, qword [ss:rbp+0xffffffffffffffa0]
	0000000100001c06         lea        rsi, qword [ss:rbp+0xffffffffffffffb8]
	0000000100001c0a         mov        rdx, rbx
	0000000100001c0d         mov        rcx, qword [ss:rbp+0xffffffffffffff78]
	0000000100001c14         call       imp___stubs__swift_dynamicCast
	0000000100001c19         test       al, 0x1
	0000000100001c1b         je         0x100001c80

	0000000100001c26         mov        qword [ss:rbp+var_68], 0xabcdefd
	0000000100001c2e         lea        rdi, qword [ss:rbp+var_68]
	```
	this is similar to the previous typecasting in that it is using the `imp___stubs__swift_dynamicCast` function to do the typecasting from our `NSObject` to `String`. (note, for some reason, Swift decided to 	turn our whole `items` array into an array of `[NSObject]`, instead of `[AnyObject]` and maybe some of this `NSObject` monkey-business was because of that. Do you know why swift did that? send a pull request 	to fix this up for everybody).

the rest of this code is not magic. so really the important thing that you would want to take away with you is that typecasting in swift is done by an actual function call to an internal and private function called `imp___stubs__swift_dynamicCast`.

Conclusion
===
1. Typecasting of values in Swift is done through an internal function called `imp___stubs__swift_dynamicCast`. Swift tends to typecast dynamically at runtime, rather than compile-time. This obviously has performance implications so keep that in mind.
2. An internal function called `__TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_` does the work for `println()` of `Int` values to the console.

References
===
1. [The Swift Programming Language - Type Casting](http://goo.gl/C15J0l)
2. [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 3A, 3B, and 3C](http://goo.gl/ZBA5oK) 
3. [`X86CallingConv.td`](http://goo.gl/CYOxoB) file, a part of LLVM compiler's open source code
4. [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG)


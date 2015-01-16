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
Build version 6C107a
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

Unconditional Downcasting
===
Let's have a look at unconditional downcasting in swift. as i mentioned before, you can learn about downcasting on [apple's website](http://goo.gl/C15J0l) so i won't teach it here.
imagine you have the following two classes:

```swift
class Vehicle{
    func id() -> Int{
        return 0xabcdefa
    }
}

class Car : Vehicle{
    override func id() -> Int {
        return 0xabcdefc
    }
}
```

and then we do this:

```swift
func example2(){
    let v: Vehicle = Car()
    let c = [v][0] as Car
    println(c)
}
```
so the variable `c` is unconditionally downcasted from the first item in the array that only has `v` as its member. this array is `[Vehicle]` so if we want to get a `Car` object out of it, we have to downcast it, which is what we are doing. So let's see how Swift will compile this code:

```asm
0000000100001740         push       rbp                                         ; XREF=__TFC12swift_weekly14ViewController11viewDidLoadfS0_FT_T_+111, __TToFC12swift_weekly14ViewController11viewDidLoadfS0_FT_T_+119
0000000100001741         mov        rbp, rsp
0000000100001744         push       r15
0000000100001746         push       r14
0000000100001748         push       r13
000000010000174a         push       r12
000000010000174c         push       rbx
000000010000174d         sub        rsp, 0x28
0000000100001751         mov        qword [ss:rbp+var_48], rdi
0000000100001755         mov        r12, qword [ds:__TMLCC12swift_weekly14ViewController3Car] ; __TMLCC12swift_weekly14ViewController3Car
000000010000175c         test       r12, r12
000000010000175f         jne        0x100001777

0000000100001761         lea        rdi, qword [ds:objc_class__TtCC12swift_weekly14ViewController3Car] ; objc_class__TtCC12swift_weekly14ViewController3Car
0000000100001768         call       imp___stubs__swift_getInitializedObjCClass
000000010000176d         mov        r12, rax
0000000100001770         mov        qword [ds:__TMLCC12swift_weekly14ViewController3Car], r12 ; __TMLCC12swift_weekly14ViewController3Car

0000000100001777         mov        esi, 0x10                                   ; XREF=__TFC12swift_weekly14ViewController8example2fS0_FT_T_+31
000000010000177c         mov        edx, 0x7
0000000100001781         mov        rdi, r12
0000000100001784         call       imp___stubs__swift_allocObject
0000000100001789         mov        r14, rax
000000010000178c         lea        rdi, qword [ds:0x10001e210]                 ; 0x10001e210 (_metadata + 0x10)
0000000100001793         mov        esi, 0x20
0000000100001798         mov        edx, 0x7
000000010000179d         call       imp___stubs__swift_allocObject
00000001000017a2         mov        r13, rax
00000001000017a5         mov        qword [ds:r13+0x10], 0x1
00000001000017ad         mov        qword [ds:r13+0x18], r14
00000001000017b1         mov        rbx, qword [ds:__TMLGCSs23_ContiguousArrayStorageCC12swift_weekly14ViewController7Vehicle_] ; __TMLGCSs23_ContiguousArrayStorageCC12swift_weekly14ViewController7Vehicle_
00000001000017b8         test       rbx, rbx
00000001000017bb         jne        0x1000017f5

00000001000017bd         mov        rsi, qword [ds:__TMLCC12swift_weekly14ViewController7Vehicle] ; __TMLCC12swift_weekly14ViewController7Vehicle
00000001000017c4         test       rsi, rsi
00000001000017c7         jne        0x1000017df

00000001000017c9         lea        rdi, qword [ds:objc_class__TtCC12swift_weekly14ViewController7Vehicle] ; objc_class__TtCC12swift_weekly14ViewController7Vehicle
00000001000017d0         call       imp___stubs__swift_getInitializedObjCClass
00000001000017d5         mov        rsi, rax
00000001000017d8         mov        qword [ds:__TMLCC12swift_weekly14ViewController7Vehicle], rsi ; __TMLCC12swift_weekly14ViewController7Vehicle

00000001000017df         mov        rdi, qword [ds:imp___got___TMPdCSs23_ContiguousArrayStorage] ; imp___got___TMPdCSs23_ContiguousArrayStorage, XREF=__TFC12swift_weekly14ViewController8example2fS0_FT_T_+135
00000001000017e6         call       imp___stubs__swift_getGenericMetadata1
00000001000017eb         mov        rbx, rax
00000001000017ee         mov        qword [ds:__TMLGCSs23_ContiguousArrayStorageCC12swift_weekly14ViewController7Vehicle_], rbx ; __TMLGCSs23_ContiguousArrayStorageCC12swift_weekly14ViewController7Vehicle_

00000001000017fd         mov        qword [ss:rbp+var_50], rax
0000000100001801         mov        esi, 0x28
0000000100001806         mov        edx, 0x7
000000010000180b         mov        rdi, rbx
000000010000180e         call       imp___stubs__swift_bufferAllocate
0000000100001813         mov        r14, rax
0000000100001816         mov        qword [ds:r14+0x18], 0x0
000000010000181e         mov        qword [ds:r14+0x10], 0x0
0000000100001826         mov        rdi, r14                                    ; argument "ptr" for method imp___stubs__malloc_size
0000000100001829         call       imp___stubs__malloc_size
000000010000182e         sub        rax, 0x20
0000000100001832         jo         0x1000019d5

0000000100001838         cmp        rax, 0xfffffffffffffff9
000000010000183c         jl         0x1000019d5

0000000100001842         mov        rcx, rax
0000000100001845         sar        rcx, 0x3f
0000000100001849         shr        rcx, 0x3d
000000010000184d         add        rcx, rax
0000000100001850         sar        rcx, 0x3
0000000100001854         lea        rax, qword [ds:rcx+rcx+0x1]
0000000100001859         mov        qword [ds:r14+0x10], 0x1
0000000100001861         mov        qword [ds:r14+0x18], rax
0000000100001865         mov        r15, qword [ds:r13+0x18]
0000000100001869         mov        qword [ds:r14+0x20], r15
000000010000186d         call       imp___stubs___TMaCSs20_IndirectArrayBuffer
0000000100001872         mov        esi, 0x1b
0000000100001877         mov        edx, 0x7
000000010000187c         mov        rdi, rax
000000010000187f         call       imp___stubs__swift_allocObject
0000000100001884         mov        rbx, rax
000000010000188f         xor        eax, eax
0000000100001891         test       r14, r14
0000000100001894         je         0x100001899

0000000100001896         mov        rax, r14

0000000100001899         mov        qword [ds:rbx+0x10], rax                    ; XREF=__TFC12swift_weekly14ViewController8example2fS0_FT_T_+340
000000010000189d         mov        byte [ds:rbx+0x18], 0x1
00000001000018a1         mov        byte [ds:rbx+0x19], 0x0
00000001000018a5         mov        byte [ds:rbx+0x1a], 0x0
00000001000018a9         mov        qword [ss:rbp+var_30], r13
00000001000018ad         lea        rdi, qword [ss:rbp+var_30]
00000001000018b1         call       imp___stubs__swift_fixLifetime
00000001000018bf         mov        al, byte [ds:rbx+0x19]
00000001000018c2         test       al, al
00000001000018c4         je         0x100001906

00000001000018de         mov        r14, rax
00000001000018e1         mov        rdi, rbx
00000001000018e4         call       __TTSCC12swift_weekly14ViewController7Vehicle___TFVSs12_ArrayBufferg5countSi
00000001000018e9         mov        r15, rax
00000001000018fc         test       r15, r15
00000001000018ff         jg         0x100001931

0000000100001901         jmp        0x1000019d5

0000000100001906         mov        r14, qword [ds:rbx+0x10]                    ; XREF=__TFC12swift_weekly14ViewController8example2fS0_FT_T_+388
000000010000190a         test       r14, r14
000000010000190d         je         0x1000019d5

0000000100001913         mov        r15, qword [ds:r14+0x10]
0000000100001927         cmp        r15, 0x0
000000010000192b         jle        0x1000019d5

0000000100001931         lea        rdi, qword [ss:rbp+var_38]                  ; XREF=__TFC12swift_weekly14ViewController8example2fS0_FT_T_+447
0000000100001935         xor        esi, esi
0000000100001937         mov        rdx, rbx
000000010000193a         call       __TTSCC12swift_weekly14ViewController7Vehicle___TFVSs12_ArrayBufferg9subscriptFSiQ_
000000010000193f         mov        rdi, qword [ss:rbp+var_38]
0000000100001943         mov        rsi, r12
0000000100001946         call       imp___stubs__swift_dynamicCastClassUnconditional
000000010000194b         mov        qword [ss:rbp+var_40], rax
0000000100001957         mov        rbx, rax
000000010000195a         lea        rdi, qword [ss:rbp+var_40]
000000010000195e         call       __TTSCC12swift_weekly14ViewController3Car_VSs7_StdoutS2_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_
000000010000199b         mov        edi, 0xa                                    ; argument "c" for method imp___stubs__putchar
00000001000019a0         call       imp___stubs__putchar
00000001000019c6         add        rsp, 0x28
00000001000019ca         pop        rbx
00000001000019cb         pop        r12
00000001000019cd         pop        r13
00000001000019cf         pop        r14
00000001000019d1         pop        r15
00000001000019d3         pop        rbp
00000001000019d4         ret
```

i've cut some of the asm code out of this output since they were doing the retain/release cycles for us, i thought they were quite useless.

now let's focus on this part of our swift code:

```swift
let c = [v][0] as Car
```

this is translated to asm like so:

```asm
0000000100001937         mov        rdx, rbx
000000010000193a         call       __TTSCC12swift_weekly14ViewController7Vehicle___TFVSs12_ArrayBufferg9subscriptFSiQ_
000000010000193f         mov        rdi, qword [ss:rbp+var_38]
0000000100001943         mov        rsi, r12
0000000100001946         call       imp___stubs__swift_dynamicCastClassUnconditional
```

as you can see, swift called a private hidden method called `imp___stubs__swift_dynamicCastClassUnconditional` to __downcast__ the `[Vehicle]` array's first item into a `Car` instance

Conditional Downcasting
===
let's add another class to our combination from the previous section:

```swift
class Bicycle : Vehicle{
    override func id() -> Int {
        return 0xabcdefb
    }
}
```

so now we have a `Car` and a `Bicycle` class and both of them inherit from the `Vehicle` class. now we can put instances of all these classes inside an array, enumerate the array, and conditionally pick the bicycles and the cars:

```swift
func example3(){
    
    let items = [Bicycle(), Car(), Bicycle()]
    for i in items{
        if let b = i as? Bicycle{
            println(0xabcdefd)
        }
        else if let c = i as? Car{
            println(0xabcdefe)
        }
    }
}
```

let's look at the asm:

```asm
0000000100001c80         push       rbp                                         ; XREF=-[_TtC12swift_weekly14ViewController example3]+23
0000000100001c81         mov        rbp, rsp
0000000100001c84         push       r15
0000000100001c86         push       r14
0000000100001c88         push       r13
0000000100001c8a         push       r12
0000000100001c8c         push       rbx
0000000100001c8d         sub        rsp, 0x58
0000000100001c91         mov        qword [ss:rbp+var_78], rdi
0000000100001c95         mov        rbx, qword [ds:__TMLCC12swift_weekly14ViewController7Bicycle] ; __TMLCC12swift_weekly14ViewController7Bicycle
0000000100001c9c         test       rbx, rbx
0000000100001c9f         jne        0x100001cb7

0000000100001ca1         lea        rdi, qword [ds:objc_class__TtCC12swift_weekly14ViewController7Bicycle] ; objc_class__TtCC12swift_weekly14ViewController7Bicycle
0000000100001ca8         call       imp___stubs__swift_getInitializedObjCClass
0000000100001cad         mov        rbx, rax
0000000100001cb0         mov        qword [ds:__TMLCC12swift_weekly14ViewController7Bicycle], rbx ; __TMLCC12swift_weekly14ViewController7Bicycle

0000000100001cb7         mov        esi, 0x10                                   ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+31
0000000100001cbc         mov        edx, 0x7
0000000100001cc1         mov        rdi, rbx
0000000100001cc4         call       imp___stubs__swift_allocObject
0000000100001cc9         mov        r15, rax
0000000100001ccc         mov        rdi, qword [ds:__TMLCC12swift_weekly14ViewController3Car] ; __TMLCC12swift_weekly14ViewController3Car
0000000100001cd3         test       rdi, rdi
0000000100001cd6         jne        0x100001cee

0000000100001cd8         lea        rdi, qword [ds:objc_class__TtCC12swift_weekly14ViewController3Car] ; objc_class__TtCC12swift_weekly14ViewController3Car
0000000100001cdf         call       imp___stubs__swift_getInitializedObjCClass
0000000100001ce4         mov        rdi, rax
0000000100001ce7         mov        qword [ds:__TMLCC12swift_weekly14ViewController3Car], rdi ; __TMLCC12swift_weekly14ViewController3Car

0000000100001cee         mov        qword [ss:rbp+var_70], rdi                  ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+86
0000000100001cf2         mov        esi, 0x10
0000000100001cf7         mov        edx, 0x7
0000000100001cfc         call       imp___stubs__swift_allocObject
0000000100001d01         mov        r12, rax
0000000100001d04         mov        esi, 0x10
0000000100001d09         mov        edx, 0x7
0000000100001d0e         mov        rdi, rbx
0000000100001d11         mov        qword [ss:rbp+var_60], rbx
0000000100001d15         call       imp___stubs__swift_allocObject
0000000100001d1a         mov        rbx, rax
0000000100001d1d         lea        rdi, qword [ds:0x10001e250]                 ; 0x10001e250 (_metadata4 + 0x10)
0000000100001d24         mov        esi, 0x30
0000000100001d29         mov        edx, 0x7
0000000100001d2e         call       imp___stubs__swift_allocObject
0000000100001d33         mov        r14, rax
0000000100001d36         mov        qword [ds:r14+0x10], 0x3
0000000100001d3e         mov        qword [ds:r14+0x20], 0x0
0000000100001d46         mov        qword [ds:r14+0x18], 0x0
0000000100001d4e         mov        qword [ds:r14+0x18], r15
0000000100001d52         mov        qword [ds:r14+0x20], r12
0000000100001d56         mov        qword [ds:r14+0x28], rbx
0000000100001d5a         mov        rdi, qword [ds:__TMLGCSs23_ContiguousArrayStorageCC12swift_weekly14ViewController7Vehicle_] ; __TMLGCSs23_ContiguousArrayStorageCC12swift_weekly14ViewController7Vehicle_
0000000100001d61         test       rdi, rdi
0000000100001d64         jne        0x100001d9e

0000000100001d66         mov        rsi, qword [ds:__TMLCC12swift_weekly14ViewController7Vehicle] ; __TMLCC12swift_weekly14ViewController7Vehicle
0000000100001d6d         test       rsi, rsi
0000000100001d70         jne        0x100001d88

0000000100001d72         lea        rdi, qword [ds:objc_class__TtCC12swift_weekly14ViewController7Vehicle] ; objc_class__TtCC12swift_weekly14ViewController7Vehicle
0000000100001d79         call       imp___stubs__swift_getInitializedObjCClass
0000000100001d7e         mov        rsi, rax
0000000100001d81         mov        qword [ds:__TMLCC12swift_weekly14ViewController7Vehicle], rsi ; __TMLCC12swift_weekly14ViewController7Vehicle

0000000100001d88         mov        rdi, qword [ds:imp___got___TMPdCSs23_ContiguousArrayStorage] ; imp___got___TMPdCSs23_ContiguousArrayStorage, XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+240
0000000100001d8f         call       imp___stubs__swift_getGenericMetadata1
0000000100001d94         mov        rdi, rax
0000000100001d97         mov        qword [ds:__TMLGCSs23_ContiguousArrayStorageCC12swift_weekly14ViewController7Vehicle_], rdi ; __TMLGCSs23_ContiguousArrayStorageCC12swift_weekly14ViewController7Vehicle_

0000000100001d9e         mov        esi, 0x38                                   ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+228
0000000100001da3         mov        edx, 0x7
0000000100001da8         call       imp___stubs__swift_bufferAllocate
0000000100001dad         mov        rbx, rax
0000000100001db0         mov        qword [ds:rbx+0x18], 0x0
0000000100001db8         mov        qword [ds:rbx+0x10], 0x0
0000000100001dc0         mov        rdi, rbx                                    ; argument "ptr" for method imp___stubs__malloc_size
0000000100001dc3         call       imp___stubs__malloc_size
0000000100001dc8         sub        rax, 0x20
0000000100001dcc         jo         0x100002219

0000000100001dd2         cmp        rax, 0xfffffffffffffff9
0000000100001dd6         jl         0x100002219

0000000100001ddc         mov        rcx, r14
0000000100001ddf         add        rcx, 0x18
0000000100001de3         mov        rdx, rax
0000000100001de6         sar        rdx, 0x3f
0000000100001dea         shr        rdx, 0x3d
0000000100001dee         add        rdx, rax
0000000100001df1         sar        rdx, 0x3
0000000100001df5         lea        rax, qword [ds:rdx+rdx+0x1]
0000000100001dfa         mov        qword [ds:rbx+0x10], 0x3
0000000100001e02         mov        qword [ds:rbx+0x18], rax
0000000100001e06         mov        r15, qword [ds:rcx]
0000000100001e09         mov        qword [ds:rbx+0x20], r15
0000000100001e0d         mov        r12, qword [ds:rcx+0x8]
0000000100001e11         mov        qword [ds:rbx+0x28], r12
0000000100001e15         mov        r13, qword [ds:rcx+0x10]
0000000100001e19         mov        qword [ds:rbx+0x30], r13
0000000100001e1d         call       imp___stubs___TMaCSs20_IndirectArrayBuffer
0000000100001e22         mov        esi, 0x1b
0000000100001e27         mov        edx, 0x7
0000000100001e2c         mov        rdi, rax
0000000100001e2f         call       imp___stubs__swift_allocObject
0000000100001e34         mov        qword [ss:rbp+var_50], rax
0000000100001e50         xor        eax, eax
0000000100001e52         test       rbx, rbx
0000000100001e55         je         0x100001e5a

0000000100001e57         mov        rax, rbx

0000000100001e5a         mov        r12, qword [ss:rbp+var_50]                  ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+469
0000000100001e5e         mov        qword [ds:r12+0x10], rax
0000000100001e63         mov        byte [ds:r12+0x18], 0x1
0000000100001e69         mov        byte [ds:r12+0x19], 0x0
0000000100001e6f         mov        byte [ds:r12+0x1a], 0x0
0000000100001e75         mov        qword [ss:rbp+var_30], r14
0000000100001e79         lea        rdi, qword [ss:rbp+var_30]
0000000100001e7d         call       imp___stubs__swift_fixLifetime
0000000100001e8b         mov        al, byte [ds:r12+0x19]
0000000100001e90         test       al, al
0000000100001e92         je         0x100001ef2

0000000100001eac         mov        r15, rax
0000000100001eaf         test       r12, r12
0000000100001eb2         je         0x100002219

0000000100001eb8         mov        rbx, qword [ds:r12+0x10]
0000000100001ebd         test       rbx, rbx
0000000100001ec0         je         0x100002219

0000000100001ed6         mov        rsi, qword [ds:0x10001f668]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
0000000100001edd         mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001ee0         call       imp___stubs__objc_msgSend
0000000100001ee5         mov        r14, rax
0000000100001ef0         jmp        0x100001f27

0000000100001ef2         mov        rbx, qword [ds:r12+0x10]                    ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+530
0000000100001ef7         test       rbx, rbx
0000000100001efa         je         0x1000021cf

0000000100001f00         mov        r14, qword [ds:rbx+0x10]

0000000100001f2f         test       r14, r14
0000000100001f32         je         0x1000021ca

0000000100001f38         xor        eax, eax
0000000100001f3a         mov        r14, r15
0000000100001f3d         mov        qword [ss:rbp+var_68], r15
0000000100001f41         nop        qword [cs:rax+rax+0x0]

0000000100001f50         mov        r13, rax                                    ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+1346
0000000100001f53         lea        rax, qword [ds:r13+0x1]
0000000100001f57         mov        qword [ss:rbp+var_50], rax
0000000100001f5b         mov        al, byte [ds:r12+0x19]
0000000100001f60         test       al, al
0000000100001f62         je         0x100001fc0

0000000100001f7c         mov        rbx, rax
0000000100001f7f         test       r13, r13
0000000100001f82         js         0x100002209

0000000100001f90         mov        rbx, rax
0000000100001f93         mov        rdi, r12
0000000100001f96         mov        r15, r12
0000000100001f99         call       __TTSCC12swift_weekly14ViewController7Vehicle___TFVSs12_ArrayBufferg5countSi
0000000100001f9e         mov        r14, rax
0000000100001fb1         cmp        r13, r14
0000000100001fb4         jl         0x10000201a

0000000100001fb6         jmp        0x100002219
0000000100001fbb         nop        qword [ds:rax+rax+0x0]

0000000100001fc0         mov        rax, r12                                    ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+738
0000000100001fc3         mov        r12, qword [ds:rax+0x10]
0000000100001fc7         mov        r15, rax
0000000100001fca         test       r12, r12
0000000100001fcd         je         0x100002219

0000000100001fd3         mov        rax, qword [ds:r12+0x10]
0000000100001fd8         mov        qword [ss:rbp+var_58], rax
0000000100001fec         mov        rbx, rax
0000000100002007         test       r13, r13
000000010000200a         js         0x100002219

0000000100002010         cmp        r13, qword [ss:rbp+var_58]
0000000100002014         jge        0x100002219

000000010000201a         mov        qword [ss:rbp+var_58], rbx                  ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+820
000000010000201e         lea        rdi, qword [ss:rbp+var_38]
0000000100002022         mov        rsi, r13
0000000100002025         mov        r12, r15
0000000100002028         mov        rdx, r12
000000010000202b         call       __TTSCC12swift_weekly14ViewController7Vehicle___TFVSs12_ArrayBufferg9subscriptFSiQ_
0000000100002030         mov        r14, qword [ss:rbp+var_38]
0000000100002034         mov        rdi, r14
0000000100002037         mov        rsi, qword [ss:rbp+var_60]
000000010000203b         call       imp___stubs__swift_dynamicCastClass
0000000100002040         mov        rbx, rax
0000000100002043         test       rbx, rbx
0000000100002046         je         0x100002070

0000000100002048         mov        qword [ss:rbp+var_48], 0xabcdefd
0000000100002058         mov        r14, rax
000000010000205b         lea        rdi, qword [ss:rbp+var_48]
000000010000205f         jmp        0x10000209b
0000000100002061         nop        qword [cs:rax+rax+0x0]

0000000100002070         mov        rdi, r14                                    ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+966
0000000100002073         mov        rsi, qword [ss:rbp+var_70]
0000000100002077         call       imp___stubs__swift_dynamicCastClass
000000010000207c         mov        rbx, rax
000000010000207f         test       rbx, rbx
0000000100002082         je         0x1000020f1

0000000100002084         mov        qword [ss:rbp+var_40], 0xabcdefe
0000000100002094         mov        r14, rax
0000000100002097         lea        rdi, qword [ss:rbp+var_40]

000000010000209b         call       __TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_ ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+991
00000001000020d8         mov        edi, 0xa                                    ; argument "c" for method imp___stubs__putchar
00000001000020dd         call       imp___stubs__putchar

00000001000020f9         mov        al, byte [ds:r12+0x19]
00000001000020fe         test       al, al
0000000100002100         je         0x100002160

0000000100002113         mov        r14, rax
0000000100002116         cmp        qword [ss:rbp+var_68], 0x0
000000010000211b         je         0x100002219

0000000100002121         mov        rbx, qword [ds:r12+0x10]
0000000100002126         mov        r13, r12
0000000100002129         test       rbx, rbx
000000010000212c         je         0x100002219

0000000100002142         mov        rsi, qword [ds:0x10001f668]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
0000000100002149         mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000214c         call       imp___stubs__objc_msgSend
0000000100002151         mov        r12, rax
000000010000215c         jmp        0x1000021b0
000000010000215e         nop        

0000000100002160         mov        rbx, qword [ds:r12+0x10]                    ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+1152
0000000100002165         mov        r13, r12
0000000100002168         test       rbx, rbx
000000010000216b         mov        r14, qword [ss:rbp+var_58]
000000010000216f         je         0x100002192

0000000100002171         mov        r12, qword [ds:rbx+0x10]
0000000100002190         jmp        0x1000021b0

000000010000219a         mov        r14, rax
00000001000021a4         xor        r12d, r12d
00000001000021a7         nop        qword [ds:rax+rax+0x0]

00000001000021b8         mov        rax, qword [ss:rbp+var_50]
00000001000021bc         cmp        rax, r12
00000001000021bf         mov        r12, r13
00000001000021c2         jne        0x100001f50

00000001000021c8         jmp        0x1000021e1

00000001000021ca         mov        r14, r15                                    ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+690
00000001000021cd         jmp        0x1000021e1

00000001000021de         mov        r14, rax

00000001000021fa         add        rsp, 0x58
00000001000021fe         pop        rbx
00000001000021ff         pop        r12
0000000100002201         pop        r13
0000000100002203         pop        r14
0000000100002205         pop        r15
0000000100002207         pop        rbp
0000000100002208         ret
```

so let's see what happens in the loop:

1. first we get the current item our of the array:

	```asm
	000000010000201a         mov        qword [ss:rbp+var_58], rbx                  ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+820
	000000010000201e         lea        rdi, qword [ss:rbp+var_38]
	0000000100002022         mov        rsi, r13
	0000000100002025         mov        r12, r15
	0000000100002028         mov        rdx, r12
	000000010000202b         call       __TTSCC12swift_weekly14ViewController7Vehicle___TFVSs12_ArrayBufferg9subscriptFSiQ_
	```

2. then it is attempting to downcast the object into an object of type `Bicycle`

	```asm
	0000000100002030         mov        r14, qword [ss:rbp+var_38]
	0000000100002034         mov        rdi, r14
	0000000100002037         mov        rsi, qword [ss:rbp+var_60]
	000000010000203b         call       imp___stubs__swift_dynamicCastClass
	```

	weird with the `r14` register `mov` and then straight into the `rdi` register. this could be optimized to:

	```asm
	mov        rdi, qword [ss:rbp+var_38]
	```

	so that we could get rid of the `mov` to `r14`. do you know why swift did this? send a pull request and enhance this article. it turns out conditional 	downcasting is done with a different method that is used for unconditional downcasting. the `imp___stubs__swift_dynamicCastClass` function seems to return a 	boolean as we will see soon.

3. the return value of the `imp___stubs__swift_dynamicCastClass` will then be checked as a boolean to see if the object could be dynamically downcasted to `Bicycle`:

	```asm
	0000000100002040         mov        rbx, rax
	0000000100002043         test       rbx, rbx
	0000000100002046         je         0x100002070
	```

4. if the downcasting was successful, we will print our value to the console:

	```asm
	0000000100002048         mov        qword [ss:rbp+var_48], 0xabcdefd
	0000000100002058         mov        r14, rax
	000000010000205b         lea        rdi, qword [ss:rbp+var_48]
	000000010000205f         jmp        0x10000209b
	0000000100002061         nop        qword [cs:rax+rax+0x0]
	```

	the jump is obviously to a `println()` statement

5. if the downcasting didn't work, we jumped to `0x100002070`:

	```asm
	0000000100002070         mov        rdi, r14                                    ; XREF=__TFC12swift_weekly14ViewController8example3fS0_FT_T_+966
	0000000100002073         mov        rsi, qword [ss:rbp+var_70]
	0000000100002077         call       imp___stubs__swift_dynamicCastClass
	000000010000207c         mov        rbx, rax
	000000010000207f         test       rbx, rbx
	0000000100002082         je         0x1000020f1
	```

you get the picture. basically, conditional downcasts work in this way:

1. the `imp___stubs__swift_dynamicCastClass` internal function is called to attempt to downcast the value to the desired class
2. this function returns a bool, indicating whether the downcasting was successful or not.

Conclusion
===
1. Typecasting of values in Swift is done through an internal function called `imp___stubs__swift_dynamicCast`. Swift tends to typecast dynamically at runtime, rather than compile-time. This obviously has performance implications so keep that in mind.
2. An internal function called `__TTSSi_VSs7_StdoutS_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_` does the work for `println()` of `Int` values to the console.
3. Unconditional downcasts in Swift are done with a call to an internal function called `imp___stubs__swift_dynamicCastClassUnconditional`, at runtime.
4. Swift tends to use an internal function called `ArrayBufferg9subscriptFSiQ_` to extract objects out of an array.
5. Conditional downcasts are done with an internal function called `imp___stubs__swift_dynamicCastClass`.
6. Conditional downcasts are different from unconditional ones since they also have to check the return value of the `imp___stubs__swift_dynamicCastClass` for true/false. They are therefore slower than unconditional downcasts.

References
===
1. [The Swift Programming Language - Type Casting](http://goo.gl/C15J0l)
2. [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 3A, 3B, and 3C](http://goo.gl/ZBA5oK) 
3. [`X86CallingConv.td`](http://goo.gl/CYOxoB) file, a part of LLVM compiler's open source code
4. [System V AMD64 ABI calling convention](http://goo.gl/mBdSoG)


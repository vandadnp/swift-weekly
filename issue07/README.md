__WORK IN PROGRESS__

Swift Weekly - Issue 07 - The Swift Runtime (Part 5) - Operators
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
I thought I'd write about operators a bit in this issue. I don't like to _teach_ how operators work, but rather show you some cool things that we can do with operators. but then again, many websites do that already. you can just search online and find hundreds, if not thousands of blogs/websites that can teach you how to use operators and how to create your own in Swift. so how can i be different and offer something else? well, we will talk about operators in this issue and how to write your own, __but__, i will also show you how custom operators are compiled by the Swift compiler.

I have the latest Xcode beta (at the time of this writing, doh!). When I run `xcrun xcodebuild -version`, i get this:

```bash
Xcode 6.2
Build version 6C101
```

so you may get different results for your output assembly depending on your compiler version. also, I am using the release version of the build to ensure the output assembly is as optimized as it can get.

A `+` Operator on `UIImage`
===
Let's say you have `img1` and `img2` and you want to put them horizontally next to each other into a new image. how can we do that? well, you'll have to create a new canvas that is big enough to contain both images and then use Core Graphics or a third party library to do this. so let's create a new `+` operator on `UIImage` that takes two images and then outputs a new image that contains both images:

```swift
extension UIImage{
    var width: CGFloat{get{return self.size.width}}
    var height: CGFloat{get{return self.size.height}}
}

infix operator +{associativity left}
func +(l: UIImage, r: UIImage) -> UIImage{
    let s = CGSize(width: l.width + r.width, height: l.height > r.height ? l.height : r.height)
    UIGraphicsBeginImageContextWithOptions(s, true, 0.0)
    l.drawAtPoint(CGPointZero)
    r.drawAtPoint(CGPoint(x: l.width, y: 0.0))
    let i = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return i
}
```

and then you can go ahead and use it like so:

```swift
func example1(){
    let img1 = UIImage(named: "1")!
    let img2 = UIImage(named: "2")!
    let mix = img1 + img2
}

```

makes you think why Apple didn't do this in the first place on UIImage. the code is very simple really. nothing special here. now let's look at the output assembly for this code:

```asm
0000000100001d70  push       rbp                                         ; Objective C Implementation defined at 0x1000052d0 (instance)
0000000100001d71  mov        rbp, rsp
0000000100001d74  push       r15
0000000100001d76  push       r14
0000000100001d78  push       r12
0000000100001d7a  push       rbx
0000000100001d7b  sub        rsp, 0x20
0000000100001d87  lea        rdi, qword [ds:___unnamed_1]                ; "1"
0000000100001d8e  mov        esi, 0x1
0000000100001d93  xor        edx, edx
0000000100001d95  call       imp___stubs__swift_convertStringToNSString
0000000100001d9a  mov        rbx, rax
0000000100001d9d  mov        rdi, qword [ds:imp___got__OBJC_CLASS_$_UIImage] ; imp___got__OBJC_CLASS_$_UIImage
0000000100001da4  call       imp___stubs__swift_getInitializedObjCClass
0000000100001da9  mov        r12, rax
0000000100001dac  mov        rsi, qword [ds:0x100005f38]                 ; @selector(imageNamed:), argument "selector" for method imp___stubs__objc_msgSend
0000000100001db3  mov        rdi, r12                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001db6  mov        rdx, rbx
0000000100001db9  call       imp___stubs__objc_msgSend
0000000100001dc6  mov        r15, rax
0000000100001dd1  test       r15, r15
0000000100001dd4  je         0x100001ff1

0000000100001dda  lea        rdi, qword [ds:___unnamed_2]                ; "2"
0000000100001de1  mov        esi, 0x1
0000000100001de6  xor        edx, edx
0000000100001de8  call       imp___stubs__swift_convertStringToNSString
0000000100001ded  mov        rbx, rax
0000000100001df0  mov        rsi, qword [ds:0x100005f38]                 ; @selector(imageNamed:), argument "selector" for method imp___stubs__objc_msgSend
0000000100001df7  mov        rdi, r12                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001dfa  mov        rdx, rbx
0000000100001dfd  call       imp___stubs__objc_msgSend
0000000100001e0a  mov        r12, rax
0000000100001e15  test       r12, r12
0000000100001e18  je         0x100001ff1

0000000100001e1e  mov        rbx, qword [ds:0x100005f20]                 ; @selector(width)
0000000100001e3d  mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001e40  mov        rsi, rbx                                    ; argument "selector" for method imp___stubs__objc_msgSend
0000000100001e43  call       imp___stubs__objc_msgSend
0000000100001e48  movsd      xmmword [ss:rbp+var_38], xmm0
0000000100001e4d  mov        rbx, qword [ds:0x100005f20]                 ; @selector(width)
0000000100001e5c  mov        rdi, r12                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001e5f  mov        rsi, rbx                                    ; argument "selector" for method imp___stubs__objc_msgSend
0000000100001e62  call       imp___stubs__objc_msgSend
0000000100001e67  addsd      xmm0, xmmword [ss:rbp+var_38]
0000000100001e6c  movsd      xmmword [ss:rbp+var_38], xmm0
0000000100001e79  mov        rsi, qword [ds:0x100005f28]                 ; @selector(height), argument "selector" for method imp___stubs__objc_msgSend
0000000100001e80  mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001e83  call       imp___stubs__objc_msgSend
0000000100001e88  movsd      xmmword [ss:rbp+var_40], xmm0
0000000100001e8d  mov        rbx, qword [ds:0x100005f28]                 ; @selector(height)
0000000100001e9c  mov        rdi, r12                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001e9f  mov        rsi, rbx                                    ; argument "selector" for method imp___stubs__objc_msgSend
0000000100001ea2  call       imp___stubs__objc_msgSend
0000000100001ea7  mov        rax, qword [ds:imp___got___TWPV12CoreGraphics7CGFloatSs11_Comparable] ; imp___got___TWPV12CoreGraphics7CGFloatSs11_Comparable
0000000100001eae  mov        rax, qword [ds:rax]
0000000100001eb1  movsd      xmmword [ss:rbp+var_28], xmm0
0000000100001eb6  movsd      xmm0, qword [ss:rbp+var_40]
0000000100001ebb  movsd      xmmword [ss:rbp+var_30], xmm0
0000000100001ec0  mov        rdx, qword [ds:imp___got___TMdV12CoreGraphics7CGFloat] ; imp___got___TMdV12CoreGraphics7CGFloat
0000000100001ec7  add        rdx, 0x8
0000000100001ecb  lea        rdi, qword [ss:rbp+var_28]
0000000100001ecf  lea        rsi, qword [ss:rbp+var_30]
0000000100001ed3  mov        rcx, rdx
0000000100001ed6  call       rax
0000000100001ed8  mov        bl, al
0000000100001eea  mov        rsi, qword [ds:0x100005f28]                 ; @selector(height)
0000000100001ef1  test       bl, 0x1
0000000100001ef4  je         0x100001efb

0000000100001ef6  mov        rdi, r15
0000000100001ef9  jmp        0x100001efe

0000000100001efb  mov        rdi, r12                                    ; XREF=-[_TtC12swift_weekly14ViewController example1]+388

0000000100001efe  call       imp___stubs__objc_msgSend                   ; XREF=-[_TtC12swift_weekly14ViewController example1]+393
0000000100001f03  movsd      xmmword [ss:rbp+var_40], xmm0
0000000100001f18  mov        edi, 0x1
0000000100001f1d  call       imp___stubs___TF10ObjectiveC22_convertBoolToObjCBoolFSbVS_8ObjCBool
0000000100001f22  movzx      edi, al
0000000100001f25  and        edi, 0x1
0000000100001f28  xorps      xmm2, xmm2
0000000100001f2b  movsd      xmm0, qword [ss:rbp+var_38]
0000000100001f30  movsd      xmm1, qword [ss:rbp+var_40]
0000000100001f35  call       imp___stubs__UIGraphicsBeginImageContextWithOptions
0000000100001f3a  mov        rax, qword [ds:imp___got__CGPointZero]      ; imp___got__CGPointZero
0000000100001f41  movsd      xmm0, qword [ds:rax]
0000000100001f45  movsd      xmm1, qword [ds:rax+0x8]
0000000100001f4a  mov        rsi, qword [ds:0x100005f30]                 ; @selector(drawAtPoint:), argument "selector" for method imp___stubs__objc_msgSend
0000000100001f51  mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001f54  call       imp___stubs__objc_msgSend
0000000100001f69  mov        rsi, qword [ds:0x100005f20]                 ; @selector(width), argument "selector" for method imp___stubs__objc_msgSend
0000000100001f70  mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001f73  call       imp___stubs__objc_msgSend
0000000100001f78  mov        rsi, qword [ds:0x100005f30]                 ; @selector(drawAtPoint:), argument "selector" for method imp___stubs__objc_msgSend
0000000100001f7f  xorps      xmm1, xmm1
0000000100001f82  mov        rdi, r12                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001f85  call       imp___stubs__objc_msgSend
0000000100001f9a  call       imp___stubs__UIGraphicsGetImageFromCurrentImageContext
0000000100001fa7  mov        rbx, rax
0000000100001faa  call       imp___stubs__UIGraphicsEndImageContext
0000000100001faf  test       rbx, rbx
0000000100001fb2  je         0x100001ff1

0000000100001fe4  add        rsp, 0x20
0000000100001fe8  pop        rbx
0000000100001fe9  pop        r12
0000000100001feb  pop        r14
0000000100001fed  pop        r15
0000000100001fef  pop        rbp
0000000100001ff0  ret
```

i've left the `cs` addresses so that we can interpret the conditional jumps in the code. i have also removed some of the calls to retain and release in the code. we all know about those so no need to keep them in the asm. let's see what happened here:

1. the stack is being set up
2. the first image is being loaded into the memory
3. then the code for our size calculation is compiled `let s = CGSize(width: l.width + r.width, height: l.height > r.height ? l.height : r.height)`. this shows that our `+` operator on the `UIImage` class was injected directly into our `example1()` function. [The Swift compiler tends to do that](http://goo.gl/mP9YaY).
4. the second parameter to the `UIGraphicsBeginImageContextWithOptions()` function is a boolean value of `yes` but that is a Swift boolean value and it seems like the compiler calls a private function called `imp___stubs___TF10ObjectiveC22_convertBoolToObjCBoolFSbVS_8ObjCBool()` to convert our Swift boolean to its objc counterpart. This is not good from the optimization perspective. Swift doesn't seem to have built-in support for internal types between Swift <-> ObjC so keep that in mind.
4. then the call to the `UIGraphicsBeginImageContextWithOptions()` function happens with our parameters loaded into the `xmm0`, `xmm1` and `xmm2` but not in that order in the code. it's strange that the parameters are all loaded into SIMD registers. the instruction that is used to load these registers with their values is the `movsd` and as mentioned in [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 3A, 3B, and 3C](http://goo.gl/ZBA5oK) 

	> Move scalar double-precision floating-point value from xmm2/m64 to xmm1 register.
	
	but then it also says:
	
	> MOVSD (128-bit Legacy SSE version: MOVSD XMM1, XMM2)	> DEST[63:0]  SRC[63:0] DEST[VLMAX-1:64] (Unmodified)
	
	so it seems  like the `movsd` instruction can operate on single and double precision floating point values under 64-bit or 128-bit modes. so that means when the compiler did this:
	
	```asm
	movsd      xmm0, qword [ss:rbp+var_38]
	```
	
	that it moved the value of our `CGSize` variable `s` into the `xmm0` 64-bit register, as the first parameter to the `UIGraphicsBeginImageContextWithOptions()` function. 
	
	and this:
	
	```asm
	movsd      xmm1, qword [ss:rbp+var_40]
	```
	
	placed the value of `true` inside the 64-bit `xmm1` register. but why are all these small values being placed inside `xmm` 64-bit registers. if we look at the function definition:
	
	```swift
	func UIGraphicsBeginImageContextWithOptions(size: CGSize, opaque: Bool, scale: CGFloat)
	```
	
	you'll realize that the first parameter is a CGSize which is defined like so:
	
	```swift
	struct CGSize {
	    var width: CGFloat
	    var height: CGFloat
	}
	```
	
	2x single precision floating point values. so we can just put them both straight into a 64-bit double precision register of `xmm0`. so this is a hell of an optimization. the compiler looked at the first
	parameter to the `UIGraphicsBeginImageContextWithOptions()` function and realized that it can fit that value into a 64-bit SIMD register, then it thought to itself, f* it, i'll put all the other parameter 	values inside SIMD registers as well, to make it easier perhaps for the aforementioned function to retrieve its parameters. so i was quite curious to find out why this is happening and it turns out, well, 	this is how LLVM does it. check this out: [`X86CallingConv.td`](http://goo.gl/CYOxoB) file, a part of LLVM compiler's open source code. cool to know!
	
5. then we are doing this in our code:

	```swift
	l.drawAtPoint(CGPointZero)
	```
	
	in order to draw the image on the left hand side of the custom `+` operator on `UIImage` and the code for that comes out like so:
	
	```asm
	0000000100001f3a         mov        rax, qword [ds:imp___got__CGPointZero]      ; imp___got__CGPointZero
	0000000100001f41         movsd      xmm0, qword [ds:rax]
	0000000100001f45         movsd      xmm1, qword [ds:rax+0x8]
	0000000100001f4a         mov        rsi, qword [ds:0x100005f30]                 ; @selector(drawAtPoint:), argument "selector" for method imp___stubs__objc_msgSend
	0000000100001f51         mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_msgSend
	0000000100001f54         call       imp___stubs__objc_msgSend
	```
	
	it seems like throughout a method implementation, that the `rdi` register consistently keeps a reference to the object on which we want to perform a method. For instance, performing the `drawAtPoint:` 	selector on a `UIImage` instance, the `rdi` register keeps the instance and the `rsi` register keeps the reference to the selector name in the `ds`.
	
	it also appears like the value of `CGPointZero` is already compiled and placed inside the data segment of our binary. no system call is made to retrieve this value. then, the `xmm0` SIMD register is 	loaded with the `width` of the point and the `xmm1` register with the `height` value of this point. notice the `ds:rax+0x8`? that means the `width` was 8 bytes long so we had to jump over it to get to the 	`height` value. so basically `CGFloat` in Swift is 64-bits long. not rocket science. since `CGPointZero` is compiled into the data segment of our binary, speeding things up, instead of making a system 	call to get its value, I'm curious to know if the same thing would happen if we created a point with the x and y values explicitly set to 0 like so `CGPoint(x: 0, y: 0)`. i ran the experiment and got the 	following assembly code:
	
	```asm
	0000000100001f05         xor        edi, edi
	0000000100001f07         xor        esi, esi
	0000000100001f09         call       imp___stubs___TFE12CoreGraphicsVSC7CGPointCfMS0_FT1xSi1ySi_S0_
	```
	
	so if you want a zero `CGPoint`, use the `CGPointZero`. this will compile the zero point into your binary's data segment whereas a call to `CGPoint()`'s constructor with the values of (0, 0) will call a 	system function called `imp___stubs___TFE12CoreGraphicsVSC7CGPointCfMS0_FT1xSi1ySi_S0_` internally. this is not as optimized as reading from the data segment.
	
	then `rsi` is being loaded with the selector value of `drawAtPoint:`, `rdi` is the instance of the `UIImage` on which we want to perform the selector and then bam! the message is dispatched, objective-c 	style! boomshakalaka!
	
	the `drawAtPoint:` method on `UIImage` takes in a `CGPoint` as its parameter and as we've seen already, this value is loaded into the `xmm0` and then `xmm1` registers, confirming that the `movsd` 	instruction is loading 64-bit `CGFloat` values indeed into our SIMD registers.
	

Conclusion
===
1. Boolean values in Swift are converted to their ObjC counterparts using an internal function called `imp___stubs___TF10ObjectiveC22_convertBoolToObjCBoolFSbVS_8ObjCBool()`. Swift booleans are not usable by Objective-C without the compiler's intervention. keep that in mind. This will have an effect on how fast your apps run especially if you are using an Objective-C physics library or 2D/3D gaming library.
2. whenever possible after all optimizations are done, the LLVM compiler passes parameters to functions that ask for 64-bit values as parameters, inside the SIMD registers, starting with `xmm0` and then onto `xmm1` and so on...
3. it seems like throughout a method implementation, that the `rdi` register consistently keeps a reference to the object on which we want to perform a method. For instance, performing the `drawAtPoint:` selector on a `UIImage` instance, the `rdi` register keeps the instance and the `rsi` register keeps the reference to the selector name in the `ds`.
4. `CGFloat` is truly a 64-bit value in x86_64 in Swift
5. The value of `CGPointZero` will be compiled into the data segment of your binary. no system call will be made to retrieve this value.
6. If you want a zero `CGPoint`, use the `CGPointZero`. this will compile the zero point into your binary's data segment whereas a call to `CGPoint()`'s constructor with the values of (0, 0) will call a 	system function called `imp___stubs___TFE12CoreGraphicsVSC7CGPointCfMS0_FT1xSi1ySi_S0_` internally. this is not as optimized as reading from the data segment.

References
===
1. [Intel® 64 and IA-32 Architectures Software Developer’s Manual Combined Volumes: 1, 2A, 2B, 2C, 3A, 3B, and 3C](http://goo.gl/ZBA5oK) 
2. [`X86CallingConv.td`](http://goo.gl/CYOxoB) file, a part of LLVM compiler's open source code


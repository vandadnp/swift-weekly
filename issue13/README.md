Swift Weekly - Issue 13 - Loops
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
I've never made it a secret that I love assembly code so in this article I'd like to have a look at creating various loops in Swift and checking out the underlying ARM assembly code with full optimization turned on. We will then have a look at the code and find out how it works and perhaps even find out which loop translates to the best underlying ARM assembly code by the compiler. So my build setting is as follows:

```
//:configuration = Debug
GCC_OPTIMIZATION_LEVEL = s
SWIFT_OPTIMIZATION_LEVEL = -Owholemodule
```

One thing that I'd like to get out of the way is that I have absolutely no idea experience writing or reading ARM assembly code! so this will be a first time for me. If you can correct any mistakes which I might have made, [contact me](mailto:vandad.np@gmail.com); I'll try to update the article and if I cannot, you're more than welcome to send a PR.

My setup is as follows:

Swift Version

```
swift --version
Apple Swift version 4.0.2 (swiftlang-900.0.69.2 clang-900.0.38)
Target: x86_64-apple-macosx10.9
```

I am also compiling the code for SDK=iphoneos and all available ARM architectures, including armv7, armv7s and arm64.


Traditional `for` Loop
===

Here is a simple `for` loop:

```swift
@inline(never)
func traditionalForLoop() {
    
    for value in 0...0xDEADBEEF {
        if value % 2 == 0 {
            print(value)
        }
    }
    
}
```

It doesn't really do anything special but it allows us to get the assembled code by searching for its name in the code segment and then analyzing the results. Here is the ARM64 generated code from *xcodebuild*:

```asm
0x0000000100005f78 FFC301D1                        sub        sp, sp, #0x70     ; XREF=-[_TtC12swift_weekly11AppDelegate application:didFinishLaunchingWithOptions:]+200
0x0000000100005f7c FC6F01A9                        stp        x28, x27, [sp, #0x10]
0x0000000100005f80 FA6702A9                        stp        x26, x25, [sp, #0x20]
0x0000000100005f84 F85F03A9                        stp        x24, x23, [sp, #0x30]
0x0000000100005f88 F65704A9                        stp        x22, x21, [sp, #0x40]
0x0000000100005f8c F44F05A9                        stp        x20, x19, [sp, #0x50]
0x0000000100005f90 FD7B06A9                        stp        x29, x30, [sp, #0x60]
0x0000000100005f94 FD830191                        add        x29, sp, #0x60
0x0000000100005f98 170080D2                        movz       x23, #0x0
0x0000000100005f9c B85FF2D2                        movz       x24, #0x92fd, lsl #48
0x0000000100005fa0 1834D3F2                        movk       x24, #0x99a0, lsl #32
0x0000000100005fa4 B8FCA0F2                        movk       x24, #0x7e5, lsl #16
0x0000000100005fa8 38E083F2                        movk       x24, #0x1f01
0x0000000100005fac B9DD9B52                        movz       w25, #0xdeed
0x0000000100005fb0 FB031F32                        orr        w27, wzr, #0x2
0x0000000100005fb4 1F2003D5                        nop        
0x0000000100005fb8 9A020158                        ldr        x26, #0x100008008
0x0000000100005fbc BCD5BB52                        movz       w28, #0xdead, lsl #16
0x0000000100005fc0 FCDD9772                        movk       w28, #0xbeef

0x0000000100005fc4 E87E589B                        smulh      x8, x23, x24      ; XREF=__T012swift_weekly11AppDelegateC18traditionalForLoopyyFTf4d_n+272
0x0000000100005fc8 0801178B                        add        x8, x8, x23
0x0000000100005fcc 09FD4F93                        asr        x9, x8, #0xf
0x0000000100005fd0 28FD488B                        add        x8, x9, x8, lsr #63
0x0000000100005fd4 08DD199B                        msub       x8, x8, x25, x23
0x0000000100005fd8 080500B5                        cbnz       x8, 0x100006078

0x0000000100005fdc 1F2003D5                        nop        
0x0000000100005fe0 C0B30158                        ldr        x0, #0x100009658
0x0000000100005fe4 000200B5                        cbnz       x0, 0x100006024

0x0000000100005fe8 1F2003D5                        nop        
0x0000000100005fec 20B30158                        ldr        x0, #0x100009650
0x0000000100005ff0 200100B5                        cbnz       x0, 0x100006014

0x0000000100005ff4 E0030032                        orr        w0, wzr, #0x1
0x0000000100005ff8 E3230091                        add        x3, sp, #0x8
0x0000000100005ffc 010080D2                        movz       x1, #0x0
0x0000000100006000 020080D2                        movz       x2, #0x0          ; argument #1 for method _swift_rt_swift_getExistentialTypeMetadata
0x0000000100006004 6F000094                        bl         _swift_rt_swift_getExistentialTypeMetadata
0x0000000100006008 48B20110                        adr        x8, #0x100009650
0x000000010000600c 1F2003D5                        nop        
0x0000000100006010 00FD9FC8                        stlr       x0, [x8]

0x0000000100006014 97000094                        bl         imp___stubs___T0s23_ContiguousArrayStorageCMa ; XREF=__T012swift_weekly11AppDelegateC18traditionalForLoopyyFTf4d_n+120
0x0000000100006018 08B20110                        adr        x8, #0x100009658
0x000000010000601c 1F2003D5                        nop        
0x0000000100006020 00FD9FC8                        stlr       x0, [x8]

0x0000000100006024 E1031A32                        orr        w1, wzr, #0x40    ; XREF=__T012swift_weekly11AppDelegateC18traditionalForLoopyyFTf4d_n+108
0x0000000100006028 E20B0032                        orr        w2, wzr, #0x7
0x000000010000602c 6A000094                        bl         _swift_rt_swift_allocObject
0x0000000100006030 F30300AA                        mov        x19, x0
0x0000000100006034 E8030032                        orr        w8, wzr, #0x1
0x0000000100006038 686E01A9                        stp        x8, x27, [x19, #0x10]
0x000000010000603c 7A1E00F9                        str        x26, [x19, #0x38]
0x0000000100006040 771200F9                        str        x23, [x19, #0x20]
0x0000000100006044 91000094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA0_
0x0000000100006048 F40300AA                        mov        x20, x0
0x000000010000604c F50301AA                        mov        x21, x1
0x0000000100006050 F60302AA                        mov        x22, x2
0x0000000100006054 90000094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA1_
0x0000000100006058 E40300AA                        mov        x4, x0
0x000000010000605c E50301AA                        mov        x5, x1
0x0000000100006060 E60302AA                        mov        x6, x2
0x0000000100006064 E00313AA                        mov        x0, x19
0x0000000100006068 E10314AA                        mov        x1, x20
0x000000010000606c E20315AA                        mov        x2, x21
0x0000000100006070 E30316AA                        mov        x3, x22
0x0000000100006074 82000094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortF

0x0000000100006078 FF021CEB                        cmp        x23, x28          ; XREF=__T012swift_weekly11AppDelegateC18traditionalForLoopyyFTf4d_n+96
0x000000010000607c A0000054                        b.eq       0x100006090

0x0000000100006080 FF0600B1                        cmn        x23, #0x1
0x0000000100006084 F7060091                        add        x23, x23, #0x1
0x0000000100006088 E7F9FF54                        b.vc       0x100005fc4

0x000000010000608c 200020D4                        brk        #0x1

0x0000000100006090 FD7B46A9                        ldp        x29, x30, [sp, #0x60] ; XREF=__T012swift_weekly11AppDelegateC18traditionalForLoopyyFTf4d_n+260
0x0000000100006094 F44F45A9                        ldp        x20, x19, [sp, #0x50]
0x0000000100006098 F65744A9                        ldp        x22, x21, [sp, #0x40]
0x000000010000609c F85F43A9                        ldp        x24, x23, [sp, #0x30]
0x00000001000060a0 FA6742A9                        ldp        x26, x25, [sp, #0x20]
0x00000001000060a4 FC6F41A9                        ldp        x28, x27, [sp, #0x10]
0x00000001000060a8 FFC30191                        add        sp, sp, #0x70
0x00000001000060ac C0035FD6                        ret
```

I will have to fire up ARM's reference manual to be able to understand all these instructions but I don't think it's a good idea to just put some assembly code in here and analyze it. Instead, we will look at some of the calls which are executed in this code and find out how they work and what they do.


Here are the external calls which the Swift compiler seems to be making in this routine:

* `_swift_rt_swift_getExistentialTypeMetadat`
* `imp___stubs___T0s23_ContiguousArrayStorageCMa`
* `imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA0_`

I couldn't find any information about the `getExistentialTypeMetadata` call in this context but I kind of can make a guess as to what it does and what it tries to achieve but it's good to confirm. I just cloned `apple/swift` repo from GitHub and went through the compiler code to find the following extract in the *Metadata.cpp* file:

```cpp
/// \brief Fetch a uniqued metadata for an existential type. The array
/// referenced by \c protocols will be sorted in-place.
const ExistentialTypeMetadata *
swift::swift_getExistentialTypeMetadata(
                                  ProtocolClassConstraint classConstraint,
                                  const Metadata *superclassConstraint,
                                  size_t numProtocols,
                                  const ProtocolDescriptor * const *protocols)
    SWIFT_CC(RegisterPreservingCC_IMPL) {

  // We entrust that the compiler emitting the call to
  // swift_getExistentialTypeMetadata always sorts the `protocols` array using
  // a globally stable ordering that's consistent across modules.

  // Ensure that the "class constraint" bit is set whenever we have a
  // superclass or a one of the protocols is class-bound.
  assert(classConstraint == ProtocolClassConstraint::Class ||
         (!superclassConstraint &&
          !anyProtocolIsClassBound(numProtocols, protocols)));
  ExistentialCacheEntry::Key key = {
    superclassConstraint, classConstraint, numProtocols, protocols
  };
  return &ExistentialTypes.getOrInsert(key).first->Data;
}
```

The assembled code for this procedure is also embedded in our binary, and is as follows:

```asm
0x00000001000061c4 28F30058  ldr        x8, #0x100008028
0x00000001000061c8 040140F9  ldr        x4, [x8]
0x00000001000061cc 00000012  and        w0, w0, #0x1
0x00000001000061d0 80001FD6  br         x4
                        ; endp
```

The assembly code doesn't tell me much so I'm now looking at the top comment on the CPP code and I see the following:

```cpp
/// \brief Fetch a uniqued metadata for an existential type. The array
/// referenced by \c protocols will be sorted in-place.
```

So it seems like this call is just retrieving some metadata for a data type with the `bl` instruction, which is "Branch and Link" that unconditionally jumps to the given pc-relative label. It would be great to understand the underlying reason why the Swift compiler decided to make a call to the `_swift_rt_swift_getExistentialTypeMetadat` built-in function. It appears that [Joe Groff](https://github.com/jckarter) who currently works at Apple has worked with this particular procedure with commits such as [36127b2801f7d3dcf96a55534e299f5bce9c0a91](https://github.com/apple/swift/commit/36127b2801f7d3dcf96a55534e299f5bce9c0a91) on Apple's Swift source code, so I'm writing an email to Joe as I'm writing this article, just to get his comments on what the aforementioned function actually does and I will update this article once I know more.

The next thing that is happening in the chain of calls is the call to the `imp___stubs___T0s23_ContiguousArrayStorageCMa` procedure. I believe this call is when Swift decides to allocate an array for our range expressed in Swift as `0...0xDEADBEEF`:

Last but not least is the call to the `imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA0_` built-in function that is the internal function that takes care of our `print()` statement. I was wondering about the performance of this Swift code so I wrote a small Swift class that is able to perform a block of code in a high priority dispatch queue 3 times and then get the mean execution time as to help us understand how much time that code block takes on average to execute. Here is that class for your reference:

```swift
import Foundation

private extension Array where Element == CFAbsoluteTime {
    var mean: CFAbsoluteTime {
        return reduce(0) {$0 + $1} / CFAbsoluteTime(count)
    }
}

class HighPriority {
    
    typealias Task = () -> Void
    let task: Task
    
    init(task: @escaping Task) {
        self.task = task
    }
    
    private lazy var queue: DispatchQueue = {
        return DispatchQueue(label: UUID().uuidString,
                             qos: DispatchQoS.userInteractive,
                             attributes: .concurrent,
                             autoreleaseFrequency: .inherit,
                             target: nil)
    }()
    
    typealias PerformCompletion = (CFAbsoluteTime) -> Void
    
    func perform(completion: @escaping PerformCompletion) {
        
        //perform 3 times, and get an average performance
        var times = [CFAbsoluteTime]()
        
        internalPerform(completion: {time in
            times.append(time)
            self.internalPerform(completion: {time in
                times.append(time)
                self.internalPerform(completion: {time in
                    times.append(time)
                    let mean = times.mean
                    completion(mean)
                })
            })
        })
        
        
    }
    
    @inline(__always)
    private func internalPerform(completion: @escaping PerformCompletion) {
        
        queue.async {
            let start = CFAbsoluteTimeGetCurrent()
            self.task()
            let end = CFAbsoluteTimeGetCurrent()
            let delta = end - start
            DispatchQueue.main.async {
                completion(delta)
            }
        }
        
    }
    
}
```

I want to now do a test on the traditional `for` loop and run it with the `HighPriority` class which we just wrote, on an iPhone 7 with full optimization on the code, and see how long it takes. But since the code right now includes a `printf()` function, it will take a huge amount of time to execute. That's dumb, so let's remove the `printf()` and make the code smarter so that it won't get optimized out since it's not doing anything, but still do something unnecessarily enough for the code to be executable:

```swift
@inline(never)
func traditionalForLoop() {
    
    var lastValue = 0
    for value in 0...0xDEADBEEF {
        if value % 0xDEED == 0 {
            lastValue = value
        }
    }
    if lastValue < 0 {
        print(lastValue)
    }
    
}
```

If I run this code with our `HighPriority` class as shown here:

```swift
HighPriority(task: traditionalForLoop).perform { (time) in
    print(time)
}
```

I get the following result: **2.68 seconds**

Verdict:

|            | Aesthetics | Conciseness | Performance | Overal Score |
|------------|------------|-------------|-------------|--------------|
| `for` loop | ⭐️⭐️⭐️⭐️⭐️      | ⭐️⭐️⭐️⭐️⭐️       | ⭐️⭐️⭐️⭐️        | ⭐️⭐️⭐️⭐️         |


`forEach{}` Loop
===
Let's rewrite the previous code by calling the `forEach` function on our array:

```swift
@inline(never)
func forEachLoop() {
    
    (0...0xDEADBEEF).forEach {value in
        if value % 2 == 0 {
            print(value)
        }
    }
    
}
```

Let's look at the generated assembly code to get some hints as to how this loop differs from the traditional `for` loop:

```asm
0x00000001000060b0 FFC301D1                        sub        sp, sp, #0x70     ; XREF=-[_TtC12swift_weekly11AppDelegate application:didFinishLaunchingWithOptions:]+204
0x00000001000060b4 FC6F01A9                        stp        x28, x27, [sp, #0x10]
0x00000001000060b8 FA6702A9                        stp        x26, x25, [sp, #0x20]
0x00000001000060bc F85F03A9                        stp        x24, x23, [sp, #0x30]
0x00000001000060c0 F65704A9                        stp        x22, x21, [sp, #0x40]
0x00000001000060c4 F44F05A9                        stp        x20, x19, [sp, #0x50]
0x00000001000060c8 FD7B06A9                        stp        x29, x30, [sp, #0x60]
0x00000001000060cc FD830191                        add        x29, sp, #0x60
0x00000001000060d0 170080D2                        movz       x23, #0x0
0x00000001000060d4 180000F0                        adrp       x24, #0x100009000
0x00000001000060d8 FA030032                        orr        w26, wzr, #0x1
0x00000001000060dc FC031F32                        orr        w28, wzr, #0x2
0x00000001000060e0 1F2003D5                        nop        
0x00000001000060e4 3BF90058                        ldr        x27, #0x100008008
0x00000001000060e8 B9D5BB52                        movz       w25, #0xdead, lsl #16
0x00000001000060ec F9DD9772                        movk       w25, #0xbeef

0x00000001000060f0 D7040037                        tbnz       w23, #0x0, 0x100006188 ; XREF=__T012swift_weekly11AppDelegateC11forEachLoopyyFTf4d_n+232

0x00000001000060f4 002F43F9                        ldr        x0, [x24, #0x658]
0x00000001000060f8 000200B5                        cbnz       x0, 0x100006138

0x00000001000060fc 1F2003D5                        nop        
0x0000000100006100 80AA0158                        ldr        x0, #0x100009650
0x0000000100006104 200100B5                        cbnz       x0, 0x100006128

0x0000000100006108 E0030032                        orr        w0, wzr, #0x1
0x000000010000610c E3230091                        add        x3, sp, #0x8
0x0000000100006110 010080D2                        movz       x1, #0x0
0x0000000100006114 020080D2                        movz       x2, #0x0          ; argument #1 for method _swift_rt_swift_getExistentialTypeMetadata
0x0000000100006118 2A000094                        bl         _swift_rt_swift_getExistentialTypeMetadata
0x000000010000611c A8A90110                        adr        x8, #0x100009650
0x0000000100006120 1F2003D5                        nop        
0x0000000100006124 00FD9FC8                        stlr       x0, [x8]

0x0000000100006128 52000094                        bl         imp___stubs___T0s23_ContiguousArrayStorageCMa ; XREF=__T012swift_weekly11AppDelegateC11forEachLoopyyFTf4d_n+84
0x000000010000612c 68A90110                        adr        x8, #0x100009658
0x0000000100006130 1F2003D5                        nop        
0x0000000100006134 00FD9FC8                        stlr       x0, [x8]

0x0000000100006138 E1031A32                        orr        w1, wzr, #0x40    ; XREF=__T012swift_weekly11AppDelegateC11forEachLoopyyFTf4d_n+72
0x000000010000613c E20B0032                        orr        w2, wzr, #0x7
0x0000000100006140 25000094                        bl         _swift_rt_swift_allocObject
0x0000000100006144 F30300AA                        mov        x19, x0
0x0000000100006148 7A7201A9                        stp        x26, x28, [x19, #0x10]
0x000000010000614c 7B1E00F9                        str        x27, [x19, #0x38]
0x0000000100006150 771200F9                        str        x23, [x19, #0x20]
0x0000000100006154 4D000094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA0_
0x0000000100006158 F40300AA                        mov        x20, x0
0x000000010000615c F50301AA                        mov        x21, x1
0x0000000100006160 F60302AA                        mov        x22, x2
0x0000000100006164 4C000094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA1_
0x0000000100006168 E40300AA                        mov        x4, x0
0x000000010000616c E50301AA                        mov        x5, x1
0x0000000100006170 E60302AA                        mov        x6, x2
0x0000000100006174 E00313AA                        mov        x0, x19
0x0000000100006178 E10314AA                        mov        x1, x20
0x000000010000617c E20315AA                        mov        x2, x21
0x0000000100006180 E30316AA                        mov        x3, x22
0x0000000100006184 3E000094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortF

0x0000000100006188 FF0219EB                        cmp        x23, x25          ; XREF=__T012swift_weekly11AppDelegateC11forEachLoopyyFTf4d_n+64
0x000000010000618c A0000054                        b.eq       0x1000061a0

0x0000000100006190 FF0600B1                        cmn        x23, #0x1
0x0000000100006194 F7060091                        add        x23, x23, #0x1
0x0000000100006198 C7FAFF54                        b.vc       0x1000060f0

0x000000010000619c 200020D4                        brk        #0x1

0x00000001000061a0 FD7B46A9                        ldp        x29, x30, [sp, #0x60] ; XREF=__T012swift_weekly11AppDelegateC11forEachLoopyyFTf4d_n+220
0x00000001000061a4 F44F45A9                        ldp        x20, x19, [sp, #0x50]
0x00000001000061a8 F65744A9                        ldp        x22, x21, [sp, #0x40]
0x00000001000061ac F85F43A9                        ldp        x24, x23, [sp, #0x30]
0x00000001000061b0 FA6742A9                        ldp        x26, x25, [sp, #0x20]
0x00000001000061b4 FC6F41A9                        ldp        x28, x27, [sp, #0x10]
0x00000001000061b8 FFC30191                        add        sp, sp, #0x70
0x00000001000061bc C0035FD6                        ret
```

So it appears as if the call to the `forEach` function of the array was made inline and this code is very much identical to the normal `for` loop.

I want to do the same thing with this code and run it through the `HighPriority` class and see how long it takes to execute on an iPhone 7 with full optimization turned on but we have to also make this code smarter so that it doesn't include a `printf()` statement (since that takes a huge amount of time for a loop between `0...0xDEADBEEF`) and also we need to ensure that the code won't just do nothing, since it will get optimized out. So here is the new code:

```swift
@inline(never)
func forEachLoop() {
    
    var lastValue = 0
    (0...0xDEADBEEF).forEach {value in
        if value % 2 == 0 {
            lastValue = value
        }
    }
    if lastValue < 0 {
        print(lastValue)
    }
    
}
```

I get the following result: **2.48 seconds**

Verdict:

|                | Aesthetics | Conciseness | Performance | Overal Score |
|----------------|------------|-------------|-------------|--------------|
| `forEach` loop | ⭐️⭐️⭐️⭐️       | ⭐️⭐️⭐️⭐️⭐️       | ⭐️⭐️⭐️⭐️        | ⭐️⭐️⭐️⭐️         |


`while` Loop
===
I don't think any programmer is ever going to write their code like this but as of the time of writing this article, you can create a loop simply by using the `while` statement. I have very few examples where a `while` would be a useful way of doing a loop, especially through numbers, but for the sake of wholesomeness of this article, let's have a look at a `while` loop as well:

```swift
@inline(never)
func whileLoop() {
    
    var value = 0
    var lastValue = 0
    while value < 0xDEADBEEF {
        if value % 2 == 0 {
            lastValue = value
        }
        value += 1
    }
    if lastValue < 0 {
        print(lastValue)
    }
    
}
```

Let's check out the ARM asm source as well:

```asm
0x00000001000098f8 FF0301D1                        sub        sp, sp, #0x40
0x00000001000098fc F65701A9                        stp        x22, x21, [sp, #0x10]
0x0000000100009900 F44F02A9                        stp        x20, x19, [sp, #0x20]
0x0000000100009904 FD7B03A9                        stp        x29, x30, [sp, #0x30]
0x0000000100009908 FDC30091                        add        x29, sp, #0x30
0x000000010000990c 080080D2                        movz       x8, #0x0
0x0000000100009910 140080D2                        movz       x20, #0x0
0x0000000100009914 A9D5BB52                        movz       w9, #0xdead, lsl #16
0x0000000100009918 E9DD9772                        movk       w9, #0xbeef

0x000000010000991c 1F0140F2                        tst        x8, #0x1          ; XREF=__T012swift_weekly11AppDelegateC9whileLoopyyF+52
0x0000000100009920 1401949A                        csel       x20, x8, x20, eq
0x0000000100009924 08050091                        add        x8, x8, #0x1
0x0000000100009928 1F0109EB                        cmp        x8, x9
0x000000010000992c 8BFFFF54                        b.lt       0x10000991c

0x0000000100009930 7405F8B6                        tbz        x20, #0x3f, 0x1000099dc

0x0000000100009934 1F2003D5                        nop        
0x0000000100009938 00FF0158                        ldr        x0, #0x10000d918
0x000000010000993c 000200B5                        cbnz       x0, 0x10000997c

0x0000000100009940 1F2003D5                        nop        
0x0000000100009944 E0FE0158                        ldr        x0, #0x10000d920
0x0000000100009948 200100B5                        cbnz       x0, 0x10000996c

0x000000010000994c E0030032                        orr        w0, wzr, #0x1
0x0000000100009950 E3230091                        add        x3, sp, #0x8
0x0000000100009954 010080D2                        movz       x1, #0x0
0x0000000100009958 020080D2                        movz       x2, #0x0          ; argument #1 for method _swift_rt_swift_getExistentialTypeMetadata
0x000000010000995c 5E010094                        bl         _swift_rt_swift_getExistentialTypeMetadata
0x0000000100009960 08FE0110                        adr        x8, #0x10000d920
0x0000000100009964 1F2003D5                        nop        
0x0000000100009968 00FD9FC8                        stlr       x0, [x8]

0x000000010000996c B9010094                        bl         imp___stubs___T0s23_ContiguousArrayStorageCMa ; XREF=__T012swift_weekly11AppDelegateC9whileLoopyyF+80
0x0000000100009970 48FD0110                        adr        x8, #0x10000d918
0x0000000100009974 1F2003D5                        nop        
0x0000000100009978 00FD9FC8                        stlr       x0, [x8]

0x000000010000997c E1031A32                        orr        w1, wzr, #0x40    ; XREF=__T012swift_weekly11AppDelegateC9whileLoopyyF+68
0x0000000100009980 E20B0032                        orr        w2, wzr, #0x7
0x0000000100009984 A1FDFF97                        bl         _swift_rt_swift_allocObject
0x0000000100009988 F30300AA                        mov        x19, x0
0x000000010000998c E8030032                        orr        w8, wzr, #0x1
0x0000000100009990 E9031F32                        orr        w9, wzr, #0x2
0x0000000100009994 682601A9                        stp        x8, x9, [x19, #0x10]
0x0000000100009998 1F2003D5                        nop        
0x000000010000999c E8330158                        ldr        x8, #0x10000c018
0x00000001000099a0 681E00F9                        str        x8, [x19, #0x38]
0x00000001000099a4 741200F9                        str        x20, [x19, #0x20]
0x00000001000099a8 B0010094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA0_
0x00000001000099ac F40300AA                        mov        x20, x0
0x00000001000099b0 F50301AA                        mov        x21, x1
0x00000001000099b4 F60302AA                        mov        x22, x2
0x00000001000099b8 AF010094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA1_
0x00000001000099bc E40300AA                        mov        x4, x0
0x00000001000099c0 E50301AA                        mov        x5, x1
0x00000001000099c4 E60302AA                        mov        x6, x2
0x00000001000099c8 E00313AA                        mov        x0, x19
0x00000001000099cc E10314AA                        mov        x1, x20
0x00000001000099d0 E20315AA                        mov        x2, x21
0x00000001000099d4 E30316AA                        mov        x3, x22
0x00000001000099d8 A1010094                        bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortF

0x00000001000099dc FD7B43A9                        ldp        x29, x30, [sp, #0x30] ; XREF=__T012swift_weekly11AppDelegateC9whileLoopyyF+56
0x00000001000099e0 F44F42A9                        ldp        x20, x19, [sp, #0x20]
0x00000001000099e4 F65741A9                        ldp        x22, x21, [sp, #0x10]
0x00000001000099e8 FF030191                        add        sp, sp, #0x40
0x00000001000099ec C0035FD6                        ret
```

The generated assembly code for this `while` loop is very similar to that generated for the `forEach` statement and that on its own very similar to the `for` loop. So as far as the asm code is concerned you can be certain that the compiler is doing a hell of a job! But what about performance. I am going to put this into our `HighPriority` class and run it with full optimization on an iPhone 7:

```swift
HighPriority(task: whileLoop).perform { (time) in
    print(time)
}
```

And I am receiving the following score: **2.45 seconds**

Verdict:

|              | Aesthetics | Conciseness | Performance | Overal Score |
|--------------|------------|-------------|-------------|--------------|
| `while` loop | ⭐️⭐️⭐️        | ⭐️⭐️⭐️         | ⭐️⭐️⭐️⭐️        | ⭐️⭐️⭐️          |

The reason behind the low score for aesthetics and conciseness are co-related. The `while` statement is physically more syntax to write and hence takes longer to understand than a simple for-loop for a finite task such as going through an array.


`repeat...while` Loop
===
This type of loop is very similar to the `while` loop which i talked about earlier with the only difference being that this loop puts the condition at the end of the loop. So you can say that the loop runs at least once and then checks for its condition to exit or continue.

```swift
@inline(never)
    func repeatLoop() {
        
        var value = 0
        var lastValue = 0
        
        repeat {
            if value % 2 == 0 {
                lastValue = value
            }
            value += 1
        } while value < 0xDEADBEEF
        
        if lastValue < 0 {
            print(lastValue)
        }
        
    }
```

I won't go through the ARM assembly code for this type of loop since that's not one of the measurements in our verdicts and I didn't really go into the details of the other ARM assembly outputs either so it's pointless for the purpose of this article. Let's run this code with full optimization with our `HighPriority` class on an iPhone 7 and see the results:

```swift
HighPriority(task: repeatLoop).perform { (time) in
    print(time)
}
```

And I'm receiving the following value: **2.49 seconds**

Verdict:

|                       | Aesthetics | Conciseness | Performance | Overal Score |
|-----------------------|------------|-------------|-------------|--------------|
| `repeat...while` loop | ⭐️⭐️⭐️        | ⭐️⭐️⭐️         | ⭐️⭐️⭐️⭐️        | ⭐️⭐️⭐️          |

I scored the aesthetics and the conciseness categories of the `while` loop lower than the traditional `for` loop since it looks disgusting in my opinion and it also puts the condition of the loop at the end, which makes it less readable. So let's gather all the data:

Final Verdict
===

Here are the contestants and their verdicts, **sorted by overal score**:

|                       | Aesthetics | Conciseness | Performance | Overal Score |
|-----------------------|------------|-------------|-------------|--------------|
| `for` loop | ⭐️⭐️⭐️⭐️⭐️      | ⭐️⭐️⭐️⭐️⭐️       | ⭐️⭐️⭐️⭐️        | ⭐️⭐️⭐️⭐️         |
| `forEach` loop | ⭐️⭐️⭐️⭐️       | ⭐️⭐️⭐️⭐️⭐️       | ⭐️⭐️⭐️⭐️        | ⭐️⭐️⭐️⭐️         |
| `repeat...while` loop | ⭐️⭐️⭐️        | ⭐️⭐️⭐️         | ⭐️⭐️⭐️⭐️        | ⭐️⭐️⭐️          |
| `while` loop | ⭐️⭐️⭐️        | ⭐️⭐️⭐️         | ⭐️⭐️⭐️⭐️        | ⭐️⭐️⭐️          |

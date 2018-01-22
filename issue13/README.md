Swift Weekly - Issue 13 - Internals of a Loop
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
0x00000001000060b0 FFC301D1   sub        sp, sp, #0x70
0x00000001000060b4 FC6F01A9   stp        x28, x27, [sp, #0x10]
0x00000001000060b8 FA6702A9   stp        x26, x25, [sp, #0x20]
0x00000001000060bc F85F03A9   stp        x24, x23, [sp, #0x30]
0x00000001000060c0 F65704A9   stp        x22, x21, [sp, #0x40]
0x00000001000060c4 F44F05A9   stp        x20, x19, [sp, #0x50]
0x00000001000060c8 FD7B06A9   stp        x29, x30, [sp, #0x60]
0x00000001000060cc FD830191   add        x29, sp, #0x60
0x00000001000060d0 170080D2   movz       x23, #0x0
0x00000001000060d4 180000F0   adrp       x24, #0x100009000
0x00000001000060d8 FA030032   orr        w26, wzr, #0x1
0x00000001000060dc FC031F32   orr        w28, wzr, #0x2
0x00000001000060e0 1F2003D5   nop        
0x00000001000060e4 3BF90058   ldr        x27, #0x100008008
0x00000001000060e8 B9D5BB52   movz       w25, #0xdead, lsl #16
0x00000001000060ec F9DD9772   movk       w25, #0xbeef

0x00000001000060f0 D7040037   tbnz       w23, #0x0, 0x100006188

0x00000001000060f4 002B43F9   ldr        x0, [x24, #0x650]
0x00000001000060f8 000200B5   cbnz       x0, 0x100006138

0x00000001000060fc 1F2003D5   nop        
0x0000000100006100 40AA0158   ldr        x0, #0x100009648
0x0000000100006104 200100B5   cbnz       x0, 0x100006128

0x0000000100006108 E0030032   orr        w0, wzr, #0x1
0x000000010000610c E3230091   add        x3, sp, #0x8
0x0000000100006110 010080D2   movz       x1, #0x0
0x0000000100006114 020080D2   movz       x2, #0x0          ; argument #1 for method _swift_rt_swift_getExistentialTypeMetadata
0x0000000100006118 2A000094   bl         _swift_rt_swift_getExistentialTypeMetadata
0x000000010000611c 68A90110   adr        x8, #0x100009648
0x0000000100006120 1F2003D5   nop        
0x0000000100006124 00FD9FC8   stlr       x0, [x8]

0x0000000100006128 52000094   bl         imp___stubs___T0s23_ContiguousArrayStorageCMa
0x000000010000612c 28A90110   adr        x8, #0x100009650
0x0000000100006130 1F2003D5   nop        
0x0000000100006134 00FD9FC8   stlr       x0, [x8]

0x0000000100006138 E1031A32   orr        w1, wzr, #0x40
0x000000010000613c E20B0032   orr        w2, wzr, #0x7
0x0000000100006140 25000094   bl         _swift_rt_swift_allocObject
0x0000000100006144 F30300AA   mov        x19, x0
0x0000000100006148 7A7201A9   stp        x26, x28, [x19, #0x10]
0x000000010000614c 7B1E00F9   str        x27, [x19, #0x38]
0x0000000100006150 771200F9   str        x23, [x19, #0x20]
0x0000000100006154 4D000094   bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA0_
0x0000000100006158 F40300AA   mov        x20, x0
0x000000010000615c F50301AA   mov        x21, x1
0x0000000100006160 F60302AA   mov        x22, x2
0x0000000100006164 4C000094   bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortFfA1_
0x0000000100006168 E40300AA   mov        x4, x0
0x000000010000616c E50301AA   mov        x5, x1
0x0000000100006170 E60302AA   mov        x6, x2
0x0000000100006174 E00313AA   mov        x0, x19
0x0000000100006178 E10314AA   mov        x1, x20
0x000000010000617c E20315AA   mov        x2, x21
0x0000000100006180 E30316AA   mov        x3, x22
0x0000000100006184 3E000094   bl         imp___stubs___T0s5printySayypGd_SS9separatorSS10terminatortF

0x0000000100006188 FF0219EB   cmp        x23, x25
0x000000010000618c A0000054   b.eq       0x1000061a0

0x0000000100006190 FF0600B1   cmn        x23, #0x1
0x0000000100006194 F7060091   add        x23, x23, #0x1
0x0000000100006198 C7FAFF54   b.vc       0x1000060f0

0x000000010000619c 200020D4   brk        #0x1

0x00000001000061a0 FD7B46A9   ldp        x29, x30, [sp, #0x60]
0x00000001000061a4 F44F45A9   ldp        x20, x19, [sp, #0x50]
0x00000001000061a8 F65744A9   ldp        x22, x21, [sp, #0x40]
0x00000001000061ac F85F43A9   ldp        x24, x23, [sp, #0x30]
0x00000001000061b0 FA6742A9   ldp        x26, x25, [sp, #0x20]
0x00000001000061b4 FC6F41A9   ldp        x28, x27, [sp, #0x10]
0x00000001000061b8 FFC30191   add        sp, sp, #0x70
0x00000001000061bc C0035FD6   ret
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


















References
===

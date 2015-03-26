Swift Weekly - Issue 12 - Adding Assembly Code to Swift
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
In this issue, I want to see how we can write a very simple assembly code (equivalent of the following Swift code), and call that assembly code from our Swift code:

```swift
func add(a: Int, _ b: Int) -> Int{
    return a + b
}
```

the xcode version that i am using is `Version 6.2 (6C131e)`. let's get started.

Writing the Intel X86_64 Version of the Code
===
when we write our app in objc or swift, the compiler automatically generates the binary for the requested architectures, namely x86_64 and armvx, where x can be any of the crazy arm cpu architectures, like v7 or v7s. when we write assembly code, we have to do that manually. in other words, we have to write two separate pieces of code, for the aforementioned cpu architectures, assembly them, get the object files and mix the object files into one object file and then link against that object file. magic! no it's not, just joking.

so let's write the simple intel x86_64 asm code for our add method:

```asm
.globl _addMethod
_addMethod:
    pushq  %rbp
    movq   %rsp, %rbp
    movq   %rdi, -0x8(%rbp)
    movq   %rsi, -0x10(%rbp)
    movq   -0x8(%rbp), %rsi
    addq   -0x10(%rbp), %rsi
    movq   %rsi, %rax
    popq   %rbp
    retq
```

great, let's compile this file now. i've named it "intel.s" so:

```bash
xcrun clang -arch x86_64 intel.s -c -o intel.o
```

and now i have a file named `intel.o` on disk. let's disassemble it and see what we get:

```bash
xcrun otool -v -t intel.o
```

and we get this:

```asm
intel.o:
(__TEXT,__text) section
_addMethod:
0000000000000000	pushq	%rbp
0000000000000001	movq	%rsp, %rbp
0000000000000004	movq	%rdi, -0x8(%rbp)
0000000000000008	movq	%rsi, -0x10(%rbp)
000000000000000c	movq	-0x8(%rbp), %rsi
0000000000000010	addq	-0x10(%rbp), %rsi
0000000000000014	movq	%rsi, %rax
0000000000000017	popq	%rbp
0000000000000018	retq
```

Linking Against the Intel Object File
===
From the previous section, we should now have a file called `intel.o` which is our object file. we can indeed now include this in our project and start calling it. so far, with my reasearch, i have not found a way to inject object files directly into swift and use them as external symbols like we have the `extern` keyword in objc. so what we are going to do is create an objc class in our swift project and then import our object file into that objective-c class, then call the method from swift. Follow these steps:

1. create a new objc class in the project, called "ObjcClass"
2. when prompted to create a bridging header, do so
3. in your bridging header, import your class:

	```objc
	#import "ObjcClass.h"
	```

4. add the method signature to the `ObjcClass.h` file:

	```objc
	#import <Foundation/Foundation.h>

	@interface ObjcClass : NSObject

	- (NSInteger) add:(NSInteger)a b:(NSInteger)b;

	@end
	```
	
5. in the `ObjcClass.m` file, add the external symbol for the `addMethod`:

	```objc
	#import "ObjcClass.h"

	extern NSInteger addMethod(NSInteger a, NSInteger b);

	@implementation ObjcClass

	- (NSInteger) add:(NSInteger)a b:(NSInteger)b{
	    return addMethod(a, b);
	}

	@end
	```

6. in your swift code, instantiate `ObjcClass` and call the `add` method on it:

	```swift
	let objc = ObjcClass()
	println("Result of add is \(objc.add(200, b: 300))")
	```
	
7. drag and drop the `intel.o` file that we just created, into your project, and ensure that it is added to your target.
8. compile and run your project (__note__: at this stage, you can only compile and run your project in the simulator, as we have just linked the intel binary to our project. the arm binary is missing)

when you run the app, you should then get the following printed to your console:

```
Result of add is 500
```

__note__: if you want to get the project with the asm file and object file the way i have set it up, check out commit [695043](http://goo.gl/rVrQvZ) from the swift-weekly repo and you should have everything that you need to test this for yourself.

Writing the ARM Version of the Code
===
just like we wrote the x86_64 version of our asm file, we have to do the same for the arm architecture. i've named my file `arm.s` and its content is:

```asm
.align 4
.global _addMethod
_addMethod:
    sub	sp, sp, #16
    stp	x1, x0, [sp]
    ldp	x1, x0, [sp]
    add	x0, x0, x1
    add	sp, sp, #16
    ret
```

and then compile this into an object file:

```bash
xcrun clang -O3 -arch arm64 arm.s -c -o arm.o
```

let's disassemble it with `xcrun otool -v -t arm.o` and see what we get:

```asm
arm.o:
(__TEXT,__text) section
_addMethod:
0000000000000000		sub	sp, sp, #16
0000000000000004		stp	x1, x0, [sp]
0000000000000008		ldp	x1, x0, [sp]
000000000000000c		add	x0, x0, x1
0000000000000010		add	sp, sp, #16
0000000000000014		ret
```

Linking Against the ARM Object File
===
This is to make sure that we can run our code on a real device, like the iPhone 6 Plus. Follow these steps:

1. ensure that the `intel.o` file is no longer attached to your target.
2. drag and drop the `arm.o` file that we created in the previous section, into your project and make sure it is attached to your target.
3. run your code on a real device.

Linking Against both the ARM and the x86_64 Object Files
===

we have a problem now. we can either run the project on the simulator, or on a device. if both `intel.o` and `arm.o` are attached to your target, and say that you want to compile your project for running on a device, you would get the following warning from Xcode:

```bash
ld: warning: ignoring file intel.o, file was built for unsupported file format ( 0xCF 0xFA 0xED 0xFE 0x07 0x00 0x00 0x01 0x03 0x00 0x00 0x00 0x01 0x00 0x00 0x00 ) which is not the architecture being linked (arm64): intel.o
```

and if you try to run the project on the simulator, you would get this warning:

```bash
(null): Ignoring file arm.o, file was built for unsupported file format ( 0xCF 0xFA 0xED 0xFE 0x0C 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 ) which is not the architecture being linked (x86_64): arm.o
```

so we need a way to combine `arm.o` and `intel.o` into one binary and then link against that binary. we use that using the `lipo` command:

```bash
xcrun lipo -create intel.o arm.o -output both.o
```

this mixes both object files into a third file called `both.o`. let's get its information:

```bash
xcrun lipo -info both.o
Architectures in the fat file: both.o are: x86_64 arm64
```

now make sure neither `intel.o` nor `arm.o` is attached to your target. then drag and drop `both.o` into your target and compile and run. it works!

References
===
1. [The ARM Instruction Set](http://goo.gl/K1Kukw)
2. [Intel® 64 and IA-32 Architectures Software Developer Manuals](http://goo.gl/B1tTk)
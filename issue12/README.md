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

References
===
1. 
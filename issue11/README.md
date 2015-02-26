Swift Weekly - Issue 11 - `@autoclosure`, `@inline`, `@noescape`, and `@noreturn` Keywords
===
	Vandad Nahavandipoor
	http://www.oreilly.com/pub/au/4596
	Email: vandad.np@gmail.com
	Blog: http://vandadnp.wordpress.com
	Skype: vandad.np

Introduction
===
So we are all familiar with these keywords, but how do they work and why would we need them? It's not enough, imho, to know that a keyword exists, but one should also know when and how to use them, or sometimes, when _not_ to use them. Let's have a look at these keywords now and i'll give you examples on when and how to use 'em. FYI, i'm on swift 1.2 and the example codes in this edition of swift-weekly may not work if you have an older version of Xcode than the following:

```bash
xcrun xcodebuild -version
Xcode 6.3
Build version 6D532l
```

`@autoclosure`
===
Let's start by quoting the [documentation](http://goo.gl/f1YIfl):

> You can apply the autoclosure attribute to a function type that has a parameter type of () and that returns the type of an expression (see [Type Attributes](http://goo.gl/4Oetr5)). An autoclosure function captures an implicit closure over the specified expression, instead of the expression itself.

Assume that you have a function that takes in a function of type `() -> Bool` as a parameter:

```swift
func show(#msg: String, ifTrue: () -> Bool){
    if ifTrue(){
        println(msg)
    }
}
```
and you go ahead and call it:

```swift
func example1(){
    
    let age = 200
    show(msg: "You are too old") { () -> Bool in
        age > 140
    }
    
}
```

the second parameter is obviously then turned into a closure. can we make this shorter? sure!

```swift
func example1(){
    
    let age = 200
    show(msg: "You are too old") {age > 140}
    
}
```

what if the second parameter could still be a closure but without us having to write the curly brackets around it? that's what `@autoclosure` is for:

```swift
 show(#msg: String, @autoclosure ifTrue: () -> Bool){
    if ifTrue(){
        println(msg)
    }
}

func example1(){
    
    let age = 200
    show(msg: "You are too old", ifTrue: age > 140)
    
}
```
you might ask: why would i even do all of this instead of changing the parameter type of the `show` function from `() -> Bool` to `Bool`? that's a good question. the answer is that you sometimes _might_ want to allow the programmer to write a closure for it, __but__, if you find that the closures that the programmers who use your code write usually ends up being a one liner, then you want to add the `@autoclosure` keyword to your parameter as to save programmers from having to write the syntax for a closure every time they call your function(s).

Also note that the `@autoclosure` keyword applies to a parameter that follows these rules:
1. is a clousre
2. takes in no parameters
3. must return a value that is __not__ a tuple

an example of `@autoclosure` in Apple's code for Swift is on the `||` operator on type `Bool`:

> ```swift
> @inline(__always) func ||<T : BooleanType, U : BooleanType>(lhs: T, rhs: @autoclosure () -> U) -> Bool
> ```

quite clever, don't you think?

rules for using `@autoclosure`:

1. use it to make it easier for programmers to pass in a 1-liner closure with no parameter to your functions
2. don't use it if you believe it adds more complexity to your code than it does any good

`@inline`
===
This one is a gem. suppose that you have a very complex function that has tons of code in it. sometimes, [as we've seen in other swift-weekly issues](http://goo.gl/1zcBvY), swift tends to inline functions that may not be even short. this little keyword is to disallow or force that. if you want to force inlining of your functions, you would prefix them with `@inline(__always)` and if you want to disallow inlining of your functions, you would prefix the function with `@inline(never)`. there is no syntax for inlining _sometimes_ because that's the default behavior:

let's see an example:

```swift
func randomInt() -> Int{
    return Int(arc4random_uniform(UInt32.max))
}

func example2(){
    println(randomInt())
}
```

if we look at the disassembly of `example2()` we will see this:

```asm
                     -[_TtC12swift_weekly14ViewController example2]:
0000000100001550         push       rbp                                         ; Objective C Implementation defined at 0x100004308 (instance)
0000000100001551         mov        rbp, rsp
0000000100001554         push       r14
0000000100001556         push       rbx
0000000100001557         sub        rsp, 0x10
000000010000155b         mov        rbx, rdi
000000010000155e         mov        rax, qword [ds:imp___got__swift_isaMask]    ; imp___got__swift_isaMask
0000000100001565         mov        rax, qword [ds:rax]
0000000100001568         and        rax, qword [ds:rbx]
000000010000156b         lea        rcx, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
0000000100001572         xor        edi, edi
0000000100001574         cmp        rax, rcx
0000000100001577         cmove      rdi, rbx
000000010000157b         test       rdi, rdi
000000010000157e         je         0x100001593

0000000100001585         mov        edi, 0xffffffff                             ; argument "upper_bound" for method imp___stubs__arc4random_uniform
000000010000158a         call       imp___stubs__arc4random_uniform
000000010000158f         mov        eax, eax
0000000100001591         jmp        0x1000015ad

0000000100001593         mov        r14, qword [ds:rax+0x58]                    ; XREF=-[_TtC12swift_weekly14ViewController example2]+46
00000001000015a7         mov        rdi, rbx
00000001000015aa         call       r14

00000001000015ad         mov        qword [ss:rbp+var_18], rax                  ; XREF=-[_TtC12swift_weekly14ViewController example2]+65
00000001000015b1         mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
00000001000015b8         add        rsi, 0x8
00000001000015bc         lea        rdi, qword [ss:rbp+var_18]
00000001000015c0         call       imp___stubs___TFSs7printlnU__FQ_T_
00000001000015cd         add        rsp, 0x10
00000001000015d1         pop        rbx
00000001000015d2         pop        r14
00000001000015d4         pop        rbp
00000001000015d5         ret
```
Do you see that the code for `example2()` includes a call to the internal function `imp___stubs__arc4random_uniform`? but that function was in the `randomInt()` function, you said with rage! well, swift noticed that the `randomInt()` function is not long enough to be a separate entity on its own and it's only been called once in the code so it inlined it to save calling it every time it needs to use it.

now what if we prefix that function with `@inline(never)`?

```swift
@inline(never) func randomInt() -> Int{
    return Int(arc4random_uniform(UInt32.max))
}
```

let's disassemble it:

```asm
                     -[_TtC12swift_weekly14ViewController example2]:
0000000100001580         push       rbp                                         ; Objective C Implementation defined at 0x100004308 (instance)
0000000100001581         mov        rbp, rsp
0000000100001584         push       r14
0000000100001586         push       rbx
0000000100001587         sub        rsp, 0x10
000000010000158b         mov        rbx, rdi
000000010000158e         mov        rax, qword [ds:imp___got__swift_isaMask]    ; imp___got__swift_isaMask
0000000100001595         mov        rax, qword [ds:rax]
0000000100001598         and        rax, qword [ds:rbx]
000000010000159b         lea        rcx, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
00000001000015a2         xor        edi, edi
00000001000015a4         cmp        rax, rcx
00000001000015a7         cmove      rdi, rbx
00000001000015ab         test       rdi, rdi
00000001000015ae         je         0x1000015bc

00000001000015b5         call       __TTSf4g___TFC12swift_weekly14ViewController9randomIntfS0_FT_Si
00000001000015ba         jmp        0x1000015d6

00000001000015bc         mov        r14, qword [ds:rax+0x58]                    ; XREF=-[_TtC12swift_weekly14ViewController example2]+46
00000001000015d0         mov        rdi, rbx
00000001000015d3         call       r14

00000001000015d6         mov        qword [ss:rbp+var_18], rax                  ; XREF=-[_TtC12swift_weekly14ViewController example2]+58
00000001000015da         mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
00000001000015e1         add        rsi, 0x8
00000001000015e5         lea        rdi, qword [ss:rbp+var_18]
00000001000015e9         call       imp___stubs___TFSs7printlnU__FQ_T_
00000001000015f6         add        rsp, 0x10
00000001000015fa         pop        rbx
00000001000015fb         pop        r14
00000001000015fd         pop        rbp
00000001000015fe         ret
```
Do you see the call to the `__TTSf4g___TFC12swift_weekly14ViewController9randomIntfS0_FT_Si` function? that's the `randomInt()` function which we disallowed inlining for. it's working!

rules for using `@inline`:

1. use `@inline(never)` if your function is quite long and you want to avoid increasing your code segment size (use `@inline(never)`)
2. use `@inline(__always)` if your function is rather small and you would prefer your app ran faster (__note__: it doesn't make _that_ much of a differenence really)
3. don't use this keyword if you don't know what inlining of code actually means. [read this first](http://goo.gl/Rgai).

`@noescape`
===
this keyword is used to indicate that a closure, which is passed to another function, will not live past the host function's lifetime and guarantees that the closure will not be captured by another closure that is not marked with `@noescape`. holy hell. so assume this situation:

1. i have a closure
2. i pass that closure to your function
3. your function will then use `dispatch_asynch` and does some network stuff
4. when the dispatch is finished, it will call my closure asynchronously

that means that the closure that I will pass to you will be used asynchronously somewhere and that it should capture the state of its local variables as to avoid having them getting deallocated under its feet. so `@noescape` comes to rescue to guarantee that a `noescape` closure that is passed to any function will not be used past the lifetime of the host function.

another advantage of `noescape` closures is that they need not use `self` to communicate with their host class/struct's member variables or functions, only when the closure is of type `() -> ()`. here is an example:

```swift
func findSingleCharacterNamesInArray(a: [String], callback: (s: String) -> Void){
    for s in a.filter({count($0.utf16) == 1}){
        callback(s: s)
    }
}
```

this function goes through an array of strings and for every string of length 1, calls a given closure. we can then use this function like so:

```swift
let msg = "Found a single character string"

func example3(){
    
    let names = ["Vandad", "x", "Sara", "Leif", "Y", "Ulla"]
    
    findSingleCharacterNamesInArray(names, { (s) -> Void in
        println(self.msg)
    })
    
}
```

you see how we are forced to use `self` in the closure? we can now use `@noescape` to avoid having to do that:

```swift
func findSingleCharacterNamesInArray(a: [String], @noescape callback: () -> ()){
    for s in a.filter({count($0.utf16) == 1}){
        callback()
    }
}
```

__note__: i changed the type of the `callback` parameter to `() -> ()` to ensure that the caller doesn't have to use `self` in the closure to refer to itself.

and then we will use it like so:

```swift
let msg = "Found a single character string"

func example3(){
    
    let names = ["Vandad", "x", "Sara", "Leif", "Y", "Ulla"]
    
    findSingleCharacterNamesInArray(names){
        println(msg)
    }
    
}
```

rules for using `@noescape`:

1. you want to ensure the caller to your method that the closure that they pass to you need not live past the lifetime of your function.
2. you want to make it easier for the caller to access their variables in their structs and classes while inside the closure.
3. you want the compiler to [apply some other small optimizations on your code](http://goo.gl/qXT80N) (god knows what they are!)

`@noreturn`
===
We use this keyword before method signatures whose sole purpose is to terminate the execution of the program. this keyword indicates that a method that is marked as noreturn will _not_ return to its caller and the only case where that is true is for a method that throws an exception unconditionally or aborts the execution of the program such as an assertion. here is an example:

```swift
@noreturn func example4(){
    fatalError("I am a terrible method")
}

override func viewDidLoad() {
    super.viewDidLoad()
    example4()
    if view.alpha == 0xabcdefa{ //this line gets a warning saying "Will never be executed"
    }
}
```

it's interesting that we get the warning "Will never be executed" after our call to a `@noreturn` function but is that really what the compiler is doing? I'd expect the compiler not to even compile the code after that call to `example4()` so let's disassemble this:

```asm
0000000100002e80         push       rbp                                         ; Objective C Implementation defined at 0x100008480 (instance)
0000000100002e81         mov        rbp, rsp
0000000100002e84         push       r14
0000000100002e86         push       rbx
0000000100002e87         sub        rsp, 0x10
0000000100002e8b         mov        r14, rdi
0000000100002e8e         mov        rbx, qword [ds:__TMLC12swift_weekly14ViewController] ; __TMLC12swift_weekly14ViewController
0000000100002ea2         test       rbx, rbx
0000000100002ea5         jne        0x100002ebd

0000000100002ea7         lea        rdi, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
0000000100002eae         call       imp___stubs__swift_getInitializedObjCClass
0000000100002eb3         mov        rbx, rax
0000000100002eb6         mov        qword [ds:__TMLC12swift_weekly14ViewController], rbx ; __TMLC12swift_weekly14ViewController

0000000100002ebd         mov        qword [ss:rbp+var_20], r14                  ; XREF=-[_TtC12swift_weekly14ViewController viewDidLoad]+37
0000000100002ec1         mov        qword [ss:rbp+var_18], rbx
0000000100002ec5         mov        rsi, qword [ds:0x1000090a0]                 ; @selector(viewDidLoad), argument "selector" for method imp___stubs__objc_msgSendSuper2
0000000100002ecc         lea        rdi, qword [ss:rbp+var_20]                  ; argument "super" for method imp___stubs__objc_msgSendSuper2
0000000100002ed0         call       imp___stubs__objc_msgSendSuper2
0000000100002ed5         mov        rax, qword [ds:imp___got__swift_isaMask]    ; imp___got__swift_isaMask
0000000100002edc         mov        rax, qword [ds:rax]
0000000100002edf         and        rax, qword [ds:r14]
0000000100002ee2         lea        rcx, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
0000000100002ee9         cmp        rax, rcx
0000000100002eec         jne        0x100002ef8

0000000100002eee         test       r14, r14
0000000100002ef1         je         0x100002ef8

0000000100002ef3         call       __TTSf4d___TFC12swift_weekly14ViewController8example4fS0_FT_T_

0000000100002ef8         mov        rdi, r14                                    ; XREF=-[_TtC12swift_weekly14ViewController viewDidLoad]+108, -[_TtC12swift_weekly14ViewController viewDidLoad]+113
0000000100002efb         call       qword [ds:rax+0x78]
0000000100002efe         nop
```

do you see the call to `__TTSf4d___TFC12swift_weekly14ViewController8example4fS0_FT_T_`? well, it turns out after that, nothing was compiled. good, gooooood!

rules for using `@noreturn`:

1. use it for methods that unconditionally do an assert that will always fail!
2. use it for methods that will certainly not return to their caller, such as those that call the `fatalError()` function.
3. do not use it for methods that do their work asynchronously or conditionally assert or abort the execution of the program.

References
===
1. [Function Type - The Swift Programming Language](http://goo.gl/f1YIfl)
2. [Inline function](http://goo.gl/Rgai)
3. [Xcode release notes](http://goo.gl/qXT80N)
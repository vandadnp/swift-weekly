# Swift Weekly - Issue 14 - Generics (Part 1)

```
Vandad Nahavandipoor
Email: vandad.np@gmail.com
```

## Introduction
In this article we are going to explore generics in Swift and how we can use them to write better and more concise code. We might not see _everything_ that Generics have to offer but I'll try to be as thorough as possible at least! 

Note: From this issue onwards, I've decided to write all Swift-Weekly issues on my iPad since now we have Swift Playgrounds available for iPad as well so that's pretty nice!

## Why do we need generics?
Imagine that you want to build a stack where you can push and pop things into the stack, just like `git stash` where you can do `git stash` to push and then `git stash pop` to pop the last item from the stash. Now, I know stash and stack sound quite alike but you get the idea. Git's stash is a stack and every stack has a push and pop mechanism, or at least by definition it should.

Now imagine that you write a simple stack class in Swift for values of type `Int`:


```swift
import Foundation

class Stack {
    private var items = [Int]()
    func push(_ value: Int) {
        items.append(value)
    }
    func pop() -> Int? {
        return items.count > 0 ? items.removeLast() : nil
    }
}


let stack = Stack()
stack.push(10)
stack.push(20)
print(stack.pop())
print(stack.pop())
print(stack.pop())
```

This stack does the least it has to do and does it rather fine. However, it's constrained only to `Int` values. If you look inside the `Stack` class you can reason that as long as _an item_ can be placed inside a Swift array, in this case, our `items` array, then the `Stack` class should allow that as well. So let's make this class more generic:

```swift
import Foundation

class Stack<T> {
    private var items = [T]()
    func push(_ value: T) {
        items.append(value)
    }
    func pop() -> T? {
        return items.count > 0 ? items.removeLast() : nil
    }
}

let stack = Stack<Int>()
stack.push(10)
stack.push(20)
print(stack.pop())
print(stack.pop())
print(stack.pop())
```

All I did here was to add the little `<T>` syntax to the `Stack` class telling the Swift compiler that this class is associated with some value defined as `T` and the definition of `T` will later be revealed when the caller instantiates `Stack` as you can see in the following line of code:

```swift
let stack = Stack<Int>()
```

Thanks to this generic implementation of the `Stack` class we are able to push and pop any value type that a Swift array can contain, including but not limited to `String` and `Double`.

We need generics to write less repeated code. In general, in programming, you are going to want to, except for very special cases, limit the number of times that you repeat yourself and generics help us greatly with that task.

## Generic Constraints
When you define a generic type, you will be able to constraint that type inside your implementation so that you expose certain methods or functionalities inside your generic type depending on the type of the generic value. Does that even make sense? Let me show you an example:


```swift
import Foundation

extension Array where Element == Int {
    func sum() -> Int {
        return reduce(0, +)
    }
}

let values = [10, 1, 3]
print(values.sum()) //prints out 14
```

This is an extension on Array only when its elements are of type `Int` and then in that case we expose a function called `sum()` which calculates the sum of all the elements in the array. 

You might be asking: what if I have elements of type `UInt`? Will this still work? No it won't because we are specifically saying that this function is available for arrays that contain items of type `Int` and `Int` is not a protocol that various types can conform to, but rather a `struct` but both `Int` and `UInt` conform a protocol called `FixedWidthInteger` so we could change our definition of this extension so that it works for all fixed width integers:

```swift
import Foundation

extension Array where Element: FixedWidthInteger {
    func sum() -> Element {
        return reduce(0, +)
    }
}

let values: [UInt] = [10, 1, 3]
print(values.sum()) //prints out 14
```

Note that instead of saying `Element == Int` we are saying `Element: FixedWidthInteger` where the former expects a specific type while the latter expects conformance to a protocol. Also note how the `sum()` function returned `Int` but now returns `Element` since all Swift `Array` instances already have a generic type called `Element` and in our case we can't really guess what the return value of the `sum()` function will be, but rather it will be an `Element` of the same array.

From the requirements perspective of our `sum()` function, it only needs a value that has a `+` function so a type that can be added to another value of its own time, so that means `Double` and `Float` and `CGFloat` and other numeric values should also be able to use our extension. But if you initialize your `values` constant with `Double` values, you'll see that the `sum()` function wont' be available to you since we are constrainting our extension to values that conform to the `FixedWidthInteger` and unfortunately `Double` and `Float` do not conform to that protocol.

What we need to do is to find a higher level protocol that all these values conform to and the protocol should also expose the `+` function and the protocol we are looking for is called `Numeric`. If you just change `FixedWidthInteger` in our implementation to `Numeric` all of a sudden our extension starts working for even `Double` and `Float` as shown here:

```swift
import Foundation

extension Array where Element: Numeric {
    func sum() -> Element {
        return reduce(0, +)
    }
}

let values = [10.2, 1, 3]
print(values.sum()) //prints out 14.2
```

## Practical Example
I've always been annoyed by the fact that functions are not extendable in Swift. For instance, if you want to extend any function that takes in a single `Int` and returns a `String`, you simply can't. So yes, functions in Swift are not extendable, and that's sad.

For this section I think we can write our own definition of a generic and synchronous function. Let's see what we mean by that.

Every function has an input and an output even if the output is `Void`. Let's define this with protocols:

```swift
import Foundation

protocol HasInput {
    associatedtype Input
}

protocol HasOutput {
    associatedtype Output
}

protocol SyncFunc: HasInput, HasOutput {
    init()
    func process(_ input: Input) -> Output
}
```

At the end of this we have a protocol called `SyncFunc` (as in synchronous function, since asynchronous functions are a whole other beast, see RxSwift).

So how do we use it, here is an example:

```swift
struct StringLength: SyncFunc {
    typealias Input = String
    typealias Output = Int
    func process(_ input: Input) -> Output {
        return input.count
    }
}
```

And this is how we would use `StringLength`:

```swift
let length = StringLength().process("Foo Bar")
print(length) //prints 7
```

Here we defined a new type called `StringLength` that can take in any value of type `String` and calculate its result. Now that `StringLength` is a concrete implementation of `SyncFunc` with specific Input and Output types, we can extend it using generic constraining:

```swift
extension SyncFunc where Output: Numeric {
    func outputSquared(withInput input: Input) -> Output {
        let result = process(input)
        return result * result
    }
}
```

Here we are extending `SyncFunc` as long as its output conforms to `Numeric` and exposing a new function through our extension which squares the result of the `process(_:)` function. Not so bad!

## Generic Operators
Building on top of our example from the previous section, let's see how we can write generic operators but before doing that let's write another synchronous function that can count the numebr of digits of an `Int`:

```swift
struct DigitCount: SyncFunc {
    typealias Input = Int
    typealias Output = Int
    func process(_ input: Input) -> Output {
        return StringLength().process("\(input)")
    }
}
```

And now let's write some operators that allows us to do something like this:

```swift
let lengthDigitCount = "Foo Bar" --> StringLength.self --> DigitCount.self
```

And we would expect the value of `lengthDigitCount` to be 1 because `StringLength` would get the length of the string and that would be 7 and `DigitCount` should count the number of digits in 7 and that should be 1.

First let's write the operator between `String` and `StringLength`:

```swift
infix operator -->: AdditionPrecedence
func --> <Input, Func: SyncFunc>(lhs: Input, rhs: Func.Type) -> Func.Output where Input == Func.Input {
    return rhs.init().process(lhs)
}

let length = "Foo Bar" --> StringLength.self
print(length) //prints 7
```

I'm not going to over-explain this since it's quite obvious what I'm doing. We take _a_ value on the left hand side of the operator as long as that value is the same value that the synchronous function takes as its input.

Now that we have this operator, we can easily use it to chain `DigitCount` as well:

```swift
let lengthDigitCount = "Foo Bar" --> StringLength.self --> DigitCount.self
print(lengthDigitCount) //prints 1
```

## Closing Words
I think by now you have an idea how generics work. In generics, you either:

1. Don't constraint your generic types at all, as you saw in the `Stack` example
2. Constraint your generic type to a protocol using the `:` syntax
3. Constraint your generic type to a specific type using the `==` syntax

In later articles we probably can have a look at some more advanced generics-related topics.

HF

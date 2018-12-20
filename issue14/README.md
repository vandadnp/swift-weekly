# Swift Weekly - Issue 14 - Generics

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
        items.insert(value, at: 0)
    }
    func pop() -> Int? {
        return items.count > 0 ? items.removeFirst() : nil
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
        items.insert(value, at: 0)
    }
    func pop() -> T? {
        return items.count > 0 ? items.removeFirst() : nil
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

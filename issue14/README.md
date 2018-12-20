# Swift Weekly - Issue 14 - Generics

```
Vandad Nahavandipoor
http://www.oreilly.com/pub/au/4596
Email: vandad.np@gmail.com
Blog: http://vandadnp.wordpress.com
Skype: vandad.np
```

## Introduction
In this article we are going to explore generics in Swift and how we can use them to write better and more concise code. We might not see _everything_ that Generics have to offer but I'll try to be as thorough as possible at least! 

Note: From this issue onwards, I've decided to write all Swift-Weekly issues on my iPad since now we have Swift Playgrounds available for iPad as well so that's pretty nice!

# Why do we need generics?
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


//
//  You are free to submit your changes/additions/fixes through
//  GitHub's Pull-Request system.
//
//  I do __not__ take any responsibility as to how and why or when you
//  use these example codes.
//
//  Please feel free to share Swift Weekly with anybody who you might
//  think may enjoy them.
//
//  Also feel free to contact me personally if you have any questions
//  or ideas for the next Swift Weekly

// allocate one integer block
var myPointer = UnsafeMutablePointer<Int>.alloc(1)
// change its value
myPointer.memory = 1_234
let myInteger = myPointer.memory
// myInteger = 1234
myPointer.destroy()
// now get rid of the pointer's memory
myPointer.dealloc(1)

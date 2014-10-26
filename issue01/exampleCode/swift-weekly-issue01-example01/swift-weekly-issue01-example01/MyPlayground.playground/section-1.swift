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

var myInt = 10
var ptr = UnsafeMutablePointer<Int>.initialize(&myInt)
ptr(20)
myInt // this is now 20






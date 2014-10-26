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

var myArray = [10, 20, 30, 40]
var arrayPtr = UnsafeMutableBufferPointer(start: &myArray, count: myArray.count)
var base = arrayPtr.baseAddress as UnsafeMutablePointer<Int>
base.memory // 10
base.memory = 100 // change the value of the first element in the array
myArray // 100, 20, 30, 40
// move the array forward by one element
base = base.successor()
base.memory // 20 (second item in the array)
// add the value of myArray[1] to myArray[0] and put it in myArray[1]
base.memory = base.memory + base.predecessor().memory
myArray // 100, 120, 30, 40

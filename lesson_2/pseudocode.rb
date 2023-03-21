# Not sure if I needed to put this on git, but I'm putting it there anyways.
# My pseudocode is pretty messy and a bit all over the place, I'll spend a day or so just working on getting better at making it more readable.

=begin
START
# Given two integers, called "num1" and "num2"

PRINT num1 + num2

END


START
# given a collection of strings, called "strings"

new_string = ''

EACH in strings |string|
  new_string << string

PRINT new_string

END

START
# given a collection of integers, called "numbers"

new_arr = []
add_num = false
EACH in numbers |num|
  print? = !add_num
  new_arr.push(num) if add_num

PRINT new_arr
END

START
given a string of characters, iterate through each character and do the following:
  - if the character matches the given character, add 1 to a character counter variable.
  - if the character does not match, go to next.
  - if the character counter hits 3, return the index of the character it hit 3 from.
  - if the loop through the string completes before the character count hits 3 and returns the index above, return nil.
END


START
given two arrays of numbers, array1, and array2, do the following:
  - create a new array to store the concatenated string in, new_array.
  - create a flipping bool that flips between true/false every time the following loop is run.
  - iterate array1.length + array2.length time
    - if the flipping bool is true, push into new_array array1.shift
    - else if the flipping bool is false, push into new_array array2.shift
  - return the value of new_array
  
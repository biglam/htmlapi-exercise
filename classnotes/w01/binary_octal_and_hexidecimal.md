### title

Binary, Octal, and Hexidecimal

### topic

### objectives

### standards

### materials

### summary

> "There are 10 types of people in the world...
>  ... those that understand binary, and those that don't."


### assessment

### follow-up

====================

# Radix/Base - what is it

In mathematics, the 'radix' or 'base' is the number of unique digits, including zero, used to represent numbers.

For example, for the decimal system (the most common system in use today) the radix is ten, because it uses the ten digits from 0 through 9.


# Binary

Binary is base-2 - it uses only two digits (0 and 1)


Number  | Binary | Octal | Hexidecimal
------: | -----: | ----: | ----------:
      0 |      0 |     0 |           0
      1 |      1 |     1 |           1
      2 |     10 |     2 |           2
      3 |     11 |     3 |           3
      4 |    100 |     4 |           4
      5 |    101 |     5 |           5
      6 |    110 |     6 |           6
      7 |    111 |     7 |           7
      8 |   1000 |    10 |           8
      9 |   1001 |    11 |           9
     10 |   1010 |    12 |           A
     11 |   1011 |    13 |           B
     12 |   1100 |    14 |           C
     13 |   1101 |    15 |           D
     14 |   1110 |    16 |           E
     15 |   1111 |    17 |           F
     16 |  10000 |    20 |          10
     17 |  10001 |    21 |          11
     18 |  10010 |    22 |          12
     19 |  10011 |    23 |          13
     20 |  10100 |    24 |          14
     21 |  10101 |    25 |          15
     22 |  10110 |    26 |          16
     23 |  10111 |    27 |          17
     24 |  11000 |    30 |          18
     25 |  11001 |    31 |          19
     26 |  11010 |    32 |          1A
     27 |  11011 |    33 |          1B
     28 |  11100 |    34 |          1C
     29 |  11101 |    35 |          1D
     30 |  11110 |    36 |          1E
     31 |  11111 |    37 |          1F
     32 | 100000 |    40 |          20

               12th |               11th |              10th |            9th |           8th |         7th |        6th |       5th |    4th |   3rd | 2nd | 1st | units | Radix
------------------: | -----------------: | ----------------: | -------------: | ------------: | ----------: | ---------: | --------: | -----: | ----: | --: | --: | ----: | -----
          Trillions |              10^12 |             10^10 |       Billions |          10^8 |        10^7 |   Millions |   100,000 | 10,000 | 1,000 | 100 |  10 |     0 | decimal
              4,096 |              2,048 |              1024 |            512 |           256 |         128 |         64 |        32 |     16 |     8 |   4 |   2 |     0 | binary
     68,719,476,736 |      8,589,934,592 |     1,073,741,824 |    134,217,728 |    16,777,216 |   2,097,152 |    262,144 |    32,768 |  4,096 |   512 |  64 |   8 |     0 | octal
281,474,976,710,656 | 17,592,186,044,416 | 1,099,511,627,776 | 68,719,476,736 | 4,294,967,296 | 268,435,456 | 16,777,216 | 1,048,576 | 65,536 | 4,096 | 256 |  16 |     0 | hexidecimal


# Why is binary used in computing?

The two digits are "0" and "1", are espressed as switches displaying OFF and ON respectively. Used in most electric counters. Thery're referred to as "bits", a contraction of "binary digits".

So it's easy for computers to count in binary - they just turn switches on and off.

But binary numbers are a bit of a pain for humans to read... why?

````
  0001 0101 1101 (2) = 349 (10)
  0010 0010 0010 1111 (2) = 8751 (10)
````

They're long... so we could do with a way to abbreviate them.


# Alternatives to Binary

Look at the list of binary numbers - when do we get a '1' followed by all zeros?

2, 4, 8, 16, 32....

And some others in the middle, like 24, are quite "round" - that is, finishing in multiple zeros.

8, 16, 24, 32.... I'm seeing multiples of 8. I wonder what would happen if we tried counting in base-8...


# Octal

Octal uses 8 digits to count (0..7).

It was popular in the 1960's and 70's due to the configuration of main-frames computers' memory at the time. Also, because it allowed easy representation of binary into a terse, human-readable form (so displays could be cheaper, because they were smaller).

```
  0001 0101 1101 (2) = 535 (8)
  0010 0010 0010 1111 (2) = 21057 (8)
```

## Hexidecimal

Instead of multiples of 8, how about 16

In hexidecimal, we can use the ten digits of decimal... but we need six more...

- We could make up some symbols.
- Or use symbols we know

The choice made was to use the letters a-f

```
  0001 0101 1101 (2) = 15D (16)
  0010 0010 0010 1111 (2) = 222F (16)
```


# Confusing numbers

What number is 1001?

- 1001?
- 9?
- 513?
- 4097?

So we represent numbers with their base subscript next to them.

Hexidecimal is often shown with '0x' in front. Or a '%' sign. Or some other notation... depending on the system.


# Converting binary to hexidecimal

Considering that any four digit binary number can be no more than 15, and 15 is the maximum value of a single digit in hexidecimal... we can map any binary number easily to hexidecimal by splitting it into sections of four, and converting each:

```
            101011101
       0001 0101 1101
          1    5    d
                0x15d

       10001000101111
  0010 0010 0010 1111
     2    2    2    f
               0x222f

      101101000111100
  0101 1010 0011 1100
     5    a    3    c
               0x5a3c
```


# Converting in Ruby

Knowing the conversion method, I bet you could write a Ruby method to convert a value from hexidecimal to binary (and vice versa), couldn't you...

Fortunately, this functionality already exists in Ruby! Integer#to_s and String#to_i take an optional "base" parameter. Integer#to_s(base) converts a decimal number to a string representing the number in the base specified:

```
  9.to_s(2) #=> "1001"
```

While the reverse is obtained with String#to_i(base):

```
  "1001".to_i(2) #=> 9
```

So you can double-check the previous conversions.

```
  "".to_i(2).to_s(16)
  "10001000101111".to_i(2).to_s(16)
  "101101000111100".to_i(2).to_s(16)
```


# Where is this useful?!

* Have you seen that IP addresses go up to 255? (and didn't we refer to them as an octet? 255 is the highest number you can get in eight bits)
* What about colours in CSS? What do they look like?
* File permissions in Unix
* Database field sizes


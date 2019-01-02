;Sets origin of the program to memory location &8000
;CPC code safe mem is &8000 Screen mem is &C000 - &FFFF
org &8000
;Load the accumulator with "4"
ld a,4
;Increment A
inc a
inc a
;Load B with 10
ld b,10
;Add b to the accumulator
add b
;Load a to &7000, brackets define a memory location, so we are putting the value of a into memory location &7000
ld (&7000),a
;Returns back to whatever called the program, in this case, basic
ret
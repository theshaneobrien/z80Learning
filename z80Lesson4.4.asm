PrintChar equ &BB5A

org &8300
	;CPC Basic store the number of parameters passed in in the accumulator
	cp 1
	;Jump to ShowUsage if no parameters passed
	jp nz,ShowUsage
	;Load the Ampersand character into the accumulator
	ld a,'&'
	;Call Print Character
	call PrintChar
	;Numbers are passed as 16bit integers
	;The first parameter location is passed by basic in IX
	;The data is passed in little Endian, it's backwards, so we load the larger part from IX+1 into A
	ld a,(ix+1)
	;OR takes an 8-bit input and compares it with the accumulator
	;It checks if anything is set, if neither is set, it results in a zero
	;0 and 0 result 0
	;0 and 1 result 1
	;1 and 0 result 1
	;1 and 1 result 1
	or a
	;If high byte is not zero, Show the Hex Conversion
	call nz,ShowHex
	;Load the accumulator with the second half of the 16bit, so we load the smaller part from IX+0 into A
	ld a,(ix+0)
	;Call ShowHex
	call ShowHex
;Return to Basic
ret

ShowUsage:
	;Set HL to ShowUsageMessage function
	ld hl,ShowUsageMessage
;Jump to PrintString, because we are using a JP there is no need for a return command
jp PrintString

ShowUsageMessage:
	;Message string we show the user if they used the program wrong
	;defb same as db
	db "Usage: Call &8300,[16 bit number]",255

;Shows an 8bit byte in Hex
ShowHex:
	;We want to divide the number in A by 16
	ld b,16
	;Call our Divide Function
	call MathDiv
	;Push the value in our accumulator to the stack for later use
	push af
		;Load the result from our division into the accumulator
		ld a,c
		;Call PrintHexChar
		call PrintHexChar
	pop af
jp PrintHexChar

;Prints the supplied 16 bit number as a Hex character
PrintHexChar:
	;Compare our divided number to 10
	cp 10
	;If the accumulator is less than 10, jump relative to PrintHexCharNotAtoF
	jr c,PrintHexCharNotAtoF
	;Add 7 to the accumulator (the ASCII difference between 9 and A)
	add 7

PrintHexCharNotAtoF:
	;Add 48 to the character stored in the accumulator
	;This converts the stored character to an ASCII character
	add 48
;Jump to PrintChar, which prints the character in A to Basic
jp PrintChar

;Divides numbers
MathDiv:
	;Load c with 0
	ld c,0
	;Compare a to zero, set the flag
	cp 0
;If the zero flag is set, return to the part of the program that called the divide function
ret z
MathDivAgain:
	;b holds the value we are dividing by, in this case 16. We subtract this from A x times until we hit zero
	sub b
	;Increment c
	inc c
	;Jump back and repeat if we haven't gone below zero
	jp nc,MathDivAgain
	;We've gone 1 further than we needed to so add the remainder to A
	add b
	;Again we've gone 1 further than we need to so decrement c by 1
	dec c
;Return to the part of the code that called this function
ret

PrintString:
	;Load the Accumulator with the byte at h1
	ld a,(hl)
	;Check if the byte in A is the same as 255
	cp 255
	;If it does, jump back to the part of the code that called this function
	ret z
	;If it doesn't increment h1 (the next byte in the sequence)
	inc hl
	;Print the character in A to Basic
	call PrintChar
;Jump back up to print string
jp PrintString
;ThinkPositive equ 1
;Defines PrintChar and point to Amstrad memory that prints ascii characters from the accumulator value
PrintChar equ &BB5A

org &8100
	;Set HL to the Introduction Address
	ld hl,Introduction
	;Call Print String Function
	call PrintString
	;Call New Line Function
	call NewLine
	;Set HL to the Message Address
	ld hl,Message
	;Call Print String Function
	call PrintString
;Return to Basic
ret

;Define PrintString Function
PrintString:
	;Load the accumulator with a byte from the address stored in HL
	ld a,(hl)
	;Was the byte 255?
	cp 255
	;If the difference between the compare value and the accumulator was 0
	;Return to the calling program (just after ld hl,Introduction)
	ret z
	;Increment HL, which loads the next byte in the string to hl? (if hl is 255, overflows to 0, zero flag now set)
	inc hl
	;Call the PrintChar Function
	call PrintChar
;Repeat
jr PrintString

;A label defining the address of our Introduction Message
Introduction:
	;A string of letters, ending with 255
	;The assembler will convert these to their equivalent bytes according to their ASCII code
	;DB stands for define byte, it allows for one or more bytes, separated by commas.
	db 'Thought of the day...',255
;If ThinkPositive is defined
ifdef ThinkPositive
	;A label message and a message that will compile when the if statement occurs
	Message:	db 'Z80 is Awesome!',255
else
	;Another message label, normally you can't have two of the same label in a program
	;But given the scope inside these if statements, only one will ever exist
	Message: 	db '6510 sucks!',255
endif

NewLine:
	;Load the accumulator with a value of 13
	;13 when printed is a "Carriage Return"
	ld a,13
 	call PrintChar
	;Load the accumulator with a value of 10
	;10 when printed is a "New Line"
	ld a,10
	call PrintChar
ret
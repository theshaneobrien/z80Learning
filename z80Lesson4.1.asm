;Definition of a symbol, pointing at a command in the CPC Firmware.
;It will print the value held in the accumulator to the screen as a character.
PrintChar equ &BB5A
;Same again, but this will wait until a key is pressed and store it in the accumulator
WaitChar equ &BB06

org &8000

;Get a character from a user keypress
call WaitChar
;Print the character to the screen
call PrintChar
;Push the character, now in the accumulator onto the stack
;Push only holds 16 bit registers, so in this case AF, the accumulator and it's flag
push af
	;Load a bar character into the accumulator
	ld a,'|'
	;Push the bar character onto the stack
	push af
	;Print the bar to the screen
	call PrintChar
		;Load x character to the accumulator
		ld a,'x'
		;Print the x character, now stored in the accumulator, to the screen
		call PrintChar
	;Pop an item off the stack into the AF register, in this case, the last thing we pushed was a bar character
	pop af
	;Print the bar character we just popped onto the screen
	call PrintChar
;Pop the user selected character off the stack, into the accumulator
pop af
;Print the user selected character again
call PrintChar
ret
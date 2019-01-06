ld b,a(HL/&8000/(&HL)) ;Loads the right side variable into the left side.

;Math
Add b(15) ;Add a register/value to A
Sub b ;Subtract a register/value from A
Inc b ;Increment a register
Dec b ;Decrement a register

;Code Nav
call Label(&8000/HL) ;Jumps to the referenced location, pushes the address after the call instruction onto the stack and jumps to the label.
ret z/nz/c/nc ;Pops the top of the stack into the Program Counter, can be conditional based on flags
jr z/nz/c/nc &8000/HL/Label ;Relative jumps to an address. Can only jump between 128 bytes ahead or behind. can be conditional.

;Stack
push AF ;Pushes a value onto the stack
pop AF ;Pops the value off the stack into the designated register

;Flags
z ;Zero flag is set
nz ;Zero flag is not set/reset
c ;Carry flag is set. >=
	;Example - If we are subtracting 5 from 4, we will have -1, in 8bit math thats 255, the carry flag gets set, same if we go over 255.
nc ;Carry flaf is not set/reset

;Byte Stuff
db 'string',255,'more stuff' ;The assembler will convert these to their equivalent bytes according to their ASCII code
				;DB stands for define byte, it allows for one or more bytes, separated by commas.
res 7,a ;Resets specified register bit (A) to zero, res bit,register. Equiv to AND %10000000
set 7,a ;Sets specified register bit (A) to one, set bit,register. Equiv to OR %10000000
bit 7,a ;Tests specified register bit (A). Equiv to CP %10000000	 ld a,%10000000
									;bit 7,a - would reset z
									;bit 0,a -would set z
nop	;Command that does nothing, useful for reserving bytes to be changed later on

;1 bit = 1 binary unit
;1 nibble = 4 bits
;1 byte = 8 bits
;1 word = 16 bits

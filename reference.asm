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
c ;Carry flag is set. 
	;Example - If we are subtracting 5 from 4, we will have -1, in 8bit math thats 255, the carry flag gets set, same if we go over 255.
nc ;Carry flaf is not set/reset

;Misc
db 'string',255,'more stuff' ;The assembler will convert these to their equivalent bytes according to their ASCII code
				;DB stands for define byte, it allows for one or more bytes, separated by commas.

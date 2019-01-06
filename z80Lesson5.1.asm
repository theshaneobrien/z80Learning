org &8000
	;We're going to alter the screen
	ld hl,&C000
AgainE:
	;Load a byte from the screen
	ld a,(hl)
	
	;Invert the bits that are 1
	xor %11111111
	
	;Clears the bits that are 0, "and %11111110" is the same as res 0,a
	;and %11111110 

	;Sets the bits to 1, "or %00000001" is the same as set 0,a
	;or %00000001

	;Load our modified byte back to the screen
	ld (hl),a
	;Increment L
	inc l
	;Jump to AgainE if L is not zero
	jp nz,AgainE
	;Increment H if we've zeroed L
	inc h
	;Jump to AgainE if H is not zero
	jp nz,AgainE
ret
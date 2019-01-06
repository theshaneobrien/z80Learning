org &8050
	;Parameters passed in from basic are stored in IX
	;Number of parameters are passed in to A
	;Compare A to 1
	cp 1
	;If A is not 1, the user did not enter any parameters, or entered too many, return to basic
	ret nz
	;If a is one, the user entered the right amount of parameters
	;Load the 'Operation' made up of the first two bytes of the parameter passed in.
	;Little Endian, so stored at (IX+1)
	ld b,(ix+1)
	;Load the 'bitmask' from the second two bytes of the passed parameter stored at (IX+)
	ld c,(ix+0)
	;Set hl to the starting point for CPC screen memory
	ld hl,&C000
Again:
	;Load the accumulator with the byte from the screen
	ld a,(hl)
	;Tests if specfied bit is set, this is like CP&80 or CP %10000000,
	;but CP would check A, this works with B
	;if Bit 7 is set to 1 (&80) then we will use AND
	bit 7,b
	;If the 1st bit is zero, jump to NoAnd. bits are counted backwards, so 7 is leftmost
	jr z,NoAnd
	;Use the AND command with parameter C
	and c
NoAnd:
	;Tests if specfied bit is set, this is like CP&40 or CP %01000000,
	;but CP would check A, this works with B
	;if Bit 6 is set to 1 (&40) then we will use OR
	bit 6,b
	;If it was zero, Jump to the NoOr label
	jr z,NoOr
	;Use the OR command with parameter C
	or c
NoOr:
	;Load our modified byte back into the screen
	ld (hl),a
	;Increment L
	inc l
	;Repeat our byte changes
	jp nz,Again
	;Increment H
	inc h
	;Repeat our byte changes
	jp nz,Again
ret
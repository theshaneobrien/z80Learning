org &8300
	cp 1
	;If no parameters passed in, return to Basic
	ret nz
	;Load the first part of the value passed in from Basic
	ld a,(ix+1)
	
	;Using IX as a pseudo switch/case
	;Load the address of our template "and" command into the HL register
	ld hl,SMAND
	;If the parameter (A) is 1, jump to Start
	cp 1
	jr z,Start

	;Load the address of our template "or"
	ld hl,SMOR
	;If the parameter (A) is 2, jump to Start
	cp 2
	jr z,Start

	;Load the address of our template "xor"	
	ld hl,SMXOR
	;If the parameter (A) is 3, jump to Start
	cp 3
	jr z,Start

Start:
	;Load the byte of the template command into A
	ld a,(hl)
	;Write the byte to the label "SelfModify"'s address, inserting it to where our first "nop" is
	ld (SelfModify),a
	ld a,(ix+0)
	;Write the byte to the label "SelfModify"'s address, inserting it to where our second "nop" is
	ld (SelfModify+1),a
	;Load HL with the start address of our screen memory
	ld hl,&C000
AgainD:
	;Load A with the first byte of screen memory
	ld a,(hl)
SelfModify:
	;We are reserving 2 bytes of memory to modify later on.
	;NOP is a one byte command that does nothing. These two will be replaced by code in the Start Label
	nop
	nop
	;Load our modified byte in the Accumulator back into screen memory
	ld (hl),a
	;Repeat to cover every byte in screen memory
	inc l
	jp nz,AgainD
	inc h
	jp nz,AgainD
ret

SMAND: AND 1
SMOR: OR 1
SMXOR: XOR 1
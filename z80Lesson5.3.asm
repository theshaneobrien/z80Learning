org &8100
	;Set HL to the start of screen mem
	ld hl,&C000
AgainB:
	;Load the first byte at screen mem to A
	ld a,(hl)

	;The bits in A are rotated right, Carry is put in bit 7 and bit 0 is put into Carry
	;RR a
	;The bits in A are rotated right, bit 0 is copied into Carry and into bit 7
	RRC a
	;The bits in A are shifted right except bit 7 remains the same
	;SRA a
	;The bits in A are shifted right except a 0 is put in bit 7, bit 0 is put into the carry flag
	;SRL a

	;Load the modified byte back to the screen
	ld (hl), a
	;Increment L
	inc l
	;Repeat modifying our screen bytes
	jp nz,AgainB
	;Increment H
	inc h
	;Repeat modifying our screen bytes
	jp nz,AgainB
;Return to Basic
ret

org &8200
	;Disable Interupts 
	di
	;Load the end of screen mem to HL
	ld hl,&FF00
;Modifying our screen backwards
AgainC:
	;Load the last byte at screen mem to A
	ld a,(hl)

	;The bits in A are rotated left, Carry is put in bit 0 and bit 7 is put into Carry
	;RLA
	;The bits in A are rotated left, bit 7 is copied into Carry and into bit 0
	RLC a
	;The bits in A are shifted left except a 0 is put in bit 0, bit 7 is put into the carry flag
	;SLA a
	;The bits in A are shifted left except a 1 is put in bit 0, bit 7 is put into the carry flag
	;SLL a
	
	;Load our modified byte back onto the screen
	ld (hl),a
	;Decrement L, counting backwards on a screen line?
	dec l
	;Repeat until we our done with this line
	jp nz,AgainC
	;Decrement H, counting backwards on a screen line?
	dec h
	;Load the value at H to A
	ld a,h
	;Repeat until we go below &C000
	cp &BF
	;If not &BF repeat again
	jp nz,AgainC
;Return to Basic
ret
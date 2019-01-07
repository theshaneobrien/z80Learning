org &8000
	;Jump block, each JP xxxx is 3 bytes, so we know "JP GetMemPos" is at &8006
	;Even though we don't know where "GetMemPos" is, we can Call &8006 and it will have the same effect as Call GetMemPos
	;This allows us to write programs that can easily be called from Basic, or other programs that were compiled separately
	jp GetSprite
	jp PutSprite
	jp GetMemPos

;This command takes an X-Pos in B and a Y-pos in C and converts them to a screen memory lotcation in HL
;Not X is measured in BYTES, there are 80 across the CPC screen, Y is measured in LINES
GetScreenPos:
	;Store our current ByteCount
	push bc
		;Load the address of our LookupTable for screen line memory locations
		;We don't need the Xpos for now, so we set B to 0
		ld b,0
		ld hl,scr_addr_table
		;Each memory location is 16 bit (2bytes) so we add B twice to HL
		;This means HL points to data containing the 16 bit Memory location of the line we want.
		add hl,bc
		add hl,bc
		;We need to load HL with the data at the memory location in HL, so we load the low byte into A
		ld a,(hl)
		;Use the fast INC L, not the slower INC HL, because we used ALIGN 2
		;this means the data won't go over a 255 byte boundary (we know we're not on &80FF	
		;Align will have added 0 bytes to ensure we're not
		inc l
		;Load H from (HL). H doesn't get erased until after (HL) has given us the byte we need.
		ld h,(hl)
		;Then load L from A, which we did above
		ld l,a
	;Get our ByteCount back. 
	pop bc
	;We want B (the Xpos) to be in the low byte 
	ld c,b
	;And we need to set the high byte to the position of our memory buffer (&C0, cos screen is at &C000)
	ld b,&C0
	;Add BC to HL
	add hl,bc
	;HL now contains the screen memory position of the X,Y pos we wanted
ret

;On CPC line tends to be &0800 below the last one, so we add &08 to H - which is faster than messing with HL
GetNextLine:
	ld a,h
	add &08
	ld h,a
	;Test the specified bit (left most)
	;When we go over &FFFF we need to start back again at the top
	;If the top bit is zero, then we've rolled back to &0000, which means we are done
	bit 7,h
	ret nz
	;If we got here we rolled over, but we can fix things by adding &C050 to get the correct position of the line.
	ld bc,&c050
	add hl,bc
ret

;Start the SpriteGrabber, check we were given 5 parameters
GetSprite: 
	cp 5
	ret nz
	;Parameters come in backwards, and are always 16bit, so MEMDEST is at byte 8 and 9, this is where we will store the sprite
	ld e,(ix+8)
	ld d,(ix+9)
	;X is at position 6, Y is at position 4, we only expect 8bits, so we ignore positions 7 and 5. These are the screen pos to grab from
	ld b,(ix+6)
	ld c,(ix+4)
	;Load the width from position 2
	ld a,(ix+2)
	;Store it in IYH
	ld iyh,a
	;And also the destination memory
	ld (de),a
	;Increase the destination memory pointer
	inc de
	;Load the height into the accumulator
	ld a,(ix+0)
	;Store it in IYL
	ld iyl,a
	;Also store it in the destination
	ld (de),a
	;Increase the destination memory pointer
	inc de
	;Convert B,C to a screen memory position(X,Y)
	call GetScreenPos
RepeatY:
	;Back up the screen memory coordinate
	push hl
		;Set BC to the number of bytes we want to copy
		ld b,0
		ld c,iyh
		;User LDIR to copy from the screen to DE
		ldir
	;Get back the screen memory pos, and move down one line
	pop hl
	call GetNextLine
	;Decrease the line counter and repeat if we're not zero
	dec iyl
	jp nz,RepeatY
	;Store the next empty memory position using self-modifying code
	ld (LastSpritePos_Plus2-2),de
ret

;Check if we were given one parameter
GetMemPos:
	cp 1
	ret nz
	;Load the reference into HL
	ld l,(ix+0)
	ld h,(ix+1)
	;Load DE with a value. Note; We're using Self-Modifying code, so the value will be the end of the last sprite
	ld de,&0000 :LastSpritePos_Plus2
	;Write the 16 bit value in DE to the memory position that HL contains
	ld (hl),e
	inc hl
	ld (hl),d
ret

;
PutSprite:
	cp 3
	ret nz
	ld e,(ix+4)
	ld d,(ix+5)
	ld b,(ix+2)
	ld c,(ix+0)
	ld a,(de)
	ld iyh,a
	inc de
	ld a,(de)
	ld iyl,a
	inc de
	call GetScreenPos
RepeatYB:
	push hl
		ld b,0
		ld c,iyh
		ex de,hl
		ldir
		ex de,hl
	pop hl
	call GetNextLine
	dec iyl
	jp nz,RepeatYB

;Align the data to a 2 byte boundary - this allow us to use INC L rather than INC HL
;as we know that the second part will not be at an address like &8100 that would cross a boundary
align 2
; This is the screen addresses of all the lines of the screen - Just copy paste these!
; Note you will have to add the base address of your screen (usually &C000)
; This table is used in Chibi Akumas, where the screen can be at &C000, or &8000 depending on which buffer is shown.
scr_addr_table:
    defb &00,&00, &00,&08, &00,&10, &00,&18, &00,&20, &00,&28, &00,&30, &00,&38;1
    defb &50,&00, &50,&08, &50,&10, &50,&18, &50,&20, &50,&28, &50,&30, &50,&38;2
    defb &A0,&00, &A0,&08, &A0,&10, &A0,&18, &A0,&20, &A0,&28, &A0,&30, &A0,&38;3
    defb &F0,&00, &F0,&08, &F0,&10, &F0,&18, &F0,&20, &F0,&28, &F0,&30, &F0,&38;4
    defb &40,&01, &40,&09, &40,&11, &40,&19, &40,&21, &40,&29, &40,&31, &40,&39;5
    defb &90,&01, &90,&09, &90,&11, &90,&19, &90,&21, &90,&29, &90,&31, &90,&39;6
    defb &E0,&01, &E0,&09, &E0,&11, &E0,&19, &E0,&21, &E0,&29, &E0,&31, &E0,&39;7
    defb &30,&02, &30,&0A, &30,&12, &30,&1A, &30,&22, &30,&2A, &30,&32, &30,&3A;8
    defb &80,&02, &80,&0A, &80,&12, &80,&1A, &80,&22, &80,&2A, &80,&32, &80,&3A;9
    defb &D0,&02, &D0,&0A, &D0,&12, &D0,&1A, &D0,&22, &D0,&2A, &D0,&32, &D0,&3A;10
    defb &20,&03, &20,&0B, &20,&13, &20,&1B, &20,&23, &20,&2B, &20,&33, &20,&3B;11
    defb &70,&03, &70,&0B, &70,&13, &70,&1B, &70,&23, &70,&2B, &70,&33, &70,&3B;12
    defb &C0,&03, &C0,&0B, &C0,&13, &C0,&1B, &C0,&23, &C0,&2B, &C0,&33, &C0,&3B;13
    defb &10,&04, &10,&0C, &10,&14, &10,&1C, &10,&24, &10,&2C, &10,&34, &10,&3C;14
    defb &60,&04, &60,&0C, &60,&14, &60,&1C, &60,&24, &60,&2C, &60,&34, &60,&3C;15
    defb &B0,&04, &B0,&0C, &B0,&14, &B0,&1C, &B0,&24, &B0,&2C, &B0,&34, &B0,&3C;16
    defb &00,&05, &00,&0D, &00,&15, &00,&1D, &00,&25, &00,&2D, &00,&35, &00,&3D;17
    defb &50,&05, &50,&0D, &50,&15, &50,&1D, &50,&25, &50,&2D, &50,&35, &50,&3D;18
    defb &A0,&05, &A0,&0D, &A0,&15, &A0,&1D, &A0,&25, &A0,&2D, &A0,&35, &A0,&3D;19
    defb &F0,&05, &F0,&0D, &F0,&15, &F0,&1D, &F0,&25, &F0,&2D, &F0,&35, &F0,&3D;20
    defb &40,&06, &40,&0E, &40,&16, &40,&1E, &40,&26, &40,&2E, &40,&36, &40,&3E;21
    defb &90,&06, &90,&0E, &90,&16, &90,&1E, &90,&26, &90,&2E, &90,&36, &90,&3E;22
    defb &E0,&06, &E0,&0E, &E0,&16, &E0,&1E, &E0,&26, &E0,&2E, &E0,&36, &E0,&3E;23
    defb &30,&07, &30,&0F, &30,&17, &30,&1F, &30,&27, &30,&2F, &30,&37, &30,&3F;24
    defb &80,&07, &80,&0F, &80,&17, &80,&1F, &80,&27, &80,&2F, &80,&37, &80,&3F;25
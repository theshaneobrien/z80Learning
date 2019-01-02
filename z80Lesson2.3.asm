;Define a constant symbol, ScreenSize as &4000 (16k)
ScreenSize equ &4000

;Program starts at &8200
org &8200

;Load the accumulator with the byte for cyan?
ld a, %00001111

;Define a Label
FillAgain:
	;Set HL to the start of screen mem
	ld hl,&C000
	;Set DE to start of screen mem+1
	ld de,&C000+1
	;Set ByteCount to ScreenSize-1
	ld bc,ScreenSize-1
	;Load the value of A to HL
	ld (hl),a
	;Copies HL to DE (ld (de),(hl)), increments de,hl, decrements bc, repeats until bc = 0
	ldir
	
	;Decrement a by 1
	dec a
	;Compare A with 255, when A hits 0 and we Dec A, it becomes 255 (overflow)
	cp 255
	;If A does not match 255, jump back to label FillAgain
	jp nz, FillAgain

;Return to basic
ret
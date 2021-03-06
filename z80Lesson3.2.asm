org &8000

;Load a with the value stored at &9000, passed in from basic
ld a,(&9000)
;Load bc
ld bc,(&9001)

;if the accumulator (a) is 0, we are adding
;Compare the accumulator to 0 (a-0 = 0), sets the z flag if a is 0 (other flags are nz, c, nc)
;0=Add in basic, zero from zero equals zero, so jump to MathAdd, "jr z"
cp 0
jr z,MathAdd
;if a is 1, we are subtracting
;1=Subtract in basic, so if we entered one, the above would have equalled -1 and not jumped
;Compare the accumulator to 1 (a-1 - 0), sets the z flag if a is 1
cp 1
jr z,MathSub
;and so on
cp 2
jr z,MathMult
cp 3
jr z,MathDiv

;if a didn't equal zero before this line, we haven't jumped, and aren't going to do anything, so reset a
ld a,0


SaveResult:
	;Load whatever's in a in memlocation &9003
	ld (&9003),a
;return to basic
ret

MathSub:
	;Load a with whatever is stored at c
	ld a,c
	;subtract whatever is stored at b from a
	sub b
jr SaveResult

MathAdd: 
	;Load a with whatever is stored at c
	ld a,c
	;add whatever is stored at b from a
	add b
jr SaveResult

MathMult:
	;Load a with whatever is stored at b
	ld a,b
	;Compares the accumulator to 0, sets the zero flag if it matches
	cp 0
	;Jump if the zero flag is set
	jr z, SaveResult
	;if it isn't, make a equal 0
	ld a,0
MathMultAgain:
	;Add c to a
	add c
	;djnz decreases b and jumps to the designated label if b does not equal 0, doesn't set a flag
	djnz MathMultAgain
jr SaveResult

MathDiv:
	;Load a with whatever value is stored at c
	ld a,c
	;Compare a to 0, sets a zero flag
	cp 0
	;Jump if the zero flag is set
	jr z, SaveResult
	;If a is not 0, Load d with the value 0
	ld d,0
MathDivAgain:
	;subtract the value at b from a
	sub b
	;increment d
	inc d
	;repeat until we hit a negative number (over 8 bits)
	jp nc, MathDivAgain
	;if we hit a negative number (over 8 bits), we've gone 1 times over our answer so decrement d again
	dec d
	;Load the value at d into a
	ld a,d
;Jump to up to SaveResult
jr SaveResult
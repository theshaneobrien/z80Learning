org &8000

;Load a with the value stored at &9000, passed in from basic
ld a,(&9000)
;Load bc
ld bc,(&9001)

;if the accumulator (a) is 0, we are adding
;Compare the accumulator to 0 (a-0 = 0), sets the z flag if it matches (other flags are nz, c, nc)
;0=Add in basic, zero from zero equals zero, so jump to MathAdd, "jr z"
cp 0
;Jump if zero flag is set
;JR can only jump 128 bytes ahead or behind, use JP to jump further
;JR slower but uses only 1 byte, JP faster but uses 2 bytes
jr z,MathAdd
;if a is 1, we are subtracting
;1=Subtract in basic, so if we entered one, the above would have equalled -1 and not jumped
;Compare the accumulator to 1 (a-1 - 0), sets the zero flag if it matches
cp 1
;Jump if zero flag is set
jr z,MathSub

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
	
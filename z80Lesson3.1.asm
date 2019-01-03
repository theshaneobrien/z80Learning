org &8000

;Load a with the value stored at &9000, passed in from basic
ld a,(&9000)
;Load bc
ld bc,(&9001)

;if the accumulator (a) is 0, we are adding
;compare subtracts 0 from a, but doesn't store it anywhere
;0=Add in basic, zero from zero equals zero, so jump to MathAdd, "jr z"
cp 0
jr z,MathAdd
;if a is 1, we are subtracting
;1=Subtract in basic, so if we entered one, the above would have equalled -1 and not jumped
;so we compare it to 1 now, z80 again, subtracts 1 from a, which equals zero, so we jump to MathSub
cp 1
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
	
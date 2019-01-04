PrintChar equ &BB5A
WaitChar equ &BB06
StrnLeng equ 5

org &8100

ld b,StrnLeng

EnterCharacters:
	call WaitChar
	call PrintChar
	push af
djnz EnterCharacters

PrintMiddle:
	ld a,' '
	call PrintChar
	ld a,'|'
	call PrintChar
	ld a,' '
	call PrintChar
	ld b,StrnLeng
jr PrintStack

PrintStack:
	pop af
	call PrintChar
djnz PrintStack
ret

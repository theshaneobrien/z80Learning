;Using the Amstrads PrintCharacter function
PrintChar equ &BB5A

;Program starts here
org &8200
	;Set IX to the SquareBrackets function
	ld ix,SquareBrackets
	;Set HL to the Message function
	ld hl,Message
	;Set DE to the PrintString function
	ld de,PrintString
	;Call the DoBrackets function
	call DoBrackets
	
	;Call the NewLine function
	call NewLine
	
	;Set IX to the CurlyBrackets function
	ld ix,CurlyBrackets
	;Set HL to the Message Function
	ld hl,Message
	;Set DE to the PrintString function
	ld de,PrintString
	;Call the DoBrackets function
	call DoBrackets
;Return to Basic
ret

DoBrackets:
	;Load the value stored at the first byte in the IX register into the accumulator
	ld a,(ix+0)
	;Call the PrintChar function
	call PrintChar
	;Call the DoCallDE function
	call DoCallDE
	;Load the value stored at the second byte in the IX register into the accumulator
	ld a,(ix+1)
;Return to the program that called this function
ret

DoCallDE:
	;We are pushing whatever value is stored in de to the stack
	push de
;ret pops the top of the stack when called(!), stores it in PC
ret


;DB stands for define byte, it allows for one or more bytes, separated by commas.
;The assembler will convert these to their equivalent bytes according to their ASCII code
SquareBrackets: db '[]'
CurlyBrackets: db '{}'

PrintString:
	;Load the value at HL
	ld a,(hl)
	;Compare the accumulator to 255
	cp 255
	;If it matches, return to the program/line(?) that called this function
	ret z
	;Increment HL (loads the next byte stored at HL ish)
	inc hl
	;Call PrintChar function
	call PrintChar
;Jump to PrintString
jr PrintString

NewLine:
	;Load 13 into the accumulator, when printed this is a "Carriage Return"
	ld a,13
	;Print it in basic
	call PrintChar
	;Load 10 into the accumulator, when printed this is a "New Line"
	ld a,10
	;Print it in basic
	call PrintChar
;Return
ret

;If ThinkPositive is defined, compile the line we want to display in the program.
ifdef ThinkPositive
	Message: db 'Z80 is Awesome!',255
else
	Message: db '6510 sucks!',255
endif

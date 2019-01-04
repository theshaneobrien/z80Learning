;This was just a proof of concept to use the stack
PrintChar equ &BB5A
WaitChar equ &BB06

org &8100
call WaitChar
call PrintChar
push af
call WaitChar
call PrintChar
push af
call WaitChar
call PrintChar
push af
call WaitChar
call PrintChar
push af
call WaitChar
call PrintChar
push af
ld a,' '
call PrintChar
ld a,'|'
call PrintChar
ld a,' '
call PrintChar
pop af
call PrintChar
pop af
call PrintChar
pop af
call PrintChar
pop af
call PrintChar
pop af
call PrintChar
ret

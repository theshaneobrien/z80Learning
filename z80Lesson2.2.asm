;Defines a symbol, ScreenSize EQUals &4000. Symbols are constants. 
;&4000 is 16k of memory, same amount of memory as the CPC screen ($C000 to &FFFF)
ScreenSize equ &4000

;Set origin to &8100
org &8100

;Load HL(source) with &C000(Screen Mem starts here)
ld hl,&C000
;Load DE(destination) with &C000+1 (increments screem mem)
ld de,&C000+1
;Load the ByteCount with the ScreenSize-1
ld bc, ScreenSize-1
;Load 0 into the memory held at HL
ld (hl),0
;Copies HL to DE (ld (de),(hl)), increments de,hl, decrements bc, repeats
ldir
;Return to basic
ret

;Copies 0 to &C000
;Every time LDIR repeats HL (0) gets copied to DE (&C000++) and BC decrements
;16k worth of screen data gets set to 0 bytes
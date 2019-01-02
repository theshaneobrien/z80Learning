;Sets the origin to Memory Location &8000;
org &8000

;Set HL register to $0000
;&0000 is just some system junk
ld hl,&0000
;Sets DE to &C000
ld de,&C000
;Set BC, the ByteCount to &4000 which is 16k, the size of the cpc screen
ld bc,&4000
;Load, Increment, Repeat. 
;Copies the value of HL to DE (ld (de),(hl)), increments de,hl, decrements bc, repeats
ldir

;return to basic
ret
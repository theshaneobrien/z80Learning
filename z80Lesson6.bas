10 MODE 1
20 PRINT"aaa111":PRINT"bbb222":PRINT"ccc333"
30 s1%=&9000
40 s2%=0
45 s0%=0
50 CALL &8000,s1%,0,0,6,24
60 CALL &8006,@s2%
70 CALL &8000,s2%,6,0,6,24
71 CALL &8006,@s0%
75 CALL &8000,s0%,12,0,6,24
80 CALL &8003,s1%,50,50
100 X=10:Y=10
110 GOTO 270
200 X2=X:Y2=Y
210 A$=UPPER$(INKEY$)
220 if A$="Z" then X=X-1
230 if A$="X" then X=X+1
240 if A$="K" then Y=Y-4
250 if A$="M" then Y=Y+4
255 if X2=X AND Y2=Y THEN GOTO 200
260 call &8003,s0%,X2,Y2
270 call &8003,s2%,X,Y
280 goto 200
5 CLS
10 INPUT "Val1";a
20 INPUT "Val2";b
30 INPUT "0=Add, 1=Sub, 2=Multiply";c
40 POKE (&9000),c
50 POKE (&9001),a
60 POKE (&9002),b
70 CALL &8000
80 PRINT PEEK(&9003)
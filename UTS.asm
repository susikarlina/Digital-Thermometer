ORG 00H
MOV P1,#11111111B   ; P1 sebagai inputan
MOV P0,#00000000B   ; P0 sebagai output port
MOV P3,#00000000B   ; P3 sebagai output port
MOV DPTR,#LABEL     ; load alamat dari "LABEL" ke DPTR
MAIN: MOV R4,#250D  ; load register R4 dengan 250D
      CLR P3.7      ; Cs=0
      SETB P3.6     ; RD high
      CLR P3.5      ; WR low
      SETB P3.5     ; low to high pulse to WR for starting conversion
WAIT: JB P3.4,WAIT  ; polls until INTR=0
      CLR P3.7      ; ensures CS=0
      CLR P3.6      ; high ke low pulse ke RD untuk membaca data dari ADC	
      MOV A,P1      ; pindahkan digital output dari ADC ke accumulator A
      MOV B,#10D    ; load B dengan 10D
      DIV AB        
      MOV R6,A      ; pindahkan A ke R6
      MOV R7,B      ; pindahkan B ke R7
DLOOP:SETB P3.2     ; sets P3.2 yang mengaktifkan segment 1
      MOV A,R6      ; pindahkan R6 ke A
      ACALL DISPLAY ; memanggil DISPLAY subroutine
      MOV P0,A      ; pindahkan A ke P0
      ACALL DELAY   ; memanggil DELAY subroutine
      CLR A         ; clear A
      MOV A,R7      ; pindahkan R7 ke A
      CLR P3.2      ; deactivates LED segment 1
      SETB P3.1     ; activates LED segment 2
      ACALL DISPLAY
      MOV P0,A      
      ACALL DELAY
      CLR A 
      CLR P3.1      ; deactivates LED segment 2
      DJNZ R4,DLOOP ; ulangi loop "DLOOP" sampai R4=0
      SJMP MAIN     ; jump back ke main loop
DELAY: MOV R3,#255D ; produces around 0.8mS delay
LABEL1: DJNZ R3,LABEL1          
        RET
DISPLAY: MOVC A,@A+DPTR ; convert A's ke corresponding digit drive pattern 
         RET
LABEL: DB 3FH       
       DB 06H
       DB 5BH
       DB 4FH
       DB 66H
       DB 6DH
       DB 7DH
       DB 07H
       DB 7FH
       DB 6FH
END 
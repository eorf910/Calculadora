
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


;funciones de la calculadora 
 
CALL CAPT; llamar a capturar operando 
PUSH AX; guarda dato 1 en pila
 
MOV AH,01h; capturar operador 
INT 21h 

MOV DL,AL; lo guarda el DL 
CALL CAPT; llamar a capturar operando  

MOV BX,AX; guarda dato 2 en BX 
POP AX; recupera dato 1 


;comparacion del operador para llamar al procedimiento de la operacion escogida 

CMP DL,2Bh; (+) 
JZ SUMA ;salta a sumar 

CMP DL,2Dh;(-) 
JZ RESTA ; salta a restar 

CMP DL,2Ah;(*) 
JZ MULT;salta a multiplicar 

CMP DL,2Fh; (/) 
JZ DIVISION; salta a dividir 


RESULTADO: 
MOV AH,02h; posición de retorno de calculo 
MOV DL,3Dh; (=) 
INT 21h; imprime caracter 
MOV DL,CL; acarreo o signo negativo 
INT 21h; imprime caracter 
MOV DL,BH; digito mas significativo 
INT 21h; imprime caracter 
MOV DL,BL; digito menos significativo 
INT 21h; imprime caracter 
RET; retornar a la interfase gráfica que lo llamo 

;capturar operando 
CAPT: 
MOV AH,01h 
INT 21h 
MOV BH,AL 
INT 21h 
MOV AH,BH 
SUB AX,3030h 
RET 

SUMA: 
MOV CL,00 
ADD AX,BX 
CMP AL,0Ah 
JB DIGITO 
DAA 
INC AH 
DIGITO: 
MOV BL,AL 
MOV AL,AH 
CMP AL,0Ah 
JB DECENA 
DAA 
MOV CL,31h 
DECENA: 
MOV BH,AL 
AND BX,0F0Fh 
OR BX,3030h 
JMP RESULTADO 

resta: 
MOV CL,00 
CMP AX,BX 
JGE restar 
XCHG AX,BX 
MOV CL,2Dh 
restar: 
SUB AX,BX 
CMP AL,0Ah 
JB listo 
DAS 
listo: 
MOV BX,AX 
AND BX,0F0Fh 
OR BX,3030h 
JMP RESULTADO 

;nota: multiplicaciones de operandos de un digito 
MULT: 
MOV CL,00 
MUL BL 
AAM 
MOV BX,AX 
AND BX,0F0Fh 
OR BX,3030h 
JMP RESULTADO 

;divisiones de numeros resultado de productos de un digito DIV es rervada no se usa como etiqueta 
DIVISION: 
MOV CL,00 
AAD 
DIV BL 
MOV BL,AL 
OR BL,30h 
JMP RESULTADO 

AND_LOGICA: 
AND BX,AX 
OR BX,3030h 
MOV CX,0000h 
JMP RESULTADO 

END 

ret





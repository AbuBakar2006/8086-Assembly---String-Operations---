.MODEL SMALL
.STACK 100H

.DATA
    ;STRING DB "Muhammad Abubakar$"
    STRING DB 50 DUP("?")
    CASESTRING DB 50 DUP("?")
    NEWLINE DB 0AH,0DH,"$"
    VOWELS DB 01H ,"$"
    CONSONANT DB 01H,"$" 
    REVERSED_STRING DB 50 DUP("?")   
    BINARY_STRING DB 500 DUP("?")
    HEX_STRING DB 100 DUP("?")
    BINARY_ONE DB 00H,"$"
    BINARY_ZERO DB 00H,"$"
    VOWEL_FREE DB 50 DUP("?")
    CONSONANT_FREE DB 50 DUP("?")
    
    
    
    ;OUTPUT MSG
    MSG1 DB "ENTER NAME: $" 
    MSG2 DB "ENTERED NAME: $"
    MSG3 DB "CASE INVERTED NAME: $" 
    MSG4 DB "VOWELS: $"
    MSG5 DB "CONSONANTS: $"
    MSG6 DB "REVERSED STRING:  $"
    MSG7 DB "BINARY STRING:  $"
    MSG8 DB "No. of 1's : $"
    MSG9 DB "No. of 0's : $"                   
    MSG10 DB "HEXADECIMAL STRING:   $"
    MSG11 DB "STRING WITHOUT VOWELS:       $"
    MSG12 DB "STRING WITHOUT CONSONANTS:   $"
    
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    
    ;OUTPUT MSG1
    MOV AH,09H
    LEA DX,MSG1 
    INT 21H
    
    
    ;TAKING INPUT
    MOV SI,OFFSET STRING
    XOR CX,CX
    
    LOOP_START:
    INC CL
    
    MOV AH,01H
    INT 21H
    MOV [SI],AL
    
    CMP [SI],"$"
    JE LOOP_EXIT
   
    INC SI
    
    JMP LOOP_START
    
    LOOP_EXIT:
    
    MOV BX,OFFSET STRING       
    MOV SI,OFFSET CASESTRING   
    XOR DX,DX                  
    XOR AX,AX
    
    ;CHANGING CASE
    
    CASE_INVERT:
    
    MOV DL,[BX] 
    
    CMP DL,"$"
    JE EXIT
    
    CMP DL," "
    JZ ENDL
    
    CMP DL,"a"
    JL LOWER
    
    CMP DL,'Z'
    JA UPPER
    
    LOWER:
    ADD DL,20H
    
    
    JMP ENDL
    
    UPPER:
    SUB DL,20H
    
    ENDL: 
    
    MOV [SI],DL
    INC SI
    INC BX
    
    INC AL
    LOOP CASE_INVERT
    
    EXIT: 
    
    MOV [SI],DL
    MOV CL,AL
    
    ;VOWELS/CONSONANTS
    MOV BX,OFFSET STRING    
    XOR DX,DX
    XOR AX,AX
    
        
    VOWELS_CONSONANTS:
    
    MOV DL,[BX]
     
    CMP DL,"$"
    JE LOOP_END
    
    CMP DL," "
    JZ LOOP_END
       
    CMP DL,"A"
    JE VOWEL
    CMP DL,"a"
    JE VOWEL
    CMP DL,"E"
    JE VOWEL
    CMP DL,"e"
    JE VOWEL
    CMP DL,"I"
    JE VOWEL
    CMP DL,"i"
    JE VOWEL
    CMP DL,"O"
    JE VOWEL
    CMP DL,"o"
    JE VOWEL
    CMP DL,"U"
    JE VOWEL
    CMP DL,"u"
    JE VOWEL
     
    INC AH 
    JMP LOOP_END
     
    VOWEL:
    INC AL
   
    LOOP_END:
    INC BX
    
    LOOP VOWELS_CONSONANTS  
    
    ADD AL,30H
    ADD AH,30H     
    
    MOV SI,OFFSET VOWELS
    MOV [SI],AL
    
    MOV SI,OFFSET CONSONANT
    MOV [SI],AH
    
    MOV BX,OFFSET STRING
    XOR DX,DX  
    XOR CX,CX
    
    STACK_MEMORY:
    CMP [BX],"$"
    JE STACK_MEMORY_EXIT
    
    PUSH [BX]
    INC BX
    INC CL
    
    JMP STACK_MEMORY
    STACK_MEMORY_EXIT:
    
    
    MOV BX,OFFSET REVERSED_STRING 
     
    RETRIVE:
    
    POP [BX]
    INC BX
    LOOP RETRIVE
                                            
    MOV [BX],"$"
                        
    MOV BX,OFFSET REVERSED_STRING
    
    MOV BX,OFFSET STRING
    MOV SI, OFFSET BINARY_STRING
    MOV AX,AX
    
    
    BINARY_CONVERSION:
      CMP [BX],"$"
      JE EXIT_BINARY_CONVERSION
      MOV AL,[BX]
      MOV CL,8
      TRUE_CONVERSION:
       
       SHL AL,1
       JC ONE
       
       INC [BINARY_ZERO]
       MOV [SI],"0"
       JMP INCREASE
       
       ONE:
       
       INC [BINARY_ONE]
       MOV [SI],"1"
    
       INCREASE:
          INC SI
    
    
       LOOP TRUE_CONVERSION
       MOV [SI]," "
       INC SI
       INC BX
       
    JMP BINARY_CONVERSION
    
    EXIT_BINARY_CONVERSION:
    
    MOV [SI],"$" 
               
    MOV BX,OFFSET STRING
    MOV SI,OFFSET VOWEL_FREE
    XOR DX,DX 
     
    FREE_VOWEL:
       MOV DL,[BX]
       
        CMP DL,"$" 
        JE EXIT_VOWEL_FREE
       
        CMP DL,"A"
        JE VOWEL2 
        
        CMP DL,"a"
        JE VOWEL2
        
        CMP DL,"E"
        JE VOWEL2
        
        CMP DL,"e"
        JE VOWEL2
        
        CMP DL,"I"
        JE VOWEL2
        
        CMP DL,"i"
        JE VOWEL2
        
        CMP DL,"O"
        JE VOWEL2
        
        CMP DL,"o"
        JE VOWEL2
        
        CMP DL,"U"
        JE VOWEL2
        
        CMP DL,"u"
        JE VOWEL2
          
    MOV [SI],DL
    INC SI
    JMP END2
    
    VOWEL2:
    MOV [SI]," "
    INC SI
    END2:
       
    INC BX   
    
    JMP FREE_VOWEL         
    EXIT_VOWEL_FREE:
    
    MOV [SI],"$"
     
      
    MOV BX,OFFSET STRING
    MOV SI,OFFSET CONSONANT_FREE
    XOR DX,DX 
     
    FREE_CONSONANT:
       MOV DL,[BX]
       
        CMP DL,"$" 
        JE EXIT_CONSONANT_FREE
       
        CMP DL,"A"
        JE VOWEL3 
        
        CMP DL,"a"
        JE VOWEL3
        
        CMP DL,"E"
        JE VOWEL3
        
        CMP DL,"e"
        JE VOWEL3
        
        CMP DL,"I"
        JE VOWEL3
        
        CMP DL,"i"
        JE VOWEL3
        
        CMP DL,"O"
        JE VOWEL3
        
        CMP DL,"o"
        JE VOWEL3
        
        CMP DL,"U"
        JE VOWEL3
        
        CMP DL,"u"
        JE VOWEL3
          
    MOV [SI]," "
    
    JMP END3
    
    VOWEL3:
    MOV [SI],DL
    
    END3:
    INC SI   
    INC BX   
    
    JMP FREE_CONSONANT
    EXIT_CONSONANT_FREE:
    
    MOV [SI],"$"    
  
      
    MOV BX,OFFSET STRING
    MOV SI,OFFSET HEX_STRING 
    XOR DX,DX
    XOR CX,CX
    XOR AX,AX
    
    HEX:
       CMP [BX],"$"
       JE HEX_EXIT
       
       MOV AX,[BX]
       MOV CX,AX
       
       AND AX,00F0H
       AND CX,000FH
        
       SHR AX,4 
       
       CMP AX,0AH
       JL AXADD
       
           ADD AX,55
       JMP CMPCX
       AXADD:
       
           ADD AX,30H
       
       CMPCX:
       CMP CX,0AH
       
       JL CXADD
       
           ADD CX,55
           
       JMP INCREASE2
              
       CXADD:
       ADD CX,30H
       
       INCREASE2:       
       
       
       MOV [SI],AX
       INC SI
       MOV [SI],CX
       INC SI
       
       MOV [SI]," "
       INC SI
       
       INC BX   
    JMP HEX
    
    
    HEX_EXIT:
    
      MOV [SI],"$"
  
      
      
      
      
      
      
      
    
    ;OUTPUTS
    
    MOV AH,09H 
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG2
    INT 21H
    
    LEA DX,STRING
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG3
    INT 21H
    
    LEA DX,CASESTRING
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG4
    INT 21H
    
    LEA DX,VOWELS
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG5
    INT 21H
    
    LEA DX,CONSONANT
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG6
    INT 21H
    
    LEA DX, REVERSED_STRING
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG7
    INT 21H
    
    LEA DX, BINARY_STRING
    INT 21H 
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG10
    INT 21H
    
    LEA DX,HEX_STRING
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG11
    INT 21H
    
    LEA DX,VOWEL_FREE
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG12
    INT 21H
    
    LEA DX,CONSONANT_FREE
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG8
    INT 21H
    
    LEA DX, BINARY_ONE
    INT 21H
    
    LEA DX,NEWLINE
    INT 21H

    LEA DX,NEWLINE
    INT 21H
    
    LEA DX,MSG9
    INT 21H
    
    LEA DX, BINARY_ZERO
    INT 21H
    
    
    
MAIN ENDP
END MAIN
**************************************
*
* Collin Folkmann
* A5
*
* Program description:
* Program processes a table of 1-byte numbers, ending 
* with sentinel val. $00. Each number is passed from the
* main program to the subroutine via b register. The 
* subroutine uses dynamic local variables allocated on
* the stack toc ompute the 4-byte fibonacci number. After 
* the result is calculated, it's returned to the main program 
* via the stack. The main program pulls the upper and lower two
* bytes off the stack an stores them into the RESARR array.
*
* Pseudocode of Main Program:
*
* unsigned int NARR[]
* unsigned int RESARR[]
*
* pointer1=&NARR[0];
* pointer2=&RESARR[0];
* while (*pointer1 != sentinel){
* B-register=*pointer1;
* save pointer1 on stack;
* call subroutine
* get upper 2 bytes of fibonacci number off the stack
* store it to memory where pointer2 is pointing to
* get lower 2 bytes of fibonacci number off the stack
* store it to memory where pointer2+2 is pointing to
* pointer2+=4;
* restore pointer1 from stack;
* pointer1++
* }
* END
*
*
*---------------------------------------
*
* Local subroutine variables (allocated dynamically on stack) 
*
* unsigned int RETURN_VAL (4-byte, reserved first, top of the stack after RTS)
* unsigned int N (1-byte, holds value passed from b register)
* unsigned int RESULT (4-byte, holds current fibonacci val)
* unsigned int PREV (4-byte, holds previous fibonacci val)
* unsigned int NEXT (4-byte, temporary for next fibonacci val)
* 
*
* Pseudocode Subroutine
*
*
* N = value sent to the subroutine
* RESULT=1
* PREV=1
* while(N>2){
* NEXT(lower two bytes) = RESULT (lower two bytes)+ PREV (lower two bytes);
* NEXT(upper two bytes) = RESULT (upper two bytes);
* if( C-flag ==1) NEXT(upper two bytes) ++;
* NEXT(upper two bytes) += PREV (upper two bytes);
*
* (the above implements a 4-byte addition using two 2-byte additions)
*
* PREV(upper two bytes) = RESULT (upper two bytes);
* PREV(lower two bytes) = RESULT (lower two bytes);
*
* RESULT(upper two bytes) = NEXT (upper two bytes);
* RESULT(lower two bytes) = NEXT (lower two bytes);
*
* N--;
* }
* }
* pull return address off
* push lower two bytes of result onto stack
* push upper two bytes of result onto stack
* push return address back
* RTS
*
**************************************
* start of data section
	ORG $B000
NARR	FCB	1, 2, 5, 10, 20, 128, 254, 255, $00
SENTIN	EQU	$00

	ORG $B010
RESARR	RMB	32	



* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including NARR and RESARR.



	ORG $C000
	LDS	#$01FF	        initialize stack pointer
* start of your main program
	LDX	#NARR		initialize pointer1
	LDY	#RESARR		initialize pointer2
WHILE	LDAB	0,X		while(*pointer1 !=SENTINEL){
	CMPB	#SENTIN		
	BEQ	ENDWHILE	  (*pointer in B register)
	PSHX			  save pointer1 on stack;
	JSR	FIBO		  jump to subroutine
	PULA
	PULB			  get upper two result bytes off the stack
	STD	0,Y		  store them in RESARR array
	PULA
	PULB 			  get lower two result bytes off the stack
	STD	2,Y		  store them in RESARR array
	LDAB	#$4
	ABY			  pointer2+=4;
	PULX			  restore pointer1 from stack
	INX			  pointer1++;
	BRA	WHILE	       }
ENDWHILE
DONE	STOP



* define any variables that your SUBROUTINE might need here
* start of data section
	ORG $B000
NARR	FCB	1, 2, 5, 10, 20, 128, 254, 255, $00
SENTIN	EQU	$00

	ORG $B010
RESARR	RMB	32	



* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including NARR and RESARR.



	ORG $C000
	LDS	#$01FF	        initialize stack pointer
* start of your main program
	LDX	#NARR		initialize pointer1
	LDY	#RESARR		initialize pointer2
WHILE	LDAB	0,X		while(*pointer1 !=SENTINEL){
	CMPB	#SENTIN		
	BEQ	ENDWHILE	  (*pointer in B register)
	PSHX			  save pointer1 on stack;
	JSR	FIBO		  jump to subroutine
	PULA
	PULB			  get upper two result bytes off the stack
	STD	0,Y		  store them in RESARR array
	PULA
	PULB 			  get lower two result bytes off the stack
	STD	2,Y		  store them in RESARR array
	LDAB	#$4
	ABY			  pointer2+=4;
	PULX			  restore pointer1 from stack
	INX			  pointer1++;
	BRA	WHILE	       }
ENDWHILE
DONE	STOP



	ORG $D000
* start of your subroutine
FIBO	PULX		;pull return address 
	DES		;4 bytes for return value 
	DES
	DES
	DES
	PSHX		;push return address
	DES		;1 byte for n 
	DES		;4 bytes for RESULT 
	DES
	DES
	DES
	DES		;4 bytes for PREV
	DES
	DES
	DES
	DES		;4 bytes for NEXT 
	DES
	DES
	DES
	TSX		
	
	STAB	12,X
	
	LDD	#0
	STD	8,X	;stores 0 in upper 2 bytes of RESULT
	STD	4,X	;stores 0 in upper 2 bytes of PREV
	
	LDD	#1
	STD	10,X	;stores 1 in lower 2 bytes of RESULT
	STD	6,X	;stores 1 in lower 2 bytes of PREV

WHIL	LDAA	12,X	;load N 
	CMPA	#2	
	BLS	ENDWHIL	;while(n>2)

	LDD	10,X	;RESULT lower 
	ADDD	6,X	;+PREV lower 
	STD	2,X	;store in NEXT lower 		
	
	LDD	8,X	;RESULT upper
IF	BCC	ENDIF	;if carry is clear, skip
THEN	ADDD	#1	;handle carry 	
ENDIF	ADDD	4,X	;+PREV upper
	STD	0,X	;store in NEXT upper

	LDD	8,X	;PREV upper = RESULT upper
	STD	4,X	
	LDD	10,X	;PREV lower = RESULT lower 
	STD	6,X
	
	LDD	0,X	;RESULT upper = NEXT upper
	STD	8,X
	LDD	2,X	;RESULT lower = NEXT lower
	STD	10,X
	
	DEC	12,X	;N--
	BRA	WHIL

ENDWHIL

	LDD	10,X	;RESULT lower 2 bytes 
	STD	17,X	
	
	LDD	8,X	;RESULT upper 2 bytes 
	STD	15,X	

	
	INS		;clean up stack 
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	INS
	RTS		;return to main program 
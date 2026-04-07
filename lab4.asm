**************************************
*
* Name:Collin Folkmann
* ID:16331039
* Date:4/1/2025
* Lab4
*
* Program description:
* This program reads the byte values from the array NARR.
* The program calls a subroutine that calculates the 4-byte
* fibonacci number. The result for each fibonacci number is 
* stored in the RESARR array. 
*
* Pseudocode of Main Program:
* 
* unsigned int N;
* unsigned int senti = 0
* unsigned int NARR[] = {1,2,5,10,20,128,254,255,0};
* unsigned int RESARR[8]; //(each element is 4byte)
* unsigned int *ptr1 =&NARR;
* unsigned int *ptr2 =&RESARR;
* while(*ptr1 != senti){
* 	N = *ptr1;
* 	fibo(); 
*	*ptr2 = result;
*	ptr2 ++;
*	ptr1++;
* }
* 
*---------------------------------------
*
* Pseudocode of Subroutine:
*
* unsigned int N;
* unsigned int RESULT;	(4-byte)
* unsigned int PREV;		(4-byte)
* unsigned int NEXT;		(4-byte )

* RESULT = 1;
* PREV = 1;
* while(N > 2){
* 	NEXT = RESULT + PREV
*	PREV = RESULT;
*	RESULT = NEXT;
*	N--;
* }
**************************************



* start of data section
	 	ORG	$B000
NARR	 	FCB	1, 2, 5, 10, 20, 128, 254, 255, $00	;unsigned int NARR[] = {1,2,5,10,20,128,254,255,0};
SENTI	EQU	$00									; unsigned int senti = 0;

	 	ORG	$B010
RESARR 	RMB	32									; unsigned int RESARR[8];



* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including NARR and RESARR.

	ORG	$C000
	LDS	#$01FF		initialize stack pointer

* start of your main program

	LDX	#NARR			; unsigned int *ptr1 =&NARR;
	LDY	#RESARR		; unsigned int *ptr2 =&RESARR;

WHILE	LDAB	0,X			; while(*ptr1 != senti){
	CMPB 	#SENTI
	BEQ	ENDWHILE
	PSHX				; N = *ptr1;
	JSR	FIBO			; fibo();
	PULA
	PULB
	STD	0,Y			; *ptr2 = result;
	PULA
	PULB
	STD	2,Y
	LDAB	#$4
	ABY				; ptr2++;
	PULX
	INX				;ptr1++;
	BRA	WHILE		
ENDWHILE
DONE	STOP		


* define any variables that your SUBROUTINE might need here
	
		ORG	$D000
RESULT	RMB	4		; unsigned int RESULT;
NEXT		RMB	4		; unsigned int NEXT;
PREV 	RMB	4			; unsigned int PREV;
N		RMB	1		;unsigned int N;	
* start of your subroutine

FIBO STAB	N
	LDD		#0
	STD		RESULT 
	STD		PREV
	LDD		#1
	STD		RESULT+2	; RESULT = 1;
	STD		PREV+2	; PREV = 1;

WHILL	LDAA		N		;while(N > 2){
	CMPA 	#2
	BLS		ENDWHILL
	LDD		RESULT+2
	ADDD		PREV+2
	STD		NEXT+2	;NEXT = RESULT + PREV;
	LDD		RESULT
	ADDD		PREV
	BCC		ENDIF
	ADDD		#1
ENDIF STD	NEXT

	LDD		RESULT
	STD		PREV
	LDD		RESULT+2
	STD		PREV+2	; PREV = RESULT;
	
	LDD		NEXT
	STD		RESULT
	LDD		NEXT+2
	STD		RESULT+2	;RESULT = NEXT;
	
	DEC		N		;N--;
	BRA		WHILL

ENDWHILL PULX
	LDD		RESULT+2
	PSHB
	PSHA
	LDD		RESULT
	PSHB
	PSHA
	PSHX
	RTS
END
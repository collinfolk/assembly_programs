**************************************
*
* Collin Folkmann
* A3
*
* Program description:This program calculates the Nth element of 
*			    the Fibonacci sequence as a 4-byte number.
*
* Pseudocode:
* 
*unsigned int N = 100;	
*unsigned int RESULT;	(4-byte variable)
*unsigned int COUNT;	(1-byte variable)
*unsigned int PREV;	(4-byte variable)
*unsigned int NEXT;	(4-byte variable)
*
*RESULT = 1;
*PREV = 1;
*COUNT = N;
*while(COUNT > 2) {
*	NEXT = RESULT + PREV;
*	PREV = RESULT;
*	RESULT = NEXT;
*	COUNT --;
* }
**************************************
* start of data section
	ORG	$B000
N	FCB	255	;unsigned int N = 100;
	ORG	$B010
RESULT RMB	4	;unsigned int RESULT;

* define any other variables that you might need here
COUNT	RMB	1	;unsigned int COUNT;
PREV	RMB	4	;unsigned int PREV;
NEXT	RMB	4	;unsigned int NEXT;

* start of your program
	ORG	$C000
	LDD	#1	;RESULT = 1;
	STD	RESULT+2
	CLR	RESULT 
	CLR	RESULT+1
	STD	PREV+2	;PREV = 1;
	CLR	PREV
	CLR	PREV+1
	LDAA	N	;COUNT = N;
	STAA	COUNT

WHILE	LDAA	COUNT	;while(COUNT > 2) {
	CMPA	#2
	BLS	ENDWHILE

	LDD	RESULT+2	;NEXT = RESULT + PREV;
	ADDD	PREV+2
	STD	NEXT+2
	LDD	RESULT
	ADCB	PREV+1
	ADCA	PREV
	STD	NEXT

	LDD	RESULT	;PREV = RESULT;
	STD	PREV
	LDD	RESULT+2
	STD	PREV+2

	LDD	NEXT	;RESULT = NEXT;
	STD	RESULT
	LDD	NEXT+2
	STD	RESULT+2

	DEC	COUNT	;COUNT --;
	BRA	WHILE	;}

ENDWHILE	STOP



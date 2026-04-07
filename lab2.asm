**************************************
*
* Name:Collin Folkmann
* ID:16331039
* Date:2/24/2025
* Lab2
*
* Program description:This program calculates the Nth Fibonacci number.
* The value of N is provided as a constant between 1 and 255. The program
* initializes the first two Fibonacci numbers to 1 and uses a while loop
* to compute the Fibonacci sequence until the Nth term. If N is 1 or 2,
* the program will set the result to 1. If N > 2, the program will calculate
* the Fibonacci numbers by adding the previous two terms. The final result is
* stored as a two-byte value in big-endian format. Pseudo code is provided below
* and along side the assembly language code as comments for clarity!
*
* Pseudocode:
* 
*  #define N 10 
*
*  int main() {
*  	unsigned int prev;
*	unsigned int curr;
*	unsigned int next;
*	unsigned int count;
*	unsigned int result;
*	
*	prev = 1;
*	curr = 1;
*	count = 2;
*	
*	if(N ==1 || N == 2) {
*		result = 1;
*	} else {
*		while (count < N) {
*			next = prev + curr;
*			prev = curr;
*			curr = next;
*			count = count + 1;
*		}
*		result = curr;
*	}
*
*  }
*
**************************************

* start of data section

	 ORG  $B000
N      FCB	200 

	 ORG  $B010
RESULT RMB	2	*unsigned int result;


* define any other variables that you might need here

PREV	 RMB	2	*unsigned int prev;
CURR	 RMB	2	*unsigned int curr;
NEXT   RMB	2	*unsigned int next;
COUNT  RMB	2	*unsigned int count;

	 ORG  $C000

* start of your program

	 LDD  #$0001	*prev = 1;
	 STD	PREV
	 STD	CURR		*curr = 1;
	 ADDD #1		*count = 2;
	 STD COUNT		

IF	 LDAA	#N		*if(N ==1 || N == 2) {
	 CMPA #$01
	 BEQ	THEN 
	 CMPA #$02
	 BEQ 	THEN
	 BRA	ELSE

THEN	 LDD #$0001		*result = 1;
	 STD	RESULT
	 BRA	ENDIF

ELSE	 LDAA	COUNT+1	*else {
	 CMPA	N		*while (count < N) {		
	 BHS  ENDWHL	
	 LDD  PREV		*next = prev + curr;	
	 ADDD CURR
	 STD  NEXT 
	 LDD  CURR		*prev = curr;
	 STD	PREV
	 LDD	NEXT
	 STD	CURR
	 LDAA	COUNT+1	*count = count + 1;
	 INCA
	 STAA	COUNT+1
	 BRA	ELSE

ENDWHL LDD  CURR		*result = curr;
	 STD  RESULT

ENDIF		STOP

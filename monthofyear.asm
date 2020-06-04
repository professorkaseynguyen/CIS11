Lab#6: Months in a Year
; This program acquires user inputs (0-11) and outputs the
; Months in a Year
; Inputs: "Enter a number 0-11 and push Enter: "
; User input: ASCII values 0 through 9
; Outputs: Day of the week, where 0 = January, 11 = December.

.ORIG x3000
START	LEA R0, PROMPT		; load prompt string
	PUTS			; display prompt string to console
	
	; //// FIRST INPUT VALIDATION \\\\
	GETC			; get character from user
	ADD R4, R0, x0		; copy input to R4
	AND R5, R5, x0		; Clear R5
	
	ADD R5, R5, #15		; load #-57 into R5 w/ 2's complement
	ADD R5, R5, #15
	ADD R5, R5, #15
	ADD R5, R5, #12
	NOT R5, R5
	ADD R5, R5, x1
	
	ADD R5, R5, R4		; R5 = input - R5
	BRp ERROR		; Branch positive: input had ASCII value higher than ASCII '9'
	AND R5, R5, x0		; clear R5
	
	ADD R5, R5, #15		; load #-48 into R5 w/ 2's complement
	ADD R5, R5, #15
	ADD R5, R5, #15
	ADD R5, R5, #3
	NOT R5, R5
	ADD R5, R5, x1

	ADD R5, R5, R4		; R5 = input - R5
	BRn ERROR		; Branch negative: input had ASCII value lower than ASCII '0'
	ADD R1, R5, x0		; Copy R5 to R1: this is the numeric value of the ASCII number char entered
	
	LEA R0, NUM		; load NUM characters to R0
	ADD R3, R5, x0		; Copy R5 to R3 for character displaying purposes	
	ADD R3, R3, x0		; R3 = 0, SET UP ZERO BRANCHING, INITIALIZE LOOP BEGIN AT ZERO
MIRROR1	BRz DISPM1		; LOOP LABEL, IF = 0, GO TO DISPLAY
	ADD R0, R0, #2		; R0 += #2, 11 CHARACTER FOR NUMBERS INCLUDING NULL TERMINATED
	ADD R3, R3, #-1		; R3 = OFFSET 1, UPDATE VALUE FOR INCREMENT IN LOOP
	BR MIRROR1		; Go back to MIRROR1 start		
DISPM1	PUTS			; SHOW FIRST NUMBER ON CONSOLE
		
	; //// SECOND INPUT VALIDATION \\\\
	GETC			; get second number
	ADD R4, R0, x0		; copy input to R4
	AND R5, R5, x0		; Clear R5
	
	ADD R5, R5, #15		; load #-57 into R5 w/ 2's complement
	ADD R5, R5, #15
	ADD R5, R5, #15
	ADD R5, R5, #12
	NOT R5, R5
	ADD R5, R5, x1
	
	ADD R5, R5, R4		; R5 = input - R5
	BRp CHKENTR		; Branch positive: input had ASCII value higher than ASCII '9', check if 'Enter' was pressed
	AND R5, R5, x0		; clear R5
	
	ADD R5, R5, #15		; load #-48 into R5 w/ 2's complement
	ADD R5, R5, #15
	ADD R5, R5, #15
	ADD R5, R5, #3
	NOT R5, R5
	ADD R5, R5, x1

	ADD R5, R5, R4		; R5 = input - R5
	BRn CHKENTR		; Branch negative: input had ASCII value lower than ASCII '0', check if 'Enter' was pressed
	ADD R2, R5, x0		; Copy R5 to R2: this is the numeric value of the ASCII number char entered in the "one's" place

	LEA R0, NUM		; load NUM characters to R0
	ADD R3, R5, x0		; Copy R5 to R3 for character displaying purposes	
	ADD R3, R3, x0		; R3 = 0, SET UP ZERO BRANCHING, INITIALIZE LOOP BEGIN AT ZERO
MIRROR2	BRz DISPM2		; LOOP LABEL, IF = 0, GO TO DISPLAY
	ADD R0, R0, #2		; R0 += #2, 11 CHARACTER FOR NUMBERS INCLUDING NULL TERMINATED
	ADD R3, R3, #-1		; R3 = OFFSET 1, UPDATE VALUE FOR INCREMENT IN LOOP
	BR MIRROR2		; Go back to MIRROR2 start		
DISPM2	PUTS			; SHOW SECOND NUMBER ON CONSOLE
	BR LOOP1

CHKENTR	AND R5, R5, x0		; clear R5
	ADD R5, R5, xA		; load xA into R5 (ASCII newline)
	NOT R5, R5
	ADD R5, R5, x1		; R5 = x-10
	ADD R5, R4, R5		; R5 = input - R5
	BRnp ERROR		; some character not 0-9 or enter pressed
	ADD R2, R1, x0		; copy R1 to R2 since we're keeping the "one's" place in R7
	AND R1, R1, x0		; Set R1 to 0

LOOP1	ADD R1, R1, x0		; check value of tens place
	BRz PREPM		; no longer numbers in 10's place
	BRn ERROR		; a negative value got into the 10's place
	ADD R2, R2, xA		; add 10 to R2; this is where we'll store the "index" of the month
	NOT R1, R1
	ADD R1, R1, x2		; R2 = -R2 + 1
	NOT R1, R1		
	ADD R1, R1, x1		; R2 = R2 - 1
	BR LOOP1		; back to start of loop

PREPM	LEA R0, LF		; add new line
	PUTS			; SHOW ON SCREEN
	AND R0, R0, x0		; Input validation: check that value of input < 12
	ADD R0, R0, xB		; R0 = 11
	NOT R0, R0		; 1's complement
	ADD R0, R0, x1		; R0 = -11, two's complement
	ADD R0, R0, R2		; R0 = R1 - 11
	BRnz GOODIN		; BRANCH NEGATIVE-ZERO: entered number is 0-11, jump to GOODIN ("Good Input")
	LEA R0, ERRNUM		; Load invalid number string
	PUTS			; display to console
	LEA R0, LF		; newline
	PUTS			; display newline
	BR START		; Go back to beginning of program

GOODIN	LEA R0, MONTHS		; load MONTHS to R0
	AND R3, R3, x0		; clear R3
	ADD R3, R2, x0		; R3 = 0, SET UP ZERO BRANCHING, INITIALIZE LOOP BEGIN AT ZERO
LOOP2	BRz DISPLAY		; LOOP LABEL, IF = 0, GO TO DISPLAY
	ADD R0, R0, #10		; R0 += #10, 10 CHARACTER FOR MONTHS INCLUDING NULL TERMINATED
	ADD R3, R3, #-1		; R3 = OFFSET 1, UPDATE VALUE FOR INCREMENT IN LOOP
	BR LOOP2		; Go back to LOOP2 start		
DISPLAY	PUTS			; SHOW ON SCREEN
	LEA R0, LF		; LOAD LF TO R0, LF HOLD MONTHS AS STRINGS
	PUTS			; SHOW ON SCREEN
	BR START		; RELOOP TO PROMPT
		
ERROR	LEA R0, LF
	PUTS
	LEA R0, ERRSTR
	PUTS
	HALT

;DATA
PROMPT	.STRINGZ "Enter a number and ENTER or two numbers 0-11: "
NUM	.STRINGZ "0"
	.STRINGZ "1"
	.STRINGZ "2"
	.STRINGZ "3"
	.STRINGZ "4"
	.STRINGZ "5"
	.STRINGZ "6"
	.STRINGZ "7"
	.STRINGZ "8"
	.STRINGZ "9"
MONTHS	.STRINGZ "January  "
	.STRINGZ "February "
	.STRINGZ "March    "
	.STRINGZ "April    "
	.STRINGZ "May      "
	.STRINGZ "June     "
	.STRINGZ "July     "
	.STRINGZ "August   "
	.STRINGZ "September"	;longest month name, 9 chars + 1 terminating char = 10 total
	.STRINGZ "October  "
	.STRINGZ "November "
	.STRINGZ "December "
ERRSTR	.STRINGZ "Input was not an integer. Exiting..."
LF	.STRINGZ "\n"
ERRNUM	.STRINGZ "Invalid index entered. Try again."
.END

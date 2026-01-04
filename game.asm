.ORIG x3000

JSR CLEAR_REGISTERS
JSR LOOPED_GAME

LOOP_START1
PUTS
    AND R1, R1, #0 ; R1 is 0 for Player 1 
    JSR CHECKLETTER1
    JSR LOOPED_GAME
    JSR WINNER2 
    ADD R4, R4, #0; need to touch R4 so you can branch on the value inside R4 bc the last thing you did is load the PC from R7 and if you do a BR without touching R4 then you will get the status of the PC
    BRz FINISH_1 ; if R4 is zero then Player 2 won 
     
PUTS
    AND R1, R1, #0
    ADD R1, R1, #1 ; R1 is 0 for Player 2 
    JSR CHECKLETTER1
    JSR LOOPED_GAME
    JSR WINNER2 
    ADD R4, R4, #0 
    BRz FINISH_2 ; if R4 is zero then Player 1 won 
    BRnp LOOP_START1
        
FINISH_1
LEA R0, WP2
PUTS 
BRnzp SKIP_F2 

FINISH_2
LEA R0, WP1
PUTS 

SKIP_F2
HALT

P1 .STRINGZ "Player 1, choose a row and number of stones: "
P2 .STRINGZ "Player 2, choose a row and number of stones: "
WP1 .STRINGZ "\nPlayer 1 Wins.\n"
WP2 .STRINGZ "\nPlayer 2 Wins.\n"
;__________________________________________________
CLEAR_REGISTERS

AND R1, R1, #0; clearing registers 
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0
RET

;__________________________________________________

LOOPED_GAME

LEA R1, ROWA; loading row a into r1 
LD R6, CHAR_A; loading the number of chars in row a into r6 

PRINTING_LOOP_A
LDR R0, R1, #0; loading the first char of row a into the output register r0 
OUT; printing the char from r0 
ADD R1, R1, #1; increment r1 so that you can point to the next char
ADD R6, R6, #-1; decrement the character count 
BRp PRINTING_LOOP_A; if the char count is still poisitive loop up since you have more char's to print 

LEA R0, NewLine
PUTS 

LEA R1, ROWB
LD R6, CHAR_B

PRINTING_LOOP_B
LDR R0, R1, #0
OUT
ADD R1, R1, #1
ADD R6, R6, #-1
BRp PRINTING_LOOP_B

LEA R0, NewLine
PUTS 

LEA R1, ROWC
LD R6, CHAR_C

PRINTING_LOOP_C
LDR R0, R1, #0
OUT
ADD R1, R1, #1
ADD R6, R6, #-1
BRp PRINTING_LOOP_C

LEA R0, NewLine

ROWA .STRINGZ "ROW A: ooo"; character count of 10
ROWB .STRINGZ "ROW B: ooooo"
ROWC .STRINGZ "ROW C: oooooooo"

CHAR_A .FILL x000A; row a has a char count of 10 
CHAR_B .FILL x000C; row b char count of 12
CHAR_C .FILL x000F; row c char count of 15 

NewLine .STRINGZ "\n"

RET; end of LOOPED_GAME
;__________________________________________________

CHECKLETTER1 
ST R7, SAVER7CHECK


PROMPT1 
ADD R1, R1, #0 ; touches R1 and creates the flag z 
BRz FIRSTPLAYER 
LEA R0, PromptP2; prompting player 2 for their first move 
BRnzp SKIPFIRSTPROMPT 
FIRSTPLAYER LEA R0, PromptP1; prompting player 1 for their first move 

SKIPFIRSTPROMPT 
PUTS

GETC; reading the row 
ST R0, MoveRow 
OUT; echoes the row that the character wants stones removed from onto the console

ADD R2, R0, #0; Player chosen row now in R2

GETC; reading the stone number that the player wants removed from the row above 
ST R0, MoveNum
OUT

ADD R3, R0, #0; Player chosen number now in R3

LD R4, ASCII_A
NOT R4, R4
ADD R4, R4, #1; 2's complement (negative) of the ascii value of A 
ADD R5, R2, R4; R5 now have the player's chosen row minus the ASCII value of A

BRz CHECKNUMBER_A
    LD R4, ASCII_B; if not A then check if the inputted row is B
    NOT R4, R4
    ADD R4, R4, #1; negative ASCII of B
    ADD R5, R2, R4; R5 now have the player's chosen row minus the ASCII value of B

    BRz CHECKNUMBER_B; if the letter is B then go on to check numbers for row B
        LD R4, ASCII_C; if not B then check if the inputted row is C
        NOT R4, R4
        ADD R4, R4, #1; negative ASCII of C
        ADD R5, R2, R4; R5 now have the player's chosen row minus the ASCII value of C
        
        BRz CHECKNUMBER_C
        
        LEA R0, InvalidString; if not A, B, or C then player is prompted for another move 
        PUTS 
        BRnzp PROMPT1; unconditional branch 

CHECKNUMBER_A; if valid row then check numbers row a 
LD R4, ROWAcount; R4 has the number of stones currently in row a
NOT R4, R4
ADD R4, R4, #1 
JSR GREATER_OR_EQUAL_TO_ONE_CHECK ; R5 is negative if invalid input because R3 has asciis that are less than the ascii value of 1 
ADD R5, R5, #0
BRn INVALID_PROMPTA; invalid ascii bc R5 is negative becuase less than 1 , jumps the next two lines 

ADD R7, R3, R4; check if R3 (player num input) is less then or equal to R4 (R3-R4) (checking if there are enough stones to remove)
BRnz REMOVE_STONES_A; if the number of stones wanted to be remmoved by the player is valid then remove stones and reset row count

INVALID_PROMPTA
LEA R0, InvalidString; if number is greater than number of stones then it is invalid and player has to put in another move 
    PUTS 
    BRnzp PROMPT1 

CHECKNUMBER_B 
LD R4, ROWBcount
NOT R4, R4
ADD R4, R4, #1 
JSR GREATER_OR_EQUAL_TO_ONE_CHECK
ADD R5, R5, #0
BRn INVALID_PROMPTB

ADD R7, R3, R4
BRnz REMOVE_STONES_B
INVALID_PROMPTB
LEA R0, InvalidString
    PUTS 
    BRnzp PROMPT1 

CHECKNUMBER_C
LD R4, ROWCcount
NOT R4, R4
ADD R4, R4, #1 
JSR GREATER_OR_EQUAL_TO_ONE_CHECK
ADD R5, R5, #0
BRn INVALID_PROMPTC

ADD R7, R3, R4
BRnz REMOVE_STONES_C
INVALID_PROMPTC
LEA R0, InvalidString
    PUTS 
    BRnzp PROMPT1

REMOVE_STONES_A
LD R4, ASCII_0; r4 has ascii of 0 now 
NOT R4, R4
ADD R4, R4, #1; r4 is negative of ascii 0 
ADD R3, R3, R4; R3 = R3 - ascii of 0 (r3 is the ascii of the inputted number from the player)

LD R6, CHAR_A; 
NOT R3, R3
ADD R3, R3, #1 
ADD R0, R6, R3
ST R0, CHAR_A

LD R6, CHAR_A; 
LD R3, ASCII_7
NOT R3, R3
ADD R3, R3, #1; r3 now has negative 7 which is the char count of "ROW A: "
ADD R0, R6, R3; CHAR_A minus 7 to get the new stone count for checking the number 

LD R3, ASCII_0  ; R3 = ASCII '0'
ADD R0, R0, R3  ; R0 = (Numerical 1) + ASCII '0' = ASCII '1' (x0031)

ST R0, ROWAcount

BRnzp DONE

REMOVE_STONES_B
LD R4, ASCII_0; r4 has ascii of 0 now 
NOT R4, R4
ADD R4, R4, #1; r4 is negative of ascii 0 
ADD R3, R3, R4

LD R6, CHAR_B; 
NOT R3, R3
ADD R3, R3, #1 
ADD R0, R6, R3
ST R0, CHAR_B

LD R6, CHAR_B; 
LD R3, ASCII_7
NOT R3, R3
ADD R3, R3, #1; r3 now has negative 7 which is the char count of "ROW B: "
ADD R0, R6, R3; CHAR_B minus 7 to get the new stone count for checking the number 

LD R3, ASCII_0  ; R3 = ASCII '0'
ADD R0, R0, R3  ; R0 = (Numerical 1) + ASCII '0' = ASCII '1' (x0031)

ST R0, ROWBcount

BRnzp DONE

REMOVE_STONES_C
LD R4, ASCII_0; r4 has ascii of 0 now 
NOT R4, R4
ADD R4, R4, #1; r4 is negative of ascii 0 
ADD R3, R3, R4

LD R6, CHAR_C; 
NOT R3, R3
ADD R3, R3, #1 
ADD R0, R6, R3
ST R0, CHAR_C

LD R6, CHAR_C; 
LD R3, ASCII_7
NOT R3, R3
ADD R3, R3, #1; r3 now has negative 7 which is the char count of "ROW C: "
ADD R0, R6, R3; CHAR_C minus 7 to get the new stone count for checking the number 

LD R3, ASCII_0  ; R3 = ASCII '0'
ADD R0, R0, R3  ; R0 = (Numerical 1) + ASCII '0' = ASCII '1' (x0031)

ST R0, ROWCcount

BRnzp DONE

DONE 
LEA R0, NewLine
PUTS 
LEA R0, NewLine
PUTS 

LD R7, SAVER7CHECK


RET; end of CHECKLETTER1 ---------------------------------------------------------

SAVER7CHECK .BLKW #1


MoveRow .BLKW 1; the row that the player wants to remove stones from
MoveNum .BLKW 1; the number of stones the player wants to remove from the row they said 

ASCII_A .FILL x0041; ASCII value of A so i can compare that to the row inputted by the player
ASCII_B .FILL x0042
ASCII_C .FILL x0043 
ASCII_o .FILL x006F
ASCII_0 .FILL x0030; ASCII value of 0 is 48 in decimal 
ASCII_7 .FILL x0007; ASCII value for 7 

InvalidString .STRINGZ "\nInvalid move. Try again.\n"
PromptP1 .STRINGZ "Player 1, choose a row and number of stones: "
PromptP2 .STRINGZ "Player 2, choose a row and number of stones: "

MoveComplete .STRINGZ "Move Completed"

ROWAcount .FILL x0033; ASCII value for 3
ROWBcount .FILL x0035; ASCII for 5
ROWCcount .FILL x0038; ASCII for 8

;__________________________________________________
GREATER_OR_EQUAL_TO_ONE_CHECK ; input R3 has the # that im checking against 
LD R5, ASCII_1
NOT R5, R5
ADD R5, R5, #1; negative of ascii value of one now in R5 
ADD R5, R3, R5; input number - ascii value of 1 

RET 

;ST R5, SAVER5GTE
;LD R5, SAVER5GTE
;SAVER5GTE .BLKW #1

ASCII_1 .FILL x0031; ASCII value of 1 is 49 in decimal 

;__________________________________________________
WINNER2 
LD R4, ROWAcount ; R4 has ASCII now need to convert to number 
LD R3, ASCII_0 ; R3 has the ASCII value of 0
NOT R3, R3
ADD R3, R3, #1 
ADD R4, R4, R3 ; R4 now has the number becuase you subtracted the ASCII value of 0 from R4 giving the difference which is the #
LD R5, ROWBcount ; R5 has ASCII now need to convert to number 
LD R3, ASCII_0 
NOT R3, R3
ADD R3, R3, #1 
ADD R5, R5, R3 ; R5 now has the number 
LD R6, ROWCcount ; R6 has ASCII now need to convert to number 
LD R3, ASCII_0 
NOT R3, R3
ADD R3, R3, #1 
ADD R6, R6, R3 ; R6 now has the number 

ADD R4, R4, R5 
ADD R4, R4, R6 
ADD R4, R4, R5 ; R4 is zero when a winner is found 
RET 

;__________________________________________________


.END
.global main
.align  4
.text

.equ SNbeginNod, 0                     //begining o struct and node pointer
.equ SNPayload, 8               //offset to payload
.equ SNpayloadOff, 12                  //offset to padding
.equ SNpadding, 16                  //added padding and full struct size

aStoui:                             //function to convert a string to a number

mov     w2, wzr                     //zero the w2 register
ldrb    w1, [x0], 1                 //load first byte of string pointer increment by 1
sub     w2, w1, 48                  //convert asci number value to its real value and store in intermidate ret register

addingLoop:
ldrb    w1, [x0], 1                 //load next byte increment pointer by one
cbz     w1, endLoop                 //check to see if end of string was reached (also used to see if there was only one value to begin with)
mul     w2, w2, 10                  //mulitiple w2(ret register) by ten to make room for next value
sub     w1, w1, 48                  //turn asci number to its real number store in x1
add     w2, w2, w1                  //store that number in itermediate ret register

b   addingLoop                      //repeat untill end of string reached
endLoop:

mov     w0, w2                      //move itermediate return register to w0 (real return register)
ret

InSrtList:

cbz     x1, emptyhead


b endHeadIf
emptyhead:
mov     x1, x0

endHeadIf:

ret

main:
stp     x29, x30, [sp, -16]!        //backup core x29 and x30 registers
stp     x20, x21 [sp, -16]!         //backup x20 (which will be used as a current linklist pointer) and x21 (which points to the head)   
stp     x22, x23 [sp, -16]!         //backup x22 and x23 (which will store argv and its pointer pointer)
str     x24, [sp, -16]!             //backup x24 (used to store aStoui return val)
mov     x22, x1                     //backup the argv to register x22 (which is on the stack)
mov     x21, xzr                    //set the pointer to the linked list head to zero

argvLoop:
ldr     x23, [x22,8]!               //load the second thing off of argv first then go from there
cbz     x23, argvLoopEnd            //check to see if you have reached the end of argv
mov     x0, x23                     //place the pointer to which argv curtainly points too in x0 (for aStoui function use)
ldrb    w1, [x23]                   //load the first char from that pointer

TSTNE   w1, '-'                     //check to see if it is the remove command
bne     addToList                   //if it not a remove command then switch to add to linked list
add     x0, x0, 1                   //if not then run delete from linked list incrase pointer after the '-'
bl      aStoui                      
//delete from linked list block

b       endIfElse
addToList:
bl      aStoui
mov     w24, w0
mov     x0, 1
mov     x1, SNpadding
bl      calloc
mov     x20, x0
mov     x1, x21
str     w24, [x20, SNPayload]
bl      InSrtList

endIfElse:

b argvLoop
argvLoopEnd:

ldp     x29,x30, [sp, -16]!         //pop the stack of x29 and x30 registers
ret

.data

head_address:	.asciz		"head points to: %x\n"
node_info:		.asciz		"node at %8x contains payload: %lu next: %8x\n"
bad_malloc:		.asciz		"malloc() failed\n"
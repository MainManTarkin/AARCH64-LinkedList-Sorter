.global main
.align  4
.text

.equ SNbegin, 0                     //begining o struct and node pointer
.equ SNnodePointer, 8               //offset to payload
.equ SNpayload, 12                  //offset to padding
.equ SNpadding, 16                  //added padding and full struct size

aStoui:

mov     w3, wzr
mov     w2, wzr
ldrb    w1, [x0], 1
sub     w2, w1, 48
mov     w3, w2

addingLoop:
ldrb    w1, [x0], 1
cbz     w1, endLoop
mul     w3, w3, 10
sub     w2, w1, 48
add     w3, w3, w2

b   addingLoop
endLoop:

mov     w0, w3
ret


main:
stp     x29, x30, [sp, -16]!        //backup core x29 and x30 registers
stp     x20, x21 [sp, -16]!         //backup x20 (which will be used as a current linklist pointer) and x21 (which points to the head)   
stp     x22, x23 [sp, -16]!         //backup x22 and x23 (which will store argv and its pointer pointer)
mov     x22, x1
mov     x21, xzr

argvLoop:
ldr     x23, [x22,8]!
cbz     x23, argvLoopEnd
mov     x0, x23
ldrb    w1, [x23]

TSTNE   w1, '-'
bne     addToList
add     x0, x0, 1
bl      aStoui


b       endIfElse
addToList:

endIfElse:

b argvLoop
argvLoopEnd:

ldp     x29,x30, [sp, -16]!         //pop the stack of x29 and x30 registers
ret

.data

head_address:	.asciz		"head points to: %x\n"
node_info:		.asciz		"node at %8x contains payload: %lu next: %8x\n"
bad_malloc:		.asciz		"malloc() failed\n"
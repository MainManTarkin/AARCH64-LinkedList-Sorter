.global main
.align  4
.text

.equ SNbegin, 0                     //begining o struct and node pointer
.equ SNnodePointer, 8               //offset to payload
.equ SNpayload, 12                  //offset to padding
.equ SNpadding, 16                  //added padding and full struct size

main:
stp     x29, x30, [sp, -16]!        //backup core x29 and x30 registers
stp     x20,x21 [sp, -16]!          //backup x20 (which will be used as a current linklist pointer) and x21 (which points to the head)   
stp     
argvLoop:
ldr     x3, [x1,8]!
cbz     x1, argvLoopEnd



b argvLoop
argvLoopEnd:

ldp     x29,x30, [sp, -16]!         //pop the stack of x29 and x30 registers
ret

.data

head_address:	.asciz		"head points to: %x\n"
node_info:		.asciz		"node at %8x contains payload: %lu next: %8x\n"
bad_malloc:		.asciz		"malloc() failed\n"
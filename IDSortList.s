.global main
.align  4
.text

.equ SNbeginNod, 0                  //begining o struct and node pointer
.equ SNPayload, 8                   //offset to payload
.equ SNpayloadOff, 12               //offset to padding
.equ SNpadding, 16                  //added padding and full struct size

aStoui:                             //function to convert a string to a number
str     x20, [sp, -16]!             //backup x20 on the stack to use it to store 10 multipler
mov     w20, 10                     //store ten in w20
mov     w2, wzr                     //zero the w2 register
ldrb    w1, [x0], 1                 //load first byte of string pointer increment by 1
sub     w2, w1, 48                  //convert asci number value to its real value and store in intermidate ret register

addingLoop:
ldrb    w1, [x0], 1                 //load next byte increment pointer by one
cbz     w1, endLoop                 //check to see if end of string was reached (also used to see if there was only one value to begin with)
mul     w2, w2, w20                  //mulitiple w2(ret register) by ten to make room for next value
sub     w1, w1, 48                  //turn asci number to its real number store in x1
add     w2, w2, w1                  //store that number in itermediate ret register

b   addingLoop                      //repeat untill end of string reached
endLoop:

mov     w0, w2                      //move itermediate return register to w0 (real return register)
ret

InSrtList:

ldr     w6, [x0, SNPayload]         //preload the payload for the node we want to insert
cbz     x1, emptyhead               //checl to see if the head points to nothing

mov     x2, x1                      //if it points to something then move what it points too to x2
ldr     w4, [x2, SNPayload]         //load x2's payload into w4
cmp     w6, w4                      //check to see if x2's payload is greater then x0's
ble     setNewHead                  //if x0's is smaller then set that as the new head

loopLink:                           //if not then run loopLink else
ldr     x3, [x2, SNbeginNod]                 //load the node x2 points to into x3
cbz     x3, setEndLink              //check to see if x2 even points to anything
ldr     w4, [x3, SNPayload]         //if so then load x3's payload into w4
cmp     w4, w6                      //see if x3's payload is less then x0's
ble     greaterThenNode             
str     x3, [x0, SNbeginNod]                 //if its greater then set x3 node to what x0 node points to
str     x0, [x2, SNbeginNod]                 //and set x2 node to point to x0 node
b       endHeadIf                   //end function
greaterThenNode:
mov     x2, x3                      //if x3 node is less then x0 make x2 become x3 keep incrementing untill you find a node that is greater then x0
b loopLink

setEndLink:
str     x0, [x2, SNbeginNod]                 //if end of linkedlist is found set x2 to point to x0 nwhich is now the end of the list
b       endHeadIf                   //end function
setNewHead:
str     x2, [x0, SNbeginNod]                 //if x0's payload is smaller then what the head points to then make it the new head
mov     x1, x0

b endHeadIf
emptyhead:
mov     x1, x0                      //if head is empty make x0 the new head

endHeadIf:
ldr     x20, [sp], 16               //pop off x20 from the stack
ret

deleteNode:                         //function to delete node from list
stp     x29, x30, [sp, -16]!        //backup frame pointer and link register to the stack
str     x20, [sp, -16]!             //backup x20 which is the current head pointer
cbz     x1, deleteNodeEnd           // check to see if x1 is null
mov     x20, x1                     //make x20's value be x1's value

ldr     x3, [x20, SNbeginNod]       //load x20's next node into x3
ldr     w4, [x20, SNPayload]        //load x20's payload
cmp     w4, w0                      //test to see if w4 and w0 are equal
beq     headNode                    //if so then run headNode routine

listIterator:                       //else iterate through the list
cbz     x3, deleteNodeEnd           //see if x3 is null (used to end loop)
ldr     w4, [x3, SNPayload]         //load x3's payload into w4
cmp     w4, w0                      //test to see if w4 is equal to w0
beq     foundMatch                  //if so run foundMatch routine
mov     x2, x3                      //if not x2 takes on x3's value
ldr     x3, [x2, SNPayload]         //get x2's next node and put it into x3
b       listIterator                //branch up continue loop

foundMatch:
ldr     x5, [x3, SNbeginNod]        //get x3's next node and load it in to x5
str     x5, [x2, SNbeginNod]        //set set x2's (prev compared node) node to x5
mov     x0, x3                      //set x0 to x3
bl      free                        //free the node

b       deleteNodeEnd

headNode:
mov     x20, x3                     //the saved head pointer is set to the next node
mov     x0, x1                      //set x0 to x1
bl      free                        //free the prev node pointed to by the head

deleteNodeEnd:
mov     x0, x20                     //set return value to saved head pointer

ldr     x20, [sp], 16              //pop off stored values from the stack
ldp     x29,x30, [sp], 16          //^
ret

main:
stp     x29, x30, [sp, -16]!        //backup core x29 and x30 registers
stp     x20, x21, [sp, -16]!         //backup x20 (which will be used as a current linklist pointer) and x21 (which points to the head)   
stp     x22, x23, [sp, -16]!         //backup x22 and x23 (which will store argv and its pointer pointer)
str     x24, [sp, -16]!             //backup x24 (used to store aStoui return val)
mov     x22, x1                     //backup the argv to register x22 (which is on the stack)
mov     x21, xzr                    //set the pointer to the linked list head to zero

argvLoop:
ldr     x23, [x22,8]!               //load the second thing off of argv first then go from there
cbz     x23, argvLoopEnd            //check to see if you have reached the end of argv
mov     x0, x23                     //place the pointer to which argv curtainly points too in x0 (for aStoui function use)
ldrb    w1, [x23]                   //load the first char from that pointer

cmp     w1, '-'                     //check to see if it is the remove command
bne     addToList                   //if it not a remove command then switch to add to linked list

add     x0, x0, 1                   //if not then run delete from linked list incrase pointer after the '-'
bl      aStoui                      //convert string to an unsigned int
mov     x1, x21                     //place current head pointer into x1 for function parameter
bl      deleteNode                  //delete node if it exist
mov     x21, x0                     //if head changed update x21 (head pointer)

b       argvLoop
addToList:
bl      aStoui                      //convert the string text to an unsigned int
mov     w24, w0                     //move return value on the stack for safe keeping
mov     x0, 1                       //make x0 1 for calloc's number of element parameter
mov     x1, SNpadding               //make x1 equal to size 16 for struct node size for calloc parameter 
bl      calloc                      //call calloc
cbz     x0, mallocFail              //check to see if calloc returned null
mov     x20, x0                     //move pointer to x20 for safe keeping
mov     x1, x21                     //get current head for function parameter
str     w24, [x20, SNPayload]       //set the payload to the newley created node
bl      InSrtList                   //call InSrtList to insert node into linked list
mov     x21, x1                     // set new head incase change occured

b argvLoop

mallocFail:
ldr     x0, =bad_malloc             //load address to string for malloc fail
bl      printf

argvLoopEnd:


ldr     x0, =head_address           //load string address for first printf format
mov     x1, x21                     //get head pointer for printf place it into x1
bl      printf
mov     x20, x21                    //use x20 for current pointer storage

printfLoop:
cbz     x20, endPrintfLoop          //check to see if current node is null
mov     x21, x20                    //if not then make x21 store said node (for free operation latter)
mov     x1, x20                     //move current node to x1 for printf function parameter
ldr     x0, =node_info              //load node_info string address to x1 for function parameter
ldr     w2, [x1, SNPayload]         //load current node payload into w2 for function parameter
ldr     x3, [x1, SNbeginNod]        //load next node into x3 for function parameter
mov     x20, x3                     //make current node the stored next node
bl      printf      
mov     x0, x21                     //place previous node into x0 for free function
bl      free
b       printfLoop                  //repeat untill end of linked list

endPrintfLoop:
mov     x0, xzr                     //set return value
ldr     x24, [sp], 16              //pop the stack of registers stored
ldp     x22, x23, [sp], 16          //^
ldp     x20, x21, [sp], 16          //^
ldp     x29, x30, [sp], 16         //^
ret

.data

head_address:	.asciz		"head points to: %x\n"
node_info:		.asciz		"node at %8x contains payload: %lu next: %8x\n"
bad_malloc:		.asciz		"malloc() failed\n"

.end

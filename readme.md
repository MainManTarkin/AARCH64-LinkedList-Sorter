# AARCH64 Sorted Linked List

## Project Description

This project implements a sorted linked list by the value of the node's ID (its payload value) from smallest to greatest. The project is written in the AARCH64 assembly. The program output an ordered list of the nodes in order from smallest value to greatest, with their virtual address and what they point to next included.

----

## Building
This project is ment to be assembled with the aarch64 linux __GNU compiler collection__.
For a __POSIX__ compliant system the following should work.

> gcc IDSortList.s

## Program Args

The user gives a list of various values and the program should return output as such

> ./a.out 43 56 12 89 10 99     
head points to: dd3da320      
node at dd3da320 contains payload: 10 next: dd3da2e0      
node at dd3da2e0 contains payload: 12 next: dd3da2a0     
node at dd3da2a0 contains payload: 43 next: dd3da2c0     
node at dd3da2c0 contains payload: 56 next: dd3da300     
node at dd3da300 contains payload: 89 next: dd3da340    
node at dd3da340 contains payload: 99 next:        0     


The user can remove an item from the list by placing a "-" symbol infront of the value.

> ./id.le 43 56 12 89 10 99 -56      
head points to: e420320          
node at  e420320 contains payload: 10 next:  e4202e0          
node at  e4202e0 contains payload: 12 next:  e4202a0           
node at  e4202a0 contains payload: 43 next:  e420300          
node at  e420300 contains payload: 89 next:  e420340         
node at  e420340 contains payload: 99 next:        0        

the node containing 56 is not present in the list.

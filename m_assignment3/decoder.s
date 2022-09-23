.text

.include "helloWorld.s"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	
	# callee-saved convention
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15

	# the decode algorithm
	movq (%rdi), %r12 # this is the value of the first memory block of the message we included
	movb %r12b, %r13b # moves the ascii value from the first line into a register
	shr $8, %r12 # shifts the value of the first line 8 bits to the right
	movb %r12b, %r14b # moves the times value from the first line into a register
	shr $8, %r12
	movq $0, %r15
	movl %r12d, %r15d # moves the value of the address of the next line into a register
	pushq %rdi # pushes %rdi so we keep the pointer to the start of the message which we will use more in our code

	decode_loop:
		movq $0, %rax 
		movb %r13b, %dil # sets the ascii value in the first parameter of putchar
		call putchar # this prints out the single char in %dil

		decb %r14b # decrements the counter by 1
		cmpb $0, %r14b # compares the counter to 0
		jnz decode_loop # loops if the counter is higher than 0 
	popq %rdi # pops the original value of %rdi back
	cmpl $0, %r15d
	jz decode_end
	
	decode_while:
	movq (%rdi, %r15, 8), %r12	
	movb %r12b, %r13b # moves the ascii value from the first line into a register
	shr $8, %r12 # shifts the value of the first line 8 bits to the right
	movb %r12b, %r14b # moves the times value from the first line into a register
	shr $8, %r12
	movq $0, %r15
	movl %r12d, %r15d # moves the value of the address of the next line into a register
	pushq %rdi # pushes %rdi so we keep the pointer to the start of the message which we will use more in our code

	decode_while_loop:
		movq $0, %rax 
		movb %r13b, %dil # sets the ascii value in the first parameter of putchar
		call putchar # this prints out the single char in %dil

		decb %r14b # decrements the counter by 1
		cmpb $0, %r14b # compares the counter to 0
		jnz decode_loop # loops if the counter is higher than 0 
	popq %rdi # pops the original value of %rdi back
	cmpl $0, %r15d
	jnz decode_while

decode_end:
	# callee-saved convention 
	popq %r15
	popq %r14
	popq %r13
	popq %r12 

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi	# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program


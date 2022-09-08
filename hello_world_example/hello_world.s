# netID rbvandenbrink, samuelbruin
# Rick weet ik veel van den Brink, Samuel Bruin
# <netID>, 5782538

.text
helloworld: .asciz "Hello World!\n"


.global main

# main function
main:
	pushq %rbp # store old base pointer to stack
	movq %rsp, %rbp # copy and store current stack pointer to base pointer

	movq $0, %rax # no vector registers needed for printf so set to 0
	movq $helloworld, %rdi # move start address of hello world literal to rdi register
	call printf # call the printf c function

	movq %rbp, %rsp # reset stack pointer to previously stored stack pointer before subroutine
	popq %rbp # pop the old base pointer from the stack (line 13) and store it into base pointer registry


# this gets called at the end of the execution of a program
end:
	movq $0, %rdi # set exit code in rdi registry
	call exit # call exit c function

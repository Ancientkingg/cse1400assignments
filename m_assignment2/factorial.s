
.data
    input_buffer: .quad 0

.text
    message: .asciz "The \"factorial\" assignment, made by Rutger van den Brink (rbvandenbrink) and Samuel Bruin (samuelbruin)\n\n"
    input_msg: .asciz "Input: "
    result_msg: .asciz "The result is: %d\n"
    input_fmt: .asciz "%d"

.global main

main:
    # Prologue
    pushq %rbp
    movq %rsp, %rbp

    # prints starting message
    movq $0, %rax # we don't use vector registers here
    movq $message, %rdi # point the first parameter of the printf function to the start of the string defined above
    call printf # function call

    # asks for a number to be used as input 
    movq $0, %rax  
    movq $input_msg, %rdi
    call printf
    # scans for input
    movq $0, %rax
    movq $input_fmt, %rdi
    movq $input_buffer, %rsi
    call scanf
    # call factorial subroutine with value of input_buffer as input
    movq input_buffer, %rdi
    movq %rdi, %rax
    call factorial
    # prints the result 
    movq $result_msg, %rdi
    movq %rax, %rsi
    movq $0, %rax  
    call printf
    
    # Epilogue
    movq %rbp, %rsp
    popq %rbp


# End of the program return exit code 0
end:
    movq $0, %rdi
    call exit

factorial:
    # prologue
    pushq %rbp
    movq %rsp, %rbp
    # recursion part
    cmpq $1, %rdi # checks if the input is 1
    jle factorial_end_early # if the input is equal or less than 1 return early with 1
    pushq %rdi # push existing input to the stack
    pushq $0 # this has to be added to keep the stack 16-byte alligned
    decq %rdi # decrement the input
    call factorial #recursion
    # calculation part
    popq %r8 # this has to be added to keep the stack 16-byte alligned
    popq %rdi # pop the stored value of the input that wasn't decremented
    mulq %rdi # multiply input from the stack with our return value
    jmp factorial_end # jumps over the end_early so the output doesn't get set to 1

    factorial_end_early:
        movq $1, %rax # if the input is not bigger than 1 set output to 1 and return
    
    factorial_end:
        # epilogue
        movq %rbp, %rsp
        popq %rbp
        ret 



 # first we decrement the input until it's 1, after that we start incrementing it back up until it is back to the number it was
factorial_calc:
    decq %rdi # decrement the input by 1
    call factorial 
    incq %rdi # increment the input back because we decremented it before
    mulq %rdi # now we start the multiplacation of the factorial
    ret 


.data
    base_buffer: .quad 0
    exp_buffer: .quad 0

.text
    message: .asciz "The \"Powers\" assignment, made by Rutger van den Brink (rbvandenbrink) and Samuel Bruin (samuelbruin)\n\n"
    base_msg: .asciz "Base: "
    exp_msg: .asciz "Exponent: "
    result_msg: .asciz "The result is: %d\n"
    linebreak: .asciz "\n"
    input_fmt: .asciz "%d"

.global main

main:
    # Prologue
    pushq %rbp
    movq %rsp, %rbp

    # in C: printf(message)
    movq $0, %rax # There are no floating points involved so set value to 0
    movq $message, %rdi # Point the first parameter of the printf function to the start of the string defined above
    call printf # function call

    # asks for a number to be used as base
    movq $0, %rax  
    movq $base_msg, %rdi
    call printf
    
    movq $0, %rax
    movq $input_fmt, %rdi
    movq $base_buffer, %rsi
    call scanf
    # asks for a number to be used as exponent
    movq $0, %rax  
    movq $exp_msg, %rdi
    call printf
    
    movq $0, %rax
    movq $input_fmt, %rdi
    movq $exp_buffer, %rsi
    call scanf

    movq base_buffer, %rdi
    movq exp_buffer, %rsi
    call pow

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


## if either the base or exponent are negative return -1 
pow: # base: rdi, exp: rsi, total: rax
    # prologue
    pushq %rbp
    movq %rsp, %rbp
    
    movq $1, %rax # total = 1

    testq %rdi, %rdi # check if the base is negative, if so return early 
    js pow_end_error

    testq %rsi, %rsi # check if the exponent is negative, if so return early
    js pow_end_error

    testq %rsi, %rsi # check if the exponent is zero, if so return early with 1
    jnz pow_if_exp_nz  
    jmp pow_end

    pow_if_exp_nz:
    testq %rdi, %rdi
    jnz pow_loop # check if the base is zero, if so return early with 0
    
    movq $0, %rax
    jmp pow_end

    # use the exponent as a counter for the loop. Until the exponent is zero multiply total (rax) by the base (rdi)
    pow_loop:
        mulq %rdi
        decq %rsi
        jnz pow_loop
    jmp pow_end

    # set the return value to -1 to signal error
    pow_end_error:
    movq $-1, %rax

    pow_end:
    # epilogue
    movq %rbp, %rsp
    popq %rbp

    ret
 

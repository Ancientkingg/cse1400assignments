
.text
    message: .asciz "The \"Powers\" assignment, made by Rutger van den Brink (rbvandenbrink) and Samuel Bruin (samuelbruin)"

.global main

main:
    # Prologue
    push %rbp
    mov %rsp, %rbp

    # in C: printf(message)
    movq $0, %rax # There are no floating points involved so set value to 0
    movq $message, %rdi # Point the first parameter of the printf function to the start of the string defined above
    call printf # function call

    # Epilogue
    movq %rbp, %rsp
    popq %rbp


# End of the program return exit code 0
end:
    movq $0, %rdi
    call exit



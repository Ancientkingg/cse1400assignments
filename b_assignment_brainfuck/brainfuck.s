.bss
input_string: .skip 1000 # reserve a 1000 chars
cells: .skip 50000 # allocate 50k bytes on the stack

.data # padded jump table 
    jmp_table:
        .quad handle_zero # '\0' 0
        .rept 42
            .quad end_loop
        .endr
        .quad handle_plus # '+' 43
        .quad handle_comma # ',' 44
        .quad handle_min # '-' 45
        .quad handle_dot # '.' 46
        .rept 13
            .quad end_loop
        .endr
        .quad handle_less # '<' 60
            .quad end_loop
        .quad handle_greater # '>' 62
        .rept 28
            .quad end_loop
        .endr
        .quad handle_opening_bracket # '[' 91
            .quad end_loop
        .quad handle_closing_bracket # ']' 93
        .rept 33
            .quad end_loop
        .endr
.text # read only memory

.global brainfuck

# Your brainfuck subroutine will receive one argument:
# a zero terminated string containing the code to execute.
brainfuck:
	pushq %rbp
	movq %rsp, %rbp


	# calling conventions
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rbx
	# needs to be 16 byte aligned so we push filler value
	pushq $0

	mov %rdi, %r12 # get pointer to first argument
    mov $0, %r13 # current index into string
    mov $0, %r14 # current pointer to cell
    
    loop:
        mov %r13, %rsi

        mov $0, %rax # clear most significant bits of rax
        movb (%r12, %r13, 1), %al # rax = current character
        jmp *jmp_table(,%rax,8) # lookup from jump table and jump to resulting address/label

        end_loop:
            add $1, %r13
            cmp $60000, %r13 # stop the program after a while
            jne loop

    end:
    mov $'\n', %rdi # print a linebreak
    mov $0, %rsi
    mov $0, %rax
    call putchar
    # call exit to exit program and set the return code to 0 (first parameter)
    mov $0, %rdi
    call exit

    handle_zero:
        jmp end # if theres a null character terminate the program
    handle_greater:
        add $1, %r14 # go to the next cell by incrementing the cell pointer (add|sub > inc in terms of perf)
        jmp end_loop
    handle_less:
        sub $1, %r14 # go to the previous cell by decrementing the cell pointer
        jmp end_loop
    handle_plus: # increment current cell
        mov $cells, %rsi
        add $1, (%rsi, %r14, 1) # indirect addressing; see rsi as an array and r14 as an index
        jmp end_loop
    handle_min: # decrement current cell
        mov $cells, %rsi
        sub $1, (%rsi, %r14, 1)

        jmp end_loop
    handle_dot: # print
        mov $cells, %rsi
        mov (%rsi, %r14, 1), %rdi
        mov $0, %rsi
        mov $0, %rax
        call putchar

        jmp end_loop
    handle_comma: # ask for input
        call getchar
        mov $cells, %rdi
        add %r14, %rdi
        mov %al, (%rdi)
        jmp end_loop
    handle_opening_bracket: # start of loop
        mov $cells, %rsi # mem
        mov (%rsi, %r14, 1), %dil # mem[cell_idx]; r14: cell_idx
        test %dil, %dil
        jz find_closing_bracket # if mem[cell_idx] != 0 then jump

        # els store the start of the loop onto the stack
		pushq $0
        pushq %r13 # push instruction_pointer
        jmp end_loop

		# loop through the program to find the closing bracket
        find_closing_bracket:
            mov %r13, %r15 # size_t jmp = instruction_pointer
            mov $1, %rcx # uint8_t brackets = 1
            find_closing_bracket_loop:
                add $1, %r15 # jmp++
                movb (%r12, %r15, 1), %al # instruction = program[jmp]

                    cmpb $'[', %al # instruction == '['
                    jne find_closing_bracket_elif
                    
                    add $1, %rcx # brackets++
                    jmp find_closing_bracket_end_loop

                find_closing_bracket_elif:
                    cmpb $']', %al # instruction == ']'
                    jne find_closing_bracket_end_loop
                    sub $1, %rcx # brackets--


                find_closing_bracket_end_loop:
                    test %rcx, %rcx
                    jnz find_closing_bracket_loop # brackets != 0
            
            mov %r15, %r13 # instruction_pointer = jump
        jmp end_loop # break
    handle_closing_bracket: # end of loop
        mov $cells, %rsi # mem
        mov (%rsi, %r14, 1), %dil # mem[cell_idx]; r14: cell_idx
        test %dil, %dil
        jz closing_bracket_else # mem[cell_idx] != 0
        mov (%rsp), %r13 # instruction_pointer = my_stack.top()
        jmp end_loop

        closing_bracket_else:
            add $16, %rsp # pop to nowhere

        jmp end_loop

	# get rid of filler value for adhering to calling conventions
	addq $8, %rsp
	popq %rbx
	popq %r15
	popq %r14
	popq %r13
	popq %r12

	movq %rbp, %rsp
	popq %rbp
	ret

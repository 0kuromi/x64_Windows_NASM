bits 64
default rel

section .data
    input_float_format db "%f", 0
    output_float_format db "%f ", 0
    output_newline db 0xA, 0
    msg_prompt_multiplier db "Enter a float multiplier: ", 0
    msg_result db "Resulting array: ", 0

    ; Define a float array (16-byte aligned)
    align 16
    float_array dd 1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8

    ; Define a variable for the input multiplier
    input_multiplier dd 0.0

    ; Define a buffer for the result array (16-byte aligned)
    align 16
    result_array dd 8 dup(0.0) ; 8 floats

section .text
    global main
    extern printf
    extern scanf
    extern ExitProcess

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32 ; Shadow space

    ; Prompt user for multiplier
    lea rcx, [msg_prompt_multiplier]
    call printf

    ; Read multiplier input
    lea rcx, [input_float_format]
    lea rdx, [input_multiplier]
    call scanf

    ; Multiply the float array
    lea rsi, [float_array] ; Source array pointer
    lea rdi, [result_array] ; Destination array pointer
    mov rbx, 2 ; Counter for 16-byte blocks (8 floats / 4 floats per movaps)
    jmp multiply_loop
multiply_loop:
    ;Load 4 floats from the input array
    movaps xmm1, [rsi]

    ; Load multiplier into xmm0 for this block and broadcast it
    movss xmm0, [input_multiplier]
    shufps xmm0, xmm0, 0 ; Broadcast the single float to all four elements

    ; Multiply by the broadcasted multiplier
    mulps xmm1, xmm0

    ; Store the 4 resulting floats
    movaps [rdi], xmm1
    ; Move to the next second block with 4 float each block
    add rsi, 16
    add rdi, 16
    dec rbx
    cmp rbx,0
    jne multiply_loop
    ; Print the result array
    lea rcx, [msg_result]
    call printf

    lea rsi, [result_array] ; Result array pointer
    mov rbx, 8 ; Counter for number of floats to print
print_loop:
    ; Load a single float for printing
    movss xmm0, [rsi]

    ; Print the float
    lea rcx, [output_float_format]
    ; For printing a single float with %f, it needs to be in xmm0
    ; The Windows x64 ABI passes floating-point arguments in XMM registers
    ; The first float argument is in xmm0, second in xmm1, etc.
    ; Since we are printing one float at a time, we move it to xmm0.
    ; The printf function expects a double for %f, so we need to convert.
    cvtss2sd xmm0, xmm0
    movq rdx,xmm0
    call printf

    lea rcx,[output_newline]
    ;call printf
    ; Move to the next float
    add rsi, 4
    dec rbx
    cmp rbx,0
    jne print_loop

    ; Print a newline at the end

    ; Exit the program
    add rsp, 32
    xor rax, rax
    call ExitProcess

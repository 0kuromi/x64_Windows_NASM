; matrix_multiply.asm
; A NASM x64 program for Windows ABI to input and multiply two 2x2 floating-point matrices
; using printf, scanf, and ExitProcess.
bits 64
default rel
section .data
    ; Define data here
    matrix1 dd 4 dup(0.0) ; 2x2 matrix of floats (doublewords)
    matrix2 dd 4 dup(0.0) ; 2x2 matrix of floats
    result_matrix dd 4 dup(0.0) ; 2x2 result matrix of floats

    ; Format strings for scanf and printf
    input_format db "%f%f%f%f", 0
    output_format db "%f ", 0
    newline_format db "%c", 0
    output_msg db "Result matrix:", 10, 0

    ; Test block messages
    msg_c00 db "Calculated C[0][0]", 10, 0
    msg_c01 db "Calculated C[0][1]", 10, 0
    msg_c10 db "Calculated C[1][0]", 10, 0
    msg_c11 db "Calculated C[1][1]", 10, 0

section .text
    extern printf
    extern scanf
    extern ExitProcess
    global main

%macro test_block 1
    section .text
    push rcx ; Save rcx
    mov rcx, %1
    call printf
    pop rcx ; Restore rcx
%endmacro

main:
    ; Program entry point for Windows ABI
    push rbp
    mov rbp,rsp
    sub rsp,0x20
    ; Prompt for and read matrix 1
    lea rcx,[output_msg]
    call printf

    lea rcx, [input_format]
    lea rdx, [matrix1]
    lea r8, [matrix1 + 4]
    lea r9, [matrix1 + 8]
    lea rax,[matrix1+12]
    mov [rsp+0x20],rax ; Place the address on the stack
    call scanf

    ; Prompt for and read matrix 2
    lea rcx, [output_msg]
    call printf ; Reuse output_msg for prompt

    lea rcx, [input_format]
    lea rdx, [matrix2];B[0][0]
    lea r8, [matrix2 + 4];B[0][1]
    lea r9, [matrix2 + 8];B[1][0]
    lea rax,[matrix2+12];B[1][1]
    mov [rsp+0x20],rax; Place the address on the stack
    call scanf

    ; A = [a00, a01, a10, a11] (row-major)
    ; B = [b00, b01, b10, b11]
    ; Result = [c00, c01, c10, c11]

   ; === C[0][0] = a00*b00 + a01*b10 ===
    movss xmm0, [matrix1 + 0]           ; a00
    movss xmm1, [matrix1 + 4]           ; a01
    shufps xmm0, xmm1, 0b00000000       ; xmm0 = [a00, a01, ?, ?]

    movss xmm2, [matrix2 + 0]           ; b00
    movss xmm3, [matrix2 + 8]           ; b10
    shufps xmm2, xmm3, 0b00000000       ; xmm2 = [b00, b10, ?, ?]

    mulps xmm0, xmm2                    ; [a00*b00, a01*b10, ?, ?]
    movaps xmm4, xmm0
    shufps xmm4, xmm4, 0b00_00_00_11    ; [a01*b10, a01*b10, ?, ?]
    addss xmm0, xmm4
    movss [result_matrix + 0], xmm0    ; C[0][0]

    ; === C[0][1] = a00*b01 + a01*b11 ===
    movss xmm0, [matrix1 + 0]           ; a00
    movss xmm1, [matrix1 + 4]           ; a01
    shufps xmm0, xmm1, 0b00000000       ; [a00, a01, ?, ?]

    movss xmm2, [matrix2 + 4]           ; b01
    movss xmm3, [matrix2 + 12]          ; b11
    shufps xmm2, xmm3, 0b00000000       ; [b01, b11, ?, ?]

    mulps xmm0, xmm2                    ; [a00*b01, a01*b11, ?, ?]
    movaps xmm4, xmm0
    shufps xmm4, xmm4, 0b00_00_00_11
    addss xmm0, xmm4
    movss [result_matrix + 4], xmm0    ; C[0][1]

    ; === C[1][0] = a10*b00 + a11*b10 ===
    movss xmm0, [matrix1 + 8]           ; a10
    movss xmm1, [matrix1 + 12]          ; a11
    shufps xmm0, xmm1, 0b00000000       ; [a10, a11, ?, ?]

    movss xmm2, [matrix2 + 0]           ; b00
    movss xmm3, [matrix2 + 8]           ; b10
    shufps xmm2, xmm3, 0b00000000       ; [b00, b10, ?, ?]

    mulps xmm0, xmm2                    ; [a10*b00, a11*b10, ?, ?]
    movaps xmm4, xmm0
    shufps xmm4, xmm4, 0b00_00_00_11
    addss xmm0, xmm4
    movss [result_matrix + 8], xmm0    ; C[1][0]

    ; === C[1][1] = a10*b01 + a11*b11 ===
    movss xmm0, [matrix1 + 8]           ; a10
    movss xmm1, [matrix1 + 12]          ; a11
    shufps xmm0, xmm1, 0b00000000       ; [a10, a11, ?, ?]

    movss xmm2, [matrix2 + 4]           ; b01
    movss xmm3, [matrix2 + 12]          ; b11
    shufps xmm2, xmm3, 0b00000000       ; [b01, b11, ?, ?]

    mulps xmm0, xmm2                    ; [a10*b01, a11*b11, ?, ?]
    movaps xmm4, xmm0
    shufps xmm4, xmm4, 0b00_00_00_11
    addss xmm0, xmm4
    movss [result_matrix + 12], xmm0   ; C[1][1]
    ; Print result matrix
    lea rcx, [output_msg]
    call printf

    ; Print elements of result_matrix using a loop
    mov ebx, 0 ; Initialize main loop counter
    mov edi, 0 ; Initialize row element counter
print_loop:
    cmp ebx, 4 ; Check if main loop counter reached 4 (2x2 matrix has 4 elements)
    jge end_print_loop

    ; Calculate address of current element: result_matrix + ebx * 4 (size of float)
    mov eax, ebx
    imul eax, 4
    lea rdx, [result_matrix + eax]

    lea rcx, [output_format]
    movss xmm0, [rdx] ; Load float from calculated address
    cvtss2sd xmm0,xmm0
    movq rdx,xmm0
    call printf

    ; Increment row element counter
    inc edi
    ; Check if row element counter reached 2
    cmp edi, 2
    jne continue_print_loop

    ; Print newline and reset row element counter
    lea rcx, [newline_format]
    mov rdx, 10 ; Newline character
    call printf
    mov edi, 0 ; Reset row element counter

continue_print_loop:
    inc ebx ; Increment main loop counter
    jmp print_loop

end_print_loop:
    ; No extra newlines needed after the loop with this logic

    sub rsp,0x28
    ; Exit program
    xor ecx, ecx ; Exit code 0
    call ExitProcess

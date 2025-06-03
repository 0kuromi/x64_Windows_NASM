bits 64
default rel

section .data
    input_format db "%f", 0
    output_format db "Integer part: %lld, Fractional part: %lf", 0xA, 0
    msg_prompt db "Enter a float number: ", 0
    input_float dd 0.0
    integer_part dq 0
    ; fractional_part dq 0 ; We can calculate this directly before printing

section .text
    global main
    extern printf
    extern scanf
    extern ExitProcess

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32 ; Shadow space for function calls

    ; Prompt user for input
    lea rcx, [msg_prompt]
    call printf

    ; Read float input
    lea rcx, [input_format]
    lea rdx, [input_float]
    call scanf

    ; Load the float into an XMM register and convert to double
    movss xmm0, [input_float]
    cvtss2sd xmm0, xmm0 ; xmm0 now contains the double-precision float

    ; Get the integer part (truncating)
    vcvttsd2si rax, xmm0 ; rax now contains the integer part
    mov [integer_part], rax ; Store integer part

    ; Convert integer part back to double for subtraction
    vcvtsi2sd xmm1, rax ; xmm1 now contains the integer part as a double

    ; Calculate the fractional part
    vsubsd xmm0, xmm0, xmm1 ; xmm0 now contains the fractional part

    ; Print the results
    lea rcx, [output_format]
    mov rdx, [integer_part] ; Integer part
    movq r8, xmm0 ; Fractional part in xmm0, move to xmm1 for printf
    call printf

    ; Exit the program
    add rsp, 32
    xor rax, rax
    call ExitProcess

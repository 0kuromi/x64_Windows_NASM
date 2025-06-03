bits 64
default rel

section .data
    input_format db "%lf", 0
    msg_prompt db "Enter an angle in radians: ", 0
    output_cos_format db "Cosine: %g", 0xA, 0
    output_sincos_format db "Sine: %g", 0xA, 0

    input_angle dq 0.0
    sine_result dq 0.0
    cosine_result dq 0.0

section .text
    global main
    extern printf
    extern scanf
    extern ExitProcess
    extern cos
    extern sin

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32 ; Shadow space

    ; Prompt user for angle
    lea rcx, [msg_prompt]
    call printf

    ; Read angle input
    lea rcx, [input_format]
    lea rdx, [input_angle]
    call scanf

    ; Load angle into xmm0 for function calls
    movsd xmm0, [input_angle]

    ; Calculate and print cosine using cos function
    movq rdi, xmm0 ; Pass angle in xmm0 for cos
    call cos ; Result is in xmm0
    lea rcx, [output_cos_format]
    movq rdx, xmm0 ; Pass result in xmm0 for printf
    call printf

    ; Calculate and print sine and cosine using sincos function
    movsd xmm0, [input_angle] ; Load angle again for sincos
    ; sincos expects angle in xmm0, address for sine in rdx, address for cosine in r8
    call sin
    lea rcx,[output_sincos_format]
    movq rdx,xmm0
    call printf

    ; Exit the program
    add rsp, 32
    xor rax, rax
    call ExitProcess

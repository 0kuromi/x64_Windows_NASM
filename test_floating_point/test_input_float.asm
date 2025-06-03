bits 64
default rel

section .data 
    input_scanf db "%f",0x0
    float_print db "Gia tri cua float:%g",0xA,0x0
    msg_print db "Vui long nhap gia tri  float:",0x0
    _MM_FROUND_NO_EXC db 0x8
    mode_input db 0 
    num_float dd 0
section .text
    global main
    extern printf
    extern scanf
    extern ExitProcess
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20

    lea rcx,[msg_print]
    call printf
    lea rcx,[input_scanf]
    lea rdx,[num_float]
    call scanf
    movss xmm0,[num_float]
    cvtss2sd xmm0,xmm0
    lea rcx,[float_print]
    movq rdx,xmm0
    call printf
    add rsp,0x20
    xor rax,rax
    call ExitProcess
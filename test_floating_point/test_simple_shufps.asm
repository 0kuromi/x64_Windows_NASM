bits 64
default rel
%macro printline 0
    push rcx
    section .data
    line db 0xA,0x0
    section .text 
    lea rcx,[line]
    call printf
    pop rcx
%endmacro 
section .data
    test_float dd 1.0,2.0,3.0,4.0
    test_float_2 dd 5.0,6.0,7.0,8.0
    test_float_shufps dd 4 dup(0.0)
    test_float_shupfps2 dd 4 dup(0.0)
    print_float db "%g ",0x0
section .text 
    global main
    extern printf 
    extern ExitProcess
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
    xor ebx,ebx

    movups xmm0,[test_float]
    movups xmm1,[test_float_2]
    shufps xmm1,xmm0,0b01_00_11_10
    movups [test_float_shufps],xmm1

    movups xmm1,[test_float_2]
    shufps xmm0,xmm1,0b11_10_01_00
    shufps xmm0,xmm0,0b01_11_10_00
    movups [test_float_shupfps2],xmm0
main_loop:
    cmp ebx,4
    jge second_loop

    lea rcx,[print_float]
    movss xmm0,[test_float_shufps+rbx*4]
    cvtss2sd xmm0,xmm0
    movq rdx,xmm0
    call printf

    inc ebx
    jmp main_loop
second_loop:
    printline
    xor ebx,ebx
second_loop_print:
    cmp ebx,4
    jge end_main

    lea rcx,[print_float]
    movss xmm0,[test_float_shupfps2+rbx*4]
    cvtss2sd xmm0,xmm0
    movq rdx,xmm0
    call printf

    inc ebx
    jmp second_loop_print
end_main:
    xor rax,rax
    call ExitProcess
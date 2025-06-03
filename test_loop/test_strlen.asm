bits 64
default rel

section .data 
    test_str db "test12313lk1l3k13lkkl123lk13k1l31",0x0
    test_out db "%d",0x0
section .text 
    global main
    extern printf
    extern strlen_func
    extern ExitProcess
main:
    lea rcx,[test_str]
    call strlen_func
    lea rcx,[test_out]
    mov rdx,rax
    call printf
    xor rax,rax
    call ExitProcess
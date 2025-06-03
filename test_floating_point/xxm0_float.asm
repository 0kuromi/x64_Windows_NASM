bits 64
default rel
section .data 
    test_double dq 13.0412937103871937
    test_float dd 13.022123
    test_print db "Du lieu double,float:%.17f %.9f",0xA,0
section .text 
    global main 
    extern printf
    extern ExitProcess
    extern nearbyintf
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
    lea rcx,[test_print]
    movsd xmm1,[test_double]
    movss xmm2,dword [test_float]
    cvtss2sd xmm2,xmm2
    movq rdx,xmm1
    movq r8,xmm2
    mov rax,1
    call printf
    add rsp,0x20
    xor rax,rax
    call ExitProcess

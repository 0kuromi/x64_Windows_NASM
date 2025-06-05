bits 64
default rel
section .bss

section .data

section .text
    global main
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
    
    add rsp,0x20
    xor rax,rax
    call ExitProcess


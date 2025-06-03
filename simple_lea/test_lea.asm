bits 64
default rel

section .data
    a db -125
section .text
    msg db "Address of &a:%p",0xA,0x0
    msg_value db "Value of *a:%d",0xA,0x0
    global main
    extern ExitProcess
    extern printf
main:
    lea rax,a
    lea rcx,[msg]
    mov rdx,rax
    call printf

    lea rax,a
    lea rcx,[msg_value]
    movsx rax,byte[eax]
    mov rdx,rax
    call printf

    xor rax,rax
    call ExitProcess


bits 64
default rel
SECTION .data
    format db "RBP=%p RSP=%p RDX=%X RBX=%p",0xD,0xA,0
SECTION .text 
    global main
    extern printf
    extern ExitProcess

main:
    push rbp
    push rdx
    mov rbp,rsp
    mov rdx,0x10
    sub rsp,0x28
    lea rcx,[format]
    mov rdx,RBP
    mov r8,RSP
    mov r9,rdx
    mov [rsp+0x20],rbx

    call printf
    xor eax,eax
    call ExitProcess
    ret
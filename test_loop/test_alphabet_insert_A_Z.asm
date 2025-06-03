bits 64
default rel

section .data
    alphabet db 27 dup(0)
    print_chuoi db "%s",0x0
section .text
    global main
    extern printf
    extern ExitProcess
main:
    mov cl,0
    lea rsi,[alphabet]
start_insert_loop:
    cmp cl,26
    jge .end_insert_loop
    mov al,'A'
    add al,cl
    mov byte[rsi],al
    inc cl
    inc rsi
    jmp start_insert_loop
.end_insert_loop:
    mov byte[rsi],0
    lea rcx,[print_chuoi]
    lea rsi,[alphabet]
    mov rdx,rsi
    call printf
    xor rax,rax
    call ExitProcess


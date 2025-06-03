bits 64
default rel

section .data
    alphabet db 20 dup(0)
    test_string db "abcdef",0x0
    len_test_string equ $-test_string
    print_char db "character:%c",0xA,0x0
    i db 0
section .text
    global main
    extern printf 
    extern ExitProcess
main:
    mov byte[i],0
    lea rsi,[test_string]
.loop_alphabet:
    movzx rax,byte[i]
    cmp rax,len_test_string
    je .end_loop_alphabet
    mov al,byte[rsi]
    cmp al,0
    je .end_loop_alphabet
    lea rcx,[print_char]
    movsx rdx,eax
    call printf
    inc rsi
    inc byte[i]
    jmp .loop_alphabet
.end_loop_alphabet:
    lea rcx,[alphabet]
    call printf
    xor rax,rax
    call ExitProcess
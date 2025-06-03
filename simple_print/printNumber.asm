bits 64
default rel
section .data
    print_string db "Value of B,W,DD,DQ: %d %d %d %ld",0xA,0x0
    num_byte db 255 
    num_word dw 6000
    num_dword dd -12000
    num_qword dq 128318128331838
section .text
    global main
    extern printf
    extern ExitProcess
    
main:
    lea rcx,[print_string];[rsp+0]
    movzx rdx,byte[num_byte];[rsp+8]
    movzx r8, word[num_word];[rsp+8*2]
    mov r9d,dword[num_dword]
    mov rax,[num_qword]
    mov qword [rsp+32],rax ;[rsp+8*4]

    call printf
    xor eax,eax
    call ExitProcess
    ret
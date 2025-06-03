bits 64
default rel
%macro print_msg 2
    section .data
    %%msg db %1,0x0
    section .text 
    mov rcx,%%msg
    lea rdx,[rel %2]
    call printf
%endmacro
%macro print_line 0
    section .data 
    %%new_line db 0xA,0x0
    section .text
    lea rcx,[%%new_line]
    call printf
%endmacro
section .data
    input_str_1 db 128 dup(0)
    input_str_2 db 128 dup(0)
    input_str_format db "%127s",0x0
    msg_bool db "Ket qua so sanh 2 chuoi: %d",0xA,0x0 
section .text
    global main
    extern printf
    extern ExitProcess
    extern scanf
main:
    print_msg "Main function()",input_str_1
    print_line
.input_str:
    print_msg "Please input string 1:",input_str_1
    lea rcx,[input_str_format]
    lea rdx,[input_str_1]
    call scanf
    print_msg "Please input string 2:",input_str_2
    lea rcx,[input_str_format]
    lea rdx,[input_str_2]
    call scanf
.compare_string:
    lea rsi,[input_str_1]
    lea rdi,[input_str_2]
    xor rax,rax
.compare_loop:
    mov bl,byte[rdi]
    cmp byte[rsi],bl
    jne .exit_process
    cmp byte[rdi],0x0
    je .end_loop
    inc rsi
    inc rdi
    jmp .compare_loop
.end_loop:
    mov al,0x1
.exit_process:
    lea rcx,[msg_bool]
    mov rdx,rax
    call printf
    xor rax,rax
    call ExitProcess

bits 64
default rel
%macro print_msg 2
    section .data
    %%msg db %1,0x0
    section .text
    lea rcx,%%msg
    lea rdx,[rel %2]
    call printf
%endmacro
%macro print_num 2
    section .data
    %%msg db %1,0x0
    section .text
    lea rcx,%%msg
    mov al,[rel %2]
    movsx rdx,eax
    call printf
%endmacro
%macro print_line 0
    section .data
    %%msg db 0xA,0x0
    section .text
    lea rcx,%%msg
    call printf
%endmacro
section .text 
    global strlen_func
; main:
;     print_msg "Input string:",input_str
;     lea rcx,[format_str]
;     lea rdx,[input_str]
;     call scanf
;     print_msg "Your input_string:%s",input_str
;     print_line
;     lea rcx,[input_str]
;     call strlen_func
;     mov byte[len_str],al
;     print_num "Your input_string length():%d",len_str
;     xor rax,rax
;     call ExitProcess
strlen_func:
    xor rax,rax
.strlen_loop:
    cmp byte[rcx],0x0
    je .end_loop
    inc rcx
    inc rax
    jmp .strlen_loop
.end_loop:
    ret

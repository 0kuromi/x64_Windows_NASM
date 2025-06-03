;This program using caller-saved register : rbp,rbx,rsi,rdi,r12-r15
bits 64
default rel

section .data
    msg_sum db "Value of a+b=%lld",0xA,0x0 
    msg_sub db "Value of a-b=%lld",0xA,0x0
    msg_mul db "Value of a*b=%lld",0xA,0x0
    msg_div db "Value of a/b=%lld reminder %d",0xA,0x0
    input_msg db "Input value of a,b:",0x0
    error_mg db "Phep tinh khong hop le hoac co loi xay ra",0x0
    input_scanf db "%lld%lld",0x0
    a dq 0
    b dq 0
section .text
    global main
    extern printf
    extern scanf
    extern ExitProcess
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x28
    lea rcx,[input_msg]
    call printf
    lea rcx,[input_scanf]
    lea rdx,[a] 
    lea r8,[b]
    call scanf

    mov rbx,[a]
    mov rsi,[b]
    mov rcx,rbx
    mov rdx,rsi
    call sub_40001

    mov rcx,rbx
    mov rdx,rsi
    call sub_40002

    mov rcx,rbx
    mov rdx,rsi
    call sub_40003

    mov rcx,rbx
    mov rdx,rsi
    call sub_40004

    xor rax,rax
    call ExitProcess
sub_40001:
    sub rsp,0x20
    mov rax,rcx
    add rax,rdx
    lea rcx,[msg_sum]
    mov rdx,rax
    call printf
    add rsp,0x20
    ret
sub_40002:
    sub rsp,0x20
    mov rax,rcx
    sub rax,rdx
    lea rcx,[msg_sub]
    mov rdx,rax
    call printf
    add rsp,0x20
    ret
sub_40003:
    sub rsp,0x20
    mov rax,rcx
    imul rax,rsi
    lea rcx,[msg_mul]
    mov rdx,rax
    call printf
    add rsp,0x20
    ret
sub_40004:
    sub rsp,0x20
    cmp rdx,0
    je .error_msg_func
    mov rax,rcx
    cqo 
    idiv rsi
    ;phan chia o rax, phan du o rdx
    lea rcx,[msg_div]
    mov rdx,rax
    mov r8,rsi
    call printf
    add rsp,0x20
    ret
.error_msg_func:
    lea rcx,[error_mg]
    call printf
    add rsp,0x20
    ret
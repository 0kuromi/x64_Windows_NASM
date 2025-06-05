bits 64
default rel
section .data 
    print_msg db "Enter arr length N = ",0x0
    format_int db "%d",0x0
    sigma db ",",0x0
    N db 0
section .bss
    test_array_dynamic resd 1
section .text 
    global main 
    extern printf
    extern ExitProcess
    extern malloc
    extern scanf
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
input_N:
    lea rcx,[print_msg]
    call printf
    lea rcx,[format_int]
    lea rdx,[N]
    call scanf
malloc_array:
    movzx rax,byte[N]
    mov rcx,4
    mul rcx
    mov rcx,rax
    call malloc
    mov [test_array_dynamic],rax
    xor ebx,ebx
input_int:
    cmp bl,byte[N]
    lea rcx,[format_int]
    lea rsi,[test_array_dynamic]
    lea rdx,[rsi+rbx*4]
    call scanf
    inc ebx
    jmp input_int
print_int:
    xor ebx,ebx
print_int_loop:
    cmp bl,byte[N]
    jge end_main
    lea rcx,[format_int]
    lea rsi,[test_array_dynamic]
    mov eax,[rsi+rbx*4]
    movsxd rdx,eax
    call printf
    inc ebx
    cmp bl,byte[N]
    je end_main
    lea rcx,[sigma]
    call printf
    jmp print_int_loop
end_main:
    add rsp,0x20
    xor rax,rax
    call ExitProcess

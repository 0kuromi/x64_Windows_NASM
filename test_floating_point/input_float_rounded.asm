bits 64
default rel
section .data
    input_scanf db "%f%lf",0x0
    input_mode db "%hhu",0x0
    float_print db "Gia tri cua float,double ban nhap: %f %f",0xA,0x0
    rounded_mode db "Vui long nhap che do lam tron (Nearest is default,0x1:Floor, 0x2:Ceil, 0x3:Truncate):",0x0
    msg_print db "Vui long nhap 2 gia tri float va double:",0x0
    mode_input db 0 
    num_float dd 0
    num_double dq 0
    mxcsr_from_memory dd 0
section .text
    global main
    extern printf
    extern scanf
    extern ExitProcess
    extern nearbyintf
    extern nearbyint
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
input_mode_main:
    lea rcx,[rounded_mode]
    call printf

    lea rcx,[input_mode]
    lea rdx,[mode_input]
    call scanf

    lea rdi,[mxcsr_from_memory]
    stmxcsr [rdi]
    mov eax,[rdi]
    cmp byte[mode_input],0x1
    je floor_mode
    cmp byte[mode_input],0x2
    je ceil_mode
    cmp byte[mode_input],0x3
    je truncate_mode
floor_mode:
    bts eax,13
    jmp load_mxcsr_for_memory
ceil_mode:
    bts eax,14
    jmp load_mxcsr_for_memory
truncate_mode:
    bts eax,13
    bts eax,14
    jmp load_mxcsr_for_memory
load_mxcsr_for_memory:
    mov dword[mxcsr_from_memory],eax
    ldmxcsr [mxcsr_from_memory]
    lea rcx,[msg_print]
    call printf
input_float_main:
    lea rcx,[input_scanf]
    lea rdx,[num_float]
    lea r8,[num_double]
    call scanf
    jmp print_float
print_float:
    movss xmm0,[num_float]
    call nearbyintf
    movsd xmm1,[num_double]
    cvtss2sd xmm0,xmm0
    movsd xmm2,xmm0
    movsd xmm0,xmm1
    call nearbyint
    movsd xmm1,xmm0
    movsd xmm0,xmm2

    lea rcx,[float_print]
    movq rdx,xmm0
    movq r8,xmm1
    call printf

exit_main:
    add rsp,0x20
    xor rax,rax
    call ExitProcess
    movq r8,xmm1
    call printf
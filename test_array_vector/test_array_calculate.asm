;Input all array element
;Calculate add,sub,div,mul all of elements and show result
bits 64
default rel
%macro print_text 2
    section .data 
        %%msg db %1,%2,0x0
    section .text 
        lea rcx,[%%msg]
        call printf
%endmacro
section .data 
    array_length db 0
    array_int dd 256 dup(0)
    input_int db "%hhu",0x0
    print_int db "%d",0x0
    format_char db ", ",0x0
    sum_int dd 0
    sub_int dd 0
    div_float dq 0.0
    mul_int dq 1
    calculate_print db "Sum: %d, Sub: %d, Mul: %lld, Div: %f",0xA,0x0
section .text
    global main
    extern scanf 
    extern printf 
    extern ExitProcess
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
    print_text "Array simple program",0xA
    print_text "Input array length:",0x0
    lea rcx,[input_int]
    lea rdx,[array_length]
    call scanf
    print_text "Input array number:",0x0
    xor rbx,rbx
input_array:
    cmp bl,byte[array_length]
    jge next_stage
    lea rcx,[print_int]
    lea rsi,[array_int]
    lea rdx,[rsi+rbx*4]
    call scanf
    inc rbx
    jmp input_array
next_stage:
    xor rbx,rbx
    print_text "Your input array is: ",0x0
print_array:
    cmp bl,byte[array_length]
    jge calculate_array
    lea rcx,[print_int]
    lea rsi,[array_int]
    mov edx,[rsi+rbx*4];mov sign extension for 32bit-64
    movsxd rdx,[rsi+rbx*4]
    call printf
    inc rbx
    cmp bl,byte[array_length]
    je calculate_array
    lea rcx,[format_char]
    call printf
    jmp print_array
calculate_array:
    print_text "",0xA
    print_text "Calculate processing....",0xA
    xor rbx, rbx                  ; index = 0
    xor eax, eax
    mov dword [sum_int], 0
    mov dword [sub_int], 0
    mov qword [mul_int], 1

    ; lấy phần tử đầu tiên cho sub và div
    movzx ecx, byte [array_length]
    cmp ecx, 0
    je end_loop

    lea rsi, [array_int]
    mov eax, [rsi]                ; phần tử đầu tiên
    mov [sum_int], eax
    mov [sub_int], eax
    cvtsi2sd xmm0, eax           ; convert int -> double
    movsd [div_float], xmm0
    movsxd rax, eax              ; đảm bảo 64-bit
    mov [mul_int], rax

    inc rbx                      ; bắt đầu từ phần tử thứ 2
calculate_loop:
    cmp bl, byte[array_length]
    jge print_result

    ; Load current element
    mov eax, [rsi + rbx*4]

    ; sum
    add [sum_int], eax

    ; sub
    sub [sub_int], eax

    ; mul (64-bit)
    movsxd rdx, eax
    push rax
    mov rax, [mul_int]
    imul rax, rdx
    mov [mul_int], rax
    pop rax
    ; div (nếu != 0)
    test eax, eax
    jz skip_div
    cvtsi2sd xmm1, eax
    movsd xmm0, [div_float]
    divsd xmm0, xmm1
    movsd [div_float], xmm0
skip_div:
    inc rbx
    jmp calculate_loop
print_result:
    lea rcx, [calculate_print]
    mov edx,[sum_int]
    mov r8d,[sub_int]
    mov r9,[mul_int]
    movsd xmm0,[div_float]
    movq [rsp+0x20],xmm0
    call printf
    jmp end_loop
end_loop:
    add rsp,0x20
    xor rax,rax 
    call ExitProcess
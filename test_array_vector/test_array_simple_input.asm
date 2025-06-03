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
section .text
    global main
    extern scanf 
    extern printf 
    extern ExitProcess
main:
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
    lea rcx,[input_int]
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
    jge end_loop
    lea rcx,[print_int]
    mov rdx,[array_int+rbx*4]
    call printf
    inc rbx
    cmp bl,byte[array_length]
    je end_loop
    lea rcx,[format_char]
    call printf
    jmp print_array
end_loop:
    xor rax,rax 
    call ExitProcess
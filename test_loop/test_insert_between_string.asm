bits 64
default rel
; INSERT KHONG SU DUNG CHUOI MOI
%macro print_str 2
    section .data
    %%msg db %1,0xA,0x0
    section .text
    mov rcx,%%msg
    lea rdx,[rel %2]
    call printf
%endmacro
%macro print_num 2
    section .data
    %%msg db %1,0x0
    section .text
    mov rcx,%%msg
    mov al,[rel %2]
    movsx rdx,eax
    call printf
%endmacro
section .data
    target_str db "ABC",0x0
    equ_len equ $-target_str
    target_len db 0
    insert_index db 2
    test_print db "%s",0xA,0x0
section .text
    global main
    extern printf
    extern ExitProcess
main:
    lea rsi,[target_str]
    mov rax,equ_len
    mov cl,byte[insert_index]
    add rsi,rax
.append_loop:
    cmp rax,rcx
    jle .append_char
    mov bl,byte[rsi-1]
    mov byte[rsi],bl
    dec rax
    dec rsi
    jmp .append_loop
.append_char:
    mov byte[rsi],'X'
    jmp .end_loop
.end_loop:
    print_str "Chuoi duoc in ra la:%s",target_str
    print_num "Do dai cua chuoi:%d",target_len
    xor rax,rax
    call ExitProcess

;;DOAN MA INSERT VOI VIEC TAO CHUOI MOI 
; section .data 
;     hello_msg db "test_string_insert",0x0
;     len_msg equ $-hello_msg
;     new_string_insert db 128 dup(0)
;     insert_index db 0
;     character_insert db "X",0x0
;     test_string_print db "chuoi sau khi xu ly :%s",0x0
; section .text 
;     global main 
;     extern printf 
;     extern ExitProcess
; main:
;     xor rbx,rbx
;     lea rsi,[new_string_insert]
; .insert_loop:
;     cmp bl,len_msg
;     jge .end_loop
;     cmp bl,byte[insert_index]
;     jne .insert_char

;     mov al,byte[character_insert]
;     mov byte[rsi],al
;     inc rsi
;     ;Insert special char
; .insert_char:
;     mov al,[hello_msg + rbx]
;     mov byte[rsi],al
;     inc bl
;     inc rsi
;     jmp .insert_loop
; .end_loop:
;     mov byte[rsi],0
;     lea rcx,[test_string_print]
;     lea rdx,[new_string_insert]
;     call printf
;     xor rax,rax
;     call ExitProcess

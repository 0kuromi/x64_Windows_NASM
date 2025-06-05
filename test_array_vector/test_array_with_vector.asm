bits 64
default rel
%macro print_debug 2
    section .data 
    %%print_dbg db %1,%2,0x0
    section .text
    lea rcx,[%%print_dbg]
    call printf
%endmacro
section .bss
    vector_num resd 1
section .data
    vector_size dd 0
    capacity dd 1
    print_msg db "Vector size = %d",0xA,"Vector elements: ",0xA,0x0
    format_int db "%d",0x0
    sigma db ",",0x0
section .text
    global main
    extern printf
    extern ExitProcess
    extern scanf
    extern malloc
    extern realloc
    extern free
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
    mov rax,1
    mov rcx,4
    mul rcx
    mov rcx,rax
    call malloc

    mov [vector_num],rax;Frist malloc call to allocate space for vector elements
    mov rcx,[vector_num];Push number 5 to vector_num
    mov rdx,5
    call push_i

    mov rcx,[vector_num];Push number 6 to vector_num
    mov rdx,6
    call push_i

    mov rcx,[vector_num];Push number 7 to vector_num
    mov rdx,7
    call push_i

    mov rcx,[vector_num];Push number 8 to vector_num
    mov rdx,8
    call push_i
    
    mov rcx,[vector_num];Pop number 7 to vector_num
    mov rdx,7
    call pop_i

    mov rcx,[vector_num];Pop number 8 to vector_num
    mov rdx,8
    call pop_i

    ;clear_all 
    ;call clear_all

    mov rcx,5
    call find_value

    mov rcx,4
    call find_value
print_vector_info:
    print_debug "print_vector_info",0xA
    lea rcx,[print_msg]
    mov rdx,[vector_size]
    call printf 
    xor rbx,rbx
loop_print_vector:
    cmp ebx,[vector_size]
    jge end_main
    lea rcx,[format_int]
    mov rsi,[vector_num]
    mov eax,[rsi+rbx*4]
    mov edx,eax
    call printf
    inc rbx
    cmp ebx,[vector_size]
    je end_main
    lea rcx,[sigma]
    call printf
    jmp loop_print_vector
end_main:
    mov rcx,[vector_num]
    call free
    add rsp,0x20
    xor rax,rax
    call ExitProcess
push_i:
    push rbp
    mov rbp, rsp
    sub rsp, 0x20
    ; kiểm tra nếu size >= capacity thì realloc
    mov eax, [vector_size]
    mov rdi, rdx
    cmp eax, [capacity]
    jl .push_element
    ; nếu đầy → call multiply_capacity
    call multiply_capacity
    ; sau khi realloc, cần cập nhật lại rcx = [vector_num]
    mov rcx, [vector_num]
.push_element:
    mov eax, [vector_size]
    mov [rcx + rax*4], edi         ; lưu giá trị rdx vào mảng
    inc dword [vector_size]        ; tăng size
    print_debug "push_i", 0xA
    add rsp, 0x20
    leave
    ret
; multiply_capacity:
; Gấp đôi capacity, realloc lại vùng nhớ, cập nhật vector_num
multiply_capacity:
    push rbp
    mov rbp, rsp
    sub rsp, 0x20
    mov eax, [capacity]
    imul eax, 2
    mov [capacity], eax
    ; tính kích thước byte mới = capacity * 4
    shl eax, 2
    mov edx, eax                  ; rdx = new size
    mov rcx, [vector_num]        ; rcx = old ptr
    call realloc
    ; cập nhật lại vector_num
    mov [vector_num], rax
    print_debug "multiply_capacity", 0xA
    add rsp, 0x20
    leave
    ret
; rcx = giá trị cần xóa (int)
pop_i:
    push rbp
    mov rbp, rsp
    sub rsp, 0x20
    mov rbx, [vector_num]       ; con trỏ mảng
    mov ecx,edx
    xor rdx, rdx                ; rdx = index = 0
    mov eax, [vector_size]
.search_loop:
    cmp edx, eax
    jge .not_found              ; nếu không tìm thấy
    mov esi, [rbx + rdx*4]      ; lấy phần tử tại index
    cmp esi, ecx                ; có bằng giá trị cần xoá không?
    je .found
    inc edx
    jmp .search_loop
.found:
    ; dịch phần tử từ (index+1) → size-1 về trái
    mov ecx, edx                ; ecx = chỉ số ghi
    inc edx                     ; edx = chỉ số đọc tiếp theo
.shift_loop:
    cmp edx, eax
    jge .shrink                 ; nếu đọc đến cuối thì kết thúc
    mov esi, [rbx + rdx*4]
    mov [rbx + rcx*4], esi
    inc ecx
    inc edx
    jmp .shift_loop
.shrink:
    ; giảm size và clear phần tử cuối
    dec eax
    mov [vector_size], eax
    mov dword [rbx + rax*4], 0
    ; shrink nếu cần
    mov ecx, [capacity]
    shr ecx, 2                  ; capacity / 4
    cmp eax, ecx
    jge .done
    ; shrink mảng
    mov [capacity], eax
    mov edx, eax
    shl edx, 2
    mov rcx, rbx
    call realloc
    mov [vector_num], rax
    print_debug "shrink vector", 0xA
    jmp .done
.not_found:
    print_debug "value not found", 0xA
.done:
    print_debug "pop_i(value)", 0xA
    add rsp, 0x20
    leave
    ret
clear_all:
    push rbp
    mov rbp, rsp
    sub rsp, 0x20

    mov rbx, [vector_num]
    mov ecx, [vector_size]
    xor edx, edx        ; edx = index = 0

.clear_loop:
    cmp edx, ecx
    jge .done_clear
    mov dword [rbx + rdx*4], 0
    inc edx
    jmp .clear_loop

.done_clear:
    mov dword [vector_size], 0
    print_debug "clear_all", 0xA
    add rsp, 0x20
    leave
    ret
find_value:
    push rbp
    mov rbp, rsp
    sub rsp, 0x20
    mov rbx, [vector_num]
    mov edx, [vector_size]
    xor eax, eax        ; eax = index = 0
.find_loop:
    cmp eax, edx
    jge .not_found
    mov esi, [rbx + rax*4]
    cmp esi, ecx
    je .found
    inc eax
    jmp .find_loop
.not_found:
    mov eax, -1
    print_debug "find_value: not found", 0xA
    add rsp, 0x20
    leave
    ret
.found:
    print_debug "find_value: found", 0xA
    add rsp, 0x20
    leave
    ret
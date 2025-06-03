bits 64
default rel

section .data 
    ;align 16
    float_num  dd 1.0, 2.0, 3.0, 4.0
    new_float  dd 4 dup(1.0)
    print_mang db "%g ",0   ; newline

section .text 
    global main
    extern printf
    extern ExitProcess
;;-----------------TEST FOR MOVEUPS without align -----------------------
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20

    movups xmm0,[float_num]
    movups xmm1,[new_float]
    addps xmm1,xmm0
    movups [new_float],xmm1
    xor rbx,rbx
loop_print_ps:
    cmp bl,4
    jge end_main
    lea rcx,[print_mang]
    movss xmm0,dword [new_float+ebx*4]
    cvtss2sd xmm0,xmm0
    movq rdx,xmm0
    call printf
    inc bl
    jmp loop_print_ps

end_main:
    add rsp,0x20
    xor rax,rax 
    call ExitProcess
;;;---------------TEST FOR MOVEAPS with align data -------------------
; main:
;     push rbp
;     mov rbp, rsp
;     sub rsp, 32               ; đủ stack cho align + lưu xmm

;     ; === Cộng vector ===
;     movaps xmm0, [float_num]
;     movaps xmm1, [new_float]
;     addps xmm1, xmm0          ; xmm1 = [1.0, 2.0, 3.0, 4.0]

;     ; === Lưu xmm1 ra stack và trích từng phần tử ===
;     sub rsp, 16
;     movaps [rsp], xmm1        ; lưu 4 float: rsp[0] → rsp+12

;     ; === Từng phần tử đưa vào xmm0 → xmm3 ===
;     movss xmm0, dword [rsp]        ; float 1
;     cvtss2sd xmm0, xmm0            ; double
;     movq rdx,xmm0

;     movss xmm1, dword [rsp + 4]    ; float 2
;     cvtss2sd xmm1, xmm1
;     movq r8,xmm1 

;     movss xmm2, dword [rsp + 8]    ; float 3
;     cvtss2sd xmm2, xmm2
;     movq r9,xmm2

;     movss xmm3, dword [rsp + 12]   ; float 4
;     cvtss2sd xmm3, xmm3
;     movq [rsp+48],xmm3
;     add rsp, 16

;     ; === Gọi printf ===
;     lea rcx, [print_mang]
;     call printf

;     ; === Kết thúc chương trình ===
;     mov rsp, rbp
;     pop rbp
;     xor rax, rax
;     call ExitProcess

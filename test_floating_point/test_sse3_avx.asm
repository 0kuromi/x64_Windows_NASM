;SSE3 - XMM - 128 bits : 
;   + 4 floats
;   + 2 double
;   + 16 byte number
;AVX - YMM - 256 bits: using VEX encoding
; What is VEX Encoding: a new structure replace encoding layer traditional, allow 2-3 more register and reduce opcode
;   + 8 floats
;   + 4 double
;   + 32 byte number
;AVX512 - ZMM - 512 bits 
;   + 16 floats
;   + 8 doubles
;   + 64 byte number
bits 64
default rel
section .data  
    test_ymm_float_data1 dd 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
    test_ymm_float_data2 dd 9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0
    test_ymm_float_array dd 8 dup(0.0)

    align 64
    test_zmm_float_data1 dd 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
    align 64
    test_zmm_float_data2 dd 9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0
    test_zmm_float_array dd 16 dup(0.0)

    print_float db "%g ",0x0
section .text
    global main
    extern printf
    extern ExitProcess
main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
    vmovaps ymm0,[test_ymm_float_data1]
    vmovaps ymm1,[test_ymm_float_data2]
    vaddps ymm2,ymm0,ymm1
    ;ymm2 = 10 12 14 16 | 18 20 22 24
    ;vshufps ymm3,ymm2,ymm2,0x0
    ;vinsertf128 ymm3,ymm3,xmm3,1
    ;vbroadcastss ymm3,xmm3
    vmovaps [test_ymm_float_array],ymm2
    ;CPU KHONG HO TRO INSTRUC AVX512
    ; vmovups zmm0,[test_zmm_float_data1]
    ; vmovups zmm1,[test_zmm_float_data2]
    ; vaddps zmm2,zmm0,zmm1
    ; vmovups [test_zmm_float_array],zmm2
    
    xor rbx,rbx
first_loop:
    cmp rbx,8
    jge end_loop

    movss xmm0,[test_ymm_float_array+rbx*4]
    cvtss2sd xmm0,xmm0
    lea rcx,[print_float]
    movq rdx,xmm0
    call printf

    inc rbx
    jmp first_loop
end_loop:
    add rsp,0x20
    xor rax,rax 
    call ExitProcess
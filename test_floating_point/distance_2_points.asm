bits 64
default rel

section .data
    fmt_in      db "%f", 0
    fmt_out     db "Distance = %g", 10, 0

    X1Y1        dd 0.0, 0.0    ; [X1, Y1]
    X2Y2        dd 0.0, 0.0    ; [X2, Y2]

section .text
    global main
    extern printf, scanf, ExitProcess

main:
    push rbp
    mov rbp,rsp
    sub rsp,0x20
    ; Nhập X1
    lea rcx, [fmt_in]
    lea rdx, [X1Y1]
    call scanf

    ; Nhập Y1
    lea rcx, [fmt_in]
    lea rdx, [X1Y1+4]
    call scanf

    ; Nhập X2
    lea rcx, [fmt_in]
    lea rdx, [X2Y2]
    call scanf

    ; Nhập Y2
    lea rcx, [fmt_in]
    lea rdx, [X2Y2+4]
    call scanf

    ; Load packed X1,Y1 và X2,Y2
    movups xmm0, [X2Y2]        ; xmm0 = [X2, Y2]
    movups xmm1, [X1Y1]        ; xmm1 = [X1, Y1]

    ; Tính (X2 - X1), (Y2 - Y1)
    subps xmm0, xmm1           ; xmm0 = [X2-X1, Y2-Y1]

    ; Nhân bình phương
    mulps xmm0, xmm0           ; xmm0 = [(X2-X1)^2, (Y2-Y1)^2]

    ; Nạp lại để cộng 2 phần tử
    movaps xmm1, xmm0
    shufps xmm1, xmm1, 0b00000001   ; xmm1 = [Ydiff^2, Ydiff^2]
    addss xmm0, xmm1           ; xmm0 = Xdiff^2 + Ydiff^2

    ; Căn bậc 2
    sqrtss xmm0, xmm0          ; distance

    ; In kết quả
    lea rcx, [fmt_out]
    cvtss2sd xmm0, xmm0        ; chuyển sang double để in
    movq rdx, xmm0
    call printf

    add rsp,0x20
    ; Thoát
    xor rax, rax
    call ExitProcess

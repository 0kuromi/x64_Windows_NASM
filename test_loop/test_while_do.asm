bits 64
default rel
%macro print 1
    section .data
    %%msg db %1,0xA,0x0
    section .text
    lea rcx,[%%msg]
    call printf
%endmacro
section .data
    i dd 0
section .text
    global main
    extern printf
    extern ExitProcess
;While loop
; main:
;     mov eax,[i]
;     movsx rax,eax
; .while_loop:
;     cmp rax,10 ; while i <10
;     jge .end_loop
;     print "test"
;     jmp .while_loop
; .end_loop:
;     print "end_loop call"
;     xor rax,rax
;     call ExitProcess

;Do-while loop
main:
    mov dword [i],0
.do_loop:
    print "i love you very much"
    inc dword [i]
    mov eax,[i]
    cmp rax,10
    jl .do_loop

    print "End do_while loop"
    xor rax,rax
    call ExitProcess
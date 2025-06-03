bits 64
default rel
%macro print 2
    section .data
    %%fmt db %1,0
    section .text
    mov rcx,%%fmt
    mov eax,[rel %2]
    movsx rdx,eax
    call printf
%endmacro

%macro printline 0
    section .text 
    lea rcx,[end_line]
    call printf
%endmacro
section .data
    i dd 0
    j dd 0
    sleep_time dd 1000
    a dd 0
    b dd 0
    character db "*",0x0
    end_line db "",0xA,0x0
section .text
    global main
    extern ExitProcess
    extern printf
    extern Sleep
main:
    print "Program : test_loop_simple.asm",i
    printline
    ;Loop start
.start_loop:
    mov eax,[i]
    movsx rax,eax
    cmp rax,10
    jge .end_loop
    print "*",i
    inc dword[i]
    xor eax,eax
    mov [j],eax
    jmp .start_j_loop
.end_loop:
    print "Gia tri cua bien j sau vong lap = %d",j
    printline
    print "Gia tri cua bien i sau vong lap = %d",i
    xor rax,rax
    call ExitProcess
.start_j_loop:
    mov eax,[j]
    movsx rax,eax
    cmp rax,20
    jge .end_j_loop
    print " *",i
    inc dword[j]
    jmp .start_j_loop
.end_j_loop:
    printline
    jmp .start_loop
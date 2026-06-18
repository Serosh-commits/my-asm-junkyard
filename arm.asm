%include "io.inc"

section .rodata
    DEFSTR hdr,   10, "arm", 10, 10
    DEFSTR s_add,  "42 + 17 = "
    DEFSTR s_sub,  "100 - 37 = "
    DEFSTR s_mul,  "123 * 456 = "
    DEFSTR s_div,  "1000 / 7 = "
    DEFSTR s_mod,  "1000 % 7 = "
    DEFSTR s_neg,  "neg(42) = "
    DEFSTR s_fhdr, 10, "Fibonacci", 10
    DEFSTR s_f93,  10, "fib(93), largest that fits in 64 bits: "
    DEFSTR s_ghdr, 10, 10, "u gcd ", 10
    DEFSTR s_gcd,  "gcd(252, 105) = "
    DEFSTR s_128h, 10, "128-bit add ", 10
    DEFSTR s_128,  "0xFFFFFFFFFFFFFFFF + 1 = 0x"

section .text
    global _start

_start:
    PRINT hdr, hdr.len

    PRINT s_add, s_add.len
    mov eax, 42
    add eax, 17
    call print_u64
    call print_nl

    PRINT s_sub, s_sub.len
    mov eax, 100
    sub eax, 37
    call print_u64
    call print_nl

    PRINT s_mul, s_mul.len
    imul eax, 123, 456
    call print_u64
    call print_nl

    PRINT s_div, s_div.len
    mov eax, 1000
    xor edx, edx
    mov ecx, 7
    div rcx
    push rdx
    call print_u64
    call print_nl

    PRINT s_mod, s_mod.len
    pop rax
    call print_u64
    call print_nl

    PRINT s_neg, s_neg.len
    mov eax, 42
    neg eax
    call print_s64
    call print_nl

    PRINT s_fhdr, s_fhdr.len
    xor r12d, r12d
    mov r13, 1
    mov r14d, 20
.fib:
    mov rax, r12
    call print_u64
    call print_space
    lea rax, [r12 + r13]
    mov r12, r13
    mov r13, rax
    dec r14d
    jnz .fib

    PRINT s_f93, s_f93.len
    xor r12d, r12d
    mov r13, 1
    mov ecx, 92
.fib93:
    lea rax, [r12 + r13]
    mov r12, r13
    mov r13, rax
    dec ecx
    jnz .fib93
    mov rax, r13
    call print_u64
    call print_nl

    PRINT s_ghdr, s_ghdr.len
    PRINT s_gcd, s_gcd.len
    mov rax, 252
    mov rbx, 105
.gcd:
    test rbx, rbx
    jz .gcd_done
    xor edx, edx
    div rbx
    mov rax, rbx
    mov rbx, rdx
    jmp .gcd
.gcd_done:
    call print_u64
    call print_nl

    PRINT s_128h, s_128h.len
    PRINT s_128, s_128.len
    mov rax, 0xFFFFFFFFFFFFFFFF
    xor edx, edx
    add rax, 1
    adc rdx, 0
    call print_hex128
    call print_nl
    call print_nl

    mov eax, 60
    xor edi, edi
    syscall

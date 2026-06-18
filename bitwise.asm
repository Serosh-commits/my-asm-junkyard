%include "io.inc"

section .rodata
    DEFSTR hdr,   10, "Bitwise Ops ", 10, 10
    DEFSTR s_and,  "0xFF0F & 0x0FF0 = 0x"
    DEFSTR s_or,   "0xFF0F | 0x0FF0 = 0x"
    DEFSTR s_xor,  "0xFF0F ^ 0x0FF0 = 0x"
    DEFSTR s_not,  "~0xFF0F [low16] = 0x"
    DEFSTR s_case, 10, "ASCII case", 10
    DEFSTR s_lower, " 'A' | 0x20 = '"
    DEFSTR s_upper, " 'z' & 0xDF = '"
    DEFSTR s_toggle," 'H' ^ 0x20 = '"
    DEFSTR s_q,     "'", 10
    DEFSTR s_tricks,10, "bit tricks ", 10
    DEFSTR s_even,  " 42 even? "
    DEFSTR s_odd,   " 37 even? "
    DEFSTR s_p2y,   " 64 power of 2? "
    DEFSTR s_p2n,   " 65 power of 2? "
    DEFSTR s_low,   " lowest set bit of 0xB4: "
    DEFSTR s_clr,   " clear lowest bit of 0xB4: 0b"
    DEFSTR s_pop,   10, "Kernighan's popcount ", 10, " bits set in 0xB5: "
    DEFSTR s_swap,  10, "XOR swap", 10
    DEFSTR s_bef,   " before: a="
    DEFSTR s_aft,   " after: a="
    DEFSTR s_b,     " b="
    DEFSTR s_yes,   "yes"
    DEFSTR s_no,    "no"

section .bss
    cbuf: resb 1

section .text
    global _start

_start:
    PRINT hdr, hdr.len

    PRINT s_and, s_and.len
    mov eax, 0xFF0F
    and eax, 0x0FF0
    call print_hex16
    call print_nl

    PRINT s_or, s_or.len
    mov eax, 0xFF0F
    or eax, 0x0FF0
    call print_hex16
    call print_nl

    PRINT s_xor, s_xor.len
    mov eax, 0xFF0F
    xor eax, 0x0FF0
    call print_hex16
    call print_nl

    PRINT s_not, s_not.len
    mov eax, 0xFF0F
    not eax
    and eax, 0xFFFF
    call print_hex16
    call print_nl

    PRINT s_case, s_case.len

    PRINT s_lower, s_lower.len
    mov al, 'A'
    or al, 0x20
    call print_char
    PRINT s_q, s_q.len

    PRINT s_upper, s_upper.len
    mov al, 'z'
    and al, 0xDF
    call print_char
    PRINT s_q, s_q.len

    PRINT s_toggle, s_toggle.len
    mov al, 'H'
    xor al, 0x20
    call print_char
    PRINT s_q, s_q.len

    PRINT s_tricks, s_tricks.len

    PRINT s_even, s_even.len
    mov eax, 42
    test al, 1
    jnz .e_no
    PRINTLN s_yes, s_yes.len
    jmp .e_done
.e_no:
    PRINTLN s_no, s_no.len
.e_done:

    PRINT s_odd, s_odd.len
    mov eax, 37
    test al, 1
    jnz .o_no
    PRINTLN s_yes, s_yes.len
    jmp .o_done
.o_no:
    PRINTLN s_no, s_no.len
.o_done:

    PRINT s_p2y, s_p2y.len
    mov eax, 64
    lea ecx, [eax - 1]
    test eax, ecx
    jnz .p2y_no
    PRINTLN s_yes, s_yes.len
    jmp .p2y_done
.p2y_no:
    PRINTLN s_no, s_no.len
.p2y_done:

    PRINT s_p2n, s_p2n.len
    mov eax, 65
    lea ecx, [eax - 1]
    test eax, ecx
    jnz .p2n_no
    PRINTLN s_yes, s_yes.len
    jmp .p2n_done
.p2n_no:
    PRINTLN s_no, s_no.len
.p2n_done:

    PRINT s_low, s_low.len
    mov eax, 0xB4
    mov ecx, eax
    neg ecx
    and eax, ecx
    call print_u64
    call print_nl

    PRINT s_clr, s_clr.len
    mov eax, 0xB4
    lea ecx, [eax - 1]
    and eax, ecx
    call print_bin8
    call print_nl

    PRINT s_pop, s_pop.len
    mov r12d, 0xB5
    xor r13d, r13d
.pop:
    test r12d, r12d
    jz .pop_done
    lea ecx, [r12 - 1]
    and r12d, ecx
    inc r13d
    jmp .pop
.pop_done:
    mov eax, r13d
    call print_u64
    call print_nl

    PRINT s_swap, s_swap.len
    mov r12, 42
    mov r13, 99
    PRINT s_bef, s_bef.len
    mov rax, r12
    call print_u64
    PRINT s_b, s_b.len
    mov rax, r13
    call print_u64
    call print_nl

    xor r12, r13
    xor r13, r12
    xor r12, r13

    PRINT s_aft, s_aft.len
    mov rax, r12
    call print_u64
    PRINT s_b, s_b.len
    mov rax, r13
    call print_u64
    call print_nl
    call print_nl

    mov eax, 60
    xor edi, edi
    syscall

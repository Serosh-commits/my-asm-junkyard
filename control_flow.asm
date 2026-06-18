%include "io.inc"

section .rodata
    DEFSTR hdr,   10, "control flow ", 10
    DEFSTR s_if,  10, " If/Else", 10
    DEFSTR s_max,  " max(42, 99) = "
    DEFSTR s_loop, 10, "continuing loop", 10
    DEFSTR s_sum,  " sum(1..100) = "
    DEFSTR s_while,10, "While ", 10
    DEFSTR s_pow,  " first power of 2 >= 1000: "
    DEFSTR s_arr,  10, "array sum", 10
    DEFSTR s_asum, " sum = "
    DEFSTR s_jt,   10, "jump and jjump", 10
    DEFSTR s_sel,  " season[2] = "
    DEFSTR s_spring, "spring", 10
    DEFSTR s_summer, "summer", 10
    DEFSTR s_autumn, "autumn", 10
    DEFSTR s_winter, "winter", 10
    DEFSTR s_mul,  10, "nested ones", 10

section .data
    arr:     dd 10, 20, 30, 40, 50
    arr_len: equ 5
    jt:      dq 0, 0, 0, 0

section .text
    global _start

_start:
    PRINT hdr, hdr.len

    PRINT s_if, s_if.len
    PRINT s_max, s_max.len
    mov eax, 42
    mov ecx, 99
    cmp eax, ecx
    cmovl eax, ecx
    call print_u64
    call print_nl

    PRINT s_loop, s_loop.len
    PRINT s_sum, s_sum.len
    xor eax, eax
    mov ecx, 100
.sum:
    add eax, ecx
    dec ecx
    jnz .sum
    call print_u64
    call print_nl

    PRINT s_while, s_while.len
    PRINT s_pow, s_pow.len
    mov eax, 1
.pow:
    cmp eax, 1000
    jge .pow_done
    shl eax, 1
    jmp .pow
.pow_done:
    call print_u64
    call print_nl

    PRINT s_arr, s_arr.len
    PRINT s_asum, s_asum.len
    lea r12, [rel arr]
    xor eax, eax
    mov ecx, arr_len
.arr:
    add eax, [r12]
    add r12, 4
    dec ecx
    jnz .arr
    call print_u64
    call print_nl

    PRINT s_jt, s_jt.len
    PRINT s_sel, s_sel.len

    lea rax, [rel .spring]
    mov [rel jt], rax
    lea rax, [rel .summer]
    mov [rel jt + 8], rax
    lea rax, [rel .autumn]
    mov [rel jt + 16], rax
    lea rax, [rel .winter]
    mov [rel jt + 24], rax

    mov eax, 2
    lea rbx, [rel jt]
    jmp [rbx + rax*8]

.spring:
    PRINTLN s_spring, s_spring.len
    jmp .jt_done
.summer:
    PRINTLN s_summer, s_summer.len
    jmp .jt_done
.autumn:
    PRINTLN s_autumn, s_autumn.len
    jmp .jt_done
.winter:
    PRINTLN s_winter, s_winter.len
.jt_done:

    PRINTLN s_mul, s_mul.len
    mov r12d, 1
.row:
    mov r13d, 1
.col:
    mov eax, r12d
    imul eax, r13d
    call print_u64
    call print_tab
    inc r13d
    cmp r13d, 5
    jle .col
    call print_nl
    inc r12d
    cmp r12d, 5
    jle .row
    call print_nl

    mov eax, 60
    xor edi, edi
    syscall

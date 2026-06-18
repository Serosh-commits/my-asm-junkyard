section .rodata
    hdr: db 10, "data movements", 10, 10
    hdr_len: equ $ - hdr
    lbl_movzx: db "movzx 0x80 <unsigned>: "
    lbl_movzx_l: equ $ - lbl_movzx
    lbl_movsx: db "movsx 0x80 <signed>: "
    lbl_movsx_l: equ $ - lbl_movsx
    lbl_max: db "max(42, 99): "
    lbl_max_l: equ $ - lbl_max
    lbl_min: db "min(42, 99): "
    lbl_min_l: equ $ - lbl_min
    lbl_abs: db "abs(-37): "
    lbl_abs_l: equ $ - lbl_abs
    lbl_lea3: db "lea 15*3: "
    lbl_lea3_l: equ $ - lbl_lea3
    lbl_lea5: db "lea 15*5: "
    lbl_lea5_l: equ $ - lbl_lea5
    lbl_lea7: db "lea 15*7: "
    lbl_lea7_l: equ $ - lbl_lea7
    lbl_bswap: db "bswap 0x12345678: 0x"
    lbl_bswap_l: equ $ - lbl_bswap
    lbl_0x: db "0x"
    newline: db 10
    hex_chars: db "0123456789ABCDEF"

section .bss
    dec_buf: resb 21
    hex_buf: resb 16

section .data
    test_byte: db 0x80

section .text
    global _start

_write:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

_print_u64:
    push rbx
    lea rdi, [rel dec_buf + 20]
    xor ecx, ecx
    mov rbx, 10
    test rax, rax
    jnz .loop
    dec rdi
    mov byte [rdi], '0'
    inc ecx
    jmp .done
.loop:
    test rax, rax
    jz .done
    xor edx, edx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc ecx
    jmp .loop
.done:
    mov rsi, rdi
    mov edx, ecx
    call _write
    pop rbx
    ret

_print_nl:
    lea rsi, [rel newline]
    mov rdx, 1
    jmp _write

_print_hex32:
    push rbx
    lea rdi, [rel hex_buf]
    lea rbx, [rel hex_chars]
    mov ecx, 8
.loop:
    rol eax, 4
    mov edx, eax
    and edx, 0x0F
    mov dl, [rbx + rdx]
    mov [rdi], dl
    inc rdi
    dec ecx
    jnz .loop
    lea rsi, [rel hex_buf]
    mov rdx, 8
    call _write
    pop rbx
    ret

_start:
    lea rsi, [rel hdr]
    mov rdx, hdr_len
    call _write

    lea rsi, [rel lbl_movzx]
    mov rdx, lbl_movzx_l
    call _write
    movzx eax, byte [rel test_byte]
    call _print_u64
    call _print_nl

    lea rsi, [rel lbl_movsx]
    mov rdx, lbl_movsx_l
    call _write
    movsx eax, byte [rel test_byte]
    push rax
    lea rsi, [rel lbl_0x]
    mov rdx, 2
    call _write
    pop rax
    call _print_hex32
    call _print_nl

    lea rsi, [rel lbl_max]
    mov rdx, lbl_max_l
    call _write
    mov rax, 42
    mov rcx, 99
    cmp rax, rcx
    cmovl rax, rcx
    call _print_u64
    call _print_nl

    lea rsi, [rel lbl_min]
    mov rdx, lbl_min_l
    call _write
    mov rax, 42
    mov rcx, 99
    cmp rax, rcx
    cmovg rax, rcx
    call _print_u64
    call _print_nl

    lea rsi, [rel lbl_abs]
    mov rdx, lbl_abs_l
    call _write
    mov rax, -37
    mov rcx, rax
    neg rcx
    test rax, rax
    cmovs rax, rcx
    call _print_u64
    call _print_nl

    mov r12, 15
    lea rsi, [rel lbl_lea3]
    mov rdx, lbl_lea3_l
    call _write
    lea rax, [r12 + r12*2]
    call _print_u64
    call _print_nl

    lea rsi, [rel lbl_lea5]
    mov rdx, lbl_lea5_l
    call _write
    lea rax, [r12 + r12*4]
    call _print_u64
    call _print_nl

    lea rsi, [rel lbl_lea7]
    mov rdx, lbl_lea7_l
    call _write
    lea rax, [r12 + r12*2]
    lea rax, [r12 + rax*2]
    call _print_u64
    call _print_nl

    lea rsi, [rel lbl_bswap]
    mov rdx, lbl_bswap_l
    call _write
    mov eax, 0x12345678
    bswap eax
    call _print_hex32
    call _print_nl
    call _print_nl

    mov rax, 60
    xor edi, edi
    syscall

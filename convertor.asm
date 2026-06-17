section .data
    number: dq 181
    bin_label: db "Binary: ", 0
    bin_len: equ $ - bin_label
    hex_label: db "Hex: 0x", 0
    hex_len: equ $ - hex_label
    dec_label: db "Decimal: ", 0
    dec_len: equ $ - dec_label
    neg_label: db "Negated: ", 0
    neg_len: equ $ - neg_label
    newline: db 10
    hex_chars: db "0123456789ABCDEF"
    endian_label: db "Endianness demo — value 0x12345678 in memory: ", 0
    endian_len: equ $ - endian_label
    endian_val: dd 0x12345678
    endian_msg: db " (little-endian: least significant byte first!)", 10, 0
    endian_msg_len: equ $ - endian_msg
    twos_label: db 10, "Two's Complement ", 10, 0
    twos_len: equ $ - twos_label
    separator: db 10, "Number Converter", 10, 0
    sep_len: equ $ - separator
    endian_sep: db 10, "Endianness Demo", 10, 0
    endian_sep_len: equ $ - endian_sep

section .bss
    bin_buf: resb 65
    hex_buf: resb 17
    dec_buf: resb 21
    byte_buf: resb 32

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel separator]
    mov rdx, sep_len
    syscall

    mov r12, [rel number]

    ; Binary
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel bin_label]
    mov rdx, bin_len
    syscall

    mov rax, r12
    lea rdi, [rel bin_buf]
    mov rcx, 64
.bin_loop:
    rol rax, 1
    jc .bin_one
    mov byte [rdi], '0'
    jmp .bin_next
.bin_one:
    mov byte [rdi], '1'
.bin_next:
    inc rdi
    dec rcx
    jnz .bin_loop

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel bin_buf]
    mov rdx, 64
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel newline]
    mov rdx, 1
    syscall

    ; Hex
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel hex_label]
    mov rdx, hex_len
    syscall

    mov rax, r12
    lea rdi, [rel hex_buf]
    mov rcx, 16
.hex_loop:
    rol rax, 4
    mov rdx, rax
    and rdx, 0x0F
    lea rbx, [rel hex_chars]
    mov dl, [rbx + rdx]
    mov [rdi], dl
    inc rdi
    dec rcx
    jnz .hex_loop

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel hex_buf]
    mov rdx, 16
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel newline]
    mov rdx, 1
    syscall

    ; Decimal
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel dec_label]
    mov rdx, dec_len
    syscall

    mov rax, r12
    lea rdi, [rel dec_buf + 20]
    mov rcx, 0
    test rax, rax
    jnz .dec_loop
    dec rdi
    mov byte [rdi], '0'
    inc rcx
    jmp .dec_print
.dec_loop:
    test rax, rax
    jz .dec_print
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    jmp .dec_loop
.dec_print:
    mov rax, 1
    mov rdx, rcx
    mov rsi, rdi
    mov rdi, 1
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel newline]
    mov rdx, 1
    syscall

    ; Two's Complement
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel twos_label]
    mov rdx, twos_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel neg_label]
    mov rdx, neg_len
    syscall

    mov rax, r12
    neg rax
    push rax

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel hex_label + 9]
    mov rdx, 2
    syscall

    pop rax

    lea rdi, [rel hex_buf]
    mov rcx, 16
.neg_hex_loop:
    rol rax, 4
    mov rdx, rax
    and rdx, 0x0F
    lea rbx, [rel hex_chars]
    mov dl, [rbx + rdx]
    mov [rdi], dl
    inc rdi
    dec rcx
    jnz .neg_hex_loop

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel hex_buf]
    mov rdx, 16
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel newline]
    mov rdx, 1
    syscall

    ; Endianness
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel endian_sep]
    mov rdx, endian_sep_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel endian_label]
    mov rdx, endian_len
    syscall

    lea r13, [rel endian_val]
    lea rdi, [rel byte_buf]
    mov rcx, 4
.endian_loop:
    movzx eax, byte [r13]
    mov rdx, rax
    shr rdx, 4
    lea rbx, [rel hex_chars]
    mov dl, [rbx + rdx]
    mov [rdi], dl
    mov rdx, rax
    and rdx, 0x0F
    mov dl, [rbx + rdx]
    mov [rdi + 1], dl
    mov byte [rdi + 2], ' '
    add rdi, 3
    inc r13
    dec rcx
    jnz .endian_loop

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel byte_buf]
    mov rdx, 12
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel endian_msg]
    mov rdx, endian_msg_len
    syscall

    mov rax, 60
    xor edi, edi
    syscall

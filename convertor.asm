section .data
    number: dq 181

    bin_label: db "Binary: "
    bin_label_len: equ $ - bin_label
    hex_label: db "Hex: 0x"
    hex_label_len: equ $ - hex_label
    dec_label: db "Decimal: "
    dec_label_len: equ $ - dec_label
    neg_label: db "Negated: 0x"
    neg_label_len: equ $ - neg_label
    newline: db 10
    hex_chars: db "0123456789ABCDEF"

    endian_val: dd 0x12345678
    endian_label: db "Endian: 0x12345678 stored as bytes: "
    endian_lbl_len: equ $ - endian_label
    endian_note: db " (little-endian)", 10
    endian_note_len: equ $ - endian_note

    hdr_main: db 10, "Number Converter", 10
    hdr_main_len: equ $ - hdr_main
    hdr_twos: db 10, "Two's Complement", 10
    hdr_twos_len: equ $ - hdr_twos
    hdr_endian: db 10, "Endianness", 10
    hdr_endian_len: equ $ - hdr_endian

section .bss
    bin_buf: resb 64
    hex_buf: resb 16
    dec_buf: resb 20
    byte_buf: resb 12

section .text
    global _start

_write:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

_to_hex:
    lea rdi, [rel hex_buf]
    lea rbx, [rel hex_chars]
    mov rcx, 16
.loop:
    rol rax, 4
    mov rdx, rax
    and edx, 0x0F
    mov dl, [rbx + rdx]
    mov [rdi], dl
    inc rdi
    dec rcx
    jnz .loop
    ret

_start:
    mov r12, [rel number]

    lea rsi, [rel hdr_main]
    mov rdx, hdr_main_len
    call _write

    lea rsi, [rel bin_label]
    mov rdx, bin_label_len
    call _write

    mov rax, r12
    lea rdi, [rel bin_buf]
    mov rcx, 64
.bin_loop:
    rol rax, 1
    setc dl
    add dl, '0'
    mov [rdi], dl
    inc rdi
    dec rcx
    jnz .bin_loop

    lea rsi, [rel bin_buf]
    mov rdx, 64
    call _write

    lea rsi, [rel newline]
    mov rdx, 1
    call _write

    lea rsi, [rel hex_label]
    mov rdx, hex_label_len
    call _write

    mov rax, r12
    call _to_hex

    lea rsi, [rel hex_buf]
    mov rdx, 16
    call _write

    lea rsi, [rel newline]
    mov rdx, 1
    call _write

    lea rsi, [rel dec_label]
    mov rdx, dec_label_len
    call _write

    mov rax, r12
    lea rdi, [rel dec_buf + 20]
    xor ecx, ecx
    test rax, rax
    jnz .dec_loop
    dec rdi
    mov byte [rdi], '0'
    inc ecx
    jmp .dec_done
.dec_loop:
    test rax, rax
    jz .dec_done
    xor edx, edx
    mov rbx, 10
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc ecx
    jmp .dec_loop
.dec_done:
    mov rsi, rdi
    mov rdx, rcx
    mov rdi, 1
    mov rax, 1
    syscall

    lea rsi, [rel newline]
    mov rdx, 1
    call _write

    lea rsi, [rel hdr_twos]
    mov rdx, hdr_twos_len
    call _write

    lea rsi, [rel neg_label]
    mov rdx, neg_label_len
    call _write

    mov rax, r12
    neg rax
    call _to_hex

    lea rsi, [rel hex_buf]
    mov rdx, 16
    call _write

    lea rsi, [rel newline]
    mov rdx, 1
    call _write

    lea rsi, [rel hdr_endian]
    mov rdx, hdr_endian_len
    call _write

    lea rsi, [rel endian_label]
    mov rdx, endian_lbl_len
    call _write

    lea r13, [rel endian_val]
    lea rdi, [rel byte_buf]
    lea rbx, [rel hex_chars]
    mov ecx, 4
.endian_loop:
    movzx eax, byte [r13]
    mov edx, eax
    shr edx, 4
    mov dl, [rbx + rdx]
    mov [rdi], dl
    mov edx, eax
    and edx, 0x0F
    mov dl, [rbx + rdx]
    mov [rdi + 1], dl
    mov byte [rdi + 2], ' '
    add rdi, 3
    inc r13
    dec ecx
    jnz .endian_loop

    lea rsi, [rel byte_buf]
    mov rdx, 12
    call _write

    lea rsi, [rel endian_note]
    mov rdx, endian_note_len
    call _write

    mov rax, 60
    xor edi, edi
    syscall

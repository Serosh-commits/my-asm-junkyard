section .rodata
    hdr: db 10, "Data Sections & Memory Layout ", 10, 10
    hdr_len: equ $ - hdr

    summary: db "section layout:", 10
             db " .text   : Code (RX)", 10
             db " .rodata : Constants (R)", 10
             db " .data   : Initialized data (RW)", 10
             db " .bss    : Zeroed buffers (RW)", 10, 10
    summary_len: equ $ - summary

    struct_hdr: db "Player struct:", 10
    struct_len: equ $ - struct_hdr

    name_lbl: db " name: "
    name_lbl_l: equ $ - name_lbl
    hp_lbl: db " health: "
    hp_lbl_l: equ $ - hp_lbl
    pos_lbl: db " pos: ("
    pos_lbl_l: equ $ - pos_lbl
    comma: db ", "
    rparen_nl: db ")", 10
    newline: db 10

section .data
    my_byte: db 0xFF
    my_word: dw 0x1234
    my_dword: dd 0xDEADBEEF
    my_qword: dq 0xCAFEBABEDEADC0DE
    my_float: dd 3.14
    my_double: dq 3.141592653589793

    byte_arr: db 1, 2, 3, 4, 5, 6, 7, 8
    dword_arr: dd 10, 20, 30, 40, 50
    ;poem i know u will hate it :/
    poem: db "roses are red,", 10
          db "violets are blue,", 10
          db "i write in assembly,", 10
          db "and so should you.", 10
    poem_len: equ $ - poem

    dashes: times 40 db '-'
            db 10
    dash_len: equ $ - dashes

    player:
    .name: db "Hero", 0
           times 11 db 0
    .hp: dd 100
    .x: dd 50
    .y: dd 75
    .level: dw 1

    P_NAME: equ 0
    P_HP: equ 16
    P_X: equ 20
    P_Y: equ 24

section .bss
    dec_buf: resb 21

section .text
    global _start

_write:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

_print_u32:
    movzx rax, eax
    lea rdi, [rel dec_buf + 20]
    xor ecx, ecx
.loop:
    test eax, eax
    jz .done
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc ecx
    jmp .loop
.done:
    test ecx, ecx
    jnz .print
    dec rdi
    mov byte [rdi], '0'
    inc ecx
.print:
    mov rsi, rdi
    mov edx, ecx
    call _write
    ret

_start:
    lea rsi, [rel hdr]
    mov rdx, hdr_len
    call _write

    lea rsi, [rel poem]
    mov rdx, poem_len
    call _write

    lea rsi, [rel dashes]
    mov rdx, dash_len
    call _write

    lea rsi, [rel summary]
    mov rdx, summary_len
    call _write

    lea rsi, [rel dashes]
    mov rdx, dash_len
    call _write

    lea rsi, [rel struct_hdr]
    mov rdx, struct_len
    call _write

    lea r12, [rel player]

    lea rsi, [rel name_lbl]
    mov rdx, name_lbl_l
    call _write
    lea rsi, [r12 + P_NAME]
    mov rdx, 4
    call _write
    lea rsi, [rel newline]
    mov rdx, 1
    call _write

    lea rsi, [rel hp_lbl]
    mov rdx, hp_lbl_l
    call _write
    mov eax, [r12 + P_HP]
    call _print_u32
    lea rsi, [rel newline]
    mov rdx, 1
    call _write

    lea rsi, [rel pos_lbl]
    mov rdx, pos_lbl_l
    call _write
    mov eax, [r12 + P_X]
    call _print_u32
    lea rsi, [rel comma]
    mov rdx, 2
    call _write
    mov eax, [r12 + P_Y]
    call _print_u32
    lea rsi, [rel rparen_nl]
    mov rdx, 2
    call _write

    mov rax, 60
    xor edi, edi
    syscall

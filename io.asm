%include "io.inc"   
section .rodata
    _nl:    db 10
    _sp:    db " "
    _tab:   db 9
    _hx:    db "0123456789ABCDEF"

section .bss
    _dbuf:  resb 21
    _hbuf:  resb 16
    _bbuf:  resb 8
    _cbuf:  resb 1

section .text
global _write, print_u64, print_s64, print_hex64, print_hex32, print_hex16
global print_nl, print_space, print_tab, print_char
global print_bin8, print_hex128

_write:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

print_u64:
    push rbx
    lea rdi, [rel _dbuf + 20]
    xor ecx, ecx
    mov rbx, 10

    test rax, rax
    jnz .divide

    dec rdi
    mov byte [rdi], '0'
    inc ecx
    jmp .out

.divide:
    xor edx, edx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc ecx
    test rax, rax
    jnz .divide

.out:
    mov rsi, rdi
    mov edx, ecx
    call _write
    pop rbx
    ret

print_s64:
    test rax, rax
    jns print_u64
    push rax
    mov byte [rel _cbuf], '-'
    lea rsi, [rel _cbuf]
    mov edx, 1
    call _write
    pop rax
    neg rax
    jmp print_u64

print_hex64:
    push rbx
    lea rdi, [rel _hbuf]
    lea rbx, [rel _hx]
    mov ecx, 16
.nib:
    rol rax, 4
    mov edx, eax
    and edx, 0x0F
    mov dl, [rbx + rdx]
    mov [rdi], dl
    inc rdi
    dec ecx
    jnz .nib
    lea rsi, [rel _hbuf]
    mov edx, 16
    call _write
    pop rbx
    ret

print_hex32:
    push rbx
    lea rdi, [rel _hbuf]
    lea rbx, [rel _hx]
    mov ecx, 8
.nib:
    rol eax, 4
    mov edx, eax
    and edx, 0x0F
    mov dl, [rbx + rdx]
    mov [rdi], dl
    inc rdi
    dec ecx
    jnz .nib
    lea rsi, [rel _hbuf]
    mov edx, 8
    call _write
    pop rbx
    ret

print_hex16:
    push rbx
    lea rdi, [rel _hbuf]
    lea rbx, [rel _hx]
    mov ecx, 4
.nib:
    rol ax, 4
    mov edx, eax
    and edx, 0x0F
    mov dl, [rbx + rdx]
    mov [rdi], dl
    inc rdi
    dec ecx
    jnz .nib
    lea rsi, [rel _hbuf]
    mov edx, 4
    call _write
    pop rbx
    ret

print_hex128:
    push rax
    mov rax, rdx
    call print_hex64
    pop rax
    jmp print_hex64

print_bin8:
    lea rdi, [rel _bbuf]
    mov ecx, 8
.bit:
    rol al, 1
    setc dl
    add dl, '0'
    mov [rdi], dl
    inc rdi
    dec ecx
    jnz .bit
    lea rsi, [rel _bbuf]
    mov edx, 8
    jmp _write

print_char:
    mov [rel _cbuf], al
    lea rsi, [rel _cbuf]
    mov edx, 1
    jmp _write

print_nl:
    lea rsi, [rel _nl]
    mov edx, 1
    jmp _write

print_space:
    lea rsi, [rel _sp]
    mov edx, 1
    jmp _write

print_tab:
    lea rsi, [rel _tab]
    mov edx, 1
    jmp _write

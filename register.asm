section .data
    header: db 10, "x86-64 Registers:/", 10, 10, 0
    header_len: equ $ - header
    ;yeah i was learning from the lessons from assembly from groundup bookfor this kinda cool right :\
    lesson1: db "Loading all 16 General Purpose Registers :)", 10, 0
    lesson1_len: equ $ - lesson1
    lesson2: db 10, "Sub-register Access 64/32/16/8-bit ", 10, 0
    lesson2_len: equ $ - lesson2
    lesson3: db 10, "0-Extension Rule", 10, 0
    lesson3_len: equ $ - lesson3
    lesson4: db 10, "Implicit Register Usage", 10, 0
    lesson4_len: equ $ - lesson4
    lesson5: db 10, "RFLAGS (Status Flags)", 10, 0
    lesson5_len: equ $ - lesson5

    gpr_msg: db " all 16 GPRs loade Use GDB 'info registers' to see them.", 10, 0
    gpr_len: equ $ - gpr_msg

    sub_msg: db " RAX = 0x1122334455667788", 10
             db " EAX (low 32) = 0x55667788", 10
             db " AX (low 16) = 0x7788", 10
             db " AH (hi 8) = 0x77", 10
             db " AL (lo 8) = 0x88", 10, 0
    sub_len: equ $ - sub_msg

    zero_msg: db " Writing to EAX (32-bit) ZEROES upper 32 bits of RAX!", 10
              db " Before: RAX = 0xFFFFFFFF00000000", 10
              db " mov eax, 1 → RAX = 0x0000000000000001", 10
              db " But writing AL does NOT zero anything above!", 10, 0
    zero_len: equ $ - zero_msg

    impl_msg: db " RAX: accumulator (mul/div result, return value)", 10
              db " RCX: counter (shifts, REP prefix, loop)", 10
              db " RDX: data (mul/div high bits, I/O port)", 10
              db " RSI: source (string ops: movsb, cmpsb)", 10
              db " RDI: destination (string ops, arg #1)", 10
              db " RSP: stack pointer (NEVER use for data!)", 10
              db " RBP: frame pointer (optional, but conventional)", 10
              db " RIP: instruction pointer (you can't mov to it!)", 10, 0
    impl_len: equ $ - impl_msg

    flags_msg: db " After 'cmp rax, rbx':", 10
               db " ZF=1 if rax == rbx (Zero Flag)", 10
               db " CF=1 if rax < rbx (Carry Flag, unsigned)", 10
               db " SF=1 if result < 0 (Sign Flag)", 10
               db " OF=1 if signed overflow (Overflow Flag)", 10
               db " These flags drive ALL conditional jumps!", 10, 0
    flags_len: equ $ - flags_msg

    done_msg: db 10, "donnie Now run with GDB:", 10
              db " make debug1-03", 10
              db " (gdb) break _start", 10
              db " (gdb) run", 10
              db " (gdb) layout regs", 10
              db " (gdb) si (step and watch registers change!)", 10, 10, 0
    done_len: equ $ - done_msg

    newline: db 10

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel header]
    mov rdx, header_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel lesson1]
    mov rdx, lesson1_len
    syscall

    mov rax, 0xAAAAAAAAAAAAAAAA
    mov rbx, 0xBBBBBBBBBBBBBBBB
    mov rcx, 0xCCCCCCCCCCCCCCCC
    mov rdx, 0xDDDDDDDDDDDDDDDD
    mov rsi, 0x1111111111111111
    mov rdi, 0x2222222222222222
    mov rbp, 0x3333333333333333
    mov r8,  0x8888888888888888
    mov r9,  0x9999999999999999
    mov r10, 0x1010101010101010
    mov r11, 0x1111111111111111
    mov r12, 0x1212121212121212
    mov r13, 0x1313131313131313
    mov r14, 0x1414141414141414
    mov r15, 0x1515151515151515

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel gpr_msg]
    mov rdx, gpr_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel lesson2]
    mov rdx, lesson2_len
    syscall

    mov rax, 0x1122334455667788

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel sub_msg]
    mov rdx, sub_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel lesson3]
    mov rdx, lesson3_len
    syscall

    mov rax, 0xFFFFFFFF00000000
    mov eax, 1
    mov rax, 0xFFFFFFFFFFFFFFFF
    mov al, 0

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel zero_msg]
    mov rdx, zero_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel lesson4]
    mov rdx, lesson4_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel impl_msg]
    mov rdx, impl_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel lesson5]
    mov rdx, lesson5_len
    syscall

    mov rax, 5
    mov rbx, 5
    cmp rax, rbx

    mov rax, 3
    cmp rax, rbx

    mov rax, 10
    cmp rax, rbx

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel flags_msg]
    mov rdx, flags_len
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [rel done_msg]
    mov rdx, done_len
    syscall

    mov rax, 60
    xor edi, edi
    syscall

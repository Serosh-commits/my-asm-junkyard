extern _write, print_u64, print_s64, print_hex64, print_hex32, print_hex16
extern print_nl, print_space, print_tab, print_char
extern print_bin8, print_hex128

%macro PRINT 2
    lea rsi, [rel %1]
    mov edx, %2
    call _write
%endmacro

%macro PRINTLN 2
    PRINT %1, %2
    call print_nl
%endmacro

%macro DEFSTR 2+
    %1: db %2
    %1.len: equ $ - %1
%endmacro

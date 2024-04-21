section .data
    nline db 10,10
    nline_len equ $-nline
    ano db 10, "Assignment no :5",
        db 10,"---",
        db 10, "Assignment Name: Conversion  and BCD to HEX N",
        db 10,"----"
    ano_len equ $-ano

    bmsg db 10, "Enter 4 digit Hex Number::"
    bmsg_len equ $-bmsg

    msg1 db 10,"Enter valid Hex number"
    msg1_len equ $-msg1

    ehmsg db 10, "The Equivalent BCD Number is::"
    ehmsg_len equ $-ehmsg

section .bss
    buf resb 5    ; Change buffer size to 5 for 4 hex digits
    char_ans resb 5
    ans resw 1

%macro Print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro exit 0 
    Print nline, nline_len     
    mov rax, 60
    xor rdi, rdi
    syscall
%endmacro

;-----------------------------------------------------------------------------------
section .text
global _start

_start:
    Print ano, ano_len
    Print bmsg, bmsg_len
    call accept
    mov [ans], bx
    Print ehmsg, ehmsg_len
    mov ax, [ans]
    call display_10

    exit

accept:
    read buf, 4    ; Read 4 hex digits
    mov rcx, 4
    mov rsi, buf
    xor bx, bx

next_byte:
    shl bx, 4
    mov al, [rsi]

    cmp al, '0'
    jb error
    cmp al, '9'
    jbe sub30

    cmp al, 'A'
    jb error
    cmp al, 'F'
    jbe sub37

    cmp al, 'a'
    jb error
    cmp al, 'f'
    jbe sub57

error:
    Print msg1, msg1_len
    exit

sub57:
    sub al, 20h
sub37:
    sub al, 07h
sub30:
    sub al, 30h

    add bx, ax
    inc rsi
    dec rcx
    jnz next_byte
    ret
    
;-------------------------------------------------------------------------------------
display_10:
    mov rsi, char_ans+4    ; Start from the 5th byte
    mov rcx, 5    ; Display 5 BCD digits
    mov rbx, 10

next_digit:
    xor rdx, rdx
    div rbx

    add dl, '0'
    mov [rsi], dl

    dec rsi
    dec rcx
    jnz next_digit

    Print char_ans, 5
    ret


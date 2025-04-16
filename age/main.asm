section .bss
    input resb 16         ; reserve 16 bytes for user input

section .data
    msg db "How old are you?", 0xA
    msg_len equ $ - msg

    older_msg db "You are older than 18", 0xA
    older_msg_len equ $ - older_msg

    youger_msg db "You are younger than 18", 0xA
    youger_msg_len equ $ - youger_msg

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80
    
    mov eax, 3            ; sys_read
    mov ebx, 0            ; stdin
    mov ecx, input        ; where to store input
    mov edx, 16           ; max bytes to read
    int 0x80              ; call kernel
    ; eax now has the number of bytes read

_loop:
    ; Convert ASCII string to integer
    xor esi, esi          ; ESI = our integer result (start at 0)
    xor edi, edi          ; EDI = index
    call _convert_loop

_convert_loop:
    movzx eax, byte [input + edi]  ; get one character
    cmp eax, 10                    ; is it newline? (Enter key)
    je _finalize_loop                   ; if yes, stop
    sub eax, '0'                   ; convert ASCII to numeric (e.g. '5' -> 5)
    imul esi, esi, 10             ; result *= 10
    add esi, eax                  ; result += digit
    inc edi                       ; move to next char
    jmp _convert_loop

_finalize_loop:
    ; input stored in esi
    cmp esi, 18
    jge _is_older
    jl _is_younger

_is_older:
    mov eax, 4
    mov ebx, 1
    mov ecx, older_msg
    mov edx, older_msg_len
    int 0x80

    jmp _exit

_is_younger:
    mov eax, 4
    mov ebx, 1
    mov ecx, youger_msg
    mov edx, youger_msg_len 
    int 0x80

    jmp _exit

_exit:
    mov eax, 1
    mov ebx, 0
    int 0x80
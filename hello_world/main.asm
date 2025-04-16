section .data
    hello_msg db "My name is Nick and this is my first Assembly program!", 0xA   ; The message + newline
    hello_len equ $ - hello_msg            ; Length of the message

section .text
    global _start

_start:
    ; syscall: write(stdout=1, msg, len)
    mov eax, 4          ; syscall number for sys_write
    mov ebx, 1          ; file descriptor: 1 = stdout
    mov ecx, hello_msg  ; pointer to the message
    mov edx, hello_len  ; length of the message
    int 0x80            ; interrupt to invoke syscall

    ; syscall: exit(0)
    mov eax, 1          ; syscall number for sys_exit
    xor ebx, ebx        ; return 0
    int 0x80

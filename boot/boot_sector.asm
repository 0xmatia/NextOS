; simple boot sector to bootstrap the bootloader and kernel

[org 0x7c00] ; bootsector is loaded to 0x7c00

jmp _text
; put include here:
%include "boot/realmode_lib.asm"

; set data here
data:
    start_message: db 0x5b,"  OK  ",0x5d, " Booting in real mode...",0

_text:
    ; setup stack:
    ; there is empty space from 0x00007e00 to 0x0007ffff (around 480kb). because the stack grows downwards,
    ; we will set the stack pointer to 0x80000, this way we will have our stack ready to go! see: https://wiki.osdev.org/Memory_Map_(x86)#Real_mode_address_space_.28.3C_1_MiB.29
    mov bp, 0x8000
    mov sp, bp

    mov bx, start_message
    call print_realmode
    mov dx, 0xCAFE
    call print_hex_realmode

    jmp $ ; jmp forever here

    times 510-($-$$) db 0 ;bootsectors are 512 bytes, last two bytes are magic numbers

    dw 0xaa55

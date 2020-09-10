; simple boot sector to bootstrap the bootloader and kernel

jmp $ ; jmp forever here

times 510-($-$$) db 0 ;bootsectors are 512 bytes, last two bytes are magic numbers

dw 0xaa55
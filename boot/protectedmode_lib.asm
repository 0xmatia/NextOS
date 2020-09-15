[bits 32] ; 32 bit pm

VIDEO_MEMORY equ 0xB80000 ; VGA memory
WHITE_ON_BLACK equ 0x0F

; prints a string pointed by EDX
print_string_pm:
    mov ebx, VIDEO_MEMORY
    mov esi, edx
    pm_print_loop:
        mov ah, WHITE_ON_BLACK
        lodsb ; load the character to al, advance esi by one byte
        cmp al, 0 ; check if we reached the end
        je done
        mov [ebx], ax ; store ax (character code + color code)
        add ebx, 2 ; point to the next location
        jmp pm_print_loop
    done:
        ret
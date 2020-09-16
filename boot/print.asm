[bits 16]

print_realmode:
    mov ah, 0x0e ; bios scrolling teletype routine
    
    ; the pointer to the string is in bx
    mov si, bx
    print_loop:
        lodsb ; loads the character to al, increments si
        cmp al, 0 ;check if we reached 0
        jz end
        int 0x10
        jmp print_loop

    end:
        ret


print_hex_realmode: 
    ; input in dx
    push dx
    mov cx, 4 ; run for each nibble
    mov bx, str
    add bx, 5 ; start from the end
    start:
        dec cx
        mov ax, dx
        shr dx, 4
        and ax, 0xf ; extract right 4 bytes
        cmp ax, 0xa
        jl is_number
        add ax, 0x7
        is_number:
            add ax, 0x30
            mov byte [bx], al ; I sat for hours on a bug, we only want the lo byte, not all of ax
            dec bx
            cmp cx, 0
            jz print_hex
            jmp start
    print_hex:
    mov bx, str
    call print_realmode
    pop dx
    ret
    str: db "0x0000",0


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
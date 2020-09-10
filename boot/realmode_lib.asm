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
            mov byte [bx], al ; I sat for hours on a bug, we only want the right byte, not all of ax
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


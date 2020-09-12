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

; Load dh sectors to ES:BX from drive dl
load_disk:
    push dx

    mov ah, 0x02 ; read sectors
    mov al, dh
    ; Start from CHS(0,0,2)
    mov ch, 0x00; cylinder 0
    mov dh, 0x00 ; head 0
    mov cl, 0x02 ; read right after the boot sector, the first sector is 512 and is already loaded
    int 0x13 ; Interrupt -> disk routines

    jc disk_error ; if carry flag is on, something went wrong

    pop dx ; restore dx, dh contains how many sectors we were asked to read
    cmp dh, al ; al contain the sectors that were actually read
    jne disk_error
    ret

    disk_error:
        mov bx, DISK_ERROR_MESSAGE
        call print_realmode
        jmp $ ; hang here and do not proceed

    ; variable
    DISK_ERROR_MESSAGE: db "Error reading from disk!", 0xD, 0xA, 0

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

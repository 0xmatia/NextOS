; simple boot sector to bootstrap the bootloader and kernel

[org 0x7c00] ; bootsector is loaded to 0x7c00
KERNEL_OFFSET equ 0x1000
jmp _text


; set data here
data:
    start_message: db 0x5b,"  OK  ",0x5d, " Booting in real mode...", 0xD, 0xA, 0
    MSG_PROT_MODE: db " Successfully landed in 32 bit Protected Mode ", 0xD, 0xA, 0
    MSG_LOAD_KERNEL: db " Successfully loaded kernel", 0xD, 0xA, 0
    BOOT_DRIVE: db 0

_text:
    mov [BOOT_DRIVE], dl ; save the boot drive

    ; setup stack:
    ; there is empty space from 0x00007e00 to 0x0007ffff (around 480kb). because the stack grows downwards,
    ; we will set the stack pointer to 0x80000, this way we will have our stack ready to go! see: https://wiki.osdev.org/Memory_Map_(x86)#Real_mode_address_space_.28.3C_1_MiB.29
    mov bp, 0x8000
    mov sp, bp

    mov bx, start_message
    call print_realmode

    call load_kernel
    
    call switch_pm ; switch to pm

    jmp $ ; jmp forever here

    ; put include here:
    %include "boot/disk.asm"
    %include "boot/print.asm"
    %include "boot/gdt.asm"
    %include "boot/pm_switch.asm"
    
    [bits 16]
    ; load_kernel
    load_kernel:
        mov bx, MSG_LOAD_KERNEL ; Print a message to say we are loading the kernel
        call print_realmode
        mov bx, KERNEL_OFFSET   ; Set -up parameters for our disk_load routine , so
        mov dh, 15              ; that we load the first 15 sectors ( excluding
        mov dl, [BOOT_DRIVE]    ; the boot sector ) from the boot disk ( i.e. our
        call load_disk          ; kernel code ) to address KERNEL_OFFSET
        ret

    [bits 32]
    begin_pm:
        push ebp
        mov ebp, esp
        mov edx, MSG_PROT_MODE
        call print_string_pm
        call KERNEL_OFFSET
        jmp $
        mov esp, ebp
        pop ebp
        times 510-($-$$) db 0 ;bootsectors are 512 bytes, last two bytes are magic numbers

    dw 0xaa55
    ; The next sectors:
    ; times 256 dw 0xCAFE 
    ; times 256 dw 0xBABE

section .bss
stack_begin:
    resb 4096
stack_end:

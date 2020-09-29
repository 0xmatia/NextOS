; switch to protected mode
[bits 16]
switch_pm:
    push ebp
    mov ebp, esp
    cli ; no interrupts, they are useless
    lgdt [gdt_descriptor] ; in gdt.asm, which is included in boot_secotor.asm
    ; set LSB bit in the cr0 control register:
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    mov esp, ebp
    pop ebp
    jmp CODE_SEG:init_pm


[bits 32]
init_pm:
    push ebp
    mov ebp, esp
    ; in flat memory model, except for the data segment, every other register points to data
    mov eax, DATA_SEG
    mov ds, eax
    mov ss, eax
    mov es, eax
    mov fs, eax
    mov gs, eax

    ; setup stack for pm
    mov ebp, stack_end
    mov esp, ebp
    call begin_pm
    mov esp, ebp
    pop ebp
    ret

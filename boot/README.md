# Bootsector

I will use make in the future, but for now, use this nasm command to compile the bootsector:
`nasm boot_sector.asm -f bin -o ../build/boot_sector.bin`

Switching to 32bit protected mode will disable bios interrupts, so we would have to implement our own.

## GDT

A table of Section Descriptors (SD). Each descriptor is 8 byte containing base address, length and various flags.
The GDT is than loaded to the cpu via the `lgdt` command, so the cpu will know how to access various segments.
In assembly I will add 3 SDs: Null SD (mandatory), code SD and data SD. Once I am using an higher level language, 
it will be much easier adding more segments to the GDT.
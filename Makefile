# $@ = target file
# $< = first dependency
# $^ = all dependencies

BUILD = build
BOOT = boot

INCLUDE = include

ASM_SOURCES := $(BOOT)/kernel_entry.asm cpu/stubs.asm
HEADERS = $(shell find $(INCLUDE) -type f -name '*.h')
C_SOURCES_DOT = $(shell find . -type f -name '*.c' -not -path "./kernel/*")
KERNEL_SRC = $(wildcard kernel/*.c)
C_SOURCES = $(KERNEL_SRC) $(C_SOURCES_DOT:./%=%)

MKDIR   = mkdir -p
RMDIR   = rm -rf
EXE     = $(BUILD)/NextOs.bin

OBJDIR = obj
C_OBJ = ${C_SOURCES:.c=.o}
ASM_OBJ = ${ASM_SOURCES:.asm=.o}
OBJECTS := ${addprefix ${OBJDIR}/, ${C_OBJ}} ${addprefix ${OBJDIR}/, ${ASM_OBJ}}

CFLAGS = -g -ffreestanding -masm=intel -I$(INCLUDE) -Wextra -Wall \
-Wshadow -Wcast-align -Wstrict-prototypes -Wswitch-default -Wswitch-enum
CC = i686-elf-gcc
GDB = gdb
QEMU = qemu-system-i386
LD = i686-elf-ld
ASM = nasm
DISASM = ndisasm

all: dirs run

dirs:
	echo $(C_SOURCES)
	@$(MKDIR) $(BUILD) $(OBJ)

run: $(EXE)
	${QEMU} -drive file=$<,format=raw,if=floppy

$(EXE): $(BUILD)/boot_sector.bin $(BUILD)/kernel.bin
	cat $^ > $@

###############BOOT SECTOR#################
$(BUILD)/boot_sector.bin: $(BOOT)/boot_sector.asm
	${ASM} $< -f bin -o $@

############################KERNEL#################
# Build the kernel.bin file - made from source files and kernel_entry.o assembly file
$(BUILD)/kernel.bin: ${OBJECTS}
	${LD} -o $@ -T setup.ld $^ --oformat binary

# debug
debug: $(EXE) $(BUILD)/kernel.elf
	${QEMU} -s -S -drive file=$(EXE),format=raw,if=floppy

# build the kernel image with symbols for debugging
$(BUILD)/kernel.elf: ${OBJECTS}
	${LD} -o $@ -T setup.ld $^

# Generic rules for wildcards
# To make an object, always compile from its .c
${OBJDIR}/%.o: %.c ${HEADERS}
	@$(MKDIR) $(dir $@)
	${CC} ${CFLAGS} -c $< -o $@

# Generic rule for assembling .asm files, except
# for boot_sector.asm
${OBJDIR}/%.o: %.asm
	@$(MKDIR) $(dir $@)
	${ASM} $< -f elf -o $@

clean:
	$(RMDIR) $(BUILD) $(OBJDIR)

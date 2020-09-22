OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)
 
SECTIONS
{
	. = 1K;
    
	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.text)
	}
}
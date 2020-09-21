OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)
 
/* Tell where the various sections of the object files will be put in the final
   kernel image. */
SECTIONS
{
	. = 0;
    
	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.text)
	}
}
#include "../cpu/isr.h"

void main()
{
    // Create a pointer to a char , and point it to the first text cell of
    // video memory (i.e. the top - left of the screen )
    char *video_memory = (char *)0xb8000;
    // At the address pointed to by video_memory , store the character ’X’
    // (i.e. display ’X’ in the top - left of the screen ).
    *video_memory = 'X';
    isr_install();
    __asm__ __volatile__("int $2");
    __asm__ __volatile__("int $3");
    __asm__ __volatile__("int $4");
}

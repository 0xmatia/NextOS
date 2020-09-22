#include "../cpu/isr.h"
#include "../drivers/screen.h"

void main()
{
    isr_install();

    clear_screen();
    kprint("Botzer Matia\n");
    __asm__("int 13");
}

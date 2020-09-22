#include "../cpu/isr.h"
#include "../drivers/screen.h"

void main()
{
    isr_install();

    clear_screen();
    kprint("AAAA\nBBSBB\nCCCASCC\n");
}

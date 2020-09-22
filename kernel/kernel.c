#include "../cpu/isr.h"
#include "../drivers/screen.h"

void main()
{
    isr_install();

    clear_screen();
    for (uint8_t i = 0; i<200; i++) {
        kprint("Botzer Matia");
    }
}

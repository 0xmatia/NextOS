#include "../cpu/isr.h"
#include "../drivers/screen/screen.h"
#include "../libc/colors.h"

void kmain()
{
    isr_install();

    clear_screen();
    kprint("Botzer Matia\n");
    uint8_t green_on_black = generate_colorcode(GREEN, BLACK);
    for (uint32_t i = 0; i<1000000; i++) {
        kprint("Mivtzar is better than Apollo\n");
        kprint_color("====================================\n", green_on_black);
    }
    __asm__("int 13");
}

#include "../cpu/isr.h"
#include "../drivers/screen/screen.h"
#include "../libc/colors.h"


/**
 * @brief kmain - Entry point of kernel
 *
 **/
void kmain(void)
{
    isr_install();

    clear_screen();
    kprint((uint8_t*)"Botzer Matia\n");
    uint8_t green_on_black = generate_colorcode(GREEN, BLACK);
    for (uint32_t i = 0; i<1000000; i++) {
        kprint((uint8_t*)"Mivtzar is better than Apollo\n");
        kprint_color((uint8_t*)"====================================\n", green_on_black);
    }
   // __asm__("int 13");
}

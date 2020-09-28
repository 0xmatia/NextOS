#include <cpu/isr.h>
#include <drivers/screen/screen.h>
#include <libc/colors.h>
#include <libc/string.h>

/**
 * @brief kmain - Entry point of kernel
 *
 **/
void kmain(void)
{
    isr_install();
    uint8_t banner[312 + 35 + 35] = "\
          #     #                     #######  #####\n\
          ##    # ###### #    # ##### #     # #     #\n\
          # #   # #       #  #    #   #     # #\n\
          #  #  # #####    ##     #   #     #  #####\n\
          #   # # #        ##     #   #     #       #\n\
          #    ## #       #  #    #   #     # #     #\n\
          #     # ###### #    #   #   #######  #####\n";

    clear_screen();
    kprint(banner);
}

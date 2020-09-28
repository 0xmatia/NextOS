#include <libc/colors.h>

uint8_t generate_colorcode(Color foreground, Color background)
{
    // TODO: check if blinking mode is set in vga controller
    return (background << 4) + foreground;
}

#ifndef COLORS_H
#define COLORS_H

#include <stdint.h>

typedef enum
{
    BLACK = 0x0,
    BLUE = 0x1,
    GREEN = 0x2,
    CYAN = 0x3,
    RED = 0x4,
    MAGENTA = 0x5,
    BROWN = 0x6,
    LIGHT_GRAY = 0x7,
    DARK_GRAY = 0x8,
    LIGHT_BLUE = 0x9,
    LIGHT_GREEN = 0xa,
    LIGHT_CYAN = 0xb,
    LIGHT_RED = 0xc,
    PINK = 0xd,
    YELLOW = 0xe,
    WHITE = 0xf,
} Color;

/**
 * @brief Generate a color code from foreground and background color.
 * right now the assamption is that the 7th bit is NOT a blinking indicator
 * 
 * @param foreground 
 * @param background 
 * @return uint8_t 
 */
uint8_t generate_colorcode(Color foreground, Color background);

#endif
#include <libc/string.h>

uint32_t strlen(uint8_t *str)
{
    uint32_t index = 0;
    // handle nulls
    if (!str)
        return 0;

    while (!str[index])
    {
        index++;
    }

    return index;
}

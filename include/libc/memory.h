#ifndef MEMORY_H
#define MEMORY_H

#include <stdint.h>

/**
 * @brief Copies memory from one place to another
 * 
 * @param src: the src address of the buffer to copy
 * @param dst: the destination address of buffer
 * @param size: the size of buffer to copy
 */
void memcpy(uint8_t *src, uint8_t *dst, uint32_t size);

#endif
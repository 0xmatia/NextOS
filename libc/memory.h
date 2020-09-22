#ifndef MEMORY_H
#define MEMORY_H
/*
 * @Author: Elad Matia 
 * @Date: 2020-09-22 23:15:52 
 * @Last Modified by: Elad Matia
 * @Last Modified time: 2020-09-22 23:22:46
 * 
 *  Header for memory related functions to be used throughout the os
 */
#include <stdint.h>

/**
 * @brief Copies memory from one place to another
 * 
 * @param src: the src address of the buffer to copy
 * @param dst: the destination address of buffer
 * @param size: the size of buffer to copy
 */
void memcpy(uint8_t* src, uint8_t* dst, uint32_t size);



#endif
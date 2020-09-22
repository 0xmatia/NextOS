/*
 * @Author: Elad Matia 
 * @Date: 2020-09-22 23:20:31 
 * @Last Modified by: Elad Matia
 * @Last Modified time: 2020-09-22 23:21:36
 * 
 *  Definitions for memory related functions
 */
#include "memory.h"

void memcpy(uint8_t* src, uint8_t* dst, uint32_t size){
    for (uint32_t i = 0; i<size; i++) {
        dst[i] = src[i];
    }
}
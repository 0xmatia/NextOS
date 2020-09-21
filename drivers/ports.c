/*
 * @Author: Elad Matia
 * @Date: 2020-09-21 14:34:54 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2020-09-21 15:32:31
 * 
 * Implementation for ports read and write (taken from: https://github.com/cfenollosa/os-tutorial/blob/master/16-video-driver/drivers/ports.c)
 */

#include "ports.h"

uint8_t port_byte_in(uint16_t port) {
    uint8_t result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

void port_byte_out(uint16_t port, uint8_t data){
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

uint16_t port_word_in(uint16_t port) {
    uint16_t result;
    __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
    return result;
}

void port_word_out (uint16_t port, uint16_t data) {
    __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
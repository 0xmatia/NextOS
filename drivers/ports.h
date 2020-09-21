/*
 * @Author: Elad Matia
 * @Date: 2020-09-21 14:17:43 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2020-09-21 14:55:46
 * 
 * Defines the interface for communicating with device i/o
 */

#include <stdint.h>

/**
 * @brief Read one byte from specified port
 * @param port: the port to read from
 * @return: the byte that was read from the port
 */
uint8_t port_byte_in(uint16_t port);

/**
 * @brief Writes one byte to port
 * 
 * @param port: the port to write to
 * @param data: the byte to write
 * @return ** void 
 */
void port_byte_out(uint16_t port, uint8_t data);

/**
 * @brief Reads one word from specified port
 * 
 * @param port: the port to read from
 * @return ** uint16_t: the word read from the port 
 */
uint16_t port_word_in(uint16_t port);

/**
 * @brief Write one word to specified port
 * 
 * @param port: the port to write to
 * @param data: the data to write
 * @return ** void 
 */
void port_word_out(uint16_t port, uint16_t data);
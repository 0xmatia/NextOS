/*
 * @Author: Elad Matia 
 * @Date: 2020-09-22 14:25:55 
 * @Last Modified by: Elad Matia
 * @Last Modified time: 2020-09-24 01:22:08
 * 
 * Header file for the screen driver
 */
#include <stdint.h>
#include "../ports.h"
#include "../../libc/memory.h"

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
// Black on white. TODO: color enum
#define WHITE_ON_BLACK 0x0f

// vga ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

// Public functions

/**
 * @brief Clears the entire screen
 * 
 */
void clear_screen(void);

/**
 * @brief prints a message at specified location. if row or col are negative, prints at cursor's location
 * 
 * @param message: message to print
 * @param row: row on screen
 * @param col: col on screen
 * @param color_code: the color of the message
 */
void kprint_at(uint8_t* message, int8_t row, int8_t col, uint8_t color_code);

/**
 * @brief Prints a message the coursor location
 * 
 * @param message: the message to print
 */
void kprint(uint8_t* message);

/**
 * @brief Prints with specified color
 * 
 * @param message the message to print
 * @param color_code: the color code, generated from generate_colorcode function
 */
void kprint_color(uint8_t* message, uint8_t color_code);

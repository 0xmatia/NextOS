/*
 * @Author: Elad Matia 
 * @Date: 2020-09-22 14:25:55 
 * @Last Modified by: Elad Matia
 * @Last Modified time: 2020-09-22 23:34:09
 * 
 * Header file for the screen driver
 */
#include <stdint.h>
#include "ports.h"
#include "../libc/memory.h"

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80
// Black on white. TODO: color enum
#define BLACK_ON_WHITE 0x0F

// vga ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

// Public functions

/**
 * @brief Clears the entire screen
 * 
 */
void clear_screen();

/**
 * @brief prints a message at specified location. if row or col are negative, prints at cursor's location
 * 
 * @param message: message to print
 * @param row: row on screen
 * @param col: col on screen
 */
void kprint_at(uint8_t* message, int8_t row, int8_t col);

/**
 * @brief Prints a message the coursor location
 * 
 * @param message: the message to print
 */
void kprint(uint8_t* message);
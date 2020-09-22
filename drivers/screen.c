/*
 * @Author: Elad Matia 
 * @Date: 2020-09-22 15:11:43 
 * @Last Modified by: Elad Matia
 * @Last Modified time: 2020-09-22 17:09:10
 * 
 *  Implementation of screen methods
 */

#include "screen.h"

uint16_t print_char(uint8_t character, int8_t row, int8_t col);
void update_cursor(uint16_t offset);
uint16_t get_cursor_position(void);
uint8_t get_offset_col(int8_t offset);
uint8_t get_offset_row(int8_t offset);

//////////////////////////////////////////////////
//              Public Functions                //
//////////////////////////////////////////////////

void clear_screen()
{
    uint8_t *video_buffer = (uint8_t *)VIDEO_ADDRESS;
    uint16_t size = MAX_ROWS * MAX_COLS;
    for (uint8_t i = 0; i < MAX_COLS; i++)
    {
        for (uint8_t j = 0; j < MAX_ROWS; j++)
        {
            print_char(' ', j, i);
        }
    }
    update_cursor(0);
}

void kprint_at(uint8_t *message, int8_t row, int8_t col)
{
    uint32_t index = 0;
    uint16_t offset = 0;
    if (row >= 0 && col >= 0)
    {
        update_cursor(2 * (row * MAX_COLS + col));
    }
    else {
        offset = get_cursor_position();
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }
    
    while (message[index] != 0)
    {
        offset = print_char(message[index++], row, col);
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }
}

void kprint(uint8_t *message)
{
    // its means the message will be printed at cursor's location
    kprint_at(message, -1, -1);
}

//////////////////////////////////////////////////
//              Private Functions               //
//////////////////////////////////////////////////

/**
 * @brief prints the given character at a given offset
 * 
 * @param character: character to print
 * @param offset: the offset from the beginning of the video buffer
 */
uint16_t print_char(uint8_t character, int8_t row, int8_t col)
{
    uint8_t *video_buffer = (uint8_t *)VIDEO_ADDRESS;
    uint16_t offset = 0;
    if (row < 0 || col < 0)
    {
        offset = get_cursor_position();
    }
    else
    {
        offset = 2 * (row * MAX_COLS + col);
    }

    if (character == '\n')
    {
        row = get_offset_row(offset); // get updated row, col is 0 anyway
        offset = 2 * ((row + 1) * MAX_COLS);
    }
    else
    {
        video_buffer[offset] = character;
        video_buffer[offset + 1] = BLACK_ON_WHITE;
        offset += 2;
    }

    update_cursor(offset);
    return offset;
}

/**
 * @brief Sets the cursor location
 * 
 * @param offset: the new offset
 */
void update_cursor(uint16_t offset)
{
    offset /= 2;

    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (uint8_t)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (uint8_t)(offset & 0xff));
}

/**
 * @brief Get the cursor position
 * 
 * @return uint16_t: returns the cursor position
 */
uint16_t get_cursor_position(void)
{
    port_byte_out(REG_SCREEN_CTRL, 14);
    uint16_t offset = port_byte_in(REG_SCREEN_DATA) << 8; /* High byte: << 8 */
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA);
    return offset * 2; /* Position * size of character cell */
}

/**
 * @brief Get the row out of the offset
 * 
 * @param offset: the new offset calculated in print_char
 * @return uint8_t: the new row extracted from the offset
 */
uint8_t get_offset_row(int8_t offset) { return offset / (2 * MAX_COLS); }

/**
 * @brief Get the new column out of the offset
 * 
 * @param offset: the new offset calculated in print_char
 * @return uint8_t: the new column extracted from the offset
 */
uint8_t get_offset_col(int8_t offset) { return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2; }
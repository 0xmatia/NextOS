/*
 * @Author: Elad Matia 
 * @Date: 2020-09-22 15:11:43 
 * @Last Modified by: Elad Matia
 * @Last Modified time: 2020-09-24 01:22:47
 * 
 *  Implementation of screen methods
 */

#include "screen.h"

uint16_t print_char(uint8_t character, int8_t row, int8_t col, uint8_t color_code);
void update_cursor(uint16_t offset);
uint16_t get_cursor_position(void);
uint8_t get_offset_col(uint16_t offset);
uint8_t get_offset_row(uint16_t offset);
uint16_t handle_scrolling(uint16_t offset);

//////////////////////////////////////////////////
//              Public Functions                //
//////////////////////////////////////////////////

void clear_screen(void)
{
    for (uint8_t i = 0; i < MAX_COLS; i++)
    {
        for (uint8_t j = 0; j < MAX_ROWS; j++)
        {
            print_char(' ', j, i, WHITE_ON_BLACK);
        }
    }
    update_cursor(0);
}

void kprint_at(uint8_t *message, int8_t row, int8_t col, uint8_t color_code)
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
        offset = print_char(message[index++], row, col, color_code);
        row = get_offset_row(offset);
        col = get_offset_col(offset);
    }
}

void kprint(uint8_t *message)
{
    // its means the message will be printed at cursor's location
    // default color: white on black
    kprint_at(message, -1, -1, WHITE_ON_BLACK);
}

void kprint_color(uint8_t *message, uint8_t color_code)
{
    // its means the message will be printed at cursor's location
    kprint_at(message, -1, -1, color_code);
}


//////////////////////////////////////////////////
//              Private Functions               //
//////////////////////////////////////////////////

/**
 * @brief prints the given character at a given offset
 * 
 * @param character: character to print
 * @param offset: the offset from the beginning of the video buffer
 * @param color_code: the color of the character
 */
uint16_t print_char(uint8_t character, int8_t row, int8_t col, uint8_t color_code)
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
        video_buffer[offset + 1] = color_code;
        offset += 2;
    }

    offset = handle_scrolling(offset);
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
 * @brief The function handles screen scolling. if the text 
 * reached the bottom of the screen, remove top line and scroll up one line
 * 
 * @param offset: the offset of the text
 * @return uint16_t: the new offset
 */
uint16_t handle_scrolling(uint16_t offset) {

    uint8_t* video_buffer = (uint8_t*)VIDEO_ADDRESS;
    if (offset < MAX_COLS*MAX_ROWS*2) {
        return offset;
    }
    // copy video buffer on line up
    uint8_t* src = (uint8_t*)VIDEO_ADDRESS + MAX_COLS * 2;
    uint8_t* dst =  (uint8_t*)VIDEO_ADDRESS;
    uint32_t size = MAX_COLS * MAX_ROWS * 2 - 2*MAX_COLS;
    memcpy(src, dst, size);

    // clean last line
    for (uint8_t i = 0; i<MAX_COLS; i++) {
        uint16_t pos = 2*((MAX_ROWS-1) * MAX_COLS + i);
        video_buffer[pos] = 0;
        video_buffer[pos+1] = 0;
    }
    offset -= 2*MAX_COLS;
    return offset;
}

/**
 * @brief Get the row out of the offset
 * 
 * @param offset: the new offset calculated in print_char
 * @return uint16_t: the new row extracted from the offset
 */
uint8_t get_offset_row(uint16_t offset) { return offset / (2 * MAX_COLS); }

/**
 * @brief Get the new column out of the offset
 * 
 * @param offset: the new offset calculated in print_char
 * @return uint16_t: the new column extracted from the offset
 */
uint8_t get_offset_col(uint16_t offset) { return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2; }

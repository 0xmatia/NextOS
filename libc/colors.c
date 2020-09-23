/*
 * @Author: Elad Matia 
 * @Date: 2020-09-24 01:08:18 
 * @Last Modified by: Elad Matia
 * @Last Modified time: 2020-09-24 01:16:08
 *  
 * Implementation for color code generation
 */

#include "colors.h"


uint8_t generate_colorcode(Color foreground, Color background){
    // TODO: check if blinking mode is set in vga controller
    return (background << 4) + foreground;
}



#ifndef STRING_H_
#define STRING_H_
#include <stdint.h>
/*
** This file contains usefull functions for string manipulation
**
*/


/*
** @brief: Returns the length of a null terminated string,
** max length: 2^32 chars
** @param str: the null terminated string
** @return string length
*/
uint32_t strlen(uint8_t* str);

#endif // STRING_H_

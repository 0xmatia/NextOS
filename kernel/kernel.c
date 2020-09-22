#include "../drivers/screen.h"

void main()
{
    clear_screen();
    uint8_t* botzer = "botzer\n";
    kprint(botzer);
    kprint("Matia");
}

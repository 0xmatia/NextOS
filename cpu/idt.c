#include "idt.h"

idt_gate_t idt[IDT_ENTRIES];
idt_register_t idt_reg;

/**
 * @brief Set idt gate entry n
 * 
 * @param n number of gate entry
 * @param handler address for the handler function
 */
void set_idt_gate(int n, uint32_t handler)
{
    idt[n].base_low = handler & 0xFFFF;
    idt[n].sel = KERNEL_CS;
    idt[n].zero = 0;
    idt[n].flags = 0x8E; // ( P=1, DPL=00b, S=0, type=1110b => type_attr=1000_1110b=0x8E)
    idt[n].base_high = (handler >> 16) & 0xFFFF;
}

/**
 * @brief loads the IDT
 */
void load_idt()
{
    idt_reg.base = (uint32_t)&idt;
    idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;

    __asm__ __volatile__("lidt (%0)"
                         :
                         : "r"(&idt_reg));
}
#ifndef IDT_H
#define IDT_H

#include <stdint.h>

/* Segment selectors */
#define KERNEL_CS 0x08

#define IDT_ENTRIES 256

// IDT gate entry
typedef struct
{
    uint16_t base_low;  // Lower 16 bits of handler function address
    uint16_t sel;       // Kernel segment selector
    uint8_t zero;       // always zero
    uint8_t flags;      // type and attr
    uint16_t base_high; // Higher 16 bits of handler function address */
} __attribute__((packed)) idt_gate_t;

/* A pointer to the array of interrupt handlers.
 * Assembly instruction 'lidt' will read it */
typedef struct
{
    uint16_t limit; // size of the IDT in bytes - 1
    uint32_t base;  // linear address of the IDT
} __attribute__((packed)) idt_register_t;

idt_gate_t idt[IDT_ENTRIES];
idt_register_t idt_reg;

void set_idt_gate(int n, uint32_t handler);
void load_idt();

#endif
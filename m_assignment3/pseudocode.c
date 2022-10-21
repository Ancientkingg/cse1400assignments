#include <iostream>
#include <stdint.h>

void decode(uint64_t* address) {
    uint64_t value = *address;
    char ascii = value;
    uint8_t times = value >> 8;
    uint32_t nextAddress = value >> 16;

    for (uint8_t i = 0; i < times; i++) {
        putchar(ascii);
    }

    while (nextAddress != 0) {
        value = *(address + nextAddress);
        ascii = value;
        times = value >> 8;
        nextAddress = value >> 16;

        for (uint8_t i = 0; i < times; i++) {
            putchar(ascii);
        }
    }
}


int main()
{
    uint64_t message[] = { 0x00020000000A0148,0x0200000000070157,0x000200000004016F,0x00020000000C010A,0x0002000000010120,0x000200000002026C,0x0002000000030121,0x020000000009016F,0x02000000000B016C,0x0200000000080172,0x0002000000050165,0x0200000000060164,0x000200000000010A, };

    decode(message);
}
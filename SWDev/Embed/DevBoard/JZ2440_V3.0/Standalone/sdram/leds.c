#define GPFCON  (*((volatile unsigned long *)0x56000050))
#define GPFDAT  (*((volatile unsigned long *)0x56000054))

#define GPF4_out    (1<<8)
#define GPF5_out    (1<<10)
#define GPF6_out    (1<<12)

void delay (volatile long i)
{
    while (i-- > 0);
}

int main (void)
{
    unsigned long i = 1;
    GPFCON = GPF4_out | GPF5_out | GPF6_out;    
    
    while (1)
    {
        delay (30000);
        GPFDAT = ~(i<<4);
        i*=2;

        if (8 == i)
            i = 1;
    }

    return 0;
}


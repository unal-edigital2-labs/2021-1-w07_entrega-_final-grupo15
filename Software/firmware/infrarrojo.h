#ifndef _INFRARROJO
#define _INFRARROJO

#define INF_EV_REFLECT        0x1

void infrarrojo_init(void);

void infrarrojo_disable(int disable);

int infrarrojo_read(void);

void infrarrojo_isr(void);

#endif
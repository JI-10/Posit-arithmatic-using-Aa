#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <pthreadUtils.h>
#include <Pipes.h>
#include <pipeHandler.h>
#ifndef SW
#include "vhdlCStubs.h"
#endif

int main(int argc, char* argv[])
{	
	// uint16_t i;
	// for(i=0;i<100;i++){
        uint32_t a,b;

        uint16_t res;
        // 0 8 0101
        a=1135083520; b=40;
        res=FP32_to_posit16(a);
        fprintf(stdout," result=%d ",res);
	// }
	
	return(0);
}

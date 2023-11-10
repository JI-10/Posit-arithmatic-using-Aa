
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
        uint16_t a,b;

        uint32_t res;
        // 0 8 0101
        a=1753; b=40;
        res=Posit16_to_FP32(a);
        fprintf(stdout," result=%d ",res);
	// }
	
	return(0);
}

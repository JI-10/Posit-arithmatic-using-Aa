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
        uint8_t i;
        uint32_t a,frac;
        uint16_t res;

        int8_t exp,sign;
        a=968577024;
        res=FP32_to_posit16(a);
        fprintf(stdout," result=%d ",res);
	// }
	
	return(0);
}

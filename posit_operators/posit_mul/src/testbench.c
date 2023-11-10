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

        uint16_t res;
        // 3 * 3
        a=22528; b=22528;
        res=pmul19(a,b);
        fprintf(stdout," result=%d ",res);
	// }
	
	return(0);
}

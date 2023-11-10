#include <vhdlCStubs.h>
uint32_t Posit16_to_FP32(uint16_t P)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call Posit16_to_FP32 ");
append_int(buffer,1); ADD_SPACE__(buffer);
append_uint16_t(buffer,P); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,32); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint32_t F = get_uint32_t(buffer,&ss);
return(F);
}
uint16_t complement(uint16_t num)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call complement ");
append_int(buffer,1); ADD_SPACE__(buffer);
append_uint16_t(buffer,num); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,16); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint16_t result = get_uint16_t(buffer,&ss);
return(result);
}
void global_storage_initializer_()
{
char buffer[4096];  char* ss;  sprintf(buffer, "call global_storage_initializer_ ");
append_int(buffer,0); ADD_SPACE__(buffer);
append_int(buffer,0); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
return;
}

#include <vhdlCStubs.h>
uint16_t FP32_to_posit16(uint32_t F)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call FP32_to_posit16 ");
append_int(buffer,1); ADD_SPACE__(buffer);
append_uint32_t(buffer,F); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,16); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint16_t P = get_uint16_t(buffer,&ss);
return(P);
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

#include <vhdlCStubs.h>
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
uint16_t pmul19(uint16_t P1,uint16_t P2)
{
char buffer[4096];  char* ss;  sprintf(buffer, "call pmul19 ");
append_int(buffer,2); ADD_SPACE__(buffer);
append_uint16_t(buffer,P1); ADD_SPACE__(buffer);
append_uint16_t(buffer,P2); ADD_SPACE__(buffer);
append_int(buffer,1); ADD_SPACE__(buffer);
append_int(buffer,16); ADD_SPACE__(buffer);
send_packet_and_wait_for_response(buffer,strlen(buffer)+1,"localhost",9999);
uint16_t result = get_uint16_t(buffer,&ss);
return(result);
}

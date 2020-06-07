import { Injectable, Inject, UseFilters, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Observable } from 'rxjs';
import { UserDto, AppointmentDto } from 'common-dto';

@Injectable()
export class CalendarService implements OnModuleInit, OnModuleDestroy{

    
    constructor(@Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy) {

    }

    onModuleInit() {
        this.redisClient.connect();
     }
 
     onModuleDestroy() {
         this.redisClient.close();
     }

    
    public appointmentList(userDto : UserDto): Observable<any> {
        return this.redisClient.send({ cmd: 'calendar_appointment_get_list' }, userDto);
    }

    public createAppointment(userDto : UserDto, appointmentList : AppointmentDto): Observable<any> {
        return this.redisClient.send({ cmd: 'calendar_appointment_create' }, {appointmentList, userDto});
    }

}

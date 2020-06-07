import { Injectable, Inject, UseFilters } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { AllClientServiceException } from 'src/common/filter/all-clientservice-exceptions.filter';
import { Observable } from 'rxjs';
import { UserDto, AppointmentDto } from 'common-dto';

@Injectable()
export class CalendarService {

    
    constructor(@Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy) {

    }

    
    // @UseFilters(AllClientServiceException)
    // public appointmentList(userDto : UserDto): Observable<any> {
    //     return this.redisClient.send({ cmd: 'calendar_appointment_get_list' }, userDto);
    // }

    @UseFilters(AllClientServiceException)
    public createAppointment(userDto : UserDto, appointmentList : AppointmentDto): Observable<any> {
        return this.redisClient.send({ cmd: 'calendar_appointment_create' }, appointmentList);
    }

    @UseFilters(AllClientServiceException)
    public doctorList(role,key): Observable<any> {
        var arr=[];
         arr[0]=role;
         arr[1]=key;
        return this.redisClient.send( { cmd: 'app_doctor_list' }, arr);
    }

    @UseFilters(AllClientServiceException)
    public doctorView(key): Observable<any> {
        return this.redisClient.send( { cmd: 'app_doctor_view' }, key);
    }

    @UseFilters(AllClientServiceException)
    public doctorPreconsultation(doctorConfigPreConsultationDto): Observable<any> {
        return this.redisClient.send( { cmd: 'app_doctor_preconsultation' }, doctorConfigPreConsultationDto);
    }



}

import { Injectable, Inject, UseFilters, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { Observable } from 'rxjs';
import { UserDto, AppointmentDto,DoctorConfigCanReschDto } from 'common-dto';
import { AllClientServiceException } from 'src/common/filter/all-clientservice-exceptions.filter';


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


    // public appointmentList(userDto : UserDto): Observable<any> {
    //     return this.redisClient.send({ cmd: 'calendar_appointment_get_list' }, userDto);
    // }
    @UseFilters(AllClientServiceException)
    //public appointmentList(appointmentDto : AppointmentDto): Observable<any> {
        public appointmentList(): Observable<any> {
        return this.redisClient.send({ cmd: 'calendar_appointment_get_list' }, '');
       // return this.redisClient.send({ cmd: 'calendar_appointment_get_list' }, appointmentDto);
    }

    @UseFilters(AllClientServiceException)
    public createAppointment(appointmentDto : AppointmentDto): Observable<any> {
        return this.redisClient.send({ cmd: 'calendar_appointment_create' },appointmentDto);
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

    @UseFilters(AllClientServiceException)
    public hospitalDetails(accountKey): Observable<any> {
        return this.redisClient.send( { cmd: 'app_hospital_details' }, accountKey);
    }

    @UseFilters(AllClientServiceException)
    public doctorCanReschEdit(doctorConfigCanReschDto : DoctorConfigCanReschDto): Observable<any> {
        return this.redisClient.send( { cmd: 'app_canresch_edit' }, doctorConfigCanReschDto);
    }

    
    @UseFilters(AllClientServiceException)
    public doctorCanReschView(doctorKey): Observable<any> {
        return this.redisClient.send( { cmd: 'app_canresch_view' }, doctorKey);
    }





}

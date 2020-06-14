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

    
    @UseFilters(AllClientServiceException)
    public createAppointment(appointmentDto : any,user : any): Observable<any> {
        appointmentDto.user = user;
        return this.redisClient.send({ cmd: 'calendar_appointment_create' },appointmentDto);
    }

    @UseFilters(AllClientServiceException)
    public doctorList(role,key): Observable<any> {
        var roleKey = {
            role: role,
            key: key
        }
        return this.redisClient.send( { cmd: 'app_doctor_list' }, roleKey);
    }

    @UseFilters(AllClientServiceException)
    public doctorView(doctorKey): Observable<any> {
        return this.redisClient.send( { cmd: 'app_doctor_view' }, doctorKey);
    }

    @UseFilters(AllClientServiceException)
    public doctorPreconsultation(doctorConfigPreConsultationDto : any,user : any): Observable<any> {
        doctorConfigPreConsultationDto.user = user;
        return this.redisClient.send( { cmd: 'app_doctor_preconsultation' }, doctorConfigPreConsultationDto);
    }

    @UseFilters(AllClientServiceException)
    public hospitalDetails(accountKey): Observable<any> {
        return this.redisClient.send( { cmd: 'app_hospital_details' }, accountKey);
    }

    @UseFilters(AllClientServiceException)
    public doctorCanReschEdit(doctorConfigCanReschDto : any,user : any): Observable<any> {
        doctorConfigCanReschDto.user = user;
        return this.redisClient.send( { cmd: 'app_canresch_edit' }, doctorConfigCanReschDto);
    }

    
    @UseFilters(AllClientServiceException)
    public doctorCanReschView(doctorKey): Observable<any> {
        return this.redisClient.send( { cmd: 'app_canresch_view' }, doctorKey);
    }

    @UseFilters(AllClientServiceException)
    public appointmentList(doctorKey): Observable<any> {
        return this.redisClient.send({ cmd: 'calendar_appointment_get_list' }, doctorKey);
    }





}

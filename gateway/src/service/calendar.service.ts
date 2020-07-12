import {Injectable, Inject, UseFilters, OnModuleDestroy, OnModuleInit, HttpStatus} from '@nestjs/common';
import {ClientProxy} from '@nestjs/microservices';
import {Observable} from 'rxjs';
import {UserDto, AppointmentDto, DoctorConfigCanReschDto, DocConfigDto,WorkScheduleDto,PatientDto} from 'common-dto';
import {AllClientServiceException} from 'src/common/filter/all-clientservice-exceptions.filter';


@Injectable()
export class CalendarService implements OnModuleInit, OnModuleDestroy {


    constructor(@Inject('REDIS_SERVICE') private readonly redisClient: ClientProxy) {

    }

    onModuleInit() {
        this.redisClient.connect();
    }

    onModuleDestroy() {
        this.redisClient.close();
    }


    @UseFilters(AllClientServiceException)
    public createAppointment(appointmentDto: any, user: any): Observable<any> {
        appointmentDto.user = user;
        return this.redisClient.send({cmd: 'calendar_appointment_create'}, appointmentDto);
    }

    @UseFilters(AllClientServiceException)
    public doctorList(user): Observable<any> {
        return this.redisClient.send({cmd: 'app_doctor_list'}, user);
    }

    @UseFilters(AllClientServiceException)
    public doctorView(user:any,doctorKey:any): Observable<any> {
        user.doctorKey = doctorKey;
        return this.redisClient.send({cmd: 'app_doctor_view'}, user);
    }

    @UseFilters(AllClientServiceException)
    public hospitalDetails(accountKey): Observable<any> {
        return this.redisClient.send({cmd: 'app_hospital_details'}, accountKey);
    }


    @UseFilters(AllClientServiceException)
    public doctorCanReschView(user,key): Observable<any> {
        user.doctorKey = key;
        return this.redisClient.send({cmd: 'app_canresch_view'}, user);
    }

    @UseFilters(AllClientServiceException)
    public doctorConfigUpdate(user: any, docConfigDto: any): Observable<any> {
        user.docConfigDto = docConfigDto;
        return this.redisClient.send({cmd: 'app_doc_config_update'}, user);
    }

    @UseFilters(AllClientServiceException)
    public workScheduleEdit(workScheduleDto: any,user:any): Observable<any> {
        workScheduleDto.user = user;
        return this.redisClient.send({cmd: 'app_work_schedule_edit'}, workScheduleDto);
    }

    @UseFilters(AllClientServiceException)
    public workScheduleView(user: any,key:any): Observable<any> {
        user.doctorKey = key;
        return this.redisClient.send({cmd: 'app_work_schedule_view'},user);
    }

    @UseFilters(AllClientServiceException)
    public appointmentSlotsView(user: any,doctorKey:any,startDate:any,endDate:any): Observable<any> {
        user.doctorKey = doctorKey;
        user.startDate = startDate;
        user.endDate = endDate;
        return this.redisClient.send({cmd: 'appointment_slots_view'},user);
    }

    @UseFilters(AllClientServiceException)
    public appointmentReschedule(appointmentDto: any,user:any): Observable<any> {
        appointmentDto.user = user;
        return this.redisClient.send({cmd: 'appointment_reschedule'},appointmentDto);
    }

    
    @UseFilters(AllClientServiceException)
    public appointmentCancel(appointmentDto: any,user:any): Observable<any> {
        appointmentDto.user = user;
        return this.redisClient.send({cmd: 'appointment_cancel'},appointmentDto);
    }

    @UseFilters(AllClientServiceException)
    public patientSearch(patientDto: any,user:any): Observable<any> {
        patientDto.user = user;
        return this.redisClient.send({cmd: 'app_patient_search'},patientDto);
    }

    @UseFilters(AllClientServiceException)
    public AppointmentView(user: any,appointmentId: any): Observable<any> {
        user.appointmentId=appointmentId.appointmentId;
        return this.redisClient.send({cmd: 'appointment_view'},user);
    }

    @UseFilters(AllClientServiceException)
    public doctorListForPatients(user: any,accountKey:any): Observable<any> {
        user.accountKey = accountKey;
        return this.redisClient.send({cmd: 'doctor_list_patients'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientInsertion(patientDto: any,patientId:any): Promise<any> {
        patientDto.patientId=patientId;
        return this.redisClient.send({cmd: 'patient_details_insertion'},patientDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public findDoctorByCodeOrName(user: any,codeOrName:any): Observable<any> {
        user.codeOrName = codeOrName;
        return this.redisClient.send({cmd: 'find_doctor_by_codeOrName'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientDetailsEdit(patientDto : any) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_details_edit'}, patientDto);
    }

    @UseFilters(AllClientServiceException)
    public patientBookAppointment(patientDto : any) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_book_appointment'}, patientDto);
    }

    @UseFilters(AllClientServiceException)
    public viewAppointmentSlotsForPatient(doctorKey : any, appointmentDate : any) : Observable <any> {
        doctorKey.appointmentDate = appointmentDate;
        return this.redisClient.send({ cmd : 'patient_view_appointment'}, doctorKey);
    }

    @UseFilters(AllClientServiceException)
    public patientPastAppointments(patientId:any) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_past_appointments'},patientId);
    }

    
    @UseFilters(AllClientServiceException)
    public patientUpcomingAppointments(patientId:any) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_upcoming_appointments'},patientId);
    }


}

import {Injectable, Inject, UseFilters, OnModuleDestroy, OnModuleInit, HttpStatus} from '@nestjs/common';
import {ClientProxy} from '@nestjs/microservices';
import {Observable} from 'rxjs';
import {UserDto, AppointmentDto, DoctorConfigCanReschDto, DocConfigDto,WorkScheduleDto,PatientDto, DoctorDto, HospitalDto} from 'common-dto';
import {AllClientServiceException} from 'src/common/filter/all-clientservice-exceptions.filter';
import { UserService } from './user.service';


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
    public createAppointment(appointmentDto: any, user: any): Promise<any> {
        appointmentDto.user = user;
        return this.redisClient.send({cmd: 'calendar_appointment_create'}, appointmentDto).toPromise();
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
    public appointmentSlotsView(user: any,doctorKey:any,paginationNumber:number): Observable<any> {
        user.doctorKey = doctorKey;
        user.paginationNumber = paginationNumber;
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
    public doctorListForPatients(user: any): Observable<any> {
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
    public patientDetailsEdit(patientDto : any) : Promise <any> {
        return this.redisClient.send({ cmd : 'patient_details_edit'}, patientDto).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public patientBookAppointment(patientDto : AppointmentDto) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_book_appointment'}, patientDto);
    }

    @UseFilters(AllClientServiceException)
    public viewAppointmentSlotsForPatient(doctorKey : any, appointmentDate : any) : Observable <any> {
        let details={
            doctorKey:doctorKey,
            appointmentDate:appointmentDate
        }
        return this.redisClient.send({ cmd : 'patient_view_appointment'}, details);
    }

    @UseFilters(AllClientServiceException)
    public patientPastAppointments(patientId:any,paginationNumber:any,limit:any) : Observable <any> {
        let user = {
            patientId:patientId,
            paginationNumber:paginationNumber,
            limit:limit
        }
        return this.redisClient.send({ cmd : 'patient_past_appointments'},user);
    }

    
    @UseFilters(AllClientServiceException)
    public patientUpcomingAppointments(patientId:any,paginationNumber,limit:any) : Observable <any> {
        let user = {
            patientId:patientId,
            paginationNumber:paginationNumber,
            limit:limit
        }
        return this.redisClient.send({ cmd : 'patient_upcoming_appointments'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientList(doctorKey:any) : Observable <any> {
        return this.redisClient.send({ cmd : 'patient_list'},doctorKey);
    }

    @UseFilters(AllClientServiceException)
    public doctorPersonalSettingsEdit(user, doctorDto:DoctorDto) : Observable <any> {
        user.doctorDto=doctorDto;
        return this.redisClient.send({ cmd : 'doctor_details_edit'},user);
    }

    @UseFilters(AllClientServiceException)
    public hospitaldetailsView(user, accountKey:any) : Observable <any> {
        user.accountKey=accountKey;
        return this.redisClient.send({ cmd : 'hospital_details_view'},user);
    }

    @UseFilters(AllClientServiceException)
    public hospitaldetailsEdit(user, hospitalDto:HospitalDto) : Observable <any> {
        user.hospitalDto=hospitalDto;
        return this.redisClient.send({ cmd : 'hospital_details_edit'},user);
    }

    @UseFilters(AllClientServiceException)
    public doctorDetails(doctorKey:any,appointmentId:any): Observable<any> {
        var details={
            doctorKey:doctorKey,
            appointmentId:appointmentId
        }
        return this.redisClient.send({cmd: 'app_doctor_details'}, details);
    }

    @UseFilters(AllClientServiceException)
    public availableSlots(user:any,doctorKey:any,appointmentDate:any): Observable<any> {
        user.doctorKey = doctorKey;
        user.appointmentDate = appointmentDate;
        return this.redisClient.send({cmd: 'app_doctor_slots'}, user);
    }

    @UseFilters(AllClientServiceException)
    public patientDetails(user:any, patientId:any,doctorKey:any) : Observable <any> {
        user.patientId = patientId;
        user.doctorKey = doctorKey;
        return this.redisClient.send({ cmd : 'patient_details'},user);
    }

    @UseFilters(AllClientServiceException)
    public reports(user:any, accountKey:any,paginationNumber:any) : Observable <any> {
        user.accountKey = accountKey;
        user.paginationNumber=paginationNumber;
        return this.redisClient.send({ cmd : 'reports_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public listOfDoctorsInHospital(user:any, accountKey:any) : Observable <any> {
        user.accountKey = accountKey;
        return this.redisClient.send({ cmd : 'list_of_doctors'},user);
    }

    @UseFilters(AllClientServiceException)
    public viewDoctorDetails(user:any, doctorKey:any) : Observable <any> {
        user.doctorKey = doctorKey;
        return this.redisClient.send({ cmd : 'view_doctor_details'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientAppointmentCancel(appointmentDto: any,user:any): Observable<any> {
        appointmentDto.user = user;
        return this.redisClient.send({cmd: 'patient_appointment_cancel'},appointmentDto);
    }

    @UseFilters(AllClientServiceException)
    public detailsOfPatient(user:any, patientId:any,doctorKey:any) : Observable <any> {
        user.patientId = patientId;
        user.doctorKey = doctorKey;
        return this.redisClient.send({ cmd : 'details_of_patient'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientUpcomingAppList(user:any, patientDto:any) : Observable <any> {
        user.patientDto = patientDto;
        return this.redisClient.send({ cmd : 'patient_upcoming_app_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientPastAppList(user:any, patientDto:any) : Observable <any> {
        user.patientDto = patientDto;
        return this.redisClient.send({ cmd : 'patient_past_app_list'},user);
    }

    @UseFilters(AllClientServiceException)
    public updatePatOnline(patientId:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'update_patient_online'},patientId).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public updateDocOnline(doctorKey:any) : Promise <any> {
        return this.redisClient.send({ cmd : 'update_doctor_online'},doctorKey).toPromise();
    }

    @UseFilters(AllClientServiceException)
    public patientGeneralSearch(user:any, patientSearch: any,doctorKey:any): Observable<any> {
        user.patientSearch = patientSearch;
        user.doctorKey = doctorKey;
        return this.redisClient.send({cmd: 'doc_patient_general_search'},user);
    }

    @UseFilters(AllClientServiceException)
    public patientAppointmentReschedule(appointmentDto: any,user:any): Observable<any> {
        appointmentDto.user = user;
        return this.redisClient.send({cmd: 'patient_appointment_reschedule'},appointmentDto);
    }


}

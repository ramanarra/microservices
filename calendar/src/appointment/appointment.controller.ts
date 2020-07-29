import {Controller, HttpStatus, Logger, UnauthorizedException} from '@nestjs/common';
import {AppointmentService} from './appointment.service';
import {MessagePattern} from '@nestjs/microservices';
import {CONSTANT_MSG, queries, DoctorDto} from 'common-dto';
import {PatientDto} from 'common-dto';
//import {DoctorService} from './doctor/doctor.service';


@Controller('appointment')
export class AppointmentController {

    private logger = new Logger('AppointmentController');

    constructor(private readonly appointmentService: AppointmentService
       // ,private readonly doctorService: DoctorService
        ) {

    }

    @MessagePattern({cmd: 'calendar_appointment_create'})
    async createAppointment(appointmentDto: any): Promise<any> {
        this.logger.log("appointmentDetails >>> " + appointmentDto);
        if(appointmentDto.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            const docId = await this.appointmentService.doctorDetails(appointmentDto.user.doctor_key);
            const config = await this.appointmentService.getDoctorConfigDetails(appointmentDto.user.doctor_key);
            appointmentDto.configSession = config.consultationSessionTimings;
            if(!docId){
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message:  CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
            appointmentDto.doctorId = docId.doctorId;
            appointmentDto.config = config; 
        } 
        const appointment = await this.appointmentService.createAppointment(appointmentDto);
        return appointment;
    }

    @MessagePattern({cmd: 'app_doctor_list'})
    async doctorList(user): Promise<any> {
        const account = await this.appointmentService.accountDetails(user.account_key);
        if (user.role == CONSTANT_MSG.ROLES.DOCTOR) {
            var docKey = await this.appointmentService.doctorDetails(user.doctor_key);
            docKey.fees = 5000;
            docKey.todaysAppointment = ['4.00pm', '4.15pm', '4.30pm'];
            docKey.todaysAvailabilitySeats = 12;
            return {
                statusCode: HttpStatus.OK,
                accountDetails: account,
                doctorList: [docKey]
            }

        }else{
            const doctor = await this.appointmentService.doctor_List(user.account_key);
              // add static values for temp
              doctor.forEach(v => {
                v.fees = 5000;
                v.todaysAppointment = ['4.00pm', '4.15pm', '4.30pm'];
                v.todaysAvailabilitySeats = 12;
            })
            return {
                statusCode: HttpStatus.OK,
                accountDetails: account,
                doctorList: doctor
            }
        }
          
    }


    @MessagePattern({cmd: 'app_doctor_view'})
    async doctorView(user): Promise<any> {
        try {
            const doctor = await this.appointmentService.doctorDetails(user.doctorKey);
            // if not doctor details return
            if (!doctor)
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message:  CONSTANT_MSG.INVALID_REQUEST
                }
            if ((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key !== user.doctorKey) || (user.role == CONSTANT_MSG.ROLES.ADMIN && user.account_key !== doctor.accountKey )|| (user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT && user.account_key !== doctor.accountKey)) {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.INVALID_REQUEST
                }
            }

            const doctorConfigDetails = await this.appointmentService.getDoctorConfigDetails(user.doctorKey);
            return {
                doctorDetails: doctor,
                configDetails: doctorConfigDetails
            }
        } catch (e) {
            console.log(e)
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message:  CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }



    @MessagePattern({cmd: 'app_canresch_view'})
    async doctorCanReschView(user: any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(user.doctorKey);
        if((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == user.doctorKey) || (user.account_key == doctor.accountKey)){
            const preconsultation = await this.appointmentService.doctorCanReschView(user.doctorKey);
            return preconsultation;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
        
    }

    @MessagePattern({cmd: 'app_doc_config_update'})
    async doctorConfigUpdate(user: any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(user.docConfigDto.doctorKey);
        if((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == user.docConfigDto.doctorKey) || (user.account_key == doctor.accountKey)){
            const docConfig = await this.appointmentService.doctorConfigUpdate(user.docConfigDto);
            return docConfig;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }   
    }

    @MessagePattern({cmd: 'app_work_schedule_edit'})
    async workScheduleEdit(workScheduleDto: any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(workScheduleDto.doctorKey);
        if((workScheduleDto.user.role == CONSTANT_MSG.ROLES.ADMIN && workScheduleDto.user.account_key == doctor.accountKey) || (workScheduleDto.user.role == CONSTANT_MSG.ROLES.DOCTOR && workScheduleDto.user.doctor_key == doctor.doctorKey)){
            const updateRes = await this.appointmentService.workScheduleEdit(workScheduleDto);
            return updateRes;
        }
        return {
            statusCode: HttpStatus.BAD_REQUEST,
            message: CONSTANT_MSG.INVALID_REQUEST
        }
        
    }

    @MessagePattern({cmd: 'app_work_schedule_view'})
    async workScheduleView(user: any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(user.doctorKey);
        if (!doctor) {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message:  CONSTANT_MSG.INVALID_REQUEST
            }
        }
        var docId = doctor.doctorId;
        if((user.role == CONSTANT_MSG.ROLES.ADMIN || user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && user.account_key == doctor.accountKey){
            const docConfig = await this.appointmentService.workScheduleView(docId, user.doctorKey);
            return docConfig;
        } else if(user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == doctor.doctorKey){
            const docConfig = await this.appointmentService.workScheduleView(docId, user.doctorKey);
            return docConfig;
        } else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }      
    }

    @MessagePattern({cmd: 'appointment_slots_view'})
    async appointmentSlotsView(user: any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(user.doctorKey);
        if(!doctor){
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
        if(((user.role == CONSTANT_MSG.ROLES.ADMIN || user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) &&  user.account_key == doctor.accountKey) || (user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == doctor.doctorKey)){
            const appointment = await this.appointmentService.appointmentSlotsView(user);
            return appointment;
        }else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }  
    }

    
    @MessagePattern({cmd: 'appointment_reschedule'})
    async appointmentReschedule(appointmentDto: any): Promise<any> {
    const app = await this.appointmentService.appointmentDetails(appointmentDto.appointmentId)
    if(appointmentDto.user.role == CONSTANT_MSG.ROLES.DOCTOR){
        appointmentDto.doctorId = app.appointmentDetails.doctorId;
    }
    const doctor = await this.appointmentService.doctor_Details(appointmentDto.doctorId);
    if(!doctor){
        return {
            statusCode: HttpStatus.NO_CONTENT,
            message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
        }
    }
    if ((appointmentDto.user.role == CONSTANT_MSG.ROLES.PATIENT && (appointmentDto.user.patient_id !== appointmentDto.patientId))||(appointmentDto.user.role == CONSTANT_MSG.ROLES.DOCTOR && doctor.doctorId!==Number(app.appointmentDetails.doctorId))||((appointmentDto.user.role == CONSTANT_MSG.ROLES.ADMIN||appointmentDto.user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && (appointmentDto.user.account_key!==doctor.accountKey))) {
        return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.INVALID_REQUEST
        }
    }
    const config = await this.appointmentService.getDoctorConfigDetails(doctor.doctorKey);
    appointmentDto.configSession = config.consultationSessionTimings;
    appointmentDto.config = config;
    const appointment = await this.appointmentService.appointmentReschedule(appointmentDto);
    return appointment;
    }

    @MessagePattern({cmd: 'appointment_cancel'})
    async appointmentCancel(appointmentDto: any): Promise<any> {
    const app = await this.appointmentService.appointmentDetails(appointmentDto.appointmentId);
    if(app.message){
        return{
            statusCode: HttpStatus.NO_CONTENT,
            message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
        }
    }
    const doctor = await this.appointmentService.doctor_Details(app.appointmentDetails.doctorId);
    if(!doctor)
        return{
            statusCode: HttpStatus.NO_CONTENT,
            message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
        }
    if ((appointmentDto.user.role == CONSTANT_MSG.ROLES.PATIENT && (appointmentDto.user.patient_id !== app.patientId))||(appointmentDto.user.role == CONSTANT_MSG.ROLES.DOCTOR && appointmentDto.user.doctor_key!==doctor.doctorKey)||((appointmentDto.user.role == CONSTANT_MSG.ROLES.ADMIN||appointmentDto.user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && (appointmentDto.user.account_key!==doctor.accountKey))) {
        return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.INVALID_REQUEST
        }
    }
    const appointment = await this.appointmentService.appointmentCancel(appointmentDto);
    return appointment;
    }

    @MessagePattern({cmd: 'app_patient_search'})
    async patientSearch(patientDto: any): Promise<any> {
        const patient = await this.appointmentService.patientSearch(patientDto);
        return patient;
    }

    @MessagePattern({cmd: 'appointment_view'})
    async AppointmentView(user: any): Promise<any> {
        const appointment = await this.appointmentService.appointmentDetails(user.appointmentId);
        if (!appointment) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
        return appointment;
    }

    @MessagePattern({cmd: 'doctor_list_patients'})
    async doctorListForPatients(user: any): Promise<any> {
        const doctor = await this.appointmentService.doctor_List(user.accountKey);
        return doctor;
    }

    @MessagePattern({cmd: 'patient_details_insertion'})
    async patientInsertion(patientDto: PatientDto): Promise<any> {
        const patient = await this.appointmentService.patientRegistration(patientDto);
        return patient;
    }

    @MessagePattern({cmd: 'find_doctor_by_codeOrName'})
    async findDoctorByCodeOrName(user: any): Promise<any> {
        const doctor = await this.appointmentService.findDoctorByCodeOrName(user.codeOrName.codeOrName);
        return doctor;
    }

    @MessagePattern({cmd: 'patient_details_edit'})
    async patientDetailsEdit(patientDto: any): Promise<any> {
        const patient = await this.appointmentService.patientDetailsEdit(patientDto);
        return patient;
    }

    @MessagePattern({cmd: 'patient_book_appointment'})
    async patientBookAppointment(patientDto: any): Promise<any> {
        const doctor = await this.appointmentService.doctor_Details(patientDto.doctorId);
        const config = await this.appointmentService.getDoctorConfigDetails(doctor.doctorKey);
        patientDto.configSession = config.consultationSessionTimings;
        patientDto.config = config;
        const patient = await this.appointmentService.createAppointment(patientDto);
        return patient;
    }

    @MessagePattern({cmd: 'patient_view_appointment'})
    async viewAppointmentSlotsForPatient(details: any): Promise<any> {
        const appointment = await this.appointmentService.availableSlots(details);
        return appointment;
    }

    @MessagePattern({cmd: 'patient_past_appointments'})
    async patientPastAppointments(user:any): Promise<any> {
        const appointment = await this.appointmentService.patientPastAppointments(user);
        return appointment;
    }

    @MessagePattern({cmd: 'patient_upcoming_appointments'})
    async patientUpcomingAppointments(user:any): Promise<any> {
        const appointment = await this.appointmentService.patientUpcomingAppointments(user);
        return appointment;
    }

    @MessagePattern({cmd: 'patient_list'})
    async patientList(doctorKey:any): Promise<any> {
        const doctor =await this.appointmentService.doctorDetails(doctorKey);
        const appointment = await this.appointmentService.patientList(doctor.doctorId);
        return appointment;
    }

    @MessagePattern({cmd: 'doctor_details_edit'})
    async doctorPersonalSettingsEdit(user:any): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(user.doctorDto.doctorKey);
        if(user.doctorDto.doctorKey == user.doctor_key){
            const doctor = await this.appointmentService.doctorPersonalSettingsEdit(user.doctorDto);
            return doctor;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
        
    }

    @MessagePattern({cmd: 'hospital_details_view'})
    async hospitaldetailsView(user:any): Promise<any> {
        if(user.accountKey == user.account_key){
            const hospital = await this.appointmentService.accountDetails(user.accountKey);
            return hospital;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
        
    }

    @MessagePattern({cmd: 'hospital_details_edit'})
    async hospitaldetailsEdit(user:any): Promise<any> {
        if(user.hospitalDto.accountKey == user.account_key){
            const hospital = await this.appointmentService.hospitaldetailsEdit(user.hospitalDto);
            return hospital;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
        
    }

    @MessagePattern({cmd: 'app_doctor_details'})
    async doctorDetails(details: any): Promise<any> {
        const doctor = await this.appointmentService.viewDoctorDetails(details);
        return doctor;        
    }

    @MessagePattern({cmd: 'app_doctor_slots'})
    async availableSlots(user: any): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(user.doctorKey);
        if((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == user.doctorKey) || ((user.role == CONSTANT_MSG.ROLES.ADMIN || user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && user.account_key == doc.accountKey)){
            const doctor = await this.appointmentService.availableSlots(user);
            return doctor; 
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
               
    }

    @MessagePattern({cmd: 'patient_details'})
    async patientDetails(user: any): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(user.doctorKey);
        if((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == user.doctorKey) || ((user.role == CONSTANT_MSG.ROLES.ADMIN || user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && user.account_key == doc.accountKey)){
            const patient = await this.appointmentService.patientDetails(user.patientId);
            return patient;  
        }
    }

    @MessagePattern({cmd: 'reports_list'})
    async reports(user: any): Promise<any> {
        if(user.account_key == user.accountKey){
           const reports = await this.appointmentService.reports(user.accountKey);
           return reports;  
        }else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
    }

    @MessagePattern({cmd: 'list_of_doctors'})
    async listOfDoctorsInHospital(user: any): Promise<any> {
        const doctors = await this.appointmentService.listOfDoctorsInHospital(user.accountKey);
        return doctors;  
    }

    @MessagePattern({cmd: 'view_doctor_details'})
    async viewDoctorDetails(user: any): Promise<any> {
        const doctors = await this.appointmentService.viewDoctor(user);
        return doctors;  
    }



}

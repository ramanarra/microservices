import {Controller, HttpStatus, Logger, UnauthorizedException} from '@nestjs/common';
import {AppointmentService} from './appointment.service';
import {MessagePattern} from '@nestjs/microservices';
import {CONSTANT_MSG, queries} from 'common-dto';
import {PatientDto} from 'common-dto';


@Controller('appointment')
export class AppointmentController {

    private logger = new Logger('AppointmentController');

    constructor(private readonly appointmentService: AppointmentService) {

    }

    @MessagePattern({cmd: 'calendar_appointment_create'})
    async createAppointment(appointmentDto: any): Promise<any> {
        this.logger.log("appointmentDetails >>> " + appointmentDto);
        if(appointmentDto.user.role == 'DOCTOR'){
            const docId = await this.appointmentService.doctorDetails(appointmentDto.user.doctor_key);
            var doctorId = docId.doctorId;
            appointmentDto.doctorId = doctorId;
        }
        
        const appointment = await this.appointmentService.createAppointment(appointmentDto);
        return appointment;
    }


    // @MessagePattern({cmd: 'auth_doctor_details'})
    // async doctor_Login(doctorKey): Promise<any> {
    //     const doctor = await this.appointmentService.doctorDetails(doctorKey);
    //     var doc = [];
    //     doc[0] = doctor;
    //     var accountKey = doctor.accountKey;
    //     const account = await this.appointmentService.accountDetails(accountKey);
    //     doc[1] = account;
    //     return doc;

    // }


    @MessagePattern({cmd: 'app_doctor_list'})
    async doctorList(user): Promise<any> {
        const account = await this.appointmentService.accountDetails(user.account_key);
        if (user.role == 'DOCTOR') {
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
                    message:  CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            if ((user.role == 'DOCTOR' && user.doctor_key !== user.doctorKey) || (user.role == 'ADMIN' && user.account_key !== doctor.accountKey )|| (user.role == 'DOC_ASSISTANT' && user.account_key !== doctor.accountKey)) {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.INVALID_REQUEST
                }
            }

            const doctorConfigDetails = await this.appointmentService.getDoctorConfigDetails(user.doctorKey);
            var accountKey = doctor.accountKey;
            // check accountKey validation
            // if (accountKey !== user.account_key)
            //     throw new UnauthorizedException('Invalid User');
            //const account = await this.appointmentService.accountDetails(accountKey);
            return {
                doctorDetails: doctor,
                // accountDetails: account,
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


    @MessagePattern({cmd: 'app_doctor_preconsultation'})
    async doctorPreconsultation(doctorConfigPreConsultationDto: any): Promise<any> {
        const preconsultation = await this.appointmentService.doctorPreconsultation(doctorConfigPreConsultationDto);
        return preconsultation;
    }


    @MessagePattern({cmd: 'app_hospital_details'})
    async hospitalDetails(accountKey: any): Promise<any> {
        const preconsultation = await this.appointmentService.accountDetails(accountKey);
        return preconsultation;
    }

    @MessagePattern({cmd: 'app_canresch_edit'})
    async doctorCanReschEdit(doctorConfigCanReschDto: any): Promise<any> {
        const preconsultation = await this.appointmentService.doctorCanReschEdit(doctorConfigCanReschDto);
        return preconsultation;
    }

    @MessagePattern({cmd: 'app_canresch_view'})
    async doctorCanReschView(user: any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(user.doctorKey);
        if((user.role == 'DOCTOR' && user.doctor_key == user.doctorKey) || (user.account_key == doctor.accountKey)){
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
        if((user.role == 'DOCTOR' && user.doctor_key == user.docConfigDto.doctorKey) || (user.account_key == doctor.accountKey)){
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
        if((workScheduleDto.user.role == 'ADMIN' && workScheduleDto.user.account_key == doctor.accountKey) || (workScheduleDto.user.role == 'DOCTOR' && workScheduleDto.user.doctor_key == doctor.doctorKey)){
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
                message:  CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
        var docId = doctor.doctorId;
        if((user.role == 'ADMIN' || user.role == 'DOC_ASSISTANT') && user.account_key == doctor.accountKey){
            const docConfig = await this.appointmentService.workScheduleView(docId, user.doctorKey);
            return docConfig;
        } else if(user.role == 'DOCTOR' && user.doctor_key == doctor.doctorKey){
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
        const appointment = await this.appointmentService.appointmentSlotsView(user);
        return appointment;
    }

    @MessagePattern({cmd: 'appointment_reschedule'})
    async appointmentReschedule(appointmentDto: any): Promise<any> {
        if (appointmentDto.user.role == 'PATIENT') {
            if (appointmentDto.user.patient_id !== appointmentDto.patientId) {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.INVALID_REQUEST
                }
            }
            const appointment = await this.appointmentService.appointmentReschedule(appointmentDto);
            return appointment;
        } else {
            const doctor = await this.appointmentService.doctorDetails(appointmentDto.user.doctor_key);
            var docId = doctor.doctor_id;
            const app = await this.appointmentService.appointmentDetails(appointmentDto.appointmentId);
            var doc = Number(app.doctorId);
            if (docId !== doc) {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message:  CONSTANT_MSG.INVALID_REQUEST
                }
            }
            appointmentDto.doctorId = docId;
            const appointment = await this.appointmentService.appointmentReschedule(appointmentDto);
            return appointment;
        }
    }

    @MessagePattern({cmd: 'appointment_cancel'})
    async appointmentCancel(appointmentDto: any): Promise<any> {
        try {
            if (appointmentDto.user.role == 'PATIENT') {
                const patId = await this.appointmentService.appointmentDetails(appointmentDto.id)
                var pat = patId.appointmentDetails.patientId;
                if (appointmentDto.user.patient_id !== pat) {
                    return {
                        statusCode: HttpStatus.NO_CONTENT,
                        message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                    }
                }
                const appointment = await this.appointmentService.appointmentCancel(appointmentDto);
                return appointment;
            } else {
                const doctor = await this.appointmentService.doctorDetails(appointmentDto.user.doctor_key);
                if (doctor && doctor.doctorId) {
                    var docId = doctor.doctorId;
                }
                const appId = await this.appointmentService.appointmentDetails(appointmentDto.appointmentId)
                if (appId) {
                    var app = Number(appId.doctorId);
                }
                if (docId !== app) {
                    return {
                        statusCode: HttpStatus.NO_CONTENT,
                        message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                    }
                }
                const appointment = await this.appointmentService.appointmentCancel(appointmentDto);
                return appointment;
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
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
        const patient = await this.appointmentService.patientBookAppointment(patientDto);
        return patient;
    }

    @MessagePattern({cmd: 'patient_view_appointment'})
    async viewAppointmentSlotsForPatient(doctor: any): Promise<any> {
        const appointment = await this.appointmentService.viewAppointmentSlotsForPatient(doctor);
        return appointment;
    }


}

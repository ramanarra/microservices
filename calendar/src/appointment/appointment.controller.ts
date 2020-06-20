import {Controller, HttpStatus, Logger, UnauthorizedException} from '@nestjs/common';
import {AppointmentService} from './appointment.service';
import {MessagePattern} from '@nestjs/microservices';

var async = require('async');


@Controller('appointment')
export class AppointmentController {

    private logger = new Logger('AppointmentController');

    constructor(private readonly appointmentService: AppointmentService) {

    }

    @MessagePattern({cmd: 'calendar_appointment_get_list'})
    async appointmentList(doctorKey): Promise<any> {
        const docId = await this.appointmentService.doctorDetails(doctorKey);
        var doctorId = docId.doctor_id
        const appointment = await this.appointmentService.getAppointmentList(doctorId);
        this.logger.log("asfn >>> " + appointment);
        return appointment;
    }

    @MessagePattern({cmd: 'calendar_appointment_create'})
    async createAppointment(appointmentDto: any): Promise<any> {
        this.logger.log("appointmentDetails >>> " + appointmentDto);
        const docId = await this.appointmentService.doctorDetails(appointmentDto.user.doctor_key);
        var doctorId = docId.doctor_id;
        appointmentDto.doctorId = doctorId;
        const appointment = await this.appointmentService.createAppointment(appointmentDto);
        return appointment;
    }


    @MessagePattern({cmd: 'auth_doctor_details'})
    async doctor_Login(doctorKey): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(doctorKey);
        var doc = [];
        doc[0] = doctor;
        var accountKey = doctor.accountKey;
        const account = await this.appointmentService.accountDetails(accountKey);
        doc[1] = account;
        return doc;

    }

    @MessagePattern({cmd: 'app_doctor_list'})
    async doctorList(roleKey): Promise<any> {
        console.log(roleKey)
        if (roleKey.role === "DOCTOR") {
            var doctorKey = roleKey.key;
            const doctor = await this.appointmentService.doctorDetails(doctorKey);
            // add static response for fees, today's appointmenet, available seats
            doctor.fees = 5000;
            doctor.todaysAppointment = ['4.00pm', '4.15pm', '4.30pm'];
            doctor.todaysAvailabilitySeats = 12;
            if (doctor) {
                return {
                    statusCode: HttpStatus.OK,
                    doctorList: doctor
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: 'content not available'
                }
            }
        } else if (roleKey.role === 'ADMIN') {
            var accountKey = roleKey.key;
            const account = await this.appointmentService.accountDetails(accountKey);
            const doctor = await this.appointmentService.doctor_List(accountKey);
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
        } else if (roleKey.role === 'DOC_ASSISTANT') {
            var accountKey = roleKey.key;
            //const account = await this.appointmentService.accountDetails(accountKey);
            const doctor = await this.appointmentService.doctor_List(accountKey);
            // add static values for temp
            doctor.forEach(v => {
                v.fees = 5000;
                v.todaysAppointment = ['4.00pm', '4.15pm', '4.30pm'];
                v.todaysAvailabilitySeats = 12;
            })
            return {
                statusCode: HttpStatus.OK,
                //accountDetails: account,
                doctorList: doctor
            }
        } else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: "Invalid request"
            }
        }

    }


    @MessagePattern({cmd: 'app_doctor_view'})
    async doctorView(doctorKey): Promise<any> {
        try {
            const doctor = await this.appointmentService.doctorDetails(doctorKey);
            // if not doctor details return
            if (!doctor)
                return "Content Not Available";

            const doctorConfigDetails = await this.appointmentService.getDoctorConfigDetails(doctorKey);
            var accountKey = doctor.accountKey;
            // check accountKey validation
            if (!accountKey)
                throw new UnauthorizedException('Content Not Available');

            const account = await this.appointmentService.accountDetails(accountKey);
            return {
                doctorDetails: doctor,
                accountDetails: account,
                configDetails: doctorConfigDetails
            }
        } catch (e) {
            console.log(e)
            return "Content Not Available";
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
    async doctorCanReschView(doctorKey: any): Promise<any> {
        const preconsultation = await this.appointmentService.doctorCanReschView(doctorKey);
        return preconsultation;
    }

    @MessagePattern({cmd: 'app_doc_config_update'})
    async doctorConfigUpdate(doctorConfigDto: any): Promise<any> {
        const docConfig = await this.appointmentService.doctorConfigUpdate(doctorConfigDto);
        return docConfig;
    }

    @MessagePattern({cmd: 'app_work_schedule_edit'})
    async workScheduleEdit(workScheduleDto: any): Promise<any> {
        const updateRes = await this.appointmentService.workScheduleEdit(workScheduleDto);



        // if (workScheduleDto.user.role == 'ADMIN') {
        //     const acc = await this.appointmentService.doctorDetails(workScheduleDto.doctorKey);
        //     var accKey = acc.accountkey;
        //     if (accKey !== workScheduleDto.user.accountKey) {
        //         return {
        //             statusCode: HttpStatus.BAD_REQUEST,
        //             message: 'Invalid Request'
        //         }
        //     }
        //     const docConfig = await this.appointmentService.workScheduleEdit(workScheduleDto, workScheduleDto.doctorKey);
        //     return docConfig;
        // } else if (workScheduleDto.user.role == 'DOCTOR') {
        //     const docConfig = await this.appointmentService.workScheduleEdit(workScheduleDto, workScheduleDto.doctorKey);
        //     return docConfig;
        // }
        // return {
        //     statusCode: HttpStatus.BAD_REQUEST,
        //     message: 'Invalid Request'
        // }
    }

    @MessagePattern({cmd: 'app_work_schedule_view'})
    async workScheduleView(doctorKey: any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(doctorKey);
        if (!doctor) {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: "DOCTOR Not found"
            }
        }
        var docId = doctor.doctor_id;
        const docConfig = await this.appointmentService.workScheduleView(docId);
        return docConfig;

    }


}

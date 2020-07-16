import {HttpStatus, Injectable} from '@nestjs/common';
import {AppointmentRepository} from './appointment.repository';
import {InjectRepository} from '@nestjs/typeorm';
import {
    AppointmentDto,
    UserDto,
    DoctorConfigPreConsultationDto,
    DoctorConfigCanReschDto,
    DocConfigDto,
    WorkScheduleDto,
    PatientDto, CONSTANT_MSG,queries, DoctorDto
} from 'common-dto';
import {Appointment} from './appointment.entity';
import {Doctor} from './doctor/doctor.entity';
import {DoctorRepository} from './doctor/doctor.repository';
import {AccountDetailsRepository} from './account/account.repository';
import {AccountDetails} from './account/account_details.entity';
import {DoctorConfigPreConsultationRepository} from './doctorConfigPreConsultancy/doctor_config_preconsultation.repository';
import {DoctorConfigPreConsultation} from './doctorConfigPreConsultancy/doctor_config_preconsultation.entity';
import {DoctorConfigCanReschRepository} from './docConfigReschedule/doc_config_can_resch.repository';
import {DoctorConfigCanResch} from './docConfigReschedule/doc_config_can_resch.entity';
import {docConfigRepository} from "./doc_config/docConfig.repository";
//import {queries} from "../config/query";
import {DocConfigScheduleDayRepository} from "./docConfigScheduleDay/docConfigScheduleDay.repository";
import {DocConfigScheduleIntervalRepository} from "./docConfigScheduleInterval/docConfigScheduleInterval.repository";
import {WorkScheduleDayRepository} from "./workSchedule/workScheduleDay.repository";
import {WorkScheduleIntervalRepository} from "./workSchedule/workScheduleInterval.repository";
import {getRepository, Any} from "typeorm";
import {DocConfigScheduleDay} from "./docConfigScheduleDay/docConfigScheduleDay.entity";
import {PatientDetailsRepository} from "./patientDetails/patientDetails.repository";
import {PatientDetails} from './patientDetails/patientDetails.entity';
import {PaymentDetailsRepository} from "./paymentDetails/paymentDetails.repository";
import {Helper} from "../utility/helper";


var async = require('async');


@Injectable()
export class AppointmentService {

    constructor(
        @InjectRepository(AppointmentRepository) private appointmentRepository: AppointmentRepository,
        private accountDetailsRepository: AccountDetailsRepository, private doctorRepository: DoctorRepository,
        private doctorConfigPreConsultationRepository: DoctorConfigPreConsultationRepository,
        private doctorConfigCanReschRepository: DoctorConfigCanReschRepository,
        private doctorConfigRepository: docConfigRepository,
        private docConfigScheduleDayRepository: DocConfigScheduleDayRepository,
        private docConfigScheduleIntervalRepository: DocConfigScheduleIntervalRepository,
        private workScheduleDayRepository: WorkScheduleDayRepository,
        private workScheduleIntervalRepository: WorkScheduleIntervalRepository,
        private patientDetailsRepository: PatientDetailsRepository,
        private paymentDetailsRepository: PaymentDetailsRepository
    ) {
    }


    async createAppointment(appointmentDto: AppointmentDto): Promise<any> {
        try {
            const app = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [appointmentDto.appointmentDate,appointmentDto.doctorId]);
            const config = await this.doctorConfigRepository 
            if(app){
                    // // validate with previous data
                    let isOverLapping = await this.findTimeOverlaping(app, appointmentDto);
                    if (isOverLapping) {
                        //return error message
                        return {
                            statusCode: HttpStatus.NOT_FOUND,
                            message: CONSTANT_MSG.TIME_OVERLAP
                        }
                    } else {
                        // create appointment on existing date old records
                        return await this.appointmentRepository.createAppointment(appointmentDto);
                    }
            }        
            return await this.appointmentRepository.createAppointment(appointmentDto);
        } catch (e) {
	    console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async doctorDetails(doctorKey): Promise<any> {
        return await this.doctorRepository.findOne({doctorKey: doctorKey});
    }

    async doctorListDetails(doctorKey): Promise<any> {
        let docConfig = await this.docConfigScheduleDayRepository.query(queries.getDocDetails, [doctorKey]);
        return docConfig;
    }

    async accountDetails(accountKey): Promise<any> {
        return await this.accountDetailsRepository.findOne({accountKey: accountKey});
    }

    async doctor_Details(doctorId): Promise<any> {
        return await this.doctorRepository.findOne({doctorId: doctorId});
    }


    async doctor_List(accountKey): Promise<any> {
        try {
            const doctorList = await this.doctorRepository.find({accountKey: accountKey});
            if (doctorList.length) {
                return doctorList;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async doctorListAccount(accountKey): Promise<any> {
        let docConfig = await this.docConfigScheduleDayRepository.query(queries.getDocListDetails, [accountKey]);
        return docConfig;
    }

    async doctorCanReschView(doctorKey): Promise<any> {
        return await this.doctorConfigCanReschRepository.findOne({doctorKey: doctorKey});
    }

    // get details from docConfig table
    async getDoctorConfigDetails(doctorKey): Promise<any> {
        return await this.doctorConfigRepository.findOne({doctorKey: doctorKey});
    }

    async doctorConfigUpdate(doctorConfigDto: DocConfigDto): Promise<any> {
        try {
                // update the doctorConfig details
            if (!doctorConfigDto.doctorKey) {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
            var condition = {
                doctorKey: doctorConfigDto.doctorKey
            }
            var values: any = doctorConfigDto;
            var updateDoctorConfig = await this.doctorConfigRepository.update(condition, values);
            if (updateDoctorConfig.affected) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.UPDATE_OK
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_MODIFIED,
                    message: CONSTANT_MSG.UPDATE_FAILED
                }
            }
        } catch (e) {
	    console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async workScheduleView(doctorId: number, docKey: string): Promise<any> {
        try {
            let docConfig = await this.docConfigScheduleDayRepository.query(queries.getWorkSchedule, [doctorId]);
            if (docConfig) {
                let monday = [], tuesday = [], wednesday = [], thursday = [], friday = [], saturday = [], sunday = [];
                // format the response
                docConfig.forEach(v => {
                    if (v.dayOfWeek === 'Monday') {
                        monday.push(v);
                    }
                    if (v.dayOfWeek === 'Tuesday') {
                        tuesday.push(v);
                    }
                    if (v.dayOfWeek === 'Wednesday') {
                        wednesday.push(v);
                    }
                    if (v.dayOfWeek === 'Thursday') {
                        thursday.push(v);
                    }
                    if (v.dayOfWeek === 'Friday') {
                        friday.push(v);
                    }
                    if (v.dayOfWeek === 'Saturday') {
                        saturday.push(v);
                    }
                    if (v.dayOfWeek === 'Sunday') {
                        sunday.push(v);
                    }
                })
                const config = await this.doctorConfigRepository.query(queries.getConfig, [docKey]);
                let config1=config[0];
                let responseData = {
                    monday: monday,
                    tuesday: tuesday,
                    wednesday: wednesday,
                    thursday: thursday,
                    friday: friday,
                    saturday: saturday,
                    sunday: sunday,
                    configDetails: config1
                }
                return responseData;
            } else {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.INVALID_REQUEST
                }
            }
        } catch (e) {
	    console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }


    async workScheduleEdit(workScheduleDto: any): Promise<any> {
        if (workScheduleDto.workScheduleConfig) {
            // update on workScheduleConfig
            var condition = {
                doctorKey: workScheduleDto.doctorKey
            }
            var values: any = workScheduleDto.workScheduleConfig;
            let updateDoctorConfig = await this.doctorConfigRepository.update(condition, values);
        }
        // update for sheduleTime Intervals
        let scheduleTimeIntervals = workScheduleDto.updateWorkSchedule;
        if (scheduleTimeIntervals && scheduleTimeIntervals.length) {
            for (let scheduleTimeInterval of scheduleTimeIntervals) {
                if (scheduleTimeInterval.scheduletimeid) {
                    if (scheduleTimeInterval.isDelete) {
                        // if delete, then delete the record
                        let scheduleTimeId = scheduleTimeInterval.scheduletimeid;
                        let scheduleDayId = scheduleTimeInterval.scheduledayid;
                        let deleteInterval = await this.deleteDoctorConfigScheduleInterval(scheduleTimeId, scheduleDayId);
                    } else {
                        // if scheduletimeid is there then need to update
                        let doctorKey = workScheduleDto.user.doctor_key;
                        let scheduleDayId = scheduleTimeInterval.scheduledayid;
                        let doctorScheduledDays = await this.getDoctorConfigSchedule(doctorKey, scheduleDayId);
                        if (doctorScheduledDays && doctorScheduledDays.length) {
                            // // validate with previous data
                            let starTime = scheduleTimeInterval.startTime;
                            let endTime = scheduleTimeInterval.endTime;
                            let doctorConfigScheduleIntervalId = scheduleTimeInterval.scheduletimeid;
                            let isOverLapping = await this.findTimeOverlaping(doctorScheduledDays, scheduleTimeInterval);
                            if (isOverLapping) {
                                //return error message
                                return {
                                    statusCode: HttpStatus.NOT_FOUND,
                                    message: CONSTANT_MSG.TIME_OVERLAP
                                }
                            } else {
                                // update old records
                                const updateRecord = await this.updateIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleIntervalId);
                            }
                        } else {
                            // no records, so cant update
                            return {
                                statusCode: HttpStatus.NO_CONTENT,
                                message:  CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                            }
                        }
                    }
                } else {
                    // if scheduletimeid is not there  then new insert new records then
                    // get the previous interval timing from db
                    let doctorKey = workScheduleDto.user.doctor_key;
                    let scheduleDayId = scheduleTimeInterval.scheduledayid;
                    let doctorScheduledDays = await this.getDoctorConfigSchedule(doctorKey, scheduleDayId);
                    if (doctorScheduledDays && doctorScheduledDays.length) {
                        // validate with previous data
                        let starTime = scheduleTimeInterval.startTime;
                        let endTime = scheduleTimeInterval.endTime;
                        let doctorConfigScheduleDayId = scheduleTimeInterval.scheduledayid;
                        let isOverLapping = await this.findTimeOverlaping(doctorScheduledDays, scheduleTimeInterval);
                        if (isOverLapping) {
                            //return error message
                            return {
                                statusCode: HttpStatus.NOT_FOUND,
                                message: CONSTANT_MSG.TIME_OVERLAP
                            }
                        } else {
                            // insert new records
                            const insertRecord = await this.insertIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleDayId);
                        }
                    } else {
                        // no previous datas are there just insert
                        let starTime = scheduleTimeInterval.startTime;
                        let endTime = scheduleTimeInterval.endTime;
                        let doctorConfigScheduleDayId = scheduleTimeInterval.scheduledayid;
                        const insertRecord = await this.insertIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleDayId);
                    }
                }
            }
            return {
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.UPDATE_OK
            }
        }
        return {
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.UPDATE_OK
        }
    }


    async getDoctorConfigSchedule(doctorKey: string, scheduleDayId: string): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.getDoctorScheduleInterval, [doctorKey, scheduleDayId]);
    }

    async deleteDoctorConfigScheduleInterval(scheduletimeid: number, scheduleDayId: number): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.deleteDocConfigScheduleInterval, [scheduletimeid, scheduleDayId]);
    }


    async insertIntoDocConfigScheduleInterval(startTime, endTime, doctorConfigScheduleDayId): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.insertIntoDocConfigScheduleInterval, [startTime, endTime, doctorConfigScheduleDayId])
    }

    async updateIntoDocConfigScheduleInterval(startTime, endTime, doctorConfigScheduleDayId): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.updateIntoDocConfigScheduleInterval, [startTime, endTime, doctorConfigScheduleDayId]);
    }


    async oldappointmentSlotsView(user: any): Promise<any> {
        try {
            const doc = await this.doctorDetails(user.doctorKey);
            var docId = doc.doctorId;
            const app = await this.appointmentRepository.query(queries.getAppointment, [user.startDate, user.endDate, docId]);
            if (app.length) {
                var appointment: any = app;
                for (var i = 0; i < appointment.length; i++) {
                    if (!appointment[i].is_cancel && appointment[i].is_active) {
                        const patId = appointment[i].patient_id;
                        const pat = await this.patientDetailsRepository.findOne({id: patId});
                        let patient = {
                            id: pat.id,
                            name: pat.name
                        }
                        appointment[i].patientDetails = patient;
                        const pay = await this.paymentDetailsRepository.findOne({appointmentId: appointment[i].id});
                        appointment[i].paymentDetails = pay;
                    }
                }
                return appointment;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }


    async appointmentSlotsView(user: any): Promise<any> {
        try {
            let doc = await this.doctorDetails(user.doctorKey);
            let docId = doc.doctorId;
            let appointmentSlots = [];
            let appointmentDates = await this.appointmentRepository.query(queries.getPossibleListAppointmentDatesFor7Days, [docId]);
            if (appointmentDates && appointmentDates.length) {
                let appDate =  appointmentDates[0].appointment_date;
                console.log('date=>', appDate.getDate(), 'monthh--->', appDate.getMonth())


            }
            let todayDay = new Date();
            console.log('date=>', todayDay.getDate(),'month =>', todayDay.getMonth(),  todayDay,   appointmentDates)


            // if(app.length){
            //     const config = await this.doctorConfigRepository.findOne({doctorKey:doc.doctorKey});
            //     let consultSession = config.consultationSessionTimings;
            //     let schDay = await this.docConfigScheduleDayRepository.findOne({doctorKey:doc.doctorKey});
            //     let schInterval = await this.docConfigScheduleIntervalRepository.find({docConfigScheduleDayId:schDay.docConfigScheduleDayId});
            //     let days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
            //
            //
            // }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }

    async appointmentReschedule(appointmentDto: any): Promise<any> {
        try {

            const app = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [appointmentDto.appointmentDate,appointmentDto.doctorId]);
            if(app){
                    // // validate with previous data
                    let isOverLapping = await this.findTimeOverlaping(app, appointmentDto);
                    if (isOverLapping) {
                        //return error message
                        return {
                            statusCode: HttpStatus.NOT_FOUND,
                            message:  CONSTANT_MSG.TIME_OVERLAP
                        }
                    } else {
                        //cancelling current appointment
                        var isCancel = await this.appointmentCancel(appointmentDto);
                        if(isCancel.message == CONSTANT_MSG.APPOINT_ALREADY_CANCELLED){
                            return isCancel;
                        }else{
                            // create appointment on existing date old records
                            return await this.appointmentRepository.createAppointment(appointmentDto);
                        }                       
                    }
            
            }
        
            return await this.appointmentRepository.createAppointment(appointmentDto);
        } catch (e) {
	        console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }

    async appointmentDetails(id: any): Promise<any> {
        try {
            const appointmentDetails = await this.appointmentRepository.findOne({id: id});
            const pat = await this.patientDetailsRepository.findOne({id: appointmentDetails.patientId});
            const pay = await this.paymentDetailsRepository.findOne({appointmentId: id});
            let patient ={
                id:pat.id,
                firstName:pat.firstName,
                lastName:pat.lastName,
                phone:pat.phone,
                email:pat.email
            }
            let res ={
                appointmentDetails:appointmentDetails,
                patientDetails:patient,
                paymentDetails:pay
            }
            return res;
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async appointmentCancel(appointmentDto: any): Promise<any> {
        try {
            if (!appointmentDto.appointmentId) {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
            var appoint=await this.appointmentRepository.findOne({id:appointmentDto.appointmentId});
            if(appoint.isCancel == true){
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.APPOINT_ALREADY_CANCELLED
                }
            }
            var condition = {
                id: appointmentDto.appointmentId
            }
            var values: any = {
                isActive:false,
                isCancel: true,
                cancelledBy: appointmentDto.user.role,
                cancelledId: appointmentDto.user.userId
            }
            var pastAppointment = await this.appointmentRepository.update(condition, values);
            if (pastAppointment.affected) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.APPOINT_CANCELED
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_MODIFIED,
                    message: CONSTANT_MSG.UPDATE_FAILED
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NOT_MODIFIED,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }


    async patientSearch(patientDto: any): Promise<any> {
        try {
            if (patientDto.phone && patientDto.phone.length === 10) {
                const patientDetails = await this.patientDetailsRepository.findOne({phone: patientDto.phone});
                if (patientDetails) {
                    return patientDetails;
                } else {
                    return {
                        statusCode: HttpStatus.NO_CONTENT,
                        message: CONSTANT_MSG.INVALID_MOBILE_NO
                    }
                }
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.INVALID_MOBILE_NO
                }
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }

    async patientRegistration(patientDto:PatientDto): Promise<any> {
        return await this.patientDetailsRepository.patientRegistration(patientDto);
    }


    async findDoctorByCodeOrName(codeOrName: any): Promise<any> {
        try {
            const name = await this.doctorRepository.findOne({doctorName:codeOrName});
            if(name){
                return name;
            }else {
                const code = await this.doctorRepository.findOne({registrationNumber:codeOrName});
                if(code){
                    return code;
                }else{
                    return {
                        statusCode: HttpStatus.NO_CONTENT,
                        message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                    }
                }
            }
        } catch (e) {
	    console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }

    async patientDetailsEdit(patientDto: any): Promise<any> {
        try {
            const patient = await this.patientDetailsRepository.findOne({id:patientDto.patientId});
            if(patientDto.phone){
                let isPhone = await this.isPhoneExists(patientDto.phone);
                if (isPhone) {
                    //return error message
                    return {
                        statusCode: HttpStatus.NOT_FOUND,
                        message: CONSTANT_MSG.PHONE_EXISTS
                    }
                }
            }
            if(!patient){
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }else {
                var condition = {
                    id: patientDto.patientId
                }
                var values: any = patientDto;
                var updatePatientDetails = await this.patientDetailsRepository.update(condition, values);
                if (updatePatientDetails.affected) {
                    return {
                        statusCode: HttpStatus.OK,
                        message: CONSTANT_MSG.UPDATE_OK
                    }
                } else {
                    return {
                        statusCode: HttpStatus.NOT_MODIFIED,
                        message: CONSTANT_MSG.UPDATE_FAILED
                    }
                }
            }
        } catch (e) {
	    console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }

    }    

    async viewAppointmentSlotsForPatient(doctor: any): Promise<any> {
        try {
            const doc = await this.doctorDetails(doctor.doctorKey);
            var docId = doc.doctor_id;
            // const app = await this.appointmentRepository.find({doctorId:docId});
            const app = await this.appointmentRepository.query(queries.getAppointmentOnDate, [doctor.appointmentDate]);
            if (app.length) {
                var appointment: any = app;
                for (var i = 0; i < appointment.length; i++) {
                    if (!appointment[i].is_cancel && appointment[i].is_active) {
                        const patId = appointment[i].patient_id;
                        const pat = await this.patientDetailsRepository.findOne({id: patId});
                        appointment[i].patientDetails = pat;
                        const pay = await this.paymentDetailsRepository.findOne({appointmentId: appointment[i].id});
                        appointment[i].paymentDetails = pay;
                    }
                }
                return appointment;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }

    async patientPastAppointments(patientId:any): Promise<any> {
        try {
            let d = new Date();
            var date =d.getFullYear()+'-'+(d.getMonth()+1)+'-'+d.getDate();
            const app = await this.appointmentRepository.query(queries.getPastAppointment, [patientId,date]);
            if (app.length) {
                var appo:any=[];
                app.forEach(a => {
                    if(a.appointment_date == date){
                        if(a.is_active == false){
                            appo.push(a);
                        }
                    }else{
                        appo.push(a);
                    }
                });
                return appo;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }

    async patientUpcomingAppointments(patientId:any): Promise<any> {
        try {
            let d = new Date();
            var date =d.getFullYear()+'-'+(d.getMonth()+1)+'-'+d.getDate();
            const app = await this.appointmentRepository.query(queries.getUpcomingAppointment, [patientId,date]);
            if (app.length) {
                 var appo:any=[];
                for (var i = 0; i < app.length; i++) {
                    if(app[i].appointment_date == date){
                        if(app[i].is_active == true){
                            appo.push(app[i]);
                        }
                    }else{
                        appo.push(app[i]);
                    }
                } 
                return appo;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }

    async patientList(): Promise<any> {
        //return await this.patientDetailsRepository.find();
        return await this.patientDetailsRepository.query(queries.getPatientList);
    }

    async doctorPersonalSettingsEdit(doctorDto:DoctorDto): Promise<any> {
       try {
            var condition = {
                doctorId: doctorDto.doctorId
            }
            var values: any = doctorDto;
            var updateDoctorConfig = await this.doctorRepository.update(condition, values);
            if (updateDoctorConfig.affected) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.UPDATE_OK
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_MODIFIED,
                    message: CONSTANT_MSG.UPDATE_FAILED
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }





      // common functions below===============================================================

    async findTimeOverlaping(doctorScheduledDays, scheduleTimeInterval): Promise<any> {
        // validate with previous data
        let starTime = scheduleTimeInterval.startTime;
        let endTime = scheduleTimeInterval.endTime;
        let isOverLapping = false;
        // convert starttime into milliseconds
        let startTimeMilliSeconds = Helper.getTimeInMilliSeconds(starTime);
        let endTimeMilliSeconds = Helper.getTimeInMilliSeconds(endTime);
        // compare the startTime in any previous records, if start time or endTime comes between previous time interval
        doctorScheduledDays.forEach(v => {
            let vstartTimeMilliSeconds = Helper.getTimeInMilliSeconds(v.startTime);
            let vEndTimeMilliSeconds = Helper.getTimeInMilliSeconds(v.endTime);
            if (startTimeMilliSeconds >= vstartTimeMilliSeconds && startTimeMilliSeconds < vEndTimeMilliSeconds) {
                isOverLapping = true;
            } else if (endTimeMilliSeconds <= vEndTimeMilliSeconds && endTimeMilliSeconds > vstartTimeMilliSeconds) {
                isOverLapping = true;
            } else if (startTimeMilliSeconds === vstartTimeMilliSeconds && endTimeMilliSeconds === vEndTimeMilliSeconds) {
                isOverLapping = true;
            }
        })
        return isOverLapping;
    }

    async isPhoneExists(phone):Promise<any>{
        let isPhone = false;
        const number = await this.patientDetailsRepository.findOne({phone: phone});
        if(number){
            isPhone = true;
        }
        return isPhone;
    }


}

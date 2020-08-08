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
    PatientDto, CONSTANT_MSG, queries, DoctorDto, HospitalDto,Email
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
import { AppointmentCancelRescheduleRepository } from "./appointmentCancelReschedule/appointmentCancelReschedule.repository";
import {Helper} from "../utility/helper";
import { AnimationFrameScheduler } from 'rxjs/internal/scheduler/AnimationFrameScheduler';
import { AppointmentDocConfigRepository } from "./appointmentDocConfig/appointmentDocConfig.repository";

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
        private paymentDetailsRepository: PaymentDetailsRepository,
        private appointmentCancelRescheduleRepository: AppointmentCancelRescheduleRepository,
        private appointmentDocConfigRepository: AppointmentDocConfigRepository,
        private email: Email

    ) {
    }


    async createAppointment(appointmentDto: any): Promise<any> {
        try {
            const app = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [appointmentDto.appointmentDate, appointmentDto.doctorId]);
            if (app) {
                // // validate with previous data
                let isOverLapping = await this.findTimeOverlapingForAppointments(app, appointmentDto);
                if (isOverLapping) {
                    //return error message
                    return {
                        statusCode: HttpStatus.NOT_FOUND,
                        message: CONSTANT_MSG.TIME_OVERLAP
                    }
                } else {
                    // let user = {
                    //     doctorKey:appointmentDto.doctorKey,
                    //     appointmentDate:appointmentDto.appointmentDate
                    // }
                    // let availableSlot = await this.availableSlots(user);
                    // if(!availableSlot.length){
                    //     return{
                    //         statusCode:HttpStatus.BAD_REQUEST,
                    //         message:CONSTANT_MSG.NO_WORK_SCHEDULE
                    //     }
                    // }else{
                    //     let flag = false;
                    //     let x:any;
                    //     for(x in availableSlot){
                    //         if(x.start == appointmentDto.startTime && x.end == appointmentDto.endTime){
                    //             flag = true;
                    //         }
                    //     }
                    //     if(flag == false){
                    //         return{
                    //             statusCode:HttpStatus.BAD_REQUEST,
                    //             message:CONSTANT_MSG.INVALID_TIMINGS
                    //         }
                    //     }
                    
                    let end = Helper.getTimeInMilliSeconds(appointmentDto.endTime);
                    let start = Helper.getTimeInMilliSeconds(appointmentDto.startTime);
                    let config = Helper.getMinInMilliSeconds(appointmentDto.config.consultationSessionTimings);
                    let endTime = start + config;
                    if(start > end){
                        return{
                            statusCode:HttpStatus.BAD_REQUEST,
                            message:CONSTANT_MSG.INVALID_TIMINGS
                        }
                    }
                    if(endTime !==end){
                        return{
                            statusCode:HttpStatus.BAD_GATEWAY,
                            message:CONSTANT_MSG.END_TIME_MISMATCHING
                        }
                    }
                    const exist=await this.appointmentRepository.query(queries.getExistAppointment,[appointmentDto.doctorId,appointmentDto.patientId,appointmentDto.appointmentDate])
                    if(exist.length && !appointmentDto.confirmation){
                        return{
                            statusCode:HttpStatus.EXPECTATION_FAILED,
                            message:CONSTANT_MSG.APPOINT_ALREADY_PRESENT
                        }
                    }else{   
                        // create appointment on existing date old records                   
                        const appoint= await this.appointmentRepository.createAppointment(appointmentDto);
                        if(!appoint.message){
                            const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                            console.log(appDocConfig);
                            return  {
                                appointment:appoint,
                                appointmentDocConfig:appDocConfig
                            }  
                        }else {
                            return appoint;
                        }

                    }
                }
            }
            const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
            if(!appoint.message){
                const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                console.log(appDocConfig);
                return  {
                    appointment:appoint,
                    appointmentDocConfig:appDocConfig
                } 
            }else {
                return appoint;
            }
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

    async doctor_lists(accountKey): Promise<any> {
        try {
            const doctorList = await this.doctorRepository.query(queries.getDocListDetails, [accountKey]);
            let res=[];
            for(let list of doctorList){
                var doc={
                    doctorId:list.doctorId,
                    accountkey:list.account_key,
                    doctorKey:list.doctor_key,
                    speciality:list.speciality,
                    photo:list.photo,
                    signature:list.signature,
                    number:list.number,
                    firstName:list.first_name,
                    lastName:list.last_name,
                    registrationNumber:list.registration_number,
                    fee:list.consultation_cost,
                    location:list.city
                }
                res.push(doc);
            }
            if (doctorList.length) {
                return res;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.INVALID_REQUEST
                }
            }
        } catch (e) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }


    async doctor_List(user): Promise<any> {
        try {
            const doctorList = await this.appointmentRepository.query(queries.getDocListForPatient, [user.patientId]);
            let ids = [];
            doctorList.forEach(a => {
                let flag = false;
                ids.forEach(i => {
                    if(i.doctorId == a.doctorId)
                        flag = true;
                });
                if(flag == false){
                    ids.push(a)
                }              
            });
            let res=[];
            for(let list of ids){
                var doc={
                    doctorId:list.doctorId,
                    accountkey:list.account_key,
                    doctorKey:list.doctor_key,
                    speciality:list.speciality,
                    photo:list.photo,
                    signature:list.signature,
                    number:list.number,
                    firstName:list.first_name,
                    lastName:list.last_name,
                    registrationNumber:list.registration_number,
                    fee:list.consultation_cost,
                    location:list.city,
                    hospitalName:list.hospital_name
                }
                res.push(doc);
            }
            if (doctorList.length) {
                return res;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.INVALID_REQUEST
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

    async todayAppointments(doctorId,date): Promise<any> {
        const appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [date,doctorId]);
        let apps: any= appointments;
        console.log("appointments <<< " + appointments);
        apps = apps.sort((val1, val2) => {
            let val1IntervalStartTime = val1.startTime;
            let val2IntervalStartTime = val2.startTime;
            val1IntervalStartTime = val1IntervalStartTime.split(':');
            val1IntervalStartTime = val1IntervalStartTime[0];
            val2IntervalStartTime = val2IntervalStartTime.split(':');
            val2IntervalStartTime = val2IntervalStartTime[0];
            if (val1IntervalStartTime < val2IntervalStartTime) {
                return -1;
            } else if (val1IntervalStartTime > val2IntervalStartTime) {
                return 1;
            }else{
                return 0;
            }
        })
        return appointments;
    }

    async todayAppointmentsForDoctor(doctorId,date): Promise<any> {
        const appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctorAlongWithPatient, [date,doctorId]);
        let apps: any= appointments;
        console.log("appointments <<< " + appointments);
        apps = apps.sort((val1, val2) => {
            let val1IntervalStartTime = val1.startTime;
            let val2IntervalStartTime = val2.startTime;
            val1IntervalStartTime = val1IntervalStartTime.split(':');
            val1IntervalStartTime = val1IntervalStartTime[0];
            val2IntervalStartTime = val2IntervalStartTime.split(':');
            val2IntervalStartTime = val2IntervalStartTime[0];
            if (val1IntervalStartTime < val2IntervalStartTime) {
                return -1;
            } else if (val1IntervalStartTime > val2IntervalStartTime) {
                return 1;
            }else{
                return 0;
            }
        })
        return appointments;
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
                let config1 = config[0];
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
            await this.doctorConfigRepository.update(condition, values);
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
                        await this.deleteDoctorConfigScheduleInterval(scheduleTimeId, scheduleDayId);
                    } else {
                        // if scheduletimeid is there then need to update
                        let doctorKey = workScheduleDto.user.doctor_key;
                        let scheduleDayId = scheduleTimeInterval.scheduledayid;
                        let doctorConfigScheduleIntervalId = scheduleTimeInterval.scheduletimeid;
                        let doctorScheduledDays = await this.getDoctorConfigSchedule(doctorKey, scheduleDayId, doctorConfigScheduleIntervalId);
                        let starTime = scheduleTimeInterval.startTime;
                        let endTime = scheduleTimeInterval.endTime;
                        if (doctorScheduledDays && doctorScheduledDays.length) {
                            // // validate with previous data
                            let isOverLapping = await this.findTimeOverlaping(doctorScheduledDays, scheduleTimeInterval);
                            if (isOverLapping) {
                                //return error message
                                return {
                                    statusCode: HttpStatus.NOT_FOUND,
                                    message: CONSTANT_MSG.TIME_OVERLAP
                                }
                            } else {
                                // update old records
                                await this.updateIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleIntervalId);
                            }
                        } else {
                            // only one record present in table update existing records
                            await this.updateIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleIntervalId);
                        }
                    }
                } else {
                    // if scheduletimeid is not there  then new insert new records then
                    // get the previous interval timing from db
                    let doctorKey = workScheduleDto.user.doctor_key;
                    let scheduleDayId = scheduleTimeInterval.scheduledayid;
                    // for inserting new schedule interval, for checking previous interval, passing as zero, as to work the query
                    let doctorScheduledDays = await this.getDoctorConfigSchedule(doctorKey, scheduleDayId, 0);
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
                            await this.insertIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleDayId);
                        }
                    } else {
                        // no previous datas are there just insert
                        let starTime = scheduleTimeInterval.startTime;
                        let endTime = scheduleTimeInterval.endTime;
                        let doctorConfigScheduleDayId = scheduleTimeInterval.scheduledayid;
                        await this.insertIntoDocConfigScheduleInterval(starTime, endTime, doctorConfigScheduleDayId);
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


    async getDoctorConfigSchedule(doctorKey: string, scheduleDayId: number, scheduleIntervalId: number): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.getDoctorScheduleInterval, [doctorKey, scheduleDayId, scheduleIntervalId]);
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


    async appointmentSlotsView(user: any): Promise<any> {
        try {
            const doc = await this.doctorDetails(user.doctorKey);
            let docId = doc.doctorId;
            let page: number = user.paginationNumber;
            var date:any = new Date();
            var startDate:any = date;
          //  var startDate = new Date(Date.now() + (page * 7 * 24 * 60 * 60 * 1000));
            let possibleNextAppointments = await this.appointmentRepository.query(queries.getAppointByDocId, [docId, startDate])
            let doctorWorkSchedule = await this.docConfigScheduleDayRepository.query(queries.getDoctorScheduleIntervalAndDay, [user.doctorKey]);
            if (doctorWorkSchedule && doctorWorkSchedule.length) {
                let doctorWorkScheduleObj = {
                    monday: [],
                    tuesday: [],
                    wednesday: [],
                    thursday: [],
                    friday: [],
                    saturday: [],
                    sunday: []
                }
                doctorWorkSchedule.forEach(v => {
                    if (v.dayOfWeek === 'Monday') {
                        doctorWorkScheduleObj.monday.push(v);
                    } else if (v.dayOfWeek === 'Tuesday') {
                        doctorWorkScheduleObj.tuesday.push(v);
                    } else if (v.dayOfWeek === 'Wednesday') {
                        doctorWorkScheduleObj.wednesday.push(v);
                    } else if (v.dayOfWeek === 'Thursday') {
                        doctorWorkScheduleObj.thursday.push(v);
                    } else if (v.dayOfWeek === 'Friday') {
                        doctorWorkScheduleObj.friday.push(v);
                    } else if (v.dayOfWeek === 'Saturday') {
                        doctorWorkScheduleObj.saturday.push(v);
                    } else if (v.dayOfWeek === 'Sunday') {
                        doctorWorkScheduleObj.sunday.push(v);
                    }
                })
                const doctorConfigDetails = await this.doctorConfigRepository.findOne({doctorKey: doc.doctorKey});
                let preconsultationHours = doctorConfigDetails.preconsultationHours;
                let preconsultationMins = doctorConfigDetails.preconsultationMins;
                let consultationSessionTiming = doctorConfigDetails.consultationSessionTimings;
                let consultationSessionTimingInMilliSeconds = Helper.getMinInMilliSeconds(doctorConfigDetails.consultationSessionTimings);
                let appointmentSlots = [];
                let dayOfWeekCount = 0;
                while (appointmentSlots.length <= page*7+7) {  // run while loop to get minimum 7  days of appointment slots
                    let day = new Date(startDate.getTime() + (dayOfWeekCount * 24 * 60 * 60 * 1000)); // increase the day one by one in loop
                    let dayOfWeek = day.getDay();
                    let workScheduleDayPresentOrNot = false;
                    let dayOfWeekInWords;
                    if (dayOfWeek === 0) {
                        dayOfWeekInWords = 'sunday';
                    } else if (dayOfWeek === 1) {
                        dayOfWeekInWords = 'monday';
                    } else if (dayOfWeek === 2) {
                        dayOfWeekInWords = 'tuesday';
                    } else if (dayOfWeek === 3) {
                        dayOfWeekInWords = 'wednesday';
                    } else if (dayOfWeek === 4) {
                        dayOfWeekInWords = 'thursday';
                    } else if (dayOfWeek === 5) {
                        dayOfWeekInWords = 'friday';
                    } else if (dayOfWeek === 6) {
                        dayOfWeekInWords = 'saturday';
                    }
                    workScheduleDayPresentOrNot = await this.isWorkScheduleAvailable(dayOfWeekInWords, doctorWorkScheduleObj); // check workSchedule interval present on this day or not
                    if (workScheduleDayPresentOrNot) {  // if workschedule present on this day, then push into appointment slots array
                        let slotObject: any = {};
                        slotObject.dayOfWeek = dayOfWeekInWords;
                        slotObject.day = day;
                        slotObject.slots = [];
                        // sort the workSchedule interval timing,ex: in db workSchedule will start 15:00 to 18:00 and second interval will be 10:00 to 12:00
                        // so to order the appointment slots based on startime, we'll sort the scheduleInterval bases on startime in below
                        let sortedWorkScheduleTimeInterval: any = doctorWorkScheduleObj[dayOfWeekInWords];
                        sortedWorkScheduleTimeInterval = sortedWorkScheduleTimeInterval.sort((val1, val2) => {
                            let val1IntervalStartTime = val1.startTime;
                            let val2IntervalStartTime = val2.startTime;
                            val1IntervalStartTime = val1IntervalStartTime.split(':');
                            val1IntervalStartTime = val1IntervalStartTime[0];
                            val2IntervalStartTime = val2IntervalStartTime.split(':');
                            val2IntervalStartTime = val2IntervalStartTime[0];
                            if (val1IntervalStartTime < val2IntervalStartTime) {
                                return -1;
                            } else if (val1IntervalStartTime > val2IntervalStartTime) {
                                return 1;
                            }
                            return 0;
                        })
                        var seconds = date.getSeconds();
                        var minutes = date.getMinutes();
                        var hour = date.getHours();
                        var time = hour+":"+minutes;
                        var timeMilli = Helper.getTimeInMilliSeconds(time);
                        // In below code => an doctor can have  many intervals on particular day, so run in loop the interval
                        //sortedWorkScheduleTimeInterval.forEach(v => {
                        for(let v of sortedWorkScheduleTimeInterval){
                            let intervalEndTime = v.endTime;
                            let intervalEnd = false;
                            let slotStartTime = v.startTime;
                            while (!intervalEnd) {  // until the interval endTime comes run the while loop
                                let slotEndTimeCalculate = Helper.getTimeInMilliSeconds(slotStartTime);
                                slotEndTimeCalculate += consultationSessionTimingInMilliSeconds; // adding slot startime + consultationSessionTiming, ex: 30 minutes
                                let slotEndTime = Helper.getTimeinHrsMins(slotEndTimeCalculate);
                                // check condition if endtime is less than schedule interval time then break the loop
                                let intervalEndTimeInMilliSeconds = Helper.getTimeInMilliSeconds(intervalEndTime);
                                if (slotEndTimeCalculate > intervalEndTimeInMilliSeconds) { // if slot endTime greater than Interval End time, then break the loop
                                    intervalEnd = true;
                                    continue;
                                }
                                let appointmentPresentOnThisDate = possibleNextAppointments.filter(v => { // check any appointment present on this date
                                    let appDate = Helper.getDayMonthYearFromDate(v.appointment_date);
                                    let compareDate = Helper.getDayMonthYearFromDate(day);
                                    return appDate === compareDate;
                                })
                                console.log(appointmentPresentOnThisDate);
                                let slotPresentOrNot = appointmentPresentOnThisDate.filter(v => {
                                    let startTimeInMilliSec = Helper.getTimeInMilliSeconds(v.startTime);
                                    let endTimeInMilliSec = Helper.getTimeInMilliSeconds(v.endTime);
                                    let slotStartTimeInMilliSec = Helper.getTimeInMilliSeconds(slotStartTime);
                                    let slotEndTimeInMilliSec = Helper.getTimeInMilliSeconds(slotEndTime);
                                    // if((slotStartTimeInMilliSec<startTimeInMilliSec && endTimeInMilliSec<=slotEndTimeInMilliSec)||(slotStartTimeInMilliSec >= startTimeInMilliSec && slotStartTimeInMilliSec < endTimeInMilliSec)||(slotEndTimeInMilliSec <= endTimeInMilliSec && slotEndTimeInMilliSec > startTimeInMilliSec)||(slotStartTimeInMilliSec === startTimeInMilliSec && slotEndTimeInMilliSec === endTimeInMilliSec)&& (!v.is_cancel)) {
                                    if(((startTimeInMilliSec<=slotStartTimeInMilliSec && endTimeInMilliSec <= slotEndTimeInMilliSec && slotStartTimeInMilliSec>=startTimeInMilliSec && slotEndTimeInMilliSec > startTimeInMilliSec  ) || ( slotStartTimeInMilliSec <= startTimeInMilliSec &&  slotEndTimeInMilliSec <= endTimeInMilliSec && startTimeInMilliSec > slotEndTimeInMilliSec && slotStartTimeInMilliSec < endTimeInMilliSec )|| ( startTimeInMilliSec <= slotStartTimeInMilliSec  &&  slotEndTimeInMilliSec <= endTimeInMilliSec)|| ( slotStartTimeInMilliSec >= startTimeInMilliSec &&  slotEndTimeInMilliSec <= endTimeInMilliSec)) && (!v.is_cancel)) {
                                   // if ((startTimeInMilliSec === slotStartTimeInMilliSec) && (!v.is_cancel)) {  // if any appointment present then push the booked appointment slots
                                        let daydate = Helper.getDayMonthYearFromDate(v.appointment_date );
                                        let datedate = Helper.getDayMonthYearFromDate(date);
                                        if(daydate == datedate){
                                            // if(v.appointmentDate == date){
                                            if(timeMilli < endTimeInMilliSec){
                                                v.slotType = 'Booked';
                                                v.preconsultationHours = preconsultationHours;
                                                v.preconsultationMins = preconsultationMins;
                                                // v.slotTiming = consultationSessionTiming;
                                                let flag = false;
                                                for(let i of slotObject.slots){
                                                    if(i.id == v.id){
                                                        flag = true;
                                                    }
                                                }
                                                if(flag == false){
                                                    slotObject.slots.push(v)
                                                    return true;
                                                }
                                                //slotObject.slots.push(v)
                                                //return true;
                                            }else {
                                                return false;
                                            }

                                        }else{
                                            v.slotType = 'Booked';
                                            v.preconsultationHours = preconsultationHours;
                                            v.preconsultationMins = preconsultationMins;
                                            // v.slotTiming = consultationSessionTiming;
                                            let flag = false;
                                            for(let i of slotObject.slots){
                                                if(i.id == v.id){
                                                    flag = true;
                                                }
                                            }
                                            if(flag == false){
                                                slotObject.slots.push(v)
                                                return true;
                                            }
                                            // slotObject.slots.push(v)
                                            // return true;
                                        }                                        
                                    } else {
                                        return false;
                                    }
                                })
                                if (!slotPresentOrNot.length) { // if no appointment present on the slot timing, then push the free slots
                                    let dto = {
                                        startTime : slotStartTime,
                                        endTime :slotEndTime,
                                    }
                                    let isOverLapping = await this.findTimeOverlapingForAppointments(appointmentPresentOnThisDate, dto);
                                    var time = date.getHours() + ":" + date.getMinutes();
                                    var timeInMS = Helper.getTimeInMilliSeconds(time);
                                    var slotEnd = Helper.getTimeInMilliSeconds(slotEndTime);
                                    if(!isOverLapping){
                                        let daydate = Helper.getDayMonthYearFromDate(day);
                                        let datedate = Helper.getDayMonthYearFromDate(date);
                                        if(daydate === datedate){
                                            if(timeMilli < slotEnd){
                                                slotObject.slots.push({ // push free slot obj
                                                    startTime: slotStartTime,
                                                    endTime: slotEndTime,
                                                    slotType: 'Free',
                                                    slotTiming: consultationSessionTiming,
                                                    preconsultationHours:preconsultationHours,
                                                    preconsultationMins:preconsultationMins
                                                })
                                            }else{
                                                slotStartTime = slotEndTime;
                                                continue
                                            }
                                        }else{
                                            slotObject.slots.push({ // push free slot obj
                                                startTime: slotStartTime,
                                                endTime: slotEndTime,
                                                slotType: 'Free',
                                                slotTiming: consultationSessionTiming,
                                                preconsultationHours:preconsultationHours,
                                                preconsultationMins:preconsultationMins
                                            })
                                        }
                                       
                                    }
                                   
                                }
                                slotStartTime = slotEndTime; // update the next slot start time
                            }
                    //    })
                        }
                        appointmentSlots.push(slotObject);
                    }
                    dayOfWeekCount++; // increase to next  Day
                }
                var res=[];
                var count =0;
                appointmentSlots.forEach((e,iterationNumber) => {
                    if( page*7 <= iterationNumber && count<7){
                        res.push(e);
                        count++;
                    }
                });
                return res;
                //return appointmentSlots;
            } else {
                console.log("Error in appointmentSlotsView api 1")
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
        } catch (e) {
            console.log("Error in appointmentSlotsView api 2", e)
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
    }




    async appointmentReschedule(appointmentDto: any): Promise<any> {
        try {

            const app = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [appointmentDto.appointmentDate, appointmentDto.doctorId]);
            if (app) {
                // // validate with previous data
                let isOverLapping = await this.findTimeOverlapingForAppointments(app, appointmentDto);
                if (isOverLapping) {
                    //return error message
                    return {
                        statusCode: HttpStatus.NOT_FOUND,
                        message: CONSTANT_MSG.TIME_OVERLAP
                    }
                } else {
                    let end = Helper.getTimeInMilliSeconds(appointmentDto.endTime);
                    let start = Helper.getTimeInMilliSeconds(appointmentDto.startTime);
                    let config = Helper.getMinInMilliSeconds(appointmentDto.config.consultationSessionTimings);
                    let endTime = start + config;
                    if(start > end){
                        return{
                            statusCode:HttpStatus.BAD_REQUEST,
                            message:CONSTANT_MSG.INVALID_TIMINGS
                        }
                    }
                    if(endTime !==end){
                        return{
                            statusCode:HttpStatus.BAD_GATEWAY,
                            message:CONSTANT_MSG.END_TIME_MISMATCHING
                        }
                    }
                    //cancelling current appointment
                    var isCancel = await this.appointmentCancel(appointmentDto);
                    if (isCancel.message == CONSTANT_MSG.APPOINT_ALREADY_CANCELLED) {
                        return isCancel;
                    } else {
                        // create appointment on existing date old records
                        const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                        if(!appoint.message){
                            const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                            console.log(appDocConfig);
                            return  {
                                appointment:appoint,
                                appointmentDocConfig:appDocConfig
                            } 
                        }else {
                            return appoint;
                        }
                    }
                    
                }

            }

            const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
            if(!appoint.message){
                const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                console.log(appDocConfig);
                return  {
                    appointment:appoint,
                    appointmentDocConfig:appDocConfig
                } 
            }else {
                return appoint;
            }
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
            console.log(appointmentDetails);
            const pat = await this.patientDetailsRepository.findOne({patientId: appointmentDetails.patientId});
            console.log(pat);
            const pay = await this.paymentDetailsRepository.findOne({appointmentId: id});
            console.log(pay);
            let patient = {
                id: pat.id,
                firstName: pat.firstName,
                lastName: pat.lastName,
                phone: pat.phone,
                email: pat.email
            }
            let res = {
                appointmentDetails: appointmentDetails,
                patientDetails: patient,
                paymentDetails: pay
            }
            return res;
        } catch (e) {
            console.log(e);
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
            var appoint = await this.appointmentRepository.findOne({id: appointmentDto.appointmentId});
            if(appoint.createdBy === CONSTANT_MSG.ROLES.DOCTOR && appoint.paymentOption === 'directPayment'){
                if(!appointmentDto.confirmation){
                    return {
                        statusCode: HttpStatus.BAD_REQUEST,
                        message: CONSTANT_MSG.CONFIRMATION_REQUIRED
                    }
                }
            }
            if (appoint.isCancel == true) {
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.APPOINT_ALREADY_CANCELLED
                }
            }
            var condition = {
                id: appointmentDto.appointmentId
            }
            var values: any = {
                isActive: false,
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
            if (patientDto.phone) {
               // const patientDetails = await this.patientDetailsRepository.find({phone: patientDto.phone});
                const patientDetails = await this.patientDetailsRepository.query(queries.getPatient, [patientDto.phone+'%'])
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

    async patientRegistration(patientDto: PatientDto): Promise<any> {
        return await this.patientDetailsRepository.patientRegistration(patientDto);
    }


    async findDoctorByCodeOrName(codeOrName: any): Promise<any> {
        try {
          //  const name = await this.doctorRepository.findOne({doctorName: codeOrName});
            const name = await this.doctorRepository.query(queries.getDoctorByName, [codeOrName])
            const hospital = await this.accountDetailsRepository.query(queries.getHospitalByName, [codeOrName])
            return {
                doctors:name,
                hospitals:hospital
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
            const patient = await this.patientDetailsRepository.findOne({patientId: patientDto.patientId});
            if (patientDto.phone) {
                let isPhone = await this.isPhoneExists(patientDto.phone);
                if (isPhone.isPhone){
                    if (isPhone.patientDetails.patientId == patientDto.patientId){
                        if (!patient) {
                            return {
                                statusCode: HttpStatus.NO_CONTENT,
                                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                            }
                        } else {
                            var condition = {
                                patientId: patientDto.patientId
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
                    }else{
                         //return error message
                        return {
                            statusCode: HttpStatus.NOT_FOUND,
                            message: CONSTANT_MSG.PHONE_EXISTS
                        }
                    }
                   
                }
            }
            if (!patient) {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            } else {
                var condition1 = {
                    id: patientDto.patientId
                }
                var values: any = patientDto;
                var updatePatientDetails = await this.patientDetailsRepository.update(condition1, values);
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

    async patientPastAppointments(user: any): Promise<any> {
        try {
            let d = new Date();
            var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
            let offset = (user.paginationNumber)*(user.limit);
            const app = await this.appointmentRepository.query(queries.getPastAppointmentsWithPagination, [user.patientId, date,offset,user.limit]);
            if(!app.length){
                return [];
            }
            const appNum = await this.appointmentRepository.query(queries.getPastAppointments, [user.patientId, date]);
            let appNumber = appNum.length;
            console.log(appNumber);
            if (app.length) {
                var appList: any = [];
                for(let appointmentList of app){
                    if (appointmentList.appointment_date == date) {
                        if (appointmentList.is_active == false) {
                            let doctor = await this.doctor_Details(appointmentList.doctorId);
                            let account = await this.accountDetails(doctor.accountKey);
                            let res = {
                                appointmentDate:appointmentList.appointment_date,
                                appointmentId:appointmentList.id,
                                startTime:appointmentList.startTime,
                                endTime:appointmentList.endTime,
                                doctorFirstName:doctor.firstName,
                                doctorLastName:doctor.lastName,
                                hospitalName:account.hospitalName,
                                doctorKey:doctor.doctorKey
                            }
                            appList.push(res);
                        }
                    } else {
                        let doctor = await this.doctor_Details(appointmentList.doctorId);
                        let account = await this.accountDetails(doctor.accountKey);
                        let res = {
                            appointmentDate:appointmentList.appointment_date,
                            appointmentId:appointmentList.id,
                            startTime:appointmentList.startTime,
                            endTime:appointmentList.endTime,
                            doctorFirstName:doctor.firstName,
                            doctorLastName:doctor.lastName,
                            hospitalName:account.hospitalName,
                            doctorKey:doctor.doctorKey
                        }
                        appList.push(res);
                    }
                }
                let result={
                    totalAppointments:appNumber,
                    appointments:appList
                }
                return result;
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

    async patientUpcomingAppointments(user: any): Promise<any> {
        try {
            let d = new Date();
            var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
            let offset = (user.paginationNumber)*(user.limit);
            const app = await this.appointmentRepository.query(queries.getUpcomingAppointmentsWithPagination, [user.patientId, date,offset,user.limit]);
            if(!app.length){
                return [];
            }
            const appNum = await this.appointmentRepository.query(queries.getUpcomingAppointments, [user.patientId, date]);
            let appNumber = appNum.length;
            if (app.length) {
                var appList: any = [];
                for(let appointmentList of app){
                    if (appointmentList.appointment_date == date) {
                        if (appointmentList.is_active == true) {
                            let doctor = await this.doctor_Details(appointmentList.doctorId);
                            let account = await this.accountDetails(doctor.accountKey);
                            let config = await this.getDoctorConfigDetails(doctor.doctorKey);
                            var preConsultationHours = null;
                            var preConsultationMins = null;
                            if(config.isPreconsultationAllowed){
                                preConsultationHours = config.preconsultationHours; 
                                preConsultationMins = config.preconsultationMins; 
                            }
                            let res = {
                                appointmentDate:appointmentList.appointment_date,
                                appointmentId:appointmentList.id,
                                startTime:appointmentList.startTime,
                                endTime:appointmentList.endTime,
                                doctorFirstName:doctor.firstName,
                                doctorLastName:doctor.lastName,
                                hospitalName:account.hospitalName,
                                preConsultationHours:preConsultationHours,
                                preConsultationMins:preConsultationMins,
                                doctorKey:doctor.doctorKey
                            }
                            appList.push(res);
                        }
                    } else {
                        let doctor = await this.doctor_Details(appointmentList.doctorId);
                        let account = await this.accountDetails(doctor.accountKey);
                        let config = await this.getDoctorConfigDetails(doctor.doctorKey);
                        var preConsultationHours = null;
                        var preConsultationMins = null;
                        if(config.isPreconsultationAllowed){
                            preConsultationHours = config.preconsultationHours; 
                            preConsultationMins = config.preconsultationMins; 
                        }
                        let res = {
                            appointmentDate:appointmentList.appointment_date,
                            appointmentId:appointmentList.id,
                            startTime:appointmentList.startTime,
                            endTime:appointmentList.endTime,
                            doctorFirstName:doctor.firstName,
                            doctorLastName:doctor.lastName,
                            hospitalName:account.hospitalName,
                            preConsultationHours:preConsultationHours,
                            preConsultationMins:preConsultationMins,
                            doctorKey:doctor.doctorKey
                        }
                        appList.push(res);
                    }
                }
                let result={
                    totalAppointments:appNumber,
                    appointments:appList
                }
                return result;
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

    async patientList(doctorId:any): Promise<any> {
        const app = await  this.appointmentRepository.query(queries.getAppList,[doctorId]);
        let ids = [];
        app.forEach(a => {
            let flag = false;
            ids.forEach(i => {
                if(i == a.patient_id)
                    flag = true;
            });
            if(flag == false){
                ids.push(a.patient_id)
            }              
        });
        let patientList = [];
        for(let x of ids){
            const patient = await this.patientDetailsRepository.query(queries.getPatientDetails,[x]); 
            patientList.push(patient[0]);
        }
        return patientList;
    }

    async doctorPersonalSettingsEdit(doctorDto: DoctorDto): Promise<any> {
        try {
            var condition = {
                doctorKey: doctorDto.doctorKey
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

    async hospitaldetailsEdit(hospitalDto: HospitalDto): Promise<any> {
        try {
            // update the doctorConfig details
            var condition = {
                accountKey: hospitalDto.accountKey
            }
            var values: any = hospitalDto;
            var updateHospital = await this.accountDetailsRepository.update(condition, values);
            if (updateHospital.affected) {
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

    async viewDoctorDetails(details: any): Promise<any> {
        const doctor = await this.doctorDetails(details.doctorKey);
        const account = await this.accountDetails(doctor.accountKey);
        const app = await this.appointmentDetails(details.appointmentId);
        const config = await this.getDoctorConfigDetails(doctor.doctorKey);
            var res = {
            email:doctor.email,
            mobileNo:doctor.number,
            hospitalName:account.hospitalName,
            location:account.city,
            appointmentDate:app.appointmentDetails.appointmentDate,
            startTime:app.appointmentDetails.startTime,
            endTime:app.appointmentDetails.endTime,
            preConsultationHours:config.preconsultationHours,
            preConsulationMinutes:config.preconsultationMins
        }
        return res;
        
    }

    async availableSlots(user: any): Promise<any> {
        const doctor = await this.doctorDetails(user.doctorKey);
        const app = await this.appointmentRepository.query(queries.getAppointments, [doctor.doctorId, user.appointmentDate]);
        const config = await this.getDoctorConfigDetails(user.doctorKey)
        let days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
        let dt = new Date(user.appointmentDate);
        //let day = days[user.appointmentDate.getDay()]
        let day = days[dt.getDay()]
        const workSchedule = await this.docConfigScheduleDayRepository.query(queries.getSlots,[day,doctor.doctorKey]) 
        if(!workSchedule[0].startTime){
            return [];
        } 
        let slots = [];
        let slotsView = [];
        let consultSession = Helper.getMinInMilliSeconds(config.consultationSessionTimings);
        for(let worksched of workSchedule){
            let start = Helper.getTimeInMilliSeconds(worksched.startTime);
            let end = Helper.getTimeInMilliSeconds(worksched.endTime);
            let end1 = start + consultSession;
            while(start < end && end1 <= end){
                let res = {
                    start:Helper.getTimeinHrsMins(start),
                    end:Helper.getTimeinHrsMins(start + consultSession),
                }
                let flag = false;
                if(app.length){
                    for(let appointment of app){
                        flag = false;
                        let dto={
                            startTime :Helper.getTimeinHrsMins(start),
                            endTime :Helper.getTimeinHrsMins(start + consultSession)
                        }
                        let isOverLapping = await this.findTimeOverlaping(app, dto);
                        if((appointment.startTime == Helper.getTimeinHrsMins(start)) || isOverLapping){
                            flag = true;
                            break;
                        }
                    }
                    if(flag == false){
                        slotsView.push(res);
                    }                        
                }else{
                    slotsView.push(res);
                }
                start = start + consultSession;
                end1 = start + consultSession;
                slots.push(res);
            }
        }
        let date = new Date();
        var time = date.getHours() + ":" + date.getMinutes();
        var timeMilli = Helper.getTimeInMilliSeconds(time);
        let daydate = Helper.getDayMonthYearFromDate(user.appointmentDate);
        let datedate = Helper.getDayMonthYearFromDate(date);
        let i:any;
        let resSlots=[];
        if(daydate == datedate){
            for(i of slotsView){
                let end =Helper.getTimeInMilliSeconds(i.end);
                if(timeMilli<end){
                    resSlots.push(i);
                }
            }
            return resSlots;
        }
       
        return slotsView;
    }

    async patientDetails(patientId:any): Promise<any> {
        const app = await  this.appointmentRepository.query(queries.getAppListForPatient,[patientId]);
        const patient = await this.patientDetailsRepository.query(queries.getPatientDetails,[patientId]); 
        let res = {
            patientDetails:patient[0],
            appointments:app
        }
        return res;
    }

    async reports(accountKey:any,paginationNumber:any): Promise<any> {
        let offset = paginationNumber*10;
        const app = await  this.appointmentRepository.query(queries.getReports,[accountKey,offset]);
        return app;
    }

    async listOfDoctorsInHospital(accountKey:any): Promise<any> {
        const app = await  this.doctorRepository.query(queries.getDocListDetails,[accountKey]);
        let res =[];
        app.forEach(a => {
           let b = {
            doctorId:a.doctorId,
            accountkey:a.account_key,
            doctorKey:a.doctor_key,
            speciality:a.speciality,
            photo:a.photo,
            signature:a.signature,
            number:a.number,
            firstName:a.first_name,
            lastName:a.last_name,
            registrationNumber:a.registration_number,
            fee:a.consultation_cost,
            location:a.city,
            hospitalName:a.hospital_name
            }
            res.push(b);
        });
        
        return res;
    }

    async viewDoctor(details: any): Promise<any> {
        const doctor = await this.doctorDetails(details.doctorKey);
        const account = await this.accountDetails(doctor.accountKey);
        const config = await this.getDoctorConfigDetails(doctor.doctorKey);
        var res = {
            name:doctor.doctorName,
            firstName:doctor.firstName,
            lastName:doctor.lastName,
            speciality:doctor.speciality,
            mobileNo:doctor.number,
            hospitalName:account.hospitalName,
            location:account.city,
            fee:config.consultationCost,
            preConsultationHours:config.preconsultationHours,
            preConsulationMinutes:config.preconsultationMins,
            photo:doctor.photo,
            sessionTiming:config.consultationSessionTimings
        }
        return res;       
    }

    async getPatientDetails(patientId:any){
        const patient = await this.patientDetailsRepository.findOne({patientId:patientId});
        return patient;
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

    async findTimeOverlapingForAppointments(doctorScheduledDays, scheduleTimeInterval): Promise<any> {
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
            if(v.is_cancel == true){
                isOverLapping = false;
            }
        })
        return isOverLapping;
    }


    async isPhoneExists(phone): Promise<any> {
        let isPhone = false;
        const number = await this.patientDetailsRepository.findOne({phone: phone});
        if (number) {
            isPhone = true;
        }
        return {isPhone:isPhone,patientDetails:number};
    }

    
    async isWorkScheduleAvailable(day, workScheduleObj): Promise<any> {
        return workScheduleObj[day].length >= 1 ? true : false;
    }

    async sendAppCreatedEmail(req) {

        var email = req.email;
        var doctorFirstName = req.doctorFirstName;
        var doctorLastName = req.doctorLastName;
        var patientFirstName = req.patientFirstName;
        var patientLastName = req.patientLastName;
        var hospital = req.hospital;
        var startTime = req.startTime;
        var endTime = req.endTime;
        var role = req.role;
        var appointmentId = req.appointmentId;
        var appointmentDate = req.appointmentDate;

         const params:any = {};

         params.subject = 'Appointment Created';
         params.recipient = email;
         params.template = '  <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">New Appointment Created</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user created appointment through VIRUJH. Please find the appointment details Below</div></div>\
             <div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Created By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Email</div><div style="display: inline-block;">: {email}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div  class="reset_titles" style="display: inline-block;">Hospital</div><div style="display: inline-block;">: {hospital}</div></div><br>Thank you</div></div>  ';        //sending Mail to user

        params.template = params.template.replace(/{doctorFirstName}/gi, doctorFirstName);
        params.template = params.template.replace(/{doctorLastName}/gi, doctorLastName);
        params.template = params.template.replace(/{patientFirstName}/gi, patientFirstName);
        params.template = params.template.replace(/{patientLastName}/gi, patientLastName);
        params.template = params.template.replace(/{email}/gi, email);
        params.template = params.template.replace(/{hospital}/gi, hospital);
        params.template = params.template.replace(/{startTime}/gi, startTime);
        params.template = params.template.replace(/{endTime}/gi, endTime);
        params.template = params.template.replace(/{role}/gi, role);
        params.template = params.template.replace(/{appointmentId}/gi, appointmentId);
        params.template = params.template.replace(/{appointmentDate}/gi, appointmentDate);
        try{
            const sendMail = await this.email.sendEmail(params);
            return{
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.MAIL_OK
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
        
}



}

import {HttpStatus, Injectable,Logger} from '@nestjs/common';
import {AppointmentRepository} from './appointment.repository';
import {InjectRepository} from '@nestjs/typeorm';
import {
    AppointmentDto,
    UserDto,
    DoctorConfigPreConsultationDto,
    DoctorConfigCanReschDto,
    DocConfigDto,
    WorkScheduleDto,
    PatientDto, CONSTANT_MSG, queries, DoctorDto, HospitalDto, Email,Sms
} from 'common-dto';
import {Appointment} from './appointment.entity';
import {Doctor} from './doctor/doctor.entity';
import {DoctorRepository} from './doctor/doctor.repository';
import {AccountDetailsRepository} from './account/account.repository';
import {PrescriptionRepository} from './prescription.repository';
import {PatientReportRepository} from './patientReport.repository'
import {AccountDetails} from './account/account_details.entity';
import {DoctorConfigPreConsultationRepository} from './doctorConfigPreConsultancy/doctor_config_preconsultation.repository';
import {DoctorConfigPreConsultation} from './doctorConfigPreConsultancy/doctor_config_preconsultation.entity';
import {DoctorConfigCanReschRepository} from './docConfigReschedule/doc_config_can_resch.repository';
import {DoctorConfigCanResch} from './docConfigReschedule/doc_config_can_resch.entity';
import {docConfigRepository} from "./doc_config/docConfig.repository";
import {docConfig} from "./doc_config/docConfig.entity";
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
import {AppointmentCancelRescheduleRepository} from "./appointmentCancelReschedule/appointmentCancelReschedule.repository";
import {Helper} from "../utility/helper";
import { AnimationFrameScheduler } from 'rxjs/internal/scheduler/AnimationFrameScheduler';
import { AppointmentDocConfigRepository } from "./appointmentDocConfig/appointmentDocConfig.repository";
import * as config from 'config';
import { identity } from 'rxjs';
import { MedicineRepository } from './medicine.repository';
import { FilesInterceptor } from '@nestjs/platform-express';
var async = require('async');
var moment = require('moment');
var fs = require('fs');
var pdf = require('html-pdf');
var moment = require('moment');

@Injectable()
export class AppointmentService {
    mail:any
    parameter:any
    email : Email;
    sms: Sms;
    private logger = new Logger('AppointmentService');
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
        private prescriptionRepository: PrescriptionRepository,
        private patientReportRepository : PatientReportRepository,
        private medicineRepository: MedicineRepository,
        private paymentDetailsRepository: PaymentDetailsRepository,
        private appointmentCancelRescheduleRepository: AppointmentCancelRescheduleRepository,
        private appointmentDocConfigRepository: AppointmentDocConfigRepository,
    ) {
        this.email = new Email();
        this.sms = new Sms();
        // const mail= config.get('mail')
        // const dparams={
        //     smtpUser:this.mail.smtpUser,
        //     smtpPass:this.mail.smtpPass,
        //     smtpHost:this.mail.smtpHost,
        //     smtpPort:this.mail.smtpPort
        // }
        // this.parameter = new Email(dparams);
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
                    let endValue = appointmentDto.endTime === '00:00' ? '24:00' : appointmentDto.endTime;
                    let end = Helper.getTimeInMilliSeconds(endValue);
                    let start = Helper.getTimeInMilliSeconds(appointmentDto.startTime);
                    let config = Helper.getMinInMilliSeconds(appointmentDto.config.consultationSessionTimings);
                    let endTime = start + config;
                    if (start > end) {
                        return {
                            statusCode: HttpStatus.BAD_REQUEST,
                            message: CONSTANT_MSG.INVALID_TIMINGS
                        }
                    }
                    if (endTime !== end) {
                        return {
                            statusCode: HttpStatus.BAD_GATEWAY,
                            message: CONSTANT_MSG.END_TIME_MISMATCHING
                        }
                    }
                    const exist = await this.appointmentRepository.query(queries.getExistAppointment, [appointmentDto.doctorId, appointmentDto.patientId, appointmentDto.appointmentDate])
                    if (exist.length && !appointmentDto.confirmation) {
                        return {
                            statusCode: HttpStatus.EXPECTATION_FAILED,
                            message: CONSTANT_MSG.APPOINT_ALREADY_PRESENT
                        }
                    } else {
                        // create appointment on existing date old records                   
                        const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                        if (!appoint.message) {
                            const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                            console.log(appDocConfig);
                            return {
                                appointment: appoint,
                                appointmentDocConfig: appDocConfig
                            }
                        } else {
                            return appoint;
                        }

                    }
                }
            }else{
                const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                if (!appoint.message) {
                    const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                    console.log(appDocConfig);
                    return {
                        appointment: appoint,
                        appointmentDocConfig: appDocConfig
                    }
                } else {
                    return appoint;
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
            let ids = [];
            doctorList.forEach(a => {
                let flag = false;
                ids.forEach(i => {
                    if (i.doctorId == a.doctorId)
                        flag = true;
                });
                if (flag == false) {
                    ids.push(a)
                }
            });
            let res = [];
            for (let list of ids) {
                var doc = {
                    doctorId: list.doctorId,
                    accountkey: list.account_key,
                    doctorKey: list.doctor_key,
                    speciality: list.speciality,
                    photo: list.photo,
                    signature: list.signature,
                    number: list.number,
                    firstName: list.first_name,
                    lastName: list.last_name,
                    registrationNumber: list.registration_number,
                    fee: list.consultation_cost,
                    location: list.city
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
                    if (i.doctorId == a.doctorId)
                        flag = true;
                });
                if (flag == false) {
                    ids.push(a)
                }
            });
            let res = [];
            for (let list of ids) {
                var doc = {
                    doctorId: list.doctorId,
                    accountkey: list.account_key,
                    doctorKey: list.doctor_key,
                    speciality: list.speciality,
                    photo: list.photo,
                    signature: list.signature,
                    number: list.number,
                    firstName: list.first_name,
                    lastName: list.last_name,
                    registrationNumber: list.registration_number,
                    fee: list.consultation_cost,
                    street: list.street1,
                    city: list.city,
                    state:list.state,
                    pincode:list.pincode,
                    country:list.country,
                    hospitalName: list.hospital_name,
                    experience:list.experience
                }
                res.push(doc);
            }
            if (doctorList.length) {
                res.sort((a, b)=>{
                    if(a.firstName < b.firstName) { return -1; }
                    if(a.firstName > b.firstName) { return 1; }
                    return 0;
                })
                return res;
            } else {
                return [];
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

    async todayAppointments(doctorId, date): Promise<any> {
        const appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctor, [date, doctorId]);
        let apps: any = appointments;
        apps = apps.sort((val1, val2) => {
            let val1IntervalStartTime = val1.startTime;
            let val2IntervalStartTime = val2.startTime;
            val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
            val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
            if (val1IntervalStartTime < val2IntervalStartTime) {
                return -1;
            } else if (val1IntervalStartTime > val2IntervalStartTime) {
                return 1;
            } else {
                return 0;
            }
        })
        return apps;
    }

    async todayAppointmentsForDoctor(doctorId, date): Promise<any> {
        const appointments = await this.appointmentRepository.query(queries.getAppointmentForDoctorAlongWithPatient, [date, doctorId, 'notCompleted', 'paused', 'online']);
        let apps: any = appointments;
        apps = apps.sort((val1, val2) => {
            let val1IntervalStartTime = val1.startTime;
            let val2IntervalStartTime = val2.startTime;
            val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
            val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
            if (val1IntervalStartTime < val2IntervalStartTime) {
                return -1;
            } else if (val1IntervalStartTime > val2IntervalStartTime) {
                return 1;
            } else {
                return 0;
            }
        })
        return apps;
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
                let days =[monday,tuesday,wednesday,thursday,friday,saturday,sunday];
                days.forEach(e => {
                    e = e.sort((val1, val2) => {
                        let val1IntervalStartTime = val1.startTime;
                        let val2IntervalStartTime = val2.startTime;
                        val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
                        val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
                        if (val1IntervalStartTime < val2IntervalStartTime) {
                            return -1;
                        } else if (val1IntervalStartTime > val2IntervalStartTime) {
                            return 1;
                        } else {
                            return 0;
                        }
                    })
                });
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
            let sortArrayForDelete = [];
            let sortArrayForNotDelete = [];
            // this sort array to push isDelete in top order and notIsDelete in lower order
            scheduleTimeIntervals.map(v=>{
                v.isDelete ? sortArrayForDelete.push(v) : sortArrayForNotDelete.push(v);
            })
            scheduleTimeIntervals = [...sortArrayForDelete,...sortArrayForNotDelete ]
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


    async appointmentSlotsView(user: any, type): Promise<any> {
        try {
            const doc = await this.doctorDetails(user.doctorKey);
            let docId = doc.doctorId;
            let page: number = user.paginationNumber;
            //var date = moment().format('YYYY-MM-DD');
            var date: any = new Date();
                
                date.setHours(date.getHours() + 5); 
                date.setMinutes(date.getMinutes() + 30);
                date.setHours(0,0,0,0);
            var startDate: any = date;
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
                        v.endTime === '00:00:00' ? v.endTime = '24:00:00' : '';
                        doctorWorkScheduleObj.monday.push(v);
                    } else if (v.dayOfWeek === 'Tuesday') {
                        v.endTime === '00:00:00' ? v.endTime = '24:00:00' : '';
                        doctorWorkScheduleObj.tuesday.push(v);
                    } else if (v.dayOfWeek === 'Wednesday') {
                        v.endTime === '00:00:00' ? v.endTime = '24:00:00' : '';
                        doctorWorkScheduleObj.wednesday.push(v);
                    } else if (v.dayOfWeek === 'Thursday') {
                        v.endTime === '00:00:00' ? v.endTime = '24:00:00' : '';
                        doctorWorkScheduleObj.thursday.push(v);
                    } else if (v.dayOfWeek === 'Friday') {
                        v.endTime === '00:00:00' ? v.endTime = '24:00:00' : '';
                        doctorWorkScheduleObj.friday.push(v);
                    } else if (v.dayOfWeek === 'Saturday') {
                        v.endTime === '00:00:00' ? v.endTime = '24:00:00' : '';
                        doctorWorkScheduleObj.saturday.push(v);
                    } else if (v.dayOfWeek === 'Sunday') {
                        v.endTime === '00:00:00' ? v.endTime = '24:00:00' : '';
                        doctorWorkScheduleObj.sunday.push(v);
                    }
                })
                const doctorConfigDetails = await this.doctorConfigRepository.findOne({doctorKey: doc.doctorKey});
                let preconsultationHours = doctorConfigDetails.preconsultationHours;
                let preconsultationMins = doctorConfigDetails.preconsultationMins;
                let consultationSessionTiming = doctorConfigDetails.consultationSessionTimings ? doctorConfigDetails.consultationSessionTimings : 10;
                let consultationSessionTimingInMilliSeconds = Helper.getMinInMilliSeconds(doctorConfigDetails.consultationSessionTimings ? doctorConfigDetails.consultationSessionTimings : 10);
                let appointmentSlots = [];
                let dayOfWeekCount = 0;
                let breaktheloop = 0;
                while (appointmentSlots.length <= page * 7 + 7) {
                    breaktheloop++;
                    //if (breaktheloop > 20) break;
                    // run while loop to get minimum 7  days of appointment slots
                    let day = new Date(startDate.getTime() + (dayOfWeekCount * 24 * 60 * 60 * 1000)); // increase the day one by one in loop
                    //let day = moment(startDate,'YYYY-MM-DD').add(dayOfWeekCount, 'days').format()
                    //let day = new Date(startDate.valueOf() + (dayOfWeekCount * 24 * 60 * 60 * 1000));
                    //let dayOfWeek = moment(day).day();
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
                            val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
                            val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
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
                        var time = hour + ":" + minutes;
                        //var time = moment().format("HH:mm:ss");
                        var timeMilli = Helper.getTimeInMilliSeconds(time);
                        // In below code => an doctor can have  many intervals on particular day, so run in loop the interval
                        //sortedWorkScheduleTimeInterval.forEach(v => {
                        for (let v of sortedWorkScheduleTimeInterval) {
                            let intervalEndTime = v.endTime;
                            let intervalEnd = false;
                            let slotStartTime = v.startTime;
                            let breaktheloop2 = 0;
                            while (!intervalEnd) {  // until the interval endTime comes run the while loop
                                breaktheloop2++;
                               // if (breaktheloop2 > 10) break;
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
                                    //let appDate = moment(v.appointment_date).format('YYYY-MM-DD');
                                    let compareDate = Helper.getDayMonthYearFromDate(day);
                                    //let compareDate = moment(day).format('YYYY-MM-DD');
                                    return appDate === compareDate;
                                })
                                let slotPresentOrNot = appointmentPresentOnThisDate.filter(v => {
                                    let startTimeInMilliSec = Helper.getTimeInMilliSeconds(v.startTime);
                                    let endTimeInMilliSec = Helper.getTimeInMilliSeconds(v.endTime);
                                    let slotStartTimeInMilliSec = Helper.getTimeInMilliSeconds(slotStartTime);
                                    let slotEndTimeInMilliSec = Helper.getTimeInMilliSeconds(slotEndTime);
                                    // if((slotStartTimeInMilliSec<startTimeInMilliSec && endTimeInMilliSec<=slotEndTimeInMilliSec)||(slotStartTimeInMilliSec >= startTimeInMilliSec && slotStartTimeInMilliSec < endTimeInMilliSec)||(slotEndTimeInMilliSec <= endTimeInMilliSec && slotEndTimeInMilliSec > startTimeInMilliSec)||(slotStartTimeInMilliSec === startTimeInMilliSec && slotEndTimeInMilliSec === endTimeInMilliSec)&& (!v.is_cancel)) {
                                    if (((startTimeInMilliSec <= slotStartTimeInMilliSec && endTimeInMilliSec <= slotEndTimeInMilliSec && slotStartTimeInMilliSec >= startTimeInMilliSec && slotEndTimeInMilliSec > startTimeInMilliSec) || (slotStartTimeInMilliSec <= startTimeInMilliSec && slotEndTimeInMilliSec <= endTimeInMilliSec && startTimeInMilliSec > slotEndTimeInMilliSec && slotStartTimeInMilliSec < endTimeInMilliSec) || (startTimeInMilliSec <= slotStartTimeInMilliSec && slotEndTimeInMilliSec <= endTimeInMilliSec) || (slotStartTimeInMilliSec >= startTimeInMilliSec && slotEndTimeInMilliSec <= endTimeInMilliSec)) && (!v.is_cancel)) {
                                        // if ((startTimeInMilliSec === slotStartTimeInMilliSec) && (!v.is_cancel)) {  // if any appointment present then push the booked appointment slots
                                        //let daydate = moment(v.appointment_date).format('YYYY-MM-DD');
                                        let daydate = Helper.getDayMonthYearFromDate(v.appointment_date);
                                        //let datedate = moment(date).format('YYYY-MM-DD');
                                        let datedate = Helper.getDayMonthYearFromDate(date);
                                        if (daydate == datedate) {
                                            // if(v.appointmentDate == date){
                                            if (timeMilli < startTimeInMilliSec) {
                                                v.slotType = 'Booked';
                                                v.preconsultationHours = preconsultationHours;
                                                v.preconsultationMins = preconsultationMins;
                                                // v.slotTiming = consultationSessionTiming;
                                                let flag = false;
                                                for (let i of slotObject.slots) {
                                                    if (i.id == v.id) {
                                                        flag = true;
                                                    }
                                                }
                                                if (flag == false) {
                                                    slotObject.slots.push(v)
                                                    return true;
                                                }

                                            } else {
                                                return false;
                                            }

                                        } else {
                                            v.slotType = 'Booked';
                                            v.preconsultationHours = preconsultationHours;
                                            v.preconsultationMins = preconsultationMins;
                                            // v.slotTiming = consultationSessionTiming;
                                            let flag = false;
                                            for (let i of slotObject.slots) {
                                                if (i.id == v.id) {
                                                    flag = true;
                                                }
                                            }
                                            if (flag == false) {
                                                slotObject.slots.push(v)
                                                return true;
                                            }

                                        }
                                    } else {
                                        return false;
                                    }
                                })
                                if (!slotPresentOrNot.length) { // if no appointment present on the slot timing, then push the free slots
                                    let dto = {
                                        startTime: slotStartTime,
                                        endTime: slotEndTime,
                                    }
                                    let isOverLapping = await this.findTimeOverlapingForAppointments(appointmentPresentOnThisDate, dto);
                                    var time = date.getHours() + ":" + date.getMinutes();
                                    //var time = moment().format("HH:mm:ss");
                                    var timeInMS = Helper.getTimeInMilliSeconds(time);
                                    var slotEnd = Helper.getTimeInMilliSeconds(slotEndTime);
                                    if (!isOverLapping) {
                                        //let daydate = moment(day).format('YYYY-MM-DD');
                                        let daydate = Helper.getDayMonthYearFromDate(day);
                                        //let datedate = moment(date).format('YYYY-MM-DD');
                                        let datedate = Helper.getDayMonthYearFromDate(date);
                                        if (daydate === datedate) {
                                            if (timeMilli < slotEnd) {
                                                slotObject.slots.push({ // push free slot obj
                                                    startTime: slotStartTime,
                                                    endTime: slotEndTime,
                                                    slotType: 'Free',
                                                    slotTiming: consultationSessionTiming,
                                                    preconsultationHours: preconsultationHours,
                                                    preconsultationMins: preconsultationMins
                                                })
                                            } else {
                                                slotStartTime = slotEndTime;
                                                continue
                                            }
                                        } else {
                                            slotObject.slots.push({ // push free slot obj
                                                startTime: slotStartTime,
                                                endTime: slotEndTime,
                                                slotType: 'Free',
                                                slotTiming: consultationSessionTiming,
                                                preconsultationHours: preconsultationHours,
                                                preconsultationMins: preconsultationMins
                                            })
                                        }

                                    }

                                }

                                slotObject.slots = slotObject.slots.sort((val1, val2) => {
                                    let val1IntervalStartTime = val1.startTime;
                                    let val2IntervalStartTime = val2.startTime;
                                    val1IntervalStartTime = Helper.getTimeInMilliSeconds(val1IntervalStartTime);
                                    val2IntervalStartTime = Helper.getTimeInMilliSeconds(val2IntervalStartTime);
                                    if (val1IntervalStartTime < val2IntervalStartTime) {
                                        return -1;
                                    } else if (val1IntervalStartTime > val2IntervalStartTime) {
                                        return 1;
                                    } else {
                                        return 0;
                                    }
                                })
                                slotStartTime = slotEndTime; // update the next slot start time
                                // breaktheloop2++;
                                // if(breaktheloop2 > 10) break;
                                if(slotEndTime >= intervalEndTime) break;
                            }
                            //    })
                        }
                        if (slotObject.slots && slotObject.slots.length) {
                            appointmentSlots.push(slotObject);
                        }
                        
                    }
                    dayOfWeekCount++; // increase to next  Day
                    breaktheloop++;
                    //if(breaktheloop > 20) break;
                    if(appointmentSlots.length > page*7+7) break;
                }
                var res = [];
                var count = 0;
                appointmentSlots.forEach((e, iterationNumber) => {
                    if (page * 7 <= iterationNumber && count < 7) {
                        res.push(e);
                        count++;
                    }
                });
                return res;
                //return appointmentSlots;
            } else {
                if (type === 'todaysAvailabilitySeats') {
                    return [];
                } else {
                    return {
                        statusCode: HttpStatus.NO_CONTENT,
                        message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                    }
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
            if (app.length) {
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
                    if (start > end) {
                        return {
                            statusCode: HttpStatus.BAD_REQUEST,
                            message: CONSTANT_MSG.INVALID_TIMINGS
                        }
                    }
                    if (endTime !== end) {
                        return {
                            statusCode: HttpStatus.BAD_GATEWAY,
                            message: CONSTANT_MSG.END_TIME_MISMATCHING
                        }
                    }
                    //cancelling current appointment
                    var isCancel = await this.appointmentCancel(appointmentDto);
                    if (isCancel.statusCode != HttpStatus.OK) {
                        return isCancel;
                    } else {
                        // create appointment on existing date old records
                        const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                        if (!appoint.message) {
                            const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
                            return {
                                appointment: appoint,
                                appointmentDocConfig: appDocConfig
                            }
                        } else {
                            return appoint;
                        }
                    }

                }

            }
            //cancelling current appointment
            var isCancel = await this.appointmentCancel(appointmentDto);
            if (isCancel.statusCode != HttpStatus.OK) {
                return isCancel;
            } else {
                const appoint = await this.appointmentRepository.createAppointment(appointmentDto);
                if (!appoint.message) {
                    const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);

                    return {
                        appointment: appoint,
                        appointmentDocConfig: appDocConfig
                    }
                } else {
                    return appoint;
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

    async getprescriptionUrl(id: any) : Promise<any> {
        try {
            const prescriptionDetails = await this.prescriptionRepository.find({appointmentId: id});
            let prescriptionUrl = [];
            if (prescriptionDetails && prescriptionDetails.length) {

                for(let i = 0; i < prescriptionDetails.length; i++) {
                    prescriptionUrl.push(prescriptionDetails[i].prescriptionUrl);
                }
            }

            return prescriptionUrl;
        }

        catch(e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }
    async appointmentDetails(id: any): Promise<any> {
        try {
            const appointmentDetails = await this.appointmentRepository.findOne({ id: id });
            const pat = await this.patientDetailsRepository.findOne({ patientId: appointmentDetails.patientId });
            const docId = await this.doctorRepository.findOne({ doctorId: appointmentDetails.doctorId }) 
            const pay = await this.paymentDetailsRepository.findOne({ appointmentId: id });
            // get patient report


            
            const reports=[];
             if(appointmentDetails.reportid){   
                const reportIds=appointmentDetails.reportid.split(',');
            reportIds.map(async id=>{
                const report = await this.patientReportRepository.findOne({
                    
                    where: {
                        id: parseInt(id),
                        active:true
                    }
                    });
                    if(report)
                        reports.push(report);

            })
            
        }
            
            
            let patient = {
                id: pat.id,
                firstName: pat.firstName,
                lastName: pat.lastName,
                phone: pat.phone,
                email: pat.email
            }
            let doctorId = {
                doctorKey: docId.doctorKey,
                accountKey: docId.accountKey,
                email: docId.email,
                doctorLiveStatus: docId.liveStatus,
                firstName: docId.firstName,
                lastName: docId.lastName,
                photo: docId.photo,
                speciality: docId.speciality,
                doctorId: docId.doctorId,

            }
            let res = {
                appointmentDetails: appointmentDetails,
                patientDetails: patient,
                paymentDetails: pay,
                reportDetails: reports,
                DoctorDetails: doctorId,

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
            if (appoint.createdBy === CONSTANT_MSG.ROLES.DOCTOR && appoint.paymentOption === 'directPayment') {
                if (!appointmentDto.confirmation) {
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
                const patientDetails = await this.patientDetailsRepository.query(queries.getPatient, [patientDto.phone + '%'])
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
        const patient = await this.patientDetailsRepository.patientRegistration(patientDto);
        return patient;
        // return await this.patientDetailsRepository.patientRegistration(patientDto);
    }


    async findDoctorByCodeOrName(codeOrName: any): Promise<any> {
        try {
            //  const name = await this.doctorRepository.findOne({doctorName: codeOrName});
            let codeOrNameTime = codeOrName ? codeOrName.trim() : codeOrName;
            const name = await this.doctorRepository.query(queries.getDoctorByName, ['%'+codeOrNameTime+'%'])
            const hospital = await this.accountDetailsRepository.query(queries.getHospitalByName, [codeOrName])

            name.sort((a, b)=>{
                if(a.firstName < b.firstName) { return -1; }
                if(a.firstName > b.firstName) { return 1; }
                return 0;
            })
            return {
                doctors: name,
                hospitals: hospital
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
                if (isPhone.isPhone) {
                    if (isPhone.patientDetails.patientId == patientDto.patientId) {
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
                    } else {
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
                    patientId: patientDto.patientId
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
            //var date = moment().format('YYYY-MM-DD');
            var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
            let offset = (user.paginationNumber) * (user.limit);
            const app = await this.appointmentRepository.query(queries.getPastAppointmentsWithPagination, [user.patientId, date, offset, user.limit,'completed']);
            if (!app.length) {
                return [];
            }
            const appNum = await this.appointmentRepository.query(queries.getPastAppointments, [user.patientId, date,'completed']);
            let appNumber = appNum.length;
            if (app.length) {
                var appList: any = [];
                for (let appointmentList of app) {
                    if (appointmentList.appointment_date == date) {
                        if (appointmentList.is_active == false) {
                            let doctor = await this.doctor_Details(appointmentList.doctorId);
                            let account = await this.accountDetails(doctor.accountKey);
                            let res = {
                                appointmentDate: appointmentList.appointment_date,
                                appointmentId: appointmentList.id,
                                startTime: appointmentList.startTime,
                                endTime: appointmentList.endTime,
                                doctorFirstName: doctor.firstName,
                                doctorLastName: doctor.lastName,
                                hospitalName: account.hospitalName,
                                doctorKey: doctor.doctorKey
                            }
                            appList.push(res);
                        }
                    } else {
                        let doctor = await this.doctor_Details(appointmentList.doctorId);
                        let account = await this.accountDetails(doctor.accountKey);
                        let res = {
                            appointmentDate: appointmentList.appointment_date,
                            appointmentId: appointmentList.id,
                            startTime: appointmentList.startTime,
                            endTime: appointmentList.endTime,
                            doctorFirstName: doctor.firstName,
                            doctorLastName: doctor.lastName,
                            hospitalName: account.hospitalName,
                            doctorKey: doctor.doctorKey
                        }
                        appList.push(res);
                    }
                }
                let result = {
                    totalAppointments: appNumber,
                    appointments: appList
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
            //var date = moment().format('YYYY-MM-DD');
            let offset = (user.paginationNumber) * (user.limit);

            let app;        
            this.logger.log("patientUpcomingAppointments Query >>> " + date + ", offset:"+offset);

            if (user.limit) {
                this.logger.log("patientUpcomingAppointments Query 1 >>> " + queries.getUpcomingAppointmentsWithPagination);

                app = await this.appointmentRepository.query(queries.getUpcomingAppointmentsWithPagination, [user.patientId, date, offset, user.limit, 'notCompleted', 'paused']);
                if (!app.length) {
                    return [];
                }
            } else {
                this.logger.log("patientUpcomingAppointments Query 2 >>> " + queries.getTodayAppointments);
                app = await this.appointmentRepository.query(queries.getTodayAppointments, [user.patientId, date, 'notCompleted', 'paused']);
                if (!app.length) {
                    return [];
                }
            }
            this.logger.log("patientUpcomingAppointments Query 3 >>> " + queries.getUpcomingAppointmentsCounts);
            const appNum = await this.appointmentRepository.query(queries.getUpcomingAppointmentsCounts, [user.patientId, date, 'notCompleted', 'paused']);
            let appNumber = appNum.length;
            if (app.length) {
                var appList: any = [];
                for (let appointmentList of app) {
                    if (appointmentList.appointment_date == date) {
                        if (appointmentList.is_active == true) {
                            let doctor = await this.doctor_Details(appointmentList.doctorId);
                            let account = await this.accountDetails(doctor.accountKey);
                            let config = await this.getAppDoctorConfigDetails(appointmentList.id);
                            var preConsultationHours = null;
                            var preConsultationMins = null;
                            if (config.isPreconsultationAllowed) {
                                preConsultationHours = config.preconsultationHours;
                                preConsultationMins = config.preconsultationMins;
                            }

                            let res = {
                                appointmentDate: appointmentList.appointment_date,
                                appointmentId: appointmentList.id,
                                startTime: appointmentList.startTime,
                                endTime: appointmentList.endTime,
                                doctorFirstName: doctor.firstName,
                                doctorLastName: doctor.lastName,
                                hospitalName: account.hospitalName,
                                preConsultationHours: preConsultationHours,
                                preConsultationMins: preConsultationMins,
                                doctorId: appointmentList.doctorId,
                                doctorKey: doctor.doctorKey,
                                liveStatus : doctor.liveStatus
                            }
                            appList.push(res);
                        }
                    } else {
                        let doctor = await this.doctor_Details(appointmentList.doctorId);
                        let account = await this.accountDetails(doctor.accountKey);
                        let config = await this.getAppDoctorConfigDetails(appointmentList.id);
                        var preConsultationHours = null;
                        var preConsultationMins = null;
                        if (config && config.isPatientPreconsultationAllowed) {
                            preConsultationHours = config.preconsultationHours;
                            preConsultationMins = config.preconsultationMinutes;
                        }

                        let res = {
                            appointmentDate: appointmentList.appointment_date,
                            appointmentId: appointmentList.id,
                            startTime: appointmentList.startTime,
                            endTime: appointmentList.endTime,
                            doctorFirstName: doctor.firstName,
                            doctorLastName: doctor.lastName,
                            hospitalName: account.hospitalName,
                            preConsultationHours: preConsultationHours,
                            preConsultationMins: preConsultationMins,
                            doctorId: appointmentList.doctorId,
                            doctorKey: doctor.doctorKey,
                            liveStatus : doctor.liveStatus
                        }
                        appList.push(res);
                    }
                }
                let result = {
                    totalAppointments: appNumber,
                    appointments: appList
                }
                return result;
            } else {
                return {
                    statusCode: HttpStatus.NO_CONTENT,
                    message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
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

    async patientList(doctorId: any,paginationNumber:any): Promise<any> {
        const app = await this.appointmentRepository.query(queries.getAppList, [doctorId]);
        let ids = [];
        app.forEach(a => {
            let flag = false;
            ids.forEach(i => {
                if (i == a.patient_id)
                    flag = true;
            });
            if (flag == false) {
                ids.push(a.patient_id)
            }
        });
        let patientList = [];
        let pag:number = paginationNumber;
        let m:number = pag*15;
        var n:number =  (pag*15)+15;
        var pats =[];
        for (var i = m; i < n; i++){
            pats.push(ids[i]);
        }
        // for (let x of ids) {
        //     const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [x]);
        //     if(patient[0]){
        //         patientList.push(patient[0]);
        //     }
        // }
        for (let x of pats) {
            const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [x]);
            if(patient[0]){
                patientList.push(patient[0]);
            }
        }
        return {totalPatients:ids.length,
            patientsList:patientList};
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

        const app = await this.appointmentDetails(details.appointmentId);
        const doctor = app.DoctorDetails;
        const d1 = await this.doctorDetails(doctor.doctorKey);
        const account = await this.accountDetails(doctor.accountKey);
        const config = await this.getAppDoctorConfigDetails(details.appointmentId);
        const patient = await this.getPatientDetails(app.appointmentDetails.patientId);
        const prescriptionUrl = await this.getprescriptionUrl(details.appointmentId);

        let preHours = null;
        let preMins = null;
        let canDays = null;
        let canHours = null;
        let canMins = null;
        let reschDays = null;
        let reschHours = null;
        let reschMins = null;
        if (config.isPatientPreconsultationAllowed) {
            preHours = config.preconsultationHours;
            preMins = config.preconsultationMinutes;
        }
        if (config.isPatientCancellationAllowed) {
            canDays = config.cancellationDays;
            canHours = config.cancellationHours;
            canMins = config.cancellationMinutes;
        }
        if (config.isPatientRescheduleAllowed) {
            reschDays = config.rescheduleDays;
            reschHours = config.rescheduleHours;
            reschMins = config.rescheduleMinutes;
        }
        var res = {
            appointmentId: details.appointmentId,
            doctorKey: details.doctorKey,
            reportDetail: app.reportDetails,
            email: doctor.email,
            doctorPhoto:doctor.photo,
            speciality:doctor.speciality,
            consultationTimeSlot: app.appointmentDetails.slotTiming,
            mobileNo: doctor.number,
            hospitalName: account.hospitalName,
            street:account.street1,
            city: account.city,
            state:account.state,
            pincode:account.pincode,
            country:account.country,
            appointmentDate: app.appointmentDetails.appointmentDate,
            startTime: app.appointmentDetails.startTime,
            endTime: app.appointmentDetails.endTime,
            preConsultationHours: preHours,
            preConsulationMinutes: preMins,
            cancellationDays: canDays,
            cancellationHours: canHours,
            cancellationMins: canMins,
            rescheduleDays: reschDays,
            rescheduleHours: reschHours,
            rescheduleMins: reschMins,
            doctorId: doctor.doctorId,
            patientId: app.appointmentDetails.patientId,
            doctorFirstName: doctor.firstName,
            doctorLastName: doctor.lastName,
            patientFirstName: patient.firstName,
            patientLastName: patient.lastName,
            doctorLiveStatus: doctor.liveStatus,
            prescriptionUrl: prescriptionUrl,
        }
        return res;

    }

    async availableSlots(user: any, type: string): Promise<any> {
        const doctor = await this.doctorDetails(user.doctorKey);
        const app = await this.appointmentRepository.query(queries.getAppointments, [doctor.doctorId, user.appointmentDate]);
       
        const config = await this.getDoctorConfigDetails(user.doctorKey)
        let days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        let dt = new Date(user.appointmentDate);
        //let day = days[user.appointmentDate.getDay()]
        let day = days[dt.getDay()]
        user.paginationNumber=0;

        // find today availablity seates
        let slotsviews = await this.appointmentSlotsView(user, 'todaysAvailabilitySeats');
        let slotview;

    //    for(let j=0;j<slotsviews.length;j++){
        if(slotsviews && slotsviews.length && typeof slotsviews === 'object'
        && !slotsviews.statusCode
         && slotsviews[0].dayOfWeek.toLowerCase() === day.toLowerCase()){
            slotview=slotsviews[0];
            // break;
        } else if (!type && type !== 'doctorList') {

            for(let j=0;j<slotsviews.length;j++){

                if(slotsviews[j].dayOfWeek.toLowerCase() === day.toLowerCase()){
                
                slotview=slotsviews[j];
                
                break;
                }
            }
        }

    //    }
       let date = new Date();
       var time = date.getHours() + ":" + date.getMinutes();
       var timeMilli = Helper.getTimeInMilliSeconds(time);
       let resSlot=[];
       let dateForm = Helper.getDayMonthYearFromDate(date);
       let dtForm = Helper.getDayMonthYearFromDate(dt);

       if(slotview !== undefined)
       if(dateForm == dtForm){
        for(let j=0;j<slotview.slots.length;j++){
            let end = Helper.getTimeInMilliSeconds(slotview.slots[j].endTime);
            if((slotview.slots[j].slotType.toLowerCase() == 'free') && timeMilli < end){
                resSlot.push(slotview.slots[j]);
            }
        }
       } else {
            for(let j=0;j<slotview.slots.length;j++){
                if(slotview.slots[j].slotType.toLowerCase() == 'free'){
                    resSlot.push(slotview.slots[j]);
                }
            }
        }
       return resSlot;
    }

    async patientDetails(patientId: any): Promise<any> {
        const app = await this.appointmentRepository.query(queries.getAppListForPatient, [patientId]);
        const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [patientId]);
        let res = {
            patientDetails: patient[0],
            appointments: app
        }
        return res;
    }

    async reports(accountKey: any, paginationNumber: any): Promise<any> {
        let offset = paginationNumber * 10;
        const app = await this.appointmentRepository.query(queries.getReports, [accountKey, offset]);
        return app;
    }

    async listOfDoctorsInHospital(accountKey: any): Promise<any> {
        const app = await this.doctorRepository.query(queries.getDocListDetails, [accountKey]);
        let res = [];
        app.forEach(a => {
            let b = {
                doctorId: a.doctorId,
                accountkey: a.account_key,
                doctorKey: a.doctor_key,
                speciality: a.speciality,
                photo: a.photo,
                signature: a.signature,
                number: a.number,
                firstName: a.first_name,
                lastName: a.last_name,
                registrationNumber: a.registration_number,
                fee: a.consultation_cost,
                street: a.street1,
                city:a.city,
                state:a.state,
                pincode:a.pincode,
                country:a.country,
                hospitalName: a.hospital_name,
                experience:a.experience
            }
            res.push(b);
        });

        return res;
    }

    async viewDoctor(details: any): Promise<any> {
        const doctor = await this.doctorDetails(details.doctorKey);
        const account = await this.accountDetails(doctor.accountKey);
        const config = await this.getDoctorConfigDetails(doctor.doctorKey);
        let preHours;
        let preMins;
        let canDays;
        let canHours;
        let canMins;
        let reschDays;
        let reschHours;
        let reschMins;
        if (config.isPreconsultationAllowed) {
            preHours = config.preconsultationHours;
            preMins = config.preconsultationMins;
        }
        if (config.isPatientCancellationAllowed) {
            canDays = config.cancellationDays;
            canHours = config.cancellationHours;
            canMins = config.cancellationMins;
        }
        if (config.isPatientRescheduleAllowed) {
            reschDays = config.rescheduleDays;
            reschHours = config.rescheduleHours;
            reschMins = config.rescheduleMins;
        }
        var res = {
            name: doctor.doctorName,
            firstName: doctor.firstName,
            lastName: doctor.lastName,
            speciality: doctor.speciality,
            mobileNo: doctor.number,
            hospitalName: account.hospitalName,
            street:account.street1,
            city: account.city,
            pincode:account.pincode,
            state:account.state,
            country:account.country,
            fee: config.consultationCost,
            preConsultationHours: preHours,
            preConsulationMinutes: preMins,
            cancellationHours: canHours,
            cancellationDays: canDays,
            cancellationMins: canMins,
            rescheduleDays: reschDays,
            rescheduleHours: reschHours,
            rescheduleMins: reschMins,
            photo: doctor.photo,
            sessionTiming: config.consultationSessionTimings
        }
        return res;
    }

    async getPatientDetails(patientId: any) {
        const patient = await this.patientDetailsRepository.findOne({patientId: patientId});
        return patient;
    }

    async getAppDoctorConfigDetails(appointmentId): Promise<any> {
        return await this.appointmentDocConfigRepository.findOne({appointmentId: appointmentId});
    }

    async detailsOfPatient(patientId: any): Promise<any> {
        const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [patientId]);
        let patientDetails = patient[0];
        patientDetails["description"] = "";
        patientDetails["allergiesList"] = [];
        return patientDetails;
    }

    async patientUpcomingAppointmentsForDoctor(user: any): Promise<any> {
        const doc = await this.doctorDetails(user.patientDto.doctorKey);
        const d: Date = new Date();
        let app =[];
        let res=[];
        var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
        //var date = moment().format('YYYY-MM-DD');
        if (user.patientDto.paginationNumber) {
            let offset = (user.paginationNumber) * (10);
            app = await this.appointmentRepository.query(queries.getUpcomingAppointmentsForPatient, [user.patientDto.patientId, date, offset, doc.doctorId, 'notCompleted', 'paused']);
        } else {
            app = await this.appointmentRepository.query(queries.getAppDoctorList, [doc.doctorId, user.patientDto.patientId, date, 'notCompleted', 'paused'])
        }
        for(let x of app){
            let time = null;
            let preHours = 0;
            let preMins = 0;
            if(x.is_preconsultation_allowed){
                if(x.pre_consultation_hours){
                    preHours = x.pre_consultation_hours;
                }
                if(x.pre_consultation_mins){
                    preMins = x.pre_consultation_mins;
                }
                time = preHours*60 + preMins;
            }
            let result ={
                appointmentId:x.appointmentId,
                appointmentDate:x.appointmentDate,
                isPreconsultationAllowed:x.is_preconsultation_allowed,
                preConsultationTime:time,
                doctorId:x.doctorId,
                doctorFirstName:x.doctorFirstName,
                doctorLastName:x.doctorLastName,
                patientId:x.patientId,
                startTime:x.startTime,
                endTime:x.endTime,
                hospitalName:x.hospitalName
            }
            res.push(result);
        }
        return res;
    }

    async patientPastAppointmentsForDoctor(user: any): Promise<any> {
        const doc = await this.doctorDetails(user.patientDto.doctorKey);
        const d: Date = new Date();
        var date = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
        //var date = moment().format('YYYY-MM-DD');
        if (user.patientDto.paginationNumber) {
            let offset = (user.paginationNumber) * (10);
            const app = await this.appointmentRepository.query(queries.getPastAppointmentsForPatient, [user.patientDto.patientId, date, offset, doc.doctorId, 'completed']);
            return app;
        } else {
            const app = await this.appointmentRepository.query(queries.getPastAppDoctorList, [doc.doctorId, user.patientDto.patientId, date, 'completed'])
            return app;
        }
    }

    async updatePatOnline(patientId): Promise<any> {
        var condition: any = {
            patientId: patientId
        }
        let dto = {
            liveStatus: 'online'
        }
        var values: any = dto;
        return await this.patientDetailsRepository.update(condition, values);
    }

    async updatePatOffline(patientId): Promise<any> {
        var condition: any = {
            patientId: patientId
        }
        let dto = {
            liveStatus: 'offline'
        }
        var values: any = dto;
        return await this.patientDetailsRepository.update(condition, values);
    }

    async updatePatLastActive(patientId): Promise<any> {
        //let date = moment().format();
        let date = new Date();
        var condition: any = {
            patientId: patientId
        }
        let dto = {
            lastActive: date
        }
        var values: any = dto;
        return await this.patientDetailsRepository.update(condition, values);
    }

    async updateDocOnline(doctorKey): Promise<any> {
        var condition: any = {
            doctorKey: doctorKey
        }
        let dto = {
            liveStatus: 'online'
        }
        var values: any = dto;
        console.log('updateDocOnline status ', {condition: condition, values: values});

        let docOnlineStatus = await this.doctorRepository.update(condition, values);
        console.log('updateDocOnline status ', docOnlineStatus);

        return docOnlineStatus;
    }

    async updateDocOffline(doctorKey): Promise<any> {
        var condition: any = {
            doctorKey: doctorKey
        }
        let dto = {
            liveStatus: 'offline'
        }
        var values: any = dto;
        return await this.doctorRepository.update(condition, values);
    }

    async updateDocLastActive(doctorKey): Promise<any> {
        //let date = moment().format();
        let date = new Date();
        var condition: any = {
            doctorKey: doctorKey
        }
        let dto = {
            lastActive: date
        }
        var values: any = dto;
        return await this.doctorRepository.update(condition, values);
    }


    async patientGeneralSearch(patientSearch: any, doctorId: any): Promise<any> {
        try {
            const app = await this.appointmentRepository.query(queries.getPatientDoctorApps, [doctorId, patientSearch]);
            let ids = [];
            app.forEach(a => {
                let flag = false;
                ids.forEach(i => {
                    if (i.patient_id == a.patient_id)
                        flag = true;
                });
                if (flag == false) {
                    ids.push(a)
                }
            });
            return ids;
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }

    }

    async updateDoctorAndPatientStatus(role: string, id: string, status: string) {

        if (role === CONSTANT_MSG.ROLES.DOCTOR) {
            const doc = await this.doctorRepository.findOne({doctorKey: id});
            if (doc) {
                doc.liveStatus = status;
                //doc.lastActive = moment().format();
                doc.lastActive = new Date();
                await this.doctorRepository.save(doc)
            }
        } else if (role === CONSTANT_MSG.ROLES.PATIENT) {
            const patient = await this.patientDetailsRepository.findOne({patientId: Number(id)});
            if (patient) {
                patient.liveStatus = status;
                //patient.lastActive = moment().format()
                patient.lastActive = new Date();
                await this.patientDetailsRepository.save(patient);
            }

        }

    }

    async accountPatientList(accountKey: any): Promise<any> {
        const doctorId = await this.doctorRepository.find({accountKey: accountKey});
        let app = [];
        for (let m of doctorId) {
            const app1 = await this.appointmentRepository.query(queries.getAccountAppList, [m.doctorId]);
            app = app.concat(app1)
        }
        let ids = [];
        app.forEach(a => {
            let flag = false;
            ids.forEach(i => {
                if (i == a.patient_id)
                    flag = true;
            });
            if (flag == false) {
                ids.push(a.patient_id)
            }
        });
        let patientList = [];
        for (let x of ids) {
            const patient = await this.patientDetailsRepository.query(queries.getPatientDetails, [x]);
            patientList.push(patient[0]);
        }
        return patientList;
    }

    async tableDataView(accountDto: any): Promise<any> {
        let tab: string = accountDto.table
        const doctor = await this.accountDetailsRepository.query(queries.getTableData+tab,[]);
        return doctor;
    }
    
    async tableDataDelete(accountDto: any): Promise<any> {
        let pre = 'DELETE FROM "'+accountDto.table +'" WHERE "'+accountDto.column+'" = '+accountDto.id
        const doctor = await this.accountDetailsRepository.query(pre);
        return doctor;
    }

    async appointmentPresentOnDate(user:any): Promise<any> {
        const exist = await this.appointmentRepository.query(queries.getExistAppointment, [user.doctorId, user.patientId, user.appointmentDate])
        if (exist.length) {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.APPOINT_ALREADY_PRESENT
            }
        }else{
            return {
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.NO_APPOINT_PRESENT
            }
        } 
     }

     async doctorRegistration(doctorDto: DoctorDto): Promise<any> {
        const doctor = await this.doctorRepository.doctorRegistration(doctorDto);
        if(doctor){
            // add config details
            const config = await this.doctorConfigRepository.doctorConfigSetup(doctor, doctorDto)
            return doctor;
        } else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.DOC_REG_FAIL
            };
        }
        
    }

    async accountdetailsInsertion(accountDto: any): Promise<any> {
        const doctor = await this.accountDetailsRepository.accountdetailsInsertion(accountDto);
        return doctor;
    }

    async listOfHospitals(): Promise<any> {
        const hospitals = await this.accountDetailsRepository.find();
        return hospitals;
    }

    async prescriptionInsertion(user: any): Promise<any> {
        const details = await this.appointmentRepository.findOne({ id: user.prescriptionDto.appointmentId });
        const pat = await this.patientDetailsRepository.findOne({ patientId: details.patientId });
        const doc = await this.doctorRepository.findOne({ doctorId: details.doctorId });
        const hosp = await this.accountDetailsRepository.findOne({ accountKey: doc.accountKey });
        const hospitaladdress=hosp.street1+", "+hosp.landmark+", "+hosp.city+", "+hosp.state+", "+hosp.pincode   
        let result = [];
        if (doc.doctorKey == user.doctor_key) {

            let prescriptionMedicineDetail = [];
            for (let i = 0; i < user.prescriptionDto.prescriptionList.length ; i++) {
                prescriptionMedicineDetail = [];
                // Add prescription
                const prescriptionDetails = {
                    currentDate: moment(new Date()).format("DD/MM/YYYY hh:mm:ss A"),
                    appointmentId: details.id,
                    appointmentDate: details.appointmentDate,
                    hospitalLogo: hosp.hospitalPhoto,
                    hospitalName: hosp.hospitalName,
                    doctorName: "Dr."+" "+ doc.firstName + " " + doc.lastName,
                    doctorSignature: doc.signature,
                    patientName: pat.firstName + " " + pat.lastName,
                    doctorId:doc.doctorId,
                    remarks:user.prescriptionDto.remarks,
                    patientAge:pat.age,
                    Gender:pat.gender,
                    patientGender:pat.honorific,
                    DoctorKey:doc.doctorKey,
                    hospitalAddress:hospitaladdress,
                    qualification:doc.qualification,
                    doctorRegistrationNumber:doc.registrationNumber,
                
                }
                const prescriptionDetail = await this.prescriptionRepository.prescriptionInsertion(prescriptionDetails);
                prescriptionMedicineDetail.push(prescriptionDetail.appointmentdetails);
                prescriptionMedicineDetail[0].medicineList = [];
                // Add medicine for prescription
                for (let j = 0; j< user.prescriptionDto.prescriptionList[i].medicineList.length; j++) {
                    const medicineData = {
                        prescriptionId: prescriptionDetail.appointmentdetails.id,
                        nameOfMedicine: user.prescriptionDto.prescriptionList[i].medicineList[j].nameOfMedicine,
                        frequencyOfEachDose: user.prescriptionDto.prescriptionList[i].medicineList[j].frequencyOfEachDose,
                        doseOfMedicine: user.prescriptionDto.prescriptionList[i].medicineList[j].doseOfMedicine,
                        typeOfMedicine: user.prescriptionDto.prescriptionList[i].medicineList[j].typeOfMedicine,
                        countOfDays: user.prescriptionDto.prescriptionList[i].medicineList[j].countOfDays,
                    }

                    const medicineDetail = await this.medicineRepository.medicineInsertion(medicineData);
                    prescriptionMedicineDetail[0].medicineList.push(medicineData);
                }

                // Generate pdf to store in cloud
                let generatePdfPrescription = await this.htmlToPdf(prescriptionMedicineDetail, 
                    prescriptionDetails.patientName,
                    prescriptionDetails.remarks,
                    prescriptionMedicineDetail[0].id,
                    prescriptionDetails.patientAge,
                    prescriptionDetails.currentDate,
                    prescriptionDetails.Gender,
                    prescriptionDetails.DoctorKey,
                    prescriptionDetails.hospitalLogo,
                    prescriptionDetails.qualification, 
                    prescriptionDetails.doctorRegistrationNumber,
                    prescriptionDetails.hospitalAddress,
                    );

                if (i === user.prescriptionDto.prescriptionList.length - 1) {
                    result.push(prescriptionDetail);
                    return result;
                } else {
                    result.push(prescriptionDetail);
                }
                    
            }
            
            
        } else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
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
            if (v.is_cancel == true) {
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
        return {isPhone: isPhone, patientDetails: number};
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

        const params: any = {};

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
        try {
            const sendMail = await this.email.sendEmail(params);
            return {
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

    async sendAppCancelledEmail(req) {

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
        var cancelledOn = req.cancelledOn;

        const params: any = {};

        params.subject = 'Appointment Cancelled';
        params.recipient = email;
        params.template = '  <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">Appointment Cancelled</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user cancelled appointment through VIRUJH. Please find the appointment details Below</div></div>\
         <div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Cancelled By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Email</div><div style="display: inline-block;">: {email}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Cancelled On</div><div style="display: inline-block;">: {cancelledOn}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
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
        params.template = params.template.replace(/{cancelledOn}/gi, cancelledOn);

        try {
            const sendMail = await this.email.sendEmail(params);
            return {
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

    async sendAppRescheduleEmail(req) {

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
        var rescheduledAppointmentDate = req.rescheduledAppointmentDate;
        var rescheduledStartTime = req.rescheduledStartTime;
        var rescheduledEndTime = req.rescheduledEndTime;
        var rescheduledOn = req.rescheduledOn;

        const params: any = {};

        params.subject = 'Appointment Rescheduled';
        params.recipient = email;
        params.template = '  <div style="height: 7px; background-color: #535353;"></div><div style="background-color:#E8E8E8; margin:0px; padding:20px 20px 40px 20px; font-family:Open Sans, Helvetica, sans-serif; font-size:12px; color:#535353;"><div style="text-align:center; font-size:24px; font-weight:bold; color:#535353;">Appointment Rescheduled</div><div style="text-align:center; font-size:18px; font-weight:bold; color:#535353; padding: inherit">One user rescheduled appointment through VIRUJH. Please find the appointment details Below</div></div>\
         <div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Rescheduled By</div><div style="display: inline-block;">: {role}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Old Appointment Id</div><div style="display: inline-block;">: {appointmentId}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Doctor Name</div><div style="display: inline-block;">: {doctorFirstName} {doctorLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Patient Name</div><div style="display: inline-block;">: {patientFirstName} {patientLastName}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Date</div><div style="display: inline-block;">: {appointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment Start time</div><div style="display: inline-block;">: {startTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Appointment End time</div><div style="display: inline-block;">: {endTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Rescheduled Appointment Date</div><div style="display: inline-block;">: {rescheduledAppointmentDate}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Rescheduled Appointment Start time</div><div style="display: inline-block;">: {rescheduledStartTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Resheduled Appointment End time</div><div style="display: inline-block;">: {rescheduledEndTime}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div class="reset_titles" style="display: inline-block;">Rescheduled On</div><div style="display: inline-block;">: {rescheduledOn}</div></div><div class="reset_info" style="text-align: left;color: #5a5a5a;">\
<div  class="reset_titles" style="display: inline-block;">Hospital</div><div style="display: inline-block;">: {hospital}</div></div><br>Thank you</div></div>  ';        //sending Mail to user

        params.template = params.template.replace(/{doctorFirstName}/gi, doctorFirstName);
        params.template = params.template.replace(/{doctorLastName}/gi, doctorLastName);
        params.template = params.template.replace(/{patientFirstName}/gi, patientFirstName);
        params.template = params.template.replace(/{patientLastName}/gi, patientLastName);
        params.template = params.template.replace(/{rescheduledAppointmentDate}/gi, rescheduledAppointmentDate);
        params.template = params.template.replace(/{rescheduledStartTime}/gi, rescheduledStartTime);
        params.template = params.template.replace(/{rescheduledEndTime}/gi, rescheduledEndTime);
        params.template = params.template.replace(/{hospital}/gi, hospital);
        params.template = params.template.replace(/{startTime}/gi, startTime);
        params.template = params.template.replace(/{endTime}/gi, endTime);
        params.template = params.template.replace(/{role}/gi, role);
        params.template = params.template.replace(/{appointmentId}/gi, appointmentId);
        params.template = params.template.replace(/{appointmentDate}/gi, appointmentDate);
        params.template = params.template.replace(/{rescheduledOn}/gi, rescheduledOn);

        try {
            const sendMail = await this.email.sendEmail(params);
            return {
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

    async sendSmsForCreatingAppointment(req) {
        var number = req.number;
        const params: any = {}
        params.message = 'Appointment created\nCreated by {role}';
        params.sender = 'Virujh';
        params.number = number;
        try {
            const sendMail = await this.sms.sendSms(params);
            return {
                statusCode: HttpStatus.OK,
                message: CONSTANT_MSG.SMS_OK
            }
        } catch (e) {
            console.log(e);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async htmlToPdf(prescription, patientName,remarks, prescriptionId,patientAge,currentDate,Gender,
        DoctorKey, hospitalLogo,qualification,doctorRegistrationNumber,hospitalAddress) {
        const params: any = {};
        const AWS = require('aws-sdk');
        let htmlPdf : any = '';
        const ID = 'AKIAISEHN3PDMNBWK2UA';
        const SECRET = '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';
        const BUCKET_NAME = 'virujh-cloud';
         
        // s3 bucket creation
         const s3 = new AWS.S3({
            accessKeyId: ID,
            secretAccessKey: SECRET
        });


        let tabledata = '';

        params.htmlTemplate = `<!DOCTYPE html>
        <html lang="en">
        
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Viruj</title>
           
            <style>
                body {
                    width: 100%;
                    background-color: #f3f6f9;
                    color: #303030;
                    margin: 0;
                    font-family: Arial, sans-serif, 'Open Sans'
                }
        
                .app-main {
                    width: 100%;
                    position: relative;
                }
        
                .logo-wrapper img {
                    width: 100%;

                }
        
                .banner-sec {
                    display: inline-block;
                    width: 140px;
                   
                    min-height:1120px;
                    background-color: #17a5e3;
                    padding: 0;
                    position: relative;
                    float: left;
                }
        
                .content-wrapper {
                    display: inline-block;
                    padding: 0;
                    border: 1px solid #f3f6f9;
                    background-color: #fff;
                    width: 85%;
                    min-height: 1120px;
                    position: absolute;
                    float: left;
                    background-image: url(https://virujh-cloud.s3.amazonaws.com/virujh/report/logo%20%281%29.png);
                    background-size: 40%;
                    background-repeat: no-repeat;
                    background-position: center;
                   
                   
                }
        
                .top-wrapper {
                    
                    padding: 20px;
                    border-bottom: 1px solid #edeff2;
                    text-align: center
                }
        
                .details-wrap label.lbl-name {
                    font-size: 14px;
                    margin: 0 0 5px 0;
                    display: block;
                }
        
                .details-wrap .li-row {
                    margin-bottom: 20px;
                }
        
                .details-wrap .lbl-txt {
                    color: white;
                    font-size: 14px;
                    margin: 0;
                }
        
                .details-wrap .doctor-details {
                    padding: 30px 15px;
                    border-bottom: 1px solid #39b6ec;
                    margin-bottom: 10px;
                }
        
                .details-wrap .personal-details {
                    padding: 10px 15px;
                    margin-top: 50px;
                }
        
                .tbl-header {
                    display: flex;
                    justify-content: center;
                    padding: 20px;
                    text-align: center;
                }
        
                .table {
                    width: 100%;
                    position: relative;
                    margin: 0;
                    font-size: 13px;
                    font-weight: normal;
                    border-spacing: 0;
                }
        
                .detail-tbl {
                    width: 100%;
                    text-align: center;
                    font-weight: normal !important;  
                }
        
                .thead {
                    background-color: #e4f7fe;
                    margin: 0;
                    text-align: center;
                }
        
                .tbody {
                    color: #818182;
                }

               
        
                .table th,
                .table td {
                    padding: 15px;
                    font-weight: normal;
                }
        
                .tbody tr td {
                    border-bottom: 1px solid #edeff2;
                }
        
                .doc-signanture {
                    color: #17a5e3;
                    font-size: 16px;
                    margin: 0;
                }
        
                .doctor-sign {
                    position: absolute;
                    bottom: 100px;
                    left: 20px;
                }
            </style>
        </head>
        
        <body>
            <section class="app-main">
                <div class="banner-sec">
                    <div class="logo-container" style="padding: 20px 15px;">
                        <div class="logo-wrapper">
                            <img src={hospitalLogo}
                                alt="" />
                        </div>
                       
                    </div>
                    <div class="details-wrap">
                        <div class="doctor-details">
                            <div class="header-wrap" style="margin-bottom: 20px;">
                                <h6 style="color:white;font-size: 16px;margin: 0;">Doctor Details</h6>
                            </div>
                            <div class="li-row">
                                <label class="lbl-name">Name of Doctor</label>
                                <label class="lbl-txt">{doctor_name}</label>
                            </div>
                           
                            <div class="li-row">
                                <label class="lbl-name">Doctor Code </label>
                                <label class="lbl-txt">{DoctorKey}</label>
                            </div>
                            <div class="li-row">
                            <label class="lbl-name">Qualification</label>
                            <label class="lbl-txt">{qualification}</label>
                            </div>
                            <div class="li-row">
                            <label class="lbl-name">Registration Number</label>
                            <label class="lbl-txt">{doctorRegistrationNumber}</label>
                            </div>
                            <div class="li-row">
                            <label class="lbl-name">Doctor Address</label>
                            <label class="lbl-txt">{hospitalAddress}</label>
                        </div>
                        </div>
                        <div class="personal-details">
                            <div class="header-wrap" style="margin-bottom: 20px;">
                                <h6 style="color:white;font-size: 16px;margin: 0;line-height: 22px;">Personal Details</h6>
                            </div>
                            <div class="li-row">
                                <label class="lbl-name">Name of Patient </label>
                                <label class="lbl-txt">{patient_name}</label>
                            </div>
                            <div class="li-row">
                                <label class="lbl-name">Age </label>
                                <label class="lbl-txt">{patientAge}</label>
                            </div>
                            <div class="li-row">
                            <label class="lbl-name">Gender</label>
                            <label class="lbl-txt">{Gender}</label>
                        </div>
                        </div>
                    </div>
                </div>
                <div class="content-wrapper">
                    <div class="top-wrapper">
                        <h5 style="margin: 0 0px 10px 0;font-size: 25px;font-weight: 500;color: #121212;"> Prescription
                        </h5>
                        <h6 style="margin: 0;font-size: 13px;font-weight: normal;">{currentDate}</h6>
                    </div>
                    <div class="detail-tbl">
                        <table class="table tbl-wrap">
                            <thead class="thead">
                                <tr>
                                    <th>Description</th>
                                    <th>Quantity</th>
                                    <th>Comments</th>
                                </tr>
                            </thead>
                            <tbody class="tbody">
                            {tabledata}
                                
                            </tbody>
                        </table>
                        <div style="font-size: 16px;color: #121212; text-align: left;">
                        <h5 style="margin-bottom: 10px;font-weight: normal;text-align: center;" >Remarks
                        </h5>
                        <p style="text-align:left;font-size: 13px;border: solid 1px;width: 640px;height: 85px;border-color: #edeff2;
                        margin: 2px;">
                        {remarks}</p>
                        </div>
                    </div>
                    <div class="doctor-sign">
                        <img src="{doctor_signature}" style="display: block;height: 50px;margin-bottom: 15px;" alt="" />
                        <label class="doc-signanture">Doctor signature</label>
                    </div>
                </div>
            </section>
        </body>
        
        </html>  `;

        prescription[0].medicineList.forEach(element => {
            tabledata +=  ' <tr><td>' + (element.nameOfMedicine ? element.nameOfMedicine : '-') +
            //  '</td>' + '<td>' + (element.typeOfMedicine ? element.typeOfMedicine : '-') + '</td>' +
            // '<td>' + (element.frequencyOfEachDose ? element.frequencyOfEachDose : '-') + '</td>' +
             '<td>' + (element.countOfDays ? element.countOfDays : '-') + '</td>' +
              '<td>' + (element.doseOfMedicine ? element.doseOfMedicine : '-') + '</td></tr>'
        });

        params.htmlTemplate = params.htmlTemplate.replace('{doctor_name}', prescription[0].doctorName);
        params.htmlTemplate = params.htmlTemplate.replace('{patient_name}', prescription[0].patientName);
        params.htmlTemplate = params.htmlTemplate.replace('{doctor_signature}', prescription[0].doctorSignature);
        params.htmlTemplate = params.htmlTemplate.replace('{tabledata}', tabledata);
        params.htmlTemplate = params.htmlTemplate.replace('{remarks}', remarks);
        params.htmlTemplate = params.htmlTemplate.replace('{patientAge}', patientAge);
        params.htmlTemplate = params.htmlTemplate.replace('{currentDate}', currentDate);
        params.htmlTemplate = params.htmlTemplate.replace('{Gender}', Gender);
        params.htmlTemplate = params.htmlTemplate.replace('{DoctorKey}', DoctorKey);
        params.htmlTemplate = params.htmlTemplate.replace('{hospitalLogo}', hospitalLogo);
        params.htmlTemplate = params.htmlTemplate.replace('{qualification}',qualification );
        params.htmlTemplate = params.htmlTemplate.replace('{doctorRegistrationNumber}',doctorRegistrationNumber );
        params.htmlTemplate = params.htmlTemplate.replace('{hospitalAddress}', hospitalAddress);

        var options = { 
            // format: 'Letter',
            orientation: "portrait", // portrait or landscape
                "border": {
                  "top": "0",// default is 0, units: mm, cm, in, px
                  "right": "0",
                  "left": "0"
                },
                paginationOffset: 1,       // Override the initial pagination number
                footer: {
                  "height": "0",
                },
                type: "pdf",
                quality: "75",
         };

         const attachment = new Promise((resolve, reject) => {
            pdf.create(params.htmlTemplate, options).toFile('./temp/prescription.pdf', (err, res) =>{
                if (err) {
                    console.log(err);
                    reject(err)
                }
                console.log(res);
                htmlPdf = res.filename;
                const fileContent = fs.readFileSync(htmlPdf);
                
                // Setting up S3 upload parameters
                const parames = {
                    ACL: 'public-read',
                    Bucket: BUCKET_NAME,
                    Key: `virujh/${patientName}/prescription/prescription-${prescriptionId}.pdf`, // File name you want to save as in S3
                    Body: fileContent,
                };
            
                // Uploading files to the bucket

                s3.upload(parames, async (err, data) => {
                    if (err) {
                        console.log('Unable to upload prescription ' + prescriptionId + ' ', err);
                        reject(err)
                    } else {
                        try {
                            // store prescription URL into database
                            const updateDB = await this.prescriptionRepository.update({
                                id: prescription[0].id,
                            },  {prescriptionUrl: data.Location});
                            resolve(updateDB)
                        } catch (err) {
                            reject(err)
                        }
                    }
                });   
            });
        })
        
        return attachment
    }
    

    //patientFileUploading

    async patientFileUpload(reports: any): Promise<any> {

        const AWS = require('aws-sdk');
        let htmlPdf: any = '';
        const ID = 'AKIAISEHN3PDMNBWK2UA';
        const SECRET = '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';
        const BUCKET_NAME = 'virujh-cloud';
        const date = new Date();
        const ReportDate = moment().format('YYYY-MM-DD');

        // s3 bucket creation
        const s3 = new AWS.S3({
            accessKeyId: ID,
            secretAccessKey: SECRET

        });



        if (reports.file.mimetype === "application/pdf") {
            var base64data = new Buffer(reports.file.buffer, 'base64');
        }
        else {
            var base64data = new Buffer(reports.file.buffer, 'binary');
        }

        const parames = {
            ACL: 'public-read',
            Bucket: BUCKET_NAME,
            Key: `virujh/report/` + reports.file.originalname,// File name you want to save as in S3
            Body: base64data
        };

        // Uploading files to the bucket
        const result = new Promise((resolve, reject) => {
            s3.upload(parames, async (err, data) => {
                if (err) {
                    reject({
                        statusCode: HttpStatus.NO_CONTENT,
                        message: "Image Uploaded Failed",
                    })
                } else {


                    // store prescription URL into database
                    await this.patientReportRepository.patientReportInsertion({
                        patientId: reports.data.patientId,
                        appointmentId: reports.data.appointmentId ? reports.data.appointmentId : null,
                        fileName: reports.file.originalname,
                        fileType: reports.file.mimetype,
                        reportURL: data.Location,
                        reportDate: date,
                        comments: reports.data.comments
                    })
                    resolve({
                        statusCode: HttpStatus.OK,
                        message: "Image Uploaded Successfully",
                        data: data.Location,
                    })
                }
            })
        })

    return result;
    }
    async deletereport(id: any): Promise<any> {

        var account = await this.patientReportRepository.find({ id: id.id })
        if (account.length) {
            const app = await this.patientReportRepository.updateReportInsertion(id)
            return app
        }
        else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.NOREPORT,
            }
        }

    }

    
    //report Data
    async report(data: any): Promise<any> {
        const patientId = data.patientId;
        const offset = data.paginationStart;
        const endset = data.paginationLimit;
        const searchText = data.searchText;
        const appointmentId = data.appointmentId;
        const active = true;
        let response = {};
        let app = [], reportList = [];

        if (searchText) {
            if (appointmentId) {
                app = await this.patientReportRepository.query(queries.getSearchReportByAppointmentId, [appointmentId, offset, endset, '%' + searchText + '%', active]);
                reportList = await this.patientReportRepository.query(queries.getReportWithoutLimitAppointmentIdSearch, [appointmentId, '%' + searchText + '%', active]);

            } else {
                app = await this.patientReportRepository.query(queries.getSearchReport, [patientId, offset, endset, '%' + searchText + '%', active]);
                reportList = await this.patientReportRepository.query(queries.getReportWithoutLimitSearch, [patientId, '%' + searchText + '%', active]);
            }

        } else {
            if (appointmentId) {
                app = await this.patientReportRepository.query(queries.getReportByAppointmentId, [appointmentId, offset, endset, active]);
                reportList = await this.patientReportRepository.query(queries.getReportWithAppointmentId, [appointmentId, active]);

            } else {
                reportList = await this.patientReportRepository.query(queries.getReportWithoutLimit, [patientId, active]);
                app = await this.patientReportRepository.query(queries.getReport, [patientId, offset, endset, active]);
            }


        }
        response['totalCount'] = reportList.length;
        response['list'] = app;
        return response;


    }



    // update consultation status
    async consultationStatusUpdate(appointmentObject: any) {

        if (appointmentObject.appointmentId) {
            const appointmentDetails = await this.appointmentRepository.findOne({ id: appointmentObject.appointmentId });

            if (appointmentDetails) {
                // Update consultation status
                var condition = {
                    id: appointmentObject.appointmentId
                }
                var values: any = {
                    hasConsultation: true,
                }

                const consultationStatus = await this.appointmentRepository.update(condition, values);

                console.log('consultationStatus', consultationStatus)
                if (consultationStatus.affected) {
                    return {
                        statusCode: HttpStatus.OK,
                        message: CONSTANT_MSG.SUCCESS_UPDATE_APPO,
                        data: appointmentDetails
                    }
                } else {
                    return {
                        statusCode: HttpStatus.BAD_REQUEST,
                        message: CONSTANT_MSG.FAILED_UPDATE_APPO
                    }
                }
            } else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: CONSTANT_MSG.NO_APPOINTMENT
                }
            }


        } else {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: CONSTANT_MSG.NO_APPOINTMENT
            }
        }


    }

    async addDoctorSignature(reports: any): Promise<any> {
        try {
            const AWS = require('aws-sdk');
            const ID = 'AKIAISEHN3PDMNBWK2UA';
            const SECRET = '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';
            const BUCKET_NAME = 'virujh-cloud';

            // s3 bucket creation
            const s3 = new AWS.S3({
                accessKeyId: ID,
                secretAccessKey: SECRET

            });


            if (reports.file.mimetype === "application/pdf") {
                var base64data = Buffer.from(reports.file.buffer, 'base64');
            }
            else {
                var base64data = Buffer.from(reports.file.buffer, 'binary');
            }

            const parames = {
                ACL: 'public-read',
                Bucket: BUCKET_NAME,
                Key: `virujh/signature/` + reports.file.originalname,// File name you want to save as in S3
                Body: base64data
            };

            // Uploading files to the bucket
            const result = new Promise((resolve, reject) => {
                let queryRes;
                s3.upload(parames, async (err, data) => {
                    if (err) {
                        reject({
                            statusCode: HttpStatus.NO_CONTENT,
                            message: "Image Uploaded Failed"
                        });
                    } else {
                        queryRes = await this.doctorRepository.query(queries.updateSignature, [reports.data.doctorId, data.Location])
                        resolve({
                            statusCode: HttpStatus.OK,
                            message: "Image Uploaded Successfully",
                            data: data.Location,
                            // url: path
                        })
                    }
                });
            });
            return result;
        } catch (err) {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: err.message,
                error: err
            };
        }

    }

    //upload files
    async uploadFile(files: any) {
        try {
            const AWS = require('aws-sdk');
            let htmlPdf: any = '';
            const ID = 'AKIAISEHN3PDMNBWK2UA';
            const SECRET = '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';
            const BUCKET_NAME = 'virujh-cloud';
            var profileURL = "";
            // s3 bucket creation
            const s3 = new AWS.S3({
                accessKeyId: ID,
                secretAccessKey: SECRET

            });

            if (files.file.mimetype === "application/pdf") {
                var base64data = new Buffer(files.file.buffer, 'base64');
            }
            else {
                var base64data = new Buffer(files.file.buffer, 'binary');
            }

            const parames = {
                ACL: 'public-read',
                Bucket: BUCKET_NAME,
                Key: `virujh/files/` + files.file.originalname,// File name you want to save as in S3
                Body: base64data
            };
            var location;


            const result = new Promise((resolve, reject) => {
                s3.upload(parames, async (err, data) => {
                    if (err) {
                        reject({
                            statusCode: HttpStatus.NO_CONTENT,
                            message: "Image Uploaded Failed"
                        });
                    } else {
                        resolve({
                            statusCode: HttpStatus.OK,
                            message: "Image Uploaded Successfully",
                            data: data.Location,
                            // url: path
                        })
                    }
                });
            });
            return result
        } catch (err) {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: err.message,
                error: err
            };
        }
    }

    async getDoctorDetails(doctorKey: any) {
        const doctor = await this.doctorRepository.findOne({ doctorKey: doctorKey });
        return doctor;
    }

    async getHospitalDetails(accountKey: any) {
        const hospital = await this.accountDetailsRepository.findOne({ accountKey: accountKey });
        return hospital;
    }

    //Getting patient report in patient detail page
    async patientDetailLabReport(patientId: any): Promise<any> {
        try {
            const patientReport = await this.patientDetailsRepository.query(queries.getPatientDetailLabReport, [patientId]);
            let patientDetailReport = patientReport;
            if (patientDetailReport.length) {
                return {
                    statusCode: HttpStatus.OK,
                    message: 'Patient Detail Report List fetched successfully',
                    data: patientDetailReport,
                }
            }
            else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: 'No record found'
                }
            }
        } catch (err) {
            console.log(err);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    //Getting appointment list report
    async appointmentListReport(user: any): Promise<any> {
        const offset = user.paginationStart;
        const endset = user.paginationLimit;
        const searchText = user.searchText;
        const from = user.fromDate;
        const to = user.toDate;
        let response = {};
        let app = [], reportList = [];

        let query = queries.getDoctorReportField + queries.getDoctorReportFromField + queries.getAppointmentListReportJoinField;

        query += user.user.doctor_key ? queries.getDoctorReportWhereForDoctor : queries.getDoctorReportWhereForAdmin;
        let whereParam = user.user.doctor_key ? user.user.doctor_key : user.user.account_key;

        if (searchText && to === undefined) {

            app = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithSearch, [whereParam, offset, endset, '%' + searchText + '%', from]);
            reportList = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithoutLimitSearch, [whereParam, '%' + searchText + '%', from]);

        }
        else if (to) {
            if (searchText) {
                app = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithFilterSearch, [whereParam, offset, endset, '%' + searchText + '%', from, to]);
                reportList = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithoutLimitFilterSearch, [whereParam, '%' + searchText + '%', from, to]);
            }
            else {
                app = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithFilter, [whereParam, offset, endset, from, to]);
                reportList = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithoutLimitFilter, [whereParam, from, to]);
            }
        } else {
            if (user.user.doctor_key) {
                app = await this.patientReportRepository.query(query + queries.getAppointmentListReportWithLimit, [whereParam, offset, endset, from]);
                reportList = await this.patientReportRepository.query(query + queries.getAppointmentListReport, [whereParam, from]);
            }
        }
        response['totalCount'] = reportList.length;
        response['list'] = app;

        if (reportList.length) {
            return {
                statusCode: HttpStatus.OK,
                message: 'Appointment Report List fetched successfully',
                data: response,
            }
        }
        else {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: 'No record found'
            }
        }
    }


    async getMessageTemplate(messageType: string, communicationType: string): Promise<any> {
        try {

            const template = await this.appointmentRepository.query(queries.getMessageTemplate, [messageType, communicationType]);
            if (template && template.length) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.MESSAGE_TEMPLATE_FETCH_SUCCESS,
                    data: template[0]
                }

            } else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: CONSTANT_MSG.NO_MESSAGE_TEMPLATE
                }
            }

        } catch (err) {
            console.log(err);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }

        }
    }

    //Getting amount  list report
    async amountListReport(user: any): Promise<any> {
        const offset = user.paginationStart;
        const endset = user.paginationLimit;
        const searchText = user.searchText;
        const from = user.fromDate;
        const to = user.toDate;
        let response = {};
        let app = [], reportList = [];

        let query = queries.getDoctorReportField + queries.getDoctorReportFromField + queries.getAmountListReportJoinField;

        query += user.user.doctor_key ? queries.getDoctorReportWhereForDoctor : queries.getDoctorReportWhereForAdmin;
        let whereParam = user.user.doctor_key ? user.user.doctor_key : user.user.account_key;

        if (searchText && to === undefined) {
            app = await this.patientReportRepository.query(query + queries.getAmountListReportWithSearch, [whereParam, offset, endset, '%' + searchText + '%', from]);
            reportList = await this.patientReportRepository.query(query + queries.getAmountListReportWithoutLimitSearch, [whereParam, '%' + searchText + '%', from]);

        }
        else if (to) {
            if (searchText) {
                app = await this.patientReportRepository.query(query + queries.getAmountListReportWithFilterSearch, [whereParam, offset, endset, '%' + searchText + '%', from, to]);
                reportList = await this.patientReportRepository.query(query + queries.getAmountListReportWithoutLimitFilterSearch, [whereParam, '%' + searchText + '%', from, to]);
            }
            else {
                app = await this.patientReportRepository.query(query + queries.getAmountListReportWithFilter, [whereParam, offset, endset, from, to]);
                reportList = await this.patientReportRepository.query(query + queries.getAmountListReportWithoutLimitFilter, [whereParam, from, to]);
            }
        } else {
            if (user.user.doctor_key) {
                app = await this.patientReportRepository.query(query + queries.getAmountListReportWithLimit, [whereParam, offset, endset, from]);
                reportList = await this.patientReportRepository.query(query + queries.getAmountListReport, [whereParam, from]);
            }
        }
        response['totalCount'] = reportList.length;
        response['list'] = app;

        if (reportList.length) {
            return {
                statusCode: HttpStatus.OK,
                message: 'Amount Collection List fetched successfully',
                data: response,
            }
        }
        else {
            return {
                statusCode: HttpStatus.NOT_FOUND,
                message: 'No record found'
            }
        }
    }

    // Getting advertisement list
    async advertisementList(user: any): Promise<any> {
        try {
            const advertisement = await this.patientReportRepository.query(queries.getAdvertisementList);
            if (advertisement && advertisement.length) {
                return {
                    statusCode: HttpStatus.OK,
                    message: CONSTANT_MSG.ADVERTISEMENT_LIST_FETCH_SUCCESS,
                    data: advertisement,
                }
            }
            else {
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message: CONSTANT_MSG.NO_ADVERTISEMENT_LIST
                }
            }

        } catch (err) {
            console.log(err);
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.DB_ERROR
            }
        }
    }

    async getPrescriptionList(appointmentId: any): Promise<any> {
        const response = await this.prescriptionRepository.query(
            queries.getPrescription,
            [appointmentId],
        );
        return response;
    }

    async getReportList(doctorId: number, patientId: any, appointmentId: any): Promise<any> {
        const response = await this.patientReportRepository.query(
            queries.getReportVideoUsage,
            [doctorId, patientId, appointmentId, 0, 5],
        );
        return response;
    }

    async getPrescriptionDetails(appointmentId: Number): Promise<any> {
        const prescription = await this.medicineRepository.query(queries.getPrescriptionDetails, [appointmentId])
        //pres remark
        const remarks=await this.prescriptionRepository.query(queries.getRemarks,[appointmentId])
        console.log(remarks);
        const prescriptionRemarks=remarks?.[0].remarks;
        return {
            appointmentId,
            prescription,
            prescriptionRemarks
        }
    }
    async getAppointmentDetails(appointmentId: Number): Promise<any> {
        return await this.appointmentRepository.query(queries.getAppointmentDetails, [appointmentId])
    }

    async getAppointmentReports(appoinmentId: Number): Promise<any> {
        const reports = await this.appointmentRepository.query(queries.getAppointmentReports, [appoinmentId])

        return {
            statusCode: HttpStatus.OK,
            message: 'Fetched report successfully',
            appoinmentId,
            reports
        }
    }

    async updatereport(data: any): Promise<any> {

        if(data.insertId){
        var account = await this.appointmentRepository.find({ id : data.appointmentId })  
        var arr = JSON.parse("[" + account[0].reportid + "]");
        data.id=data.insertId;
        data.id = account[0].reportid ? account[0].reportid + ',' + data.id : data.id;
        
        if(account.length){
            const app = await this.appointmentRepository.updateReportId(data)
            return app
        }
       
        else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.NOREPORT,
            }
        }
        
        
    }
    
    if(data.deleteId){
        var account = await this.appointmentRepository.find({ id : data.appointmentId })  
        var arr = JSON.parse("[" + account[0].reportid + "]");
        data.id=data.deleteId
        const tempArr = arr.filter(val => (val != data.id) );
        const newid=tempArr.toString()
        data.id =  newid ;
        if(account.length){
        const app = await this.appointmentRepository.deleteReportid(data)
        return app
        }
        else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.NOREPORT,
            }
        }
    }

    }
}

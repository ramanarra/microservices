import {Controller, HttpStatus, Logger, UnauthorizedException} from '@nestjs/common';
import {AppointmentService} from './appointment.service';
import {MessagePattern} from '@nestjs/microservices';
import {CONSTANT_MSG, queries, DoctorDto, DocConfigDto, Sms} from 'common-dto';
import {PatientDto} from 'common-dto';
import {Helper} from "../utility/helper";
import { of } from 'rxjs';
import { VideoService } from './video.service';
import { PatientDetailsRepository } from './patientDetails/patientDetails.repository';
import * as Razorpay from 'razorpay';
import { PaymentService } from './payment.service';
import * as config from 'config';
import {PaymentDetailsRepository} from "./paymentDetails/paymentDetails.repository";
import { PaymentDetails } from "./paymentDetails/paymentDetails.entity";
import { HelperService } from 'src/utility/helper.service';
//import * as moment from 'moment';

//import {DoctorService} from './doctor/doctor.service';
var moment = require('moment');

@Controller('appointment')
export class AppointmentController {

    private logger = new Logger('AppointmentController');
    textLocal:any;
    constructor(private readonly appointmentService: AppointmentService,
        private readonly videoService : VideoService,
        private readonly paymentService : PaymentService,
        private patientDetailsRepository : PatientDetailsRepository,
        private paymentDetailsRepository: PaymentDetailsRepository,
        private helperService: HelperService) {
        //    this.textLocal = config.get('textLocal');
    }

    @MessagePattern({cmd: 'calendar_appointment_create'})
    async createAppointment(appointmentDto: any): Promise<any> {
        this.logger.log("appointmentDetails >>> " + appointmentDto);
        let doctorId;
        if(appointmentDto.user.role == CONSTANT_MSG.ROLES.DOCTOR){
            doctorId = await this.appointmentService.doctorDetails(appointmentDto.user.doctor_key);
            const config = await this.appointmentService.getDoctorConfigDetails(appointmentDto.user.doctor_key);
            appointmentDto.configSession = config.consultationSessionTimings;
            if(!doctorId){
                return {
                    statusCode: HttpStatus.NOT_FOUND,
                    message:  CONSTANT_MSG.CONTENT_NOT_AVAILABLE
                }
            }
            appointmentDto.doctorId = doctorId.doctorId;
            appointmentDto.config = config; 
        }else{  
            doctorId = await this.appointmentService.doctorDetails(appointmentDto.doctorKey);         
            const config = await this.appointmentService.getDoctorConfigDetails(appointmentDto.doctorKey);
            appointmentDto.doctorId = doctorId.doctorId;
            appointmentDto.config = config; 
        }    
        const pat = await this.appointmentService.getPatientDetails(appointmentDto.patientId); 
        const account = await this.appointmentService.accountDetails(doctorId.accountKey);  
        const appointment = await this.appointmentService.createAppointment(appointmentDto);       
        if(!appointment.message){
            const pay = new PaymentDetails();
            pay.amount = appointmentDto.config.consultationCost;
            pay.appointmentId = appointment.appointment.appointmentdetails.id;
            pay.paymentStatus = CONSTANT_MSG.PAYMENT_STATUS.FULLY_PAID
            const payment = await pay.save();
            let data={
                email:pat.email,
                appointmentId:appointment.appointment.appointmentdetails.id,
                patientFirstName:pat.firstName,
                patientLastName:pat.lastName,
                doctorFirstName:doctorId.firstName ,
                doctorLastName:doctorId.lastName ,
                hospital: account.hospitalName,
                appointmentDate:appointment.appointment.appointmentdetails.appointmentDate,
                startTime:appointment.appointment.appointmentdetails.startTime,
                endTime:appointment.appointment.appointmentdetails.endTime,
                role:appointment.appointment.appointmentdetails.createdBy,
            }
            appointment.patientDetail=data;
           // const mail = await this.appointmentService.sendAppCreatedEmail(data)
            //let apiKey = new Sms(this.textLocal.apiKey);
            let params = {
            }
        }
        return appointment;
    }

    @MessagePattern({cmd: 'app_doctor_list'})
    async doctorList(user): Promise<any> {
        const account = await this.appointmentService.accountDetails(user.account_key);
        if (user.role == CONSTANT_MSG.ROLES.DOCTOR) {
            var docKey = await this.appointmentService.doctorDetails(user.doctor_key);
            var config = await this.appointmentService.getDoctorConfigDetails(user.doctor_key);
            docKey.fees = config['consultationCost'];
            let app =[];
            //let slots = [];
            //const date = moment().format();
            //const time = moment().format("HH:mm:ss");
            var date:any = new Date();
            //var currenttime= moment()
            //const time = moment(currenttime).format("hh:mm"));
            var seconds = date.getSeconds();
            var minutes = date.getMinutes();
            var hour = date.getHours();
            var time = hour+":"+minutes;
            var timeMilli = Helper.getTimeInMilliSeconds(time);
            var appointment = await this.appointmentService.todayAppointments(docKey.doctorId,date)
            let i:any;
            for(i of appointment){
                let end =Helper.getTimeInMilliSeconds(i.endTime);
                if(timeMilli<end){
                    app.push(i.startTime);
                }
            }
            let app1=[]
            if(app.length>3){
                for(i=0;i<4;i++){
                    app1.push(app[i]);
                }
            }else{
                app1=app;
            }
                
            docKey.todaysAppointment = app1;
            let dto = {
                doctorKey:user.doctor_key,
                appointmentDate:date
            }
            var available = await this.appointmentService.availableSlots(dto, 'doctorList');
            docKey.todaysAvailabilitySeats = available.length;
            return {
                statusCode: HttpStatus.OK,
                accountDetails: account,
                doctorList: [docKey]
            }

        }else{
            const doctor = await this.appointmentService.doctor_lists(user.account_key);
              // add static values for temp
              for(let v of doctor){
                var config = await this.appointmentService.getDoctorConfigDetails(v.doctorKey);
                v.fees = config['consultationCost'];
                let app =[];
                // const date = moment().format();
                // const time = moment().format("HH:mm:ss");
                var date:any = new Date();
                var minutes = date.getMinutes();
                var hour = date.getHours();
                var time = hour+":"+minutes;
                var timeMilli = Helper.getTimeInMilliSeconds(time);
                var appointment = await this.appointmentService.todayAppointments(v.doctorId,date)
                let i:any;
                for(i of appointment){
                    let end =Helper.getTimeInMilliSeconds(i.endTime);
                    if(timeMilli<end){
                        app.push(i.startTime);
                    }
                }
                let app1=[]
                if(app.length>3){
                    for(i=0;i<4;i++){
                        app1.push(app[i]);
                    }
                }else{
                    app1=app;
                }
                v.todaysAppointment = app1;
                let dto = {
                    doctorKey:v.doctorKey,
                    appointmentDate:date
                }
                var available = await this.appointmentService.availableSlots(dto, 'doctorList');
                v.todaysAvailabilitySeats = available.length;
            }
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
            const configDetails = await this.appointmentService.getDoctorConfigDetails(user.docConfigDto.doctorKey);
            var iscanAllowed = configDetails.isPatientCancellationAllowed;
            var isreschAllowed = configDetails.isPatientRescheduleAllowed;

            var canhours = configDetails.cancellationHours;
            var canDays = configDetails.cancellationDays;
            var canMins = configDetails.cancellationMins;

            var reschDays = configDetails.rescheduleDays;
            var reschedHours = configDetails.rescheduleHours;
            var reschedMins = configDetails.rescheduleMins;

            if(user.docConfigDto.isPatientCancellationAllowed){
                iscanAllowed = user.docConfigDto.isPatientCancellationAllowed;
            }
            if(user.docConfigDto.isPatientRescheduleAllowed){
                isreschAllowed = user.docConfigDto.isPatientRescheduleAllowed;
            }
            if(user.docConfigDto.cancellationDays>=0){
                canDays = user.docConfigDto.cancellationDays;
            }
            if(user.docConfigDto.cancellationHours>=0){
                canhours = user.docConfigDto.cancellationHours;
            }
            if(user.docConfigDto.cancellationMins>=0){
                canMins = user.docConfigDto.cancellationMins;
            }
            if(user.docConfigDto.rescheduleDays>=0){
                reschDays = user.docConfigDto.rescheduleDays;
            }
            if(user.docConfigDto.rescheduleHours>=0){
                reschedHours = user.docConfigDto.rescheduleHours;
            }
            if(user.docConfigDto.rescheduleMins>=0){
                reschedMins = user.docConfigDto.rescheduleMins;
            }
            if(iscanAllowed){
                let cTime=canhours+':'+canMins;
                if(canDays == 0){
                    const canTime=  Helper.getTimeInMilliSeconds(cTime);

                    if (user.docConfigDto.isPatientCancellationAllowed) {
                        // by default 10 mins cancelation will set
                        user.docConfigDto['cancellationMins'] = '10';
                        user.docConfigDto['cancellationHours'] = '0';
                        user.docConfigDto['cancellationDays'] = '0';

                    } else if(canTime < 600000){
                        return {statusCode:HttpStatus.BAD_REQUEST ,message: "Cancellation time should be greater than 10 minutes"}
                    }
                } else {

                    if (user.docConfigDto.isPatientCancellationAllowed) {
                        // by default 10 mins cancelation will set
                        user.docConfigDto['cancellationMins'] = '10';
                        user.docConfigDto['cancellationHours'] = '0';
                        user.docConfigDto['cancellationDays'] = '0';

                    }
                }           
            }
            if(isreschAllowed){
                let rTime=reschedHours+':'+reschedMins;
                if(reschDays == 0){
                    const canTime= Helper.getTimeInMilliSeconds(rTime);

                    if (user.docConfigDto.isPatientRescheduleAllowed) {
                        // by default 10 mins reschdule will set
                        user.docConfigDto['rescheduleMins'] = '10';
                        user.docConfigDto['rescheduleHours'] = '0';
                        user.docConfigDto['rescheduleDays'] = '0';

                    } else if(canTime < 600000){

                        return {statusCode:HttpStatus.BAD_REQUEST ,message: "Reschedule time should be greater than 10 minutes"}
                    }
                } else {

                    if (user.docConfigDto.isPatientRescheduleAllowed) {
                        // by default 10 mins reschdule will set
                        user.docConfigDto['rescheduleMins'] = '10';
                        user.docConfigDto['rescheduleHours'] = '0';
                        user.docConfigDto['rescheduleDays'] = '0';

                    }
                }           
            }
            
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
            if(workScheduleDto.user.role == CONSTANT_MSG.ROLES.ADMIN){
                workScheduleDto.user.doctor_key = workScheduleDto.doctorKey;
            }
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
            const appointment = await this.appointmentService.appointmentSlotsView(user, '');
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
    const payment = await this.paymentDetailsRepository.findOne({appointmentId:appointmentDto.appointmentId})
    if(appointmentDto.user.role == CONSTANT_MSG.ROLES.DOCTOR || CONSTANT_MSG.ROLES.DOC_ASSISTANT){
        appointmentDto.doctorId = app.appointmentDetails.doctorId;
    }else{
        const docId = await this.appointmentService.doctorDetails(appointmentDto.doctorKey);
        appointmentDto.doctorId = docId.doctorId;
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
    const pat = await this.appointmentService.getPatientDetails(app.appointmentDetails.patientId); 
    const account = await this.appointmentService.accountDetails(doctor.accountKey);
    //const date = moment().format();
    let date = new Date();  
    if(!appointment.message){
        payment.appointmentId = appointment.appointment.appointmentdetails.id;
        await payment.save();
        let data={
            email:doctor.email,
            appointmentId:app.appointmentDetails.id,
            patientFirstName:pat.firstName,
            patientLastName:pat.lastName,
            doctorFirstName:doctor.firstName ,
            doctorLastName:doctor.lastName ,
            hospital: account.hospitalName,
            appointmentDate:app.appointmentDetails.appointmentDate,
            startTime:app.appointmentDetails.startTime,
            endTime:app.appointmentDetails.endTime,
            role:CONSTANT_MSG.ROLES.PATIENT,
            rescheduledOn:date,
            rescheduledAppointmentDate:appointment.appointment.appointmentdetails.appointmentDate,
            rescheduledStartTime:appointment.appointment.appointmentdetails.startTime,
            rescheduledEndTime:appointment.appointment.appointmentdetails.endTime,
            patientEmail: pat.email ? pat.email : '',
        }
        appointment.patientDetail = data;
        //const mail = await this.appointmentService.sendAppRescheduleEmail(data);
        //console.log(mail);
    }
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
    if ((appointmentDto.user.role == CONSTANT_MSG.ROLES.PATIENT && (appointmentDto.user.patient_id !== app.appointmentDetails.patientId))||(appointmentDto.user.role == CONSTANT_MSG.ROLES.DOCTOR && appointmentDto.user.doctor_key!==doctor.doctorKey)||((appointmentDto.user.role == CONSTANT_MSG.ROLES.ADMIN||appointmentDto.user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && (appointmentDto.user.account_key!==doctor.accountKey))) {
        return {
        statusCode: HttpStatus.BAD_REQUEST,
        message: CONSTANT_MSG.INVALID_REQUEST
        }
    }
    //const date = moment().format();
    let date = new Date();
    const appointment = await this.appointmentService.appointmentCancel(appointmentDto);
    const pat = await this.appointmentService.getPatientDetails(app.appointmentDetails.patientId); 
    const account = await this.appointmentService.accountDetails(doctor.accountKey);  
    if(appointment.statusCode==HttpStatus.OK){
        let data={
            email:pat.email,
            appointmentId:app.appointmentDetails.id,
            patientFirstName:pat.firstName,
            patientLastName:pat.lastName,
            doctorFirstName:doctor.firstName ,
            doctorLastName:doctor.lastName ,
            hospital: account.hospitalName,
            appointmentDate:app.appointmentDetails.appointmentDate,
            startTime:app.appointmentDetails.startTime,
            endTime:app.appointmentDetails.endTime,
            role:appointmentDto.user.role,
            cancelledOn:date,
        }
        appointment.patientDetail = data;
        //const mail = await this.appointmentService.sendAppCancelledEmail(data)
    }
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

    @MessagePattern({ cmd: 'doctor_list_patients' })
    async doctorListForPatients(user: any): Promise<any> {
        const doctor = await this.appointmentService.doctor_List(user);
        return doctor;
    }

    @MessagePattern({ cmd: 'patient_details_insertion' })
    async patientInsertion(patientDto: PatientDto): Promise<any> {
        const patient = await this.appointmentService.patientRegistration(patientDto);
        return patient;
    }

    @MessagePattern({ cmd: 'find_doctor_by_codeOrName' })
    async findDoctorByCodeOrName(user: any): Promise<any> {
        const doctor = await this.appointmentService.findDoctorByCodeOrName(user.codeOrName.codeOrName);
        return doctor;
    }

    @MessagePattern({ cmd: 'patient_details_edit' })
    async patientDetailsEdit(patientDto: any): Promise<any> {
        const patient = await this.appointmentService.patientDetailsEdit(patientDto);
        return patient;
    }

    @MessagePattern({ cmd: 'payment_recipt_details' })
    async paymentReciptDetails(pymntId: String): Promise<any> {
        const recipt = await this.paymentService.paymentReciptDetails(pymntId)
        return recipt?.data
    }

    @MessagePattern({ cmd: 'patient_book_appointment' })
    async patientBookAppointment(patientDto: any): Promise<any> {
        const docId = await this.appointmentService.doctorDetails(patientDto.doctorKey);
        patientDto.doctorId = docId.doctorId;
        const doctor = await this.appointmentService.doctor_Details(patientDto.doctorId);
        const config = await this.appointmentService.getDoctorConfigDetails(doctor.doctorKey);
        patientDto.configSession = config.consultationSessionTimings;
        patientDto.config = config;
        const app = await this.appointmentService.createAppointment(patientDto);
        if(app.message){
            return app;
        }
        const pat = await this.appointmentService.getPatientDetails(patientDto.patientId); 
        const account = await this.appointmentService.accountDetails(docId.accountKey); 
        if(app){
            const pay = await this.paymentDetailsRepository.findOne( { where : {id : patientDto.paymentId}});
            pay.appointmentId = app.appointment.appointmentdetails.id;
            const payment = await this.paymentDetailsRepository.save(pay);
            let data={
                email:doctor.email,
                appointmentId:app.appointment.appointmentdetails.id,
                patientFirstName:pat.firstName,
                patientLastName:pat.lastName,
                doctorFirstName:doctor.firstName ,
                doctorLastName:doctor.lastName ,
                hospital: account.hospitalName,
                appointmentDate:app.appointment.appointmentdetails.appointmentDate,
                startTime:app.appointment.appointmentdetails.startTime,
                endTime:app.appointment.appointmentdetails.endTime,
                role:app.appointment.appointmentdetails.createdBy,
                patientEmail: pat.email? pat.email:'',
            }
           app.patientDetail = data; 
          // const mail = await this.appointmentService.sendAppCreatedEmail(data)
        }
        return app;
    }

    @MessagePattern({cmd: 'patient_view_appointment'})
    async viewAppointmentSlotsForPatient(user: any): Promise<any> {
        const doctor = await this.appointmentService.availableSlots(user, '');
        if(!doctor.length && user.confirmation){
            let avlbl= doctor;
            //var nextday = moment(user.appointmentDate).format();
            const nextday = new Date(user.appointmentDate)
            while(!avlbl.length){
                //nextday = moment(nextday).add(1, 'days').format()
                nextday.setDate(nextday.getDate() + 1)
                user.appointmentDate = nextday;
                const doctor = await this.appointmentService.availableSlots(user, '');
                avlbl = doctor;
            }
           return{
               date:nextday,
               slots:avlbl
           }
        }
        
        return {
            date:new Date(user.appointmentDate),
            slots:doctor
        }; 
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
    async patientList(user:any): Promise<any> {
        const doctor =await this.appointmentService.doctorDetails(user.doctorKey);
        const appointment = await this.appointmentService.patientList(doctor.doctorId,user.paginationNumber);
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
            const doctor = await this.appointmentService.availableSlots(user, '');
            if(!doctor.length && user.confirmation){
                let avlbl= doctor;
                //var nextday = moment(user.appointmentDate).format();
                const nextday = new Date(user.appointmentDate)
                while(!avlbl.length){
                    //nextday = moment(nextday).add(1, 'days').format()
                    nextday.setDate(nextday.getDate() + 1)
                    user.appointmentDate = nextday;
                    const doctor = await this.appointmentService.availableSlots(user, '');
                    avlbl = doctor;
                }
               return{
                   date:nextday,
                   slots:avlbl
               }
            }
            var currentDate = new Date(Date.now());
            let now = moment(currentDate).format('YYYY-MM-DD');
            let appointmentDate = moment(user.appointmentDate).format('YYYY-MM-DD');
            if(now == appointmentDate){
                var doctorList = [];
                for(const list of doctor)
                {
                    let time = moment(currentDate).format('HH:mm:ss');
                    if(list.startTime> time){
                        doctorList.push(list)
                    }
                }
                return {
                    date:new Date(user.appointmentDate),
                    slots:doctorList
                }
            }
            return {
                date:new Date(user.appointmentDate),
                slots:doctor
            }; 
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
           const reports = await this.appointmentService.reports(user.accountKey,user.paginationNumber);
           return reports;  
        }else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
    }

    @MessagePattern({cmd: 'video_doctor_session_create'})
    async videoDoctorSessionCreate(doctorKey: string): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(doctorKey);
        if(doc){
            let tokenResponseDetails = await this.videoService.createDoctorSession(doc);
            return tokenResponseDetails;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
    }

    @MessagePattern({cmd: 'video_patient_create_token_by_doctor'})
    async videoDoctorCreateTokenForPatient(docPatientDetail): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(docPatientDetail.doctorKey);
        const app = await this.appointmentService.appointmentDetails(docPatientDetail.appointmentId);
        const pat = await this.patientDetailsRepository.findOne({patientId: app.appointmentDetails.patientId});
        if(doc.doctorId==app.appointmentDetails.doctorId){
            let tokenResponseDetails = await this.videoService.createPatientTokenByDoctor(doc, pat,docPatientDetail.appointmentId);
            return tokenResponseDetails;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
    }

    @MessagePattern({cmd: 'video_get_patient_token_for_doctor'})
    async getPatientTokenForDoctor(docPatientDetail): Promise<any> {
        const app = await this.appointmentService.appointmentDetails(docPatientDetail.appointmentId);
        const doc = await this.appointmentService.doctor_Details(app.appointmentDetails.doctorId);
        const pat = await this.patientDetailsRepository.findOne({patientId: docPatientDetail.patientId});
        if(docPatientDetail.patientId == app.appointmentDetails.patientId){
            let tokenResponseDetails = await this.videoService.getPatientToken(doc.doctorId, pat.patientId, docPatientDetail.appointmentId);
            return tokenResponseDetails;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }

    }

    @MessagePattern({cmd: 'video_remove_patient_token_by_doctor'})
    async removePatientTokenByDoctor(docPatientDetail): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(docPatientDetail.doctorKey);
        const app = await this.appointmentService.appointmentDetails(docPatientDetail.appointmentId);
        const pat = await this.patientDetailsRepository.findOne({patientId: app.appointmentDetails.patientId});
        if(doc.doctorId==app.appointmentDetails.doctorId){
            const res=await this.videoService.removePatientToken(doc, pat.patientId, docPatientDetail.appointmentId, docPatientDetail.status);
            const patient=pat.patientId;
            let result={
                response: res,
                patient:patient,
                isRemoved:true
            }
            return result;
        }else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
    }

    @MessagePattern({cmd: 'video_remove_session_token_by_doctor'})
    async removeSessionAndTokenByDoctor(user): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(user.doctorKey);
        const app = await this.appointmentService.appointmentDetails(user.appointmentId);
        const pat = await this.patientDetailsRepository.findOne({patientId: app.appointmentDetails.patientId});
        if(doc){
            await this.videoService.removeSessionAndTokenByDoctor(doc,user.appointmentId);
            const patient=pat.patientId;
            let result={
                patient:patient,
                isRemoved:true
            }
            return result;
        } else {
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }

    }

    @MessagePattern({cmd: 'get_doctor_appointments'})
    async getDoctorAppointments(doctorKey): Promise<any> {       
        const doc = await this.appointmentService.doctorDetails(doctorKey);
        if(doc){
            let app =[];
            //const date = moment().format();
            //const time = moment().format("HH:mm:ss");
            var date:any = new Date();
            var seconds = date.getSeconds();
            var minutes = date.getMinutes();
            var hour = date.getHours();
            var time = hour+":"+minutes;
            var timeMilli = Helper.getTimeInMilliSeconds(time);
            var appointment = await this.appointmentService.todayAppointmentsForDoctor(doc.doctorId,date)
            let i:any;
            for(i of appointment){
                let end =Helper.getTimeInMilliSeconds(i.endTime);
                if(timeMilli<end){
                    app.push(i);
                }
            }
            let app1=[];
            if(app1.length>=29){
                for(i=0;i<30;i++){
                    app1.push(app[i]);
                }
            }else{
                app1=app;
            }
            return app1;
        } else {
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

    @MessagePattern({cmd: 'patient_appointment_cancel'})
    async patientAppointmentCancel(appointmentDto: any): Promise<any> {
        const app = await this.appointmentService.appointmentDetails(appointmentDto.appointmentId);
        if(app.message){
            return{
                statusCode: HttpStatus.NO_CONTENT,
                message: CONSTANT_MSG.CONTENT_NOT_AVAILABLE
            }
        }
        const doctor = await this.appointmentService.doctor_Details(app.appointmentDetails.doctorId);
        const pat = await this.appointmentService.getPatientDetails(app.appointmentDetails.patientId); 
        const account = await this.appointmentService.accountDetails(doctor.accountKey);  
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
        const config = await this.appointmentService.getAppDoctorConfigDetails(appointmentDto.appointmentId);
        if(config.isPatientCancellationAllowed){
            let canDays=config.cancellationDays;
            let canTime= config.cancellationHours+":"+config.cancellationMinutes;
            //const date = moment().format();
            //const time = moment().format("HH:mm:ss");
            let date = new Date();
            var minutes = date.getMinutes();
            var hour = date.getHours();
            var time = hour+":"+minutes;
            var timeMilli = Helper.getTimeInMilliSeconds(time);
            let appDate=app.appointmentDetails.appointmentDate;
            let appointmentMinutesArray = app.appointmentDetails.startTime.split(':');
            let appointmentMinutes = moment(appDate).add(((Number(appointmentMinutesArray[0]) * 60) + Number(appointmentMinutesArray[1])), 'm').toDate();
            let appStart = app.appointmentDetails.startTime;
            let appMilli = Helper.getTimeInMilliSeconds(appStart);
            let diffDate = appDate;
            //diffDate = moment(diffDate).subtract(canDays, 'days').format()
            diffDate.setDate(diffDate.getDate() - canDays);
            let diffTime = appMilli-Helper.getTimeInMilliSeconds(canTime);

            let cancelAppointmentMinutes= moment(appointmentMinutes).subtract((Number(config.cancellationDays) * 1440) + (Number(config.cancellationHours) * 60) + Number(config.cancellationMinutes), 'm').toDate();;

            // if(date < diffDate){
            if(moment().valueOf() < cancelAppointmentMinutes.valueOf()) {
                const appointment = await this.appointmentService.appointmentCancel(appointmentDto);
                if(appointment.statusCode==HttpStatus.OK){
                    let data={
                        email:doctor.email,
                        appointmentId:app.appointmentDetails.id,
                        patientFirstName:pat.firstName,
                        patientLastName:pat.lastName,
                        doctorFirstName:doctor.firstName ,
                        doctorLastName:doctor.lastName ,
                        hospital: account.hospitalName,
                        appointmentDate:app.appointmentDetails.appointmentDate,
                        startTime:app.appointmentDetails.startTime,
                        endTime:app.appointmentDetails.endTime,
                        role:CONSTANT_MSG.ROLES.PATIENT,
                        cancelledOn:date,
                        patientEmail: pat.email?pat.email:'',
                    }
                    appointment.patientDetail=data;
                   // const mail = await this.appointmentService.sendAppCancelledEmail(data)
                }
                return appointment;
            }else if(moment().valueOf() == cancelAppointmentMinutes.valueOf()){
                if(timeMilli < diffTime){
                    const appointment = await this.appointmentService.appointmentCancel(appointmentDto);
                    if(!appointment.message){
                        let data={
                            email:doctor.email,
                            appointmentId:app.appointmentDetails.id,
                            patientFirstName:pat.firstName,
                            patientLastName:pat.lastName,
                            doctorFirstName:doctor.firstName ,
                            doctorLastName:doctor.lastName ,
                            hospital: account.hospitalName,
                            appointmentDate:app.appointmentDetails.appointmentDate,
                            startTime:app.appointmentDetails.startTime,
                            endTime:app.appointmentDetails.endTime,
                            role:CONSTANT_MSG.ROLES.PATIENT,
                            cancelledOn:date,
                            patientEmail: pat.email? pat.email:'',
                        }
                        appointment.patientDetail=data;
                        //const mail = await this.appointmentService.sendAppCancelledEmail(data)
                    }
                    return appointment;
                }else{
                    return{
                        statusCode: HttpStatus.BAD_REQUEST,
                        message: CONSTANT_MSG.CANCEL_EXCEEDS
                    }
                }
            }else{
                return{
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.CANCEL_EXCEEDS
                }
            }

        }else{
            return{
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.CANCEL_NOT_ALLOWED
            }
        }
        
    }

    @MessagePattern({cmd: 'details_of_patient'})
    async detailsOfPatient(user: any): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(user.doctorKey);
        if((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == user.doctorKey) || ((user.role == CONSTANT_MSG.ROLES.ADMIN || user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && user.account_key == doc.accountKey)){
            const patient = await this.appointmentService.detailsOfPatient(user.patientId);
            return patient;  
        }
    }

    @MessagePattern({cmd: 'patient_upcoming_app_list'})
    async patientUpcomingAppList(user:any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(user.patientDto.doctorKey);
        if((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == user.patientDto.doctorKey) || ((user.role == CONSTANT_MSG.ROLES.ADMIN || user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && user.account_key == doctor.accountKey)){
            const appointment = await this.appointmentService.patientUpcomingAppointmentsForDoctor(user);
            return appointment;
        }
        
    }

    @MessagePattern({cmd: 'patient_past_app_list'})
    async patientPastAppList(user:any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(user.patientDto.doctorKey);
        if((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == user.patientDto.doctorKey) || ((user.role == CONSTANT_MSG.ROLES.ADMIN || user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && user.account_key == doctor.accountKey)){
            const appointment = await this.appointmentService.patientPastAppointmentsForDoctor(user);
            return appointment;
        }
        
    }

    @MessagePattern({cmd: 'update_patient_online'})
    async updatePatOnline(patientId:any): Promise<any> {
        return await this. appointmentService.updatePatOnline(patientId);
        
    }

    @MessagePattern({cmd: 'update_patient_offline'})
    async updatePatOffline(patientId:any): Promise<any> {
        return await this. appointmentService.updatePatOffline(patientId);
        
    }

    @MessagePattern({cmd: 'update_patient_last_active'})
    async updatePatLastActive(patientId:any): Promise<any> {
        return await this. appointmentService.updatePatLastActive(patientId);
        
    }

    @MessagePattern({cmd: 'update_doctor_online'})
    async updateDocOnline(doctorKey:any): Promise<any> {
        console.log('update_doctor_online ', doctorKey)
        return await this. appointmentService.updateDocOnline(doctorKey);       
    }

    @MessagePattern({cmd: 'update_doctor_offline'})
    async updateDocOffline(doctorKey:any): Promise<any> {
        return await this. appointmentService.updateDocOffline(doctorKey);       
    }

    @MessagePattern({cmd: 'update_doctor_last_active'})
    async updateDocLastActive(doctorKey:any): Promise<any> {
        return await this. appointmentService.updateDocLastActive(doctorKey);       
    }

    
    @MessagePattern({cmd: 'get_patient_details'})
    async getPatientDetails(patientId: any): Promise<any> {
        const patient = await this.appointmentService.getPatientDetails(patientId);
        return patient;
    }

    @MessagePattern({cmd: 'patient_appointment_reschedule'})
    async patientAppointmentReschedule(appointmentDto: any): Promise<any> {
        const app = await this.appointmentService.appointmentDetails(appointmentDto.appointmentId)
        const payment = await this.paymentDetailsRepository.findOne({appointmentId:appointmentDto.appointmentId})
        const config = await this.appointmentService.getAppDoctorConfigDetails(appointmentDto.appointmentId);
        if(app.appointmentDetails.patientId == appointmentDto.user.patientId){
            if(config.isPatientRescheduleAllowed){
                let canDays = config.rescheduleDays;
                let canTime = config.rescheduleHours + ":" + config.rescheduleMins;
                //const date = moment().format();
                //const time = moment().format("HH:mm:ss");
                let date = new Date();
                // var minutes = date.getMinutes();
                // var hour = date.getHours();
                // var time = hour+":"+minutes;
                // var timeMilli = Helper.getTimeInMilliSeconds(time);
                let appDate=app.appointmentDetails.appointmentDate;
                // let appStart = app.appointmentDetails.startTime;
                // let appMilli = Helper.getTimeInMilliSeconds(appStart);
                let diffDate = appDate;
                //diffDate = moment(diffDate).subtract(canDays, 'days').format()
                diffDate.setDate(diffDate.getDate() - canDays)
                // .setHours(hour, minutes);
                // let reschduleDateCompare = date.setHours(0,0,0,0);
                // let diffTime = appMilli-Helper.getTimeInMilliSeconds(canTime);

                let appointmentMinutesArray = app.appointmentDetails.startTime.split(':');
                let appointmentMinutes = moment(appDate).add(((Number(appointmentMinutesArray[0]) * 60) + Number(appointmentMinutesArray[1])), 'm').toDate();

                let rescAppointmentMinutes= moment(appointmentMinutes).subtract((Number(config.rescheduleDays) * 1440) + (Number(config.rescheduleHours) * 60) + Number(config.rescheduleMinutes), 'm').toDate();

                if(moment().valueOf() < rescAppointmentMinutes.valueOf()) {
                    const doctor = await this.appointmentService.doctor_Details(app.appointmentDetails.doctorId);
                    const config = await this.appointmentService.getDoctorConfigDetails(doctor.doctorKey);
                    appointmentDto.configSession = config.consultationSessionTimings;
                    appointmentDto.config = config;
                    appointmentDto.doctorId = app.appointmentDetails.doctorId;
                    const appointment = await this.appointmentService.appointmentReschedule(appointmentDto);
                    const pat = await this.appointmentService.getPatientDetails(app.appointmentDetails.patientId); 
                    const account = await this.appointmentService.accountDetails(doctor.accountKey);  
                    if(!appointment.message){
                        payment.appointmentId = appointment.appointment.appointmentdetails.id;
                        await payment.save();
                        let data={
                            email:doctor.email,
                            appointmentId:app.appointmentDetails.id,
                            patientFirstName:pat.firstName,
                            patientLastName:pat.lastName,
                            doctorFirstName:doctor.firstName ,
                            doctorLastName:doctor.lastName ,
                            hospital: account.hospitalName,
                            appointmentDate:app.appointmentDetails.appointmentDate,
                            startTime:app.appointmentDetails.startTime,
                            endTime:app.appointmentDetails.endTime,
                            role:CONSTANT_MSG.ROLES.PATIENT,
                            rescheduledOn:date,
                            rescheduledAppointmentDate:appointment.appointment.appointmentdetails.appointmentDate,
                            rescheduledStartTime:appointment.appointment.appointmentdetails.startTime,
                            rescheduledEndTime:appointment.appointment.appointmentdetails.endTime,
                            patientEmail: pat.email? pat.email:'',
                        }
                        appointment.patientDetail=data;
                        //const mail = await this.appointmentService.sendAppRescheduleEmail(data);
                        //console.log(mail);
                    }
                    return appointment;

                } else if(moment().valueOf() === rescAppointmentMinutes.valueOf()){
                    // if(date == diffDate){
                        const doctor = await this.appointmentService.doctor_Details(app.appointmentDetails.doctorId);
                        appointmentDto.doctorId = doctor.doctorId;
                        
                        const config = await this.appointmentService.getDoctorConfigDetails(doctor.doctorKey);
                        appointmentDto.configSession = config.consultationSessionTimings;
                        appointmentDto.config = config;

                        const appointment = await this.appointmentService.appointmentReschedule(appointmentDto);
                                                
                        const pat = await this.appointmentService.getPatientDetails(app.appointmentDetails.patientId); 
                        const account = await this.appointmentService.accountDetails(doctor.accountKey);  
                        
                        if(!appointment.message){
                            payment.appointmentId = appointment.appointment.appointmentdetails.id;
                            await payment.save();
                            let data={
                                email:doctor.email,
                                appointmentId:app.appointmentDetails.id,
                                patientFirstName:pat.firstName,
                                patientLastName:pat.lastName,
                                doctorFirstName:doctor.firstName ,
                                doctorLastName:doctor.lastName ,
                                hospital: account.hospitalName,
                                appointmentDate:app.appointmentDetails.appointmentDate,
                                startTime:app.appointmentDetails.startTime,
                                endTime:app.appointmentDetails.endTime,
                                role:CONSTANT_MSG.ROLES.PATIENT,
                                rescheduledOn:date,
                                rescheduledAppointmentDate:appointment.appointment.appointmentdetails.appointmentDate,
                                rescheduledStartTime:appointment.appointment.appointmentdetails.startTime,
                                rescheduledEndTime:appointment.appointment.appointmentdetails.endTime,
                                patientEmail: pat.email? pat.email:'',
                            }
                            appointment.patientDetail = data;
                           // const mail = await this.appointmentService.sendAppRescheduleEmail(data);
                        }
                        return appointment;
                    // }

                }else{
                    return{
                        statusCode: HttpStatus.BAD_REQUEST,
                        message: CONSTANT_MSG.RESCHED_EXCEEDS
                    }
                }

            }else{
                return {
                    statusCode: HttpStatus.BAD_REQUEST,
                    message: CONSTANT_MSG.RESCHED_NOT_ALLOWED
                }
            }
        }else{
            return {
                statusCode: HttpStatus.BAD_REQUEST,
                message: CONSTANT_MSG.INVALID_REQUEST
            }
        }
    }

    @MessagePattern({cmd : 'update_patient_doctor_live_status'})
    async updatePatientDoctorLiveStatus(userIfo : any){
        this.appointmentService.updateDoctorAndPatientStatus(userIfo.role, userIfo.id, userIfo.status);
    }

    @MessagePattern({cmd: 'doc_patient_general_search'})
    async patientGeneralSearch(user: any): Promise<any> {
        const doctor =await this.appointmentService.doctorDetails(user.doctorKey);
        const patient = await this.appointmentService.patientGeneralSearch(user.patientSearch,doctor.doctorId);
        return patient;
    }

    @MessagePattern({cmd: 'patient_app_date'})
    async appointmentPresentOnDate(user: any): Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(user.doctorKey);
        user.doctorId = doctor.doctorId;
        const patient = await this.appointmentService.appointmentPresentOnDate(user);
        return patient;
    }

    
    @MessagePattern({cmd: 'get_payment_order'})
    async paymentOrder(user: any): Promise<any> {
        const patient = await this.paymentService.paymentOrder(user.accountDto);
        return patient;
    }

    @MessagePattern({cmd: 'get_payment_verification'})
    async paymentVerification(user: any): Promise<any> {
        const patient = await this.paymentService.paymentVerification(user.accountDto);
        return patient;
    }

    @MessagePattern({cmd: 'account_patients_list'})
    async accountPatientsList(user: any): Promise<any> {
        if(user.account_key == user.accountKey){
            const patients = await this.appointmentService.accountPatientList(user.accountKey);
            return patients;
        }else{
            return{
                statusCode: HttpStatus.BAD_REQUEST,
                message:CONSTANT_MSG.INVALID_REQUEST
            }
        }       
    }

    @MessagePattern({cmd: 'get_time_milli'})
    async getMilli(time: any): Promise<any> {
        const patient = Helper.getTimeInMilliSeconds(time);
        return patient;
    }

    @MessagePattern({cmd: 'create_payment_link'})
    async createPaymentLink(user: any): Promise<any> {
        const patient = await this.paymentService.createPaymentLink(user.accountDto);
        return patient;
    }

    @MessagePattern({cmd: 'table_data_view_delete'})
    async tableDataViewOrDelete(user: any): Promise<any> {
        if(user.accountDto.type == 'view'){
            const patient = await this.appointmentService.tableDataView(user.accountDto);
            return patient;
        }else if(user.accountDto.type == 'edit'){
            const patient = await this.appointmentService.tableDataDelete(user.accountDto);
            return patient;
        }
    }

    @MessagePattern({cmd: 'doctor_details_insertion'})
    async doctorInsertion(doctorDto: DoctorDto): Promise<any> {
        const doctor = await this.appointmentService.doctorRegistration(doctorDto);
        return doctor;
    }

    @MessagePattern({cmd: 'account_details_insertion'})
    async accountdetailsInsertion(user: any): Promise<any> {
        const doctor = await this.appointmentService.accountdetailsInsertion(user.accountDto);
        return doctor;
    }

    @MessagePattern({cmd: 'list_of_hospitals'})
    async listOfHospitals(user: any): Promise<any> {
        const doctors = await this.appointmentService.listOfHospitals();
        return doctors;  
    }

    @MessagePattern({cmd: 'doctor_signature'})
    async addDoctorSignature(reports: any): Promise<any> {
        return await this.appointmentService.addDoctorSignature(reports);
     }


    @MessagePattern({cmd: 'doctor_prescription_insertion'})
    async prescriptionInsertion(user:any): Promise<any> {
        const doc = await this.appointmentService.prescriptionInsertion(user);
        return doc;
    }

    @MessagePattern({cmd: 'patient_report'})
    async addPatientRecord(reports: any): Promise<any> {
        const patient = await this.appointmentService.patientFileUpload(reports);
        return patient;  
    }
    @MessagePattern({cmd: 'patient_delete_report'})
    async Report(id: any): Promise<any> {
        const patient = await this.appointmentService.deletereport(id);
        return patient;  
    }
   
    @MessagePattern({cmd: 'report_list'})
    async report(data: any): Promise<any> {
        const report = await this.appointmentService.report(data);
        return report;
    }

    // Update doctor consultation status
    @MessagePattern({cmd : 'consultation_status_update'})
    async consultationStatusUpdate(appointmentObject: any): Promise<any> {
        console.log('appointmen tObject')
        return await this.appointmentService.consultationStatusUpdate(appointmentObject);
    }
    
    //upload file
    @MessagePattern({cmd: 'upload_file'})
    async uploadFile(files: any): Promise<any> {
        const profileURL = await this.appointmentService.uploadFile(files) 
        return profileURL;
        
    }

    @MessagePattern({cmd: 'get_doctor_details'})
    async doctorDetailsEdit(doctorKey: any): Promise<any> {
        const doctor = await this.appointmentService.getDoctorDetails(doctorKey);
        return doctor;
    }

    @MessagePattern({cmd: 'get_hospital_details'})
    async doctorHospitalEdit(accountKey: any): Promise<any> {
        const hospital = await this.appointmentService.getHospitalDetails(accountKey);
        return hospital;
    }
    
    //patient report in patient detail page
    @MessagePattern({cmd: 'patient_detail_labreport'})
    async patientDetailLabReport(user: any): Promise<any> {
        const doc = await this.appointmentService.doctorDetails(user.doctorKey);
        if((user.role == CONSTANT_MSG.ROLES.DOCTOR && user.doctor_key == user.doctorKey) || ((user.role == CONSTANT_MSG.ROLES.ADMIN || user.role == CONSTANT_MSG.ROLES.DOC_ASSISTANT) && user.account_key == doc.accountKey)){
            const patient = await this.appointmentService.patientDetailLabReport(user.patientId);
            return patient;  
        }
    }

    //appointment list report 
    @MessagePattern({ cmd: 'appointment_list_report' })
    async appoinmentListReport(data: any): Promise<any> {
        return await this.appointmentService.appointmentListReport(data);
    }

     @MessagePattern({cmd: 'get_message_template'})
    async getMessageTemplate(data: any): Promise<any> {
        return await this.appointmentService.getMessageTemplate(data.messageType, data.communicationType);
    }

    @MessagePattern({cmd: 'send_confirmation_email_or_sms'})
    async sendConfirmationEmailOrSMS(data: any): Promise<any> {
        return await this.helperService.sendConfirmationMailOrSMS(data);
    }

    //amount list report 
    @MessagePattern({cmd: 'amount_list_report'})
    async amountListReport(data: any): Promise<any> {
        return await this.appointmentService.amountListReport(data);
    }

       @MessagePattern({ cmd: 'get_prescription_list' })
       async getPrescriptionList(user: any): Promise<any> {
         const response = await this.appointmentService.getPrescriptionList(user);
         return response;
       }
     
       @MessagePattern({ cmd: 'get_report_list' })
       async getReport(reqData: any): Promise<any> {
         let doctorId = await this.appointmentService.doctorDetails(
           reqData.doctor_key,
         );
         const response = await this.appointmentService.getReportList(
           doctorId.doctorId,
           reqData.patientId,
           reqData.appointmentId,
         );
     
         return response;
       }

       @MessagePattern({ cmd: 'advertisement_list' })
       async advertisementList(data: any): Promise<any> {
           const advertisement = await this.appointmentService.advertisementList(data);
           return advertisement;
       }
    
    @MessagePattern({ cmd: 'get_prescription_details' })
    async getPrescriptionDetails(appoinmnetId: number): Promise<any> {
        return await this.appointmentService.getPrescriptionDetails(appoinmnetId)
    }

    @MessagePattern({ cmd: 'get_appointment_details' })
    async getAppointmentDetails(appoinmnetId: number): Promise<any> {
        return await this.appointmentService.getAppointmentDetails(appoinmnetId)
    }

    @MessagePattern({ cmd: 'get_appointment_reports' })
    async getAppointmentReports(appoinmentId: Number): Promise<any> {
        return await this.appointmentService.getAppointmentReports(appoinmentId)
    }
}

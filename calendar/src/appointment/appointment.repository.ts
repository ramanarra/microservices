import { Repository, EntityRepository } from "typeorm";
import {InjectRepository} from '@nestjs/typeorm';
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Appointment } from "./appointment.entity";
import { PaymentDetails } from "./paymentDetails/paymentDetails.entity";
import { AppointmentDto , DoctorConfigPreConsultationDto,CONSTANT_MSG} from  "common-dto";
import { AppointmentDocConfigRepository } from "./appointmentDocConfig/appointmentDocConfig.repository";
import { AppointmentCancelRescheduleRepository } from "./appointmentCancelReschedule/appointmentCancelReschedule.repository";
import { AppointmentDocConfig } from "./appointmentDocConfig/appointmentDocConfig.entity";



@EntityRepository(Appointment)
export class AppointmentRepository extends Repository<Appointment> {
    //constructor AppointmentRepository(appointmentDocConfigRepository: AppointmentDocConfigRepository, appointmentCancelRescheduleRepository: AppointmentCancelRescheduleRepository): AppointmentRepository

    private logger = new Logger('AppointmentRepository');
    private appointmentDocConfigRepository:AppointmentDocConfigRepository;
    private appointmentCancelRescheduleRepository:AppointmentCancelRescheduleRepository;
    async createAppointment(appointmentDto: any): Promise<any> {

        const { doctorId, patientId, appointmentDate, startTime, endTime } = appointmentDto;

        const appointment = new Appointment();
        appointment.doctorId = appointmentDto.doctorId;
        appointment.patientId =appointmentDto.patientId ;
        appointment.appointmentDate =new Date(appointmentDto.appointmentDate);
        appointment.startTime = appointmentDto.startTime;
        appointment.endTime = appointmentDto.endTime;
        // appointment.appointmentDate = moment.utc(moment(appointmentDto.appointmentDate)).format();
        // appointment.startTime = new moment(appointmentDto.startTime, "HH:mm").utc();
        // appointment.endTime = new moment(appointmentDto.endTime, "HH:mm").utc();
        appointment.slotTiming = appointmentDto.configSession;
        appointment.isActive= true;
        appointment.isCancel= false;
        appointment.paymentOption = appointmentDto.paymentOption;
        appointment.consultationMode = appointmentDto.consultationMode;
        appointment.createdTime = new Date();
        //appointment.createdTime = moment().format();
        if(appointmentDto.user){
            appointment.createdBy = appointmentDto.user.role;
            appointment.createdId = appointmentDto.user.userId;
        }else{
            appointment.createdBy = CONSTANT_MSG.ROLES.PATIENT;
            appointment.createdId = appointmentDto.patientId;
        }               

        try {
            const app =  await appointment.save();  
            appointmentDto.appointmentId = app.id       
            return {
                appointmentdetails:app,
            };         
        } catch (error) {
            if (error.code === "22007") {
                this.logger.warn(`appointment date is invalid ${appointment.appointmentDate}`);
            } else {
                this.logger.error(`Unexpected Appointment save error` + error.message);
                throw new InternalServerErrorException();
            }
        }
    }

    async updateReportId(data): Promise<any>{
       
        const newdata = await this.query(queries.getReportId,[data.id,data.appointmentId] ) 
        try {
            return{
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.Report,
            
            }
         } 
         catch (error) {
         this.logger.error(`Unexpected patientReport save error` + error.message);
         throw new InternalServerErrorException();
     }
    }
    async deleteReportid(data): Promise<any>{
       
        const newdata = await this.query(queries.getReportId,[data.id,data.appointmentId] ) 
        try {
            return{
            statusCode: HttpStatus.OK,
            message: CONSTANT_MSG.  REPORTDELETE,
           
            }
         } 
         catch (error) {
         this.logger.error(`Unexpected patientReport save error` + error.message);
         throw new InternalServerErrorException();
     }
    }
    
}
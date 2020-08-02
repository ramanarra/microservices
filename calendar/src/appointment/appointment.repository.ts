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
        appointment.slotTiming = appointmentDto.configSession;
        appointment.isActive= true;
        appointment.isCancel= false;
        appointment.paymentOption = appointmentDto.paymentOption;
        appointment.consultationMode = appointmentDto.consultationMode;
        if(appointmentDto.user){
            appointment.createdBy = appointmentDto.user.role;
            appointment.createdId = appointmentDto.user.userId;
        }else{
            appointment.createdBy = CONSTANT_MSG.ROLES.PATIENT;
            appointment.createdId = appointmentDto.patientId;
        }               

        try {
            const app =  await appointment.save();  
            const pay = new PaymentDetails();
            pay.appointmentId = app.id;
            if(app.createdBy == CONSTANT_MSG.ROLES.PATIENT){
                pay.isPaid = true;
            }
            const payment = await pay.save();
            appointmentDto.appointmentId = app.id;
           // const appDocConfig = await this.appointmentDocConfigRepository.createAppDocConfig(appointmentDto);
            //console.log(appDocConfig);
            return {
                appointmentdetails:app,
                paymentDetails:payment
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



}
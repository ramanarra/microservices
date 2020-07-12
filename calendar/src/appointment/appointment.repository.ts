import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Appointment } from "./appointment.entity";
import { PaymentDetails } from "./paymentDetails/paymentDetails.entity";
import { AppointmentDto , DoctorConfigPreConsultationDto} from  "common-dto";
import { Doctor } from "./doctor/doctor.entity";
import { DocConfigScheduleInterval } from "./docConfigScheduleInterval/docConfigScheduleInterval.entity";
import { DocConfigScheduleDay } from "./docConfigScheduleDay/docConfigScheduleDay.entity";
import { DocConfigScheduleDayRepository } from "./docConfigScheduleDay/docConfigScheduleDay.repository";
import { DocConfigScheduleIntervalRepository } from "./docConfigScheduleInterval/docConfigScheduleInterval.repository";


@EntityRepository(Appointment)
export class AppointmentRepository extends Repository<Appointment> {

    private logger = new Logger('AppointmentRepository');
    async createAppointment(appointmentDto: any): Promise<any> {

        const { doctorId, patientId, appointmentDate, startTime, endTime } = appointmentDto;

        const appointment = new Appointment();
        appointment.doctorId = appointmentDto.doctorId;
        appointment.patientId =appointmentDto.patientId ;
        appointment.appointmentDate =new Date(appointmentDto.appointmentDate);
        appointment.startTime = appointmentDto.startTime;
        appointment.endTime = appointmentDto.endTime;
        appointment.isActive= true;
        appointment.isCancel= false;
        if(appointmentDto.user){
            appointment.createdBy = appointmentDto.user.role;
            appointment.createdId = appointmentDto.user.userId;
        }else{
            appointment.createdBy = 'PATIENT';
            appointment.createdId = appointmentDto.patientId;
        }               

        try {
            const app =  await appointment.save();  
            const pay = new PaymentDetails();
            pay.appointmentId = app.id;
            const payment = await pay.save();
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
import { Repository, EntityRepository } from "typeorm";
import { ConflictException, InternalServerErrorException, Logger } from "@nestjs/common";
import { Appointment } from "./appointment.entity";
import { AppointmentDto , DoctorConfigPreConsultationDto} from  "common-dto";
import { Doctor } from "./doctor.entity";

@EntityRepository(Appointment)
export class AppointmentRepository extends Repository<Appointment> {

    private logger = new Logger('AppointmentRepository');
    async createAppointment(appointmentDto: AppointmentDto): Promise<any> {

        const { doctorId, patientId, appointmentDate, startTime, endTime } = appointmentDto;

        const appointment = new Appointment();
        appointment.doctorId = appointmentDto.doctorId;
        appointment.patientId =appointmentDto.patientId ;
        appointment.appointmentDate = new Date(appointmentDto.appointmentDate);
        appointment.startTime = appointmentDto.startTime;
        appointment.endTime = appointmentDto.endTime;

        try {
            return await appointment.save();          
        } catch (error) {
            if (error.code === "22007") {
                this.logger.warn(`appointment date is invalid ${appointment.appointmentDate}`);
                //throw new ConflictException("Appointment already exists");
            } else {
                this.logger.error(`Unexpected Appointment save error` + error.message);
                throw new InternalServerErrorException();
            }
        }
    }



}
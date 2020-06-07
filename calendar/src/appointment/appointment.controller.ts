import { Controller, Logger } from '@nestjs/common';
import { AppointmentService } from './appointment.service';
import { MessagePattern } from '@nestjs/microservices';
import { AppointmentDto } from 'common-dto';

@Controller('appointment')
export class AppointmentController {

    private logger = new Logger('AppointmentController');

    constructor(private readonly appointmentService: AppointmentService) {

    }

    @MessagePattern({ cmd: 'calendar_appointment_get_list' })
    async getList(userDto : any): Promise<any> {
        console.log("asdasd");
        const appointment = await this.appointmentService.getAppointmentList(userDto);
        this.logger.log("asfn >>> " + appointment);
        return appointment;
    }

    @MessagePattern({ cmd: 'calendar_appointment_create' })
    async createAppointment(appointmentDetails: any): Promise<any> {
        this.logger.log("appointmentDetails >>> " + appointmentDetails);
        const appointment = await this.appointmentService.getAppointmentList(appointmentDetails);
        
        return appointment;
    }

    
    @MessagePattern({ cmd: 'auth_doctor_details' })
    async doctor_Login(doctorKey) : Promise<any> {
        const doctor = await this.appointmentService.doctorDetails(doctorKey);
        return doctor;
       
    }



}

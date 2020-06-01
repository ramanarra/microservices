import { Injectable } from '@nestjs/common';
import { AppointmentRepository } from './appointment.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { AppointmentDto, UserDto } from 'common-dto';
import { Appointment } from './appointment.entity';

@Injectable()
export class AppointmentService {

    constructor(
        @InjectRepository(AppointmentRepository) private appointmentRepository: AppointmentRepository
    ) {
    }

    async getAppointmentList(userDto : UserDto): Promise<Appointment[]>{
       return await this.appointmentRepository.find({});
    }

    async createAppointment(appointmentDto: AppointmentDto): Promise<any> {
        return await this.appointmentRepository.createAppointment(appointmentDto);
    }

}

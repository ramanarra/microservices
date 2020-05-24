import { Injectable } from '@nestjs/common';
import { AppointmentRepository } from './appointment.repository';
import { InjectRepository } from '@nestjs/typeorm';

@Injectable()
export class AppointmentService {

    constructor(
        @InjectRepository(AppointmentRepository) private appointmentRepository: AppointmentRepository
    ) {
    }

    async getAppointmentList(userDto : any){
        await this.appointmentRepository.find({});
    }

}

import { Injectable } from '@nestjs/common';
import { AppointmentRepository } from './appointment.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { AppointmentDto, UserDto } from 'common-dto';
import { Appointment } from './appointment.entity';
import { Doctor } from './doctor.entity';
import { DoctorRepository } from './doctor.repository';
import { AccountDetailsRepository } from './account.repository';


@Injectable()
export class AppointmentService {

    constructor(
        @InjectRepository(AppointmentRepository) private appointmentRepository: AppointmentRepository, private accountDetailsRepository: AccountDetailsRepository, private doctorRepository: DoctorRepository
    ) {
    }

    async getAppointmentList(userDto : UserDto): Promise<Appointment[]>{
       return await this.appointmentRepository.find({});
    }

    async createAppointment(appointmentDto: AppointmentDto): Promise<any> {
        return await this.appointmentRepository.createAppointment(appointmentDto);
    }

    async doctorDetails(doctorKey): Promise<any> {
        return await this.doctorRepository.findOne({doctorKey : doctorKey});
    }

    async accountDetails(accountKey): Promise<any> {
        return await this.accountDetailsRepository.findOne({accountKey : accountKey});
    }

}

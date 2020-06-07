import { Injectable } from '@nestjs/common';
import { AppointmentRepository } from './appointment.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { AppointmentDto, UserDto , DoctorConfigPreConsultationDto} from 'common-dto';
import { Appointment } from './appointment.entity';
import { Doctor } from './doctor.entity';
import { DoctorRepository } from './doctor.repository';
import { AccountDetailsRepository } from './account.repository';
import { AccountDetails } from './account_details.entity';


@Injectable()
export class AppointmentService {

    constructor(
        @InjectRepository(AppointmentRepository) private appointmentRepository: AppointmentRepository, private accountDetailsRepository: AccountDetailsRepository, private doctorRepository: DoctorRepository
    ) {
    }

    async getAppointmentList(userDto : any){
        await this.appointmentRepository.find({});
    }

    async doctorDetails(doctorKey): Promise<any> {
        return await this.appointmentRepository.findOne( doctorKey);
        return await this.doctorRepository.findOne({doctorKey : doctorKey});
    }

    async accountDetails(accountKey): Promise<any> {
        return await this.accountDetailsRepository.findOne({accountKey : accountKey});
    }

    async doctor_Details(doctorId): Promise<any> {
        return await this.doctorRepository.findOne({doctor_id : doctorId});
    }


    async doctor_List(accountKey): Promise<any> {
        return await this.doctorRepository.find({accountKey : accountKey});
    }

    // async doctorPreconsultation(doctorConfigPreConsultationDto: DoctorConfigPreConsultationDto): Promise<any> {
    //     return await this.appointmentRepository.doctorPreconsultation(doctorConfigPreConsultationDto);
    // }

}

import { Injectable } from '@nestjs/common';
import { AppointmentRepository } from './appointment.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { AppointmentDto, UserDto , DoctorConfigPreConsultationDto, DoctorConfigCanReschDto} from 'common-dto';
import { Appointment } from './appointment.entity';
import { Doctor } from './doctor.entity';
import { DoctorRepository } from './doctor.repository';
import { AccountDetailsRepository } from './account.repository';
import { AccountDetails } from './account_details.entity';
import { DoctorConfigPreConsultationRepository } from './doctor_config_preconsultation.repository';
import { DoctorConfigPreConsultation } from './doctor_config_preconsultation.entity';
import { DoctorConfigCanReschRepository } from './doc_config_can_resch.repository';
import { DoctorConfigCanResch } from './doc_config_can_resch.entity';


@Injectable()
export class AppointmentService {

    constructor(
        @InjectRepository(AppointmentRepository) private appointmentRepository: AppointmentRepository, private accountDetailsRepository: AccountDetailsRepository, private doctorRepository: DoctorRepository,  private doctorConfigPreConsultationRepository: DoctorConfigPreConsultationRepository, private doctorConfigCanReschRepository: DoctorConfigCanReschRepository
    ) {
    }

    async getAppointmentList(doctorId): Promise<Appointment[]>{
       return await this.appointmentRepository.find({doctorId : doctorId});
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

    async doctor_Details(doctorId): Promise<any> {
        return await this.doctorRepository.findOne({doctor_id : doctorId});
    }


    async doctor_List(accountKey): Promise<any> {
        return await this.doctorRepository.find({accountKey : accountKey});
    }

    async doctorPreconsultation(doctorConfigPreConsultationDto: DoctorConfigPreConsultationDto): Promise<any> {
        return await this.doctorConfigPreConsultationRepository.doctorPreconsultation(doctorConfigPreConsultationDto);
    }

    async doctorCanReschEdit(doctorConfigCanReschDto: DoctorConfigCanReschDto): Promise<any> {
        return await this.doctorConfigCanReschRepository.doctorCanReschEdit(doctorConfigCanReschDto);
    }

    async doctorCanReschView(doctorKey): Promise<any> {
        return await this.doctorConfigCanReschRepository.findOne({doctorKey:doctorKey});
    }

}

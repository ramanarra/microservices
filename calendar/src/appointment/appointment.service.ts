import {HttpStatus, Injectable} from '@nestjs/common';
import {AppointmentRepository} from './appointment.repository';
import {InjectRepository} from '@nestjs/typeorm';
import {
    AppointmentDto,
    UserDto,
    DoctorConfigPreConsultationDto,
    DoctorConfigCanReschDto,
    DocConfigDto,
    WorkScheduleDto
} from 'common-dto';
import {Appointment} from './appointment.entity';
import {Doctor} from './doctor/doctor.entity';
import {DoctorRepository} from './doctor/doctor.repository';
import {AccountDetailsRepository} from './account/account.repository';
import {AccountDetails} from './account/account_details.entity';
import {DoctorConfigPreConsultationRepository} from './doctorConfigPreConsultancy/doctor_config_preconsultation.repository';
import {DoctorConfigPreConsultation} from './doctorConfigPreConsultancy/doctor_config_preconsultation.entity';
import {DoctorConfigCanReschRepository} from './docConfigReschedule/doc_config_can_resch.repository';
import {DoctorConfigCanResch} from './docConfigReschedule/doc_config_can_resch.entity';
import {docConfigRepository} from "./doc_config/docConfig.repository";
import {queries} from "../config/query";
import {WorkScheduleRepository} from "./workSchedule/workSchedule.repository";
import { DocConfigScheduleDayRepository } from "./DocConfigScheduleDay/docConfigScheduleDay.repository";
import { DocConfigScheduleIntervalRepository } from "./DocConfigScheduleInterval/docConfigScheduleInterval.repository";


@Injectable()
export class AppointmentService {

    constructor(
        @InjectRepository(AppointmentRepository) private appointmentRepository: AppointmentRepository,
        private accountDetailsRepository: AccountDetailsRepository, private doctorRepository: DoctorRepository,
        private doctorConfigPreConsultationRepository: DoctorConfigPreConsultationRepository,
        private doctorConfigCanReschRepository: DoctorConfigCanReschRepository,
        private doctorConfigRepository: docConfigRepository,
        private workScheduleRepository: WorkScheduleRepository,
        private docConfigScheduleDayRepository:DocConfigScheduleDayRepository,
        private docConfigScheduleIntervalRepository:DocConfigScheduleIntervalRepository

    ) {
    }

    async getAppointmentList(doctorId): Promise<Appointment[]> {
        return await this.appointmentRepository.find({doctorId: doctorId});
    }

    async createAppointment(appointmentDto: AppointmentDto): Promise<any> {
        return await this.appointmentRepository.createAppointment(appointmentDto);
    }

    async doctorDetails(doctorKey): Promise<any> {
        return await this.doctorRepository.findOne({doctorKey: doctorKey});
    }

    async accountDetails(accountKey): Promise<any> {
        return await this.accountDetailsRepository.findOne({accountKey: accountKey});
    }

    async doctor_Details(doctorId): Promise<any> {
        return await this.doctorRepository.findOne({doctor_id: doctorId});
    }


    async doctor_List(accountKey): Promise<any> {
        return await this.doctorRepository.find({accountKey: accountKey});
    }

    async doctorPreconsultation(doctorConfigPreConsultationDto: DoctorConfigPreConsultationDto): Promise<any> {
        return await this.doctorConfigPreConsultationRepository.doctorPreconsultation(doctorConfigPreConsultationDto);
    }

    async doctorCanReschEdit(doctorConfigCanReschDto: DoctorConfigCanReschDto): Promise<any> {
        return await this.doctorConfigCanReschRepository.doctorCanReschEdit(doctorConfigCanReschDto);
    }

    async doctorCanReschView(doctorKey): Promise<any> {
        return await this.doctorConfigCanReschRepository.findOne({doctorKey: doctorKey});
    }

    // get details from docConfig table
    async getDoctorConfigDetails(doctorKey): Promise<any> {
        return await this.doctorConfigRepository.findOne({doctorKey: doctorKey});
    }

    async doctorConfigUpdate(doctorConfigDto: DocConfigDto): Promise<any> {
        // update the doctorConfig details
        if (!doctorConfigDto.doctorKey) {
            return {
                statusCode: HttpStatus.NO_CONTENT,
                message: 'Invalid Request'
            }
        }
        var condition = {
            doctorKey: doctorConfigDto.doctorKey
        }
        var values: any = doctorConfigDto;
        var updateDoctorConfig = await this.doctorConfigRepository.update(condition, values);
        if (updateDoctorConfig.affected) {
            return {
                statusCode: HttpStatus.OK,
                message: 'Updated Successfully'
            }
        } else {
            return {
                statusCode: HttpStatus.NOT_MODIFIED,
                message: 'Updation Failed'
            }
        }
    }

    async workScheduleEdit(workScheduleDto: WorkScheduleDto): Promise<any> {
        //update work schedule
       // return await this.workScheduleRepository.update({condition, values});
    }

    // async workScheduleView(docId): Promise<any> {
    //     const day = await this.docConfigScheduleDayRepository.find({doctorId : docId});
    //     var workSched=[];
        
    //     day.forEach( async function (workSchedule) {
    //         var dayDetails = workSchedule.docConfigScheduleDayId;
    //         const interval = this.docConfigScheduleIntervalRepository.find({docConfigScheduleDayId:dayDetails});
    //         var res = {
    //             day: workSchedule,
    //             interval: interval
    //         }
    //         workSched.push(res);
    //     });
    //     return workSched;
    // }

    async workScheduleView(doctorId: number): Promise<any> {
        return await this.docConfigScheduleDayRepository.query(queries.getWorkSchedule, [doctorId]);
    }

}

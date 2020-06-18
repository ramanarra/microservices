import { Module } from '@nestjs/common';
import { AppointmentController } from './appointment.controller';
import { AppointmentService } from './appointment.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppointmentRepository } from './appointment.repository';
import { DoctorRepository } from './doctor/doctor.repository';
import { AccountDetailsRepository } from './account/account.repository';
import { DoctorConfigPreConsultationRepository } from './doctorConfigPreConsultancy/doctor_config_preconsultation.repository';
import { DoctorConfigCanReschRepository } from './docConfigReschedule/doc_config_can_resch.repository';
import {docConfigRepository} from "./doc_config/docConfig.repository";
import {WorkScheduleRepository} from "./WorkSchedule/workSchedule.repository";
import {DocConfigScheduleDayRepository} from "./docConfigScheduleDay/docConfigScheduleDay.repository";
import {DocConfigScheduleIntervalRepository} from "./docConfigScheduleInterval/docConfigScheduleInterval.repository";

@Module({
  imports: [
    TypeOrmModule.forFeature([AppointmentRepository,DoctorRepository, AccountDetailsRepository,
      DoctorConfigPreConsultationRepository,DoctorConfigCanReschRepository, docConfigRepository, WorkScheduleRepository,DocConfigScheduleDayRepository,DocConfigScheduleIntervalRepository])
  ],
  controllers: [AppointmentController],
  providers: [AppointmentService]
})
export class AppointmentModule { }

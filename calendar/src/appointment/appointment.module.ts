import { Module } from '@nestjs/common';
import { AppointmentController } from './appointment.controller';
import { AppointmentService } from './appointment.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppointmentRepository } from './appointment.repository';
import { DoctorRepository } from './doctor.repository';
import { AccountDetailsRepository } from './account.repository';
import { DoctorConfigPreConsultationRepository } from './doctor_config_preconsultation.repository';
import { DoctorConfigCanReschRepository } from './doc_config_can_resch.repository';

@Module({
  imports: [
    TypeOrmModule.forFeature([AppointmentRepository,DoctorRepository, AccountDetailsRepository, DoctorConfigPreConsultationRepository,DoctorConfigCanReschRepository ])
  ],
  controllers: [AppointmentController],
  providers: [AppointmentService]
})
export class AppointmentModule { }

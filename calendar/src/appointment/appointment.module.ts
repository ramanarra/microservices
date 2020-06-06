import { Module } from '@nestjs/common';
import { AppointmentController } from './appointment.controller';
import { AppointmentService } from './appointment.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppointmentRepository } from './appointment.repository';
import { DoctorRepository } from './doctor.repository';
import { AccountDetailsRepository } from './account.repository';

@Module({
  imports: [
    TypeOrmModule.forFeature([AppointmentRepository,DoctorRepository, AccountDetailsRepository])
  ],
  controllers: [AppointmentController],
  providers: [AppointmentService]
})
export class AppointmentModule { }

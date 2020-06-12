import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { databaseConfig } from './config/database.config';
import { UserModule } from './user/user.module';
//import { DoctorModule } from './doctor/doctor.module';
//import { AccountModule } from './account/account.module';
//import { AppointmentModule } from '.calendar/appointment/appointment.module';


@Module({
  imports: [
    UserModule,
    //AccountModule,
    TypeOrmModule.forRoot(databaseConfig),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

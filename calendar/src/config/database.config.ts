import { TypeOrmModuleOptions} from '@nestjs/typeorm';
import * as config from 'config';
import { Appointment } from 'src/appointment/appointment.entity';
import { AccountDetails } from 'src/appointment/account_details.entity';
import { DoctorConfigPreConsultation } from 'src/appointment/doctor_config_preconsultation.entity';
import { Doctor } from 'src/appointment/doctor.entity';

const dbConfig = config.get('database');

export const databaseConfig : TypeOrmModuleOptions = {

    type : dbConfig.type,
    host : dbConfig.host,
    port : dbConfig.port,
    username : dbConfig.username,
    password : dbConfig.password,
    database : dbConfig.database,
    entities : [Appointment,AccountDetails,DoctorConfigPreConsultation, Doctor],
    synchronize : dbConfig.synchronize

} 
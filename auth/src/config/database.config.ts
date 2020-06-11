import { TypeOrmModuleOptions} from '@nestjs/typeorm';
import * as config from 'config';
import { Users } from 'src/user/users.entity';
import { Account } from 'src/user/account.entity';
//import { Doctor } from 'src/doctor/doctor.entity';
//import { Account } from 'src/account/account.entity';
//import { Doctor } from 'caledar/src/doctor/doctor.entity';
import { Roles } from 'src/user/roles.entity';

const dbConfig = config.get('database');

export const databaseConfig : TypeOrmModuleOptions = {

    type : dbConfig.type,
    host : dbConfig.host,
    port : dbConfig.port,
    username : dbConfig.username,
    password : dbConfig.password,
    database : dbConfig.database,
    entities : [Users,Account,Roles],
    synchronize : dbConfig.synchronize

} 
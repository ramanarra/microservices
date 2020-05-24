import { TypeOrmModuleOptions} from '@nestjs/typeorm';
import * as config from 'config';
import { Users } from 'src/user/users.entity';

const dbConfig = config.get('database');

export const databaseConfig : TypeOrmModuleOptions = {

    type : dbConfig.type,
    host : dbConfig.host,
    port : dbConfig.port,
    username : dbConfig.username,
    password : dbConfig.password,
    database : dbConfig.database,
    entities : [Users],
    synchronize : dbConfig.synchronize

} 
import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserRepository } from './user.repository';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import * as config from 'config';

const jwtConfig = config.get('JWT'); 

@Module({
    imports: [
        TypeOrmModule.forFeature([UserRepository]),
        JwtModule.register({
            secret : jwtConfig.secret,
            signOptions : {
              expiresIn : jwtConfig.expiresIn
            }
          }),
          PassportModule.register({defaultStrategy : jwtConfig.defaultStrategy})
    ],
    controllers: [UserController],
    providers: [UserService]
})
export class UserModule { }

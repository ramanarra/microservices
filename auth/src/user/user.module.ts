import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserRepository } from './user.repository';
import { AccountRepository } from './account.repository';
import { RolesRepository } from './roles.repository';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import * as config from 'config';
import { AppModule } from 'src/app.module';
import { ClientProxyFactory } from '@nestjs/microservices';
import { NestFactory } from '@nestjs/core';
import { Transport, MicroserviceOptions } from '@nestjs/microservices';

const jwtConfig = config.get('JWT'); 

@Module({
    imports: [
        TypeOrmModule.forFeature([UserRepository,AccountRepository,RolesRepository]),
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

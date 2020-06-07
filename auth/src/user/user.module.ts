import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserRepository } from './user.repository';
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
      // {
      //   provide: 'REDIS_SERVICE',
      //   useFactory: (appModule: AppModule) => {
      //     return ClientProxyFactory.create({
      //       transport: Transport.REDIS,
      //       options: {
      //         url: 'redis://localhost:6379',
      //       }
      //     });
      //   },
      //   inject: [
      //     AppModule
      //   ]
      // },

})
export class UserModule { }
// {
//     provide: 'REDIS_SERVICE',
//         useFactory: (appModule: AppModule) => {
//     return ClientProxyFactory.create(appModule.get('redisService'));
// },
//     inject: [
//     AppModule
// ]
// },
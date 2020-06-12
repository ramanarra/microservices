import { Controller, UseFilters, Body, Logger, Inject } from '@nestjs/common';
import { MessagePattern } from '@nestjs/microservices';
import { UserService } from './user.service';
import { UserDto } from 'common-dto';
import { AllExceptionsFilter } from 'src/common/filter/all-exceptions.filter';
import { ClientProxy } from "@nestjs/microservices";
import { async } from 'rxjs/internal/scheduler/async';

@Controller('user')
@UseFilters(AllExceptionsFilter)
export class UserController {

  private logger = new Logger('UserController');
  

  constructor(private readonly userService: UserService ) {

  }


  @MessagePattern({ cmd: 'auth_user_validate_email_password' })
  async login(userDto: UserDto): Promise<any> {
    this.logger.log(" login  service >> " + userDto);
    const user = await this.userService.validateEmailPassword(userDto);
    this.logger.log("asfn >>> " + user);
             return user;
  }



  @MessagePattern({ cmd: 'auth_user_find_by_email' })
  async findByEmail(email: string): Promise<any> {
   const user = await this.userService.findByEmail(email);
   return user;
  }




  @MessagePattern({ cmd: 'auth_doctor_login' })
  async doctorLogin(doctorDto: any): Promise<any> {
      const { email, password } = doctorDto;
      const doctor = await this.userService.doctor_Login(email,password);
      return {
        "doctorKey":doctor.doctor_key,
        "accountKey":doctor.account_key,
        "accessToken":doctor.accessToken
      }
  };


}

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

  // @MessagePattern({ cmd: 'auth_user_signUp' })
  // async signUp(userDto: UserDto): Promise<any> {
  //   this.logger.log(" authh service >> " + userDto);
  //   return await this.userService.signUp(userDto);
  // }

  // @MessagePattern({ cmd: 'auth_user_find_by_email' })
  // async findByEmail(email: string): Promise<UserDto> {
  //   return await this.userService.findByEmail(email);
  // }

  // @MessagePattern({ cmd: 'auth_user_list' })
  // async findUsers():Promise<any>{
  //   return await this.userService.findUsers();
  // }

  @MessagePattern({ cmd: 'auth_doctor__login' })
  async doctor_Login(doctorDto: any): Promise<any> {
      const { email, password } = doctorDto;
      const doctor = await this.userService.doctor_Login(email,password);
      if(doctor){
        var doctorKey = doctor.doctor_key;
      var accountId = doctor.account_id;
      return {
        "doctorKey":doctorKey,
        "accountId":accountId,
        "accessToken":doctor.accessToken
      };
      }
      else{
        return "Invalid Credentials of Doctor";
      }

  }




  @MessagePattern({ cmd: 'auth_doctor_login' })
  async doctorLogin(doctorDto: any): Promise<any> {
      const { email, password } = doctorDto;
      var res=[];
      const doctor = await this.userService.doctor_Login(email,password);
      var accountId = doctor.account_id;
      var doctorKey = doctor.doctor_key;
      return {
        "accountId":accountId,
        "doctorKey":doctorKey,
        "accessToken":doctor.accessToken
      }

  };


}

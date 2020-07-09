import { Controller,HttpStatus, Body, Param, Query, Post, Get, Put, UseFilters, Logger } from '@nestjs/common';
import { UserService } from 'src/service/user.service';
import {CalendarService} from 'src/service/calendar.service';
import { UserDto, DoctorDto, PatientDto,CONSTANT_MSG } from 'common-dto';
import { AllExceptionsFilter } from 'src/common/filter/all-exceptions.filter';
import {
  ApiCreatedResponse,
  ApiOkResponse,
  ApiUnauthorizedResponse,
  ApiBody,
  ApiResponse
} from '@nestjs/swagger';
import { defaultMaxListeners } from 'stream';

@Controller('api/auth')
@UseFilters(AllExceptionsFilter)
export class AuthController {

  private logger = new Logger('AuthController');

  constructor(private readonly userService: UserService, private readonly calendarService: CalendarService) { }

    @Post('doctorLogin')
    @ApiOkResponse({ description: 'requestBody example :   {\n' +
          '"email":"test@apollo.com",\n' +
          '"password": "123456" \n' +
          '}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: UserDto })
    doctorsLogin(@Body() userDto : UserDto) {
      this.logger.log(`Doctor Login  Api -> Request data ${JSON.stringify(userDto)}`);
      const doc = this.userService.doctorsLogin(userDto);
      return doc;
    }

    @Post('patientLogin')
    @ApiOkResponse({ description: 'requestBody example :   {\n' +
          '"phone":"9999999996",\n' +
          '"password": "123456" \n' +
          '}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: PatientDto })
    patientLogin(@Body() patientDto : PatientDto) {
      this.logger.log(`Patient Login  Api -> Request data ${JSON.stringify(patientDto)}`);
      return this.userService.patientLogin(patientDto);
    }

    @Post('patientRegistration')
    @ApiOkResponse({ description: 'requestBody example :   {\n' +
          '"phone":"9999999992",\n' +
          '"email":"nirmala@gmail.com",\n' +
          '"password": "123456", \n' +
          '"landmark":"landmark", \n' +
          '"country":"country", \n' +
          '"name":"name", \n' +
          '"address":"address", \n' +
          '"state":"state", \n' +
          '"pincode":"12346", \n' +
          '"photo":"https://homepages.cae.wisc.edu/~ece533/images/airplane.png" \n' +
          '}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: PatientDto })
    async patientRegistration(@Body() patientDto : PatientDto) {
      this.logger.log(`Patient Registration  Api -> Request data ${JSON.stringify(patientDto)}`);
      const patient = await this.userService.patientRegistration(patientDto);
      if(patient.message){
        return patient;
      }else {
        const details = await this.calendarService.patientInsertion(patientDto,patient.patient_id);
        return {
          patient:patient,
          details:details
        }
      }
    }

}

import {
  Controller,
  HttpStatus,
  Body,
  Param,
  Query,
  Post,
  Get,
  Put,
  UseFilters,
  Logger,
  ValidationPipe, UsePipes
} from '@nestjs/common';
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
      if(!userDto.email){
        console.log("Provide email");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide email"}
      }else if(!userDto.password){
        console.log("Provide password");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide password"}
      }
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
      if(!patientDto.phone || !(patientDto.phone.length == 10)){
        console.log("Provide Valid Phone");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide Valid Phone"}
      }else if(!patientDto.password){
        console.log("Provide password");
        return{statusCode:HttpStatus.BAD_REQUEST,message:"Provide password"}
      }
      this.logger.log(`Patient Login  Api -> Request data ${JSON.stringify(patientDto)}`);
      return this.userService.patientLogin(patientDto);
    }

    @Post('patientRegistration')
    @ApiOkResponse({ description: 'requestBody example :   {\n' +
          '"phone":"9999999992",\n' +
          '"email":"nirmala@gmail.com",\n' +
          '"password": "123456", \n' +
          '"firstName":"firstName", \n' +
          '"lastName":"lastName", \n' +
          '"dateOfBirth":"DOB", \n' +
          '"landmark":"landmark", \n' +
          '"country":"country", \n' +
          '"address":"address", \n' +
          '"state":"state", \n' +
          '"pincode":"12346", \n' +
          '"alternateContact":"alternateContact", \n' +
          '"age":21, \n' +
          '"photo":"https://homepages.cae.wisc.edu/~ece533/images/airplane.png" \n' +
          '}' })
    @ApiUnauthorizedResponse({ description: 'Invalid credentials' })
    @ApiBody({ type: PatientDto })
    @UsePipes(new ValidationPipe({ transform: true }))
    async patientRegistration(@Body() patientDto : PatientDto) {
      if(patientDto.phone && patientDto.phone.length == 10){
        if(patientDto.password){
          let regDto:any ={
            phone:patientDto.phone,
            password:patientDto.password,
            createdBy:CONSTANT_MSG.ROLES.PATIENT
          }
          this.logger.log(`Patient Registration  Api -> Request data ${JSON.stringify(regDto)}`);
          const patient = await this.userService.patientRegistration(regDto);
          if(patient.message){
            return patient;
          }else if(patient.update){
              patientDto.patientId = patient.patientId;
              let patDto:any = {
                phone:patientDto.phone,
                email:patientDto.email,
                patientId:patient.patientId,
                firstName:patientDto.firstName,
                lastName:patientDto.lastName,
                name:patientDto.firstName+" "+patientDto.lastName,
                dateOfBirth:patientDto.dateOfBirth,
                landmark:patientDto.landmark,
                country:patientDto.country,
                address:patientDto.address,
                state:patientDto.state,
                pincode:patientDto.pincode,
                alternateContact:patientDto.alternateContact,
                age:patientDto.age,
                photo:patientDto.photo

              }
              const details = await this.calendarService.patientDetailsEdit(patDto);
              return {
                patient:patient,
                details:details
              }
          }else {
            const details = await this.calendarService.patientInsertion(patientDto,patient.patientId);
            return {
              patient:patient,
              details:details
            }
          }
        }else{
          return {
            statusCode: HttpStatus.BAD_REQUEST,
            message: "Provide password"
          }
        }
        
      }else{
        return {
          statusCode: HttpStatus.BAD_REQUEST,
          message: "Provide valid phone"
        }
      }
    }

}
